#!/bin/bash
# 2019-02-07
# doesn't work reliably

# testing this in docker
# docker run --rm -ti -v $PWD:/tmp/1 qwe1/shellcheck shellcheck -e SC2144 -s bash /tmp/1/dilbert.sh

# also doesn't take time zone differences into account

# since it's for personal I use, I just assume I have enough brain
# to run it at late UK night when the author in US already uploaded
# the day's comic


# could be dockerized, rewritten in python or whatever
# dockerization would bring a whole host of problems, such as:
# where to save, uid differences

# enough

# wanted to write this in python,
# but ended up in bash

# directory the script is launched from
# bashism
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#DIR="$(pwd -P)"
#DIR="$(pwd)"

#2018-11-26
# update to https
url="https://dilbert.com/strip/"
ref="https://dilbert.com"

# 2018-11-26
# update UA to ff 60
ua='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101 Firefox/60.0'
# if you can make use of this var, go ahead
# I couldn't
#args="-L -A ${ua} --referer ${ref}"

# dates
py3="python3"
pyscript="${DIR}/date-generator.py"

# trying to get /bin/sh to work
if [ ! -e "${pyscript}" ];then
echo "Var pyscript/date-generator.py not found, exiting."
exit
fi
datelist="/tmp/date.list"
"${py3}" "${pyscript}" > "${datelist}"


downloadfolder="$HOME/Pictures/dilbert"

# if downloadfolder doesn't exist, make it
if [ ! -d "${downloadfolder}" ];then
	mkdir -p "${downloadfolder}"
fi

nowget()
{
clear
printf "Wget not found in your PATH var."
exit
}
command -v wget > /dev/null 2>&1 || nowget

nocurl()
{
clear
printf "curl not found in your PATH var."
exit
}
command -v curl > /dev/null 2>&1 || nocurl
# python looks more charming every time
#wgetargs="-c -P "${downloadfolder}""

nofile()
{
clear
printf "file not found in your PATH var."
exit
}
command -v file > /dev/null 2>&1 || nofile

download()
{
# if download() is not called from main, but from today()
if [ -z "${var}" ];then
var="$(tail -n 1 ${datelist})"
fi

# 2018-11-26
# added last sed since the site changes from http to https
imglink="$(curl -sS -L -A "${ua}" --referer ${ref} "${url}""${var}" | grep 'img-responsive\|img-comic' | awk -F'"' '{print $10}' | sed '/^\s*$/d' | sed 's/^/https:/g')"

# the awk part separates the last part of the URL
# resulting in the random string of the image on assets.amuniversal.com
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"

wget -U "${ua}" -c -P "${downloadfolder}" "${imglink}"

# 2018-11-26
# idiot, you never tested if the image existed in the first place
# so when dilbert.com changed to https, your non-existing downloads
# still got mv-d
if [ ! -e "${downloadfolder}"/"${filename}" ];then

echo "The downloaded image doesn't exist."

fi


imgtype="$(file "${downloadfolder}"/"${filename}")"

case "${imgtype}" in

	*"JPEG image data"*) #jpg
	mv "${downloadfolder}"/"${filename}" "${downloadfolder}"/"${var}".jpg
	;;

	*"GIF image data"*) #gif
	#"${gifsicle}" -d 10 "${downloadfolder}"/"${filename}" > "${downloadfolder}"/"${var}".gif
	mv "${downloadfolder}"/"${filename}" "${downloadfolder}"/"${var}".gif
	;;

	*"PNG image data"*) #png
	mv "${downloadfolder}"/"${filename}" "${downloadfolder}"/"${var}".png
	;;

esac

rm -f "${downloadfolder}"/"${filename}"
sleep 6;
}

main()
{
# loop
while read -r var; do
# this if wrapper should skip existing images
if [ ! -e "${downloadfolder}/${var}".* ];then

# call the download function
download

fi
done < "${datelist}"
}

today()
{
	# today's formatted date
	todayis="$(tail -n 1 ${datelist})"

	# exit if today's comic is already download
	if [ -e "${downloadfolder}/${todayis}".* ];then
	printf "Today\\'s comic has already been downloaded.\\nExiting.\\n"
	exit
	fi

	# if wrapper to see today's comic doesn't exist
	# then download it
	if [ ! -e "${downloadfolder}/${todayis}".* ];then
	download
	fi
}

help()
{
dg="${pyscript}"
# terrorize the user with instructions!
clear
echo "Usage of $0:"
echo "By default, $0 expects ${dg} to be in the same directory."
echo "'${dg}' creates a list of dates that $0 can use."
echo ''
echo "You should specify the following arguments for $0 in the first argument: "
echo "eg: bash -x $0 --first-argument"
echo ''
echo 'To download all images or continue an interrupted job, use these flags for first argument:'
echo '-all|--all|-a|--a|-download|--download|-d|--d|-long|--long|-l|--l'
echo ''
echo "To only download today's comic, use these flags in first arg:"
echo "-today|--today|-todays|--todays|-t"
echo ''
echo 'For everything else, this useless help() function gets printed to the cli.'
}

case "$1" in
	# if first arg matches these flags, then run main() to download all
	-all|--all|-a|--a|-download|--download|-d|--d|-long|--long|-l|--l)
		main
		;;
	# for these flags, only download today's comic
	-today|--today|-todays|--todays|-t)
		today
		;;
	# for everything else, throw up our hands and behave like a child
	*)
		help
		;;
esac
