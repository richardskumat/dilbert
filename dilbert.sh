#!/bin/bash

# directory the script is launched from
# bashism
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#DIR="$(pwd -P)"
#DIR="$(pwd)"

#2018-11-26
# update to https
url="https://dilbert.com/strip/"
ref="https://dilbert.com"

ua='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:69.0) Gecko/20100101 Firefox/69.0'

# dates
# fall back to python
# on android termux python package is actually python3
py3="$(command -v python3 || command -v python || echo 'no python found in path, exiting.' && exit)"
pyscript="${DIR}/date-generator.py"

# trying to get /bin/sh to work
if [ ! -e "${pyscript}" ];then
echo "Var pyscript/date-generator.py not found, exiting."
exit
fi
datelist="${DIR}/date.list"
"${py3}" "${pyscript}" > "${datelist}"


downloadfolder="$HOME/Pictures/dilbert"

# if downloadfolder doesn't exist, make it
if [ ! -d "${downloadfolder}" ];then
	mkdir -p "${downloadfolder}"
fi


nocurl()
{
clear
printf "curl not found in your PATH var."
exit
}
command -v curl > /dev/null 2>&1 || nocurl

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
var="$(tail -n 1 "${datelist}")"
fi

# 2018-11-26
# added last sed since the site changes from http to https
imglink="$(curl -sS -L -A "${ua}" --referer ${ref} "${url}""${var}" | grep 'img-responsive\|img-comic' | awk -F'"' '{print $10}' | sed '/^\s*$/d' | sed 's/^/https:/g')"

# the awk part separates the last part of the URL
# resulting in the random string of the image on assets.amuniversal.com
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"

curl -A "${ua}" -o "${downloadfolder}/${filename}" "${imglink}"

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

# clean up the temporary date file
rm_date_list

}

today()
{
	# today's formatted date
	todayis="$(tail -n 1 "${datelist}")"

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

	# clean up the temporary date file
	rm_date_list
}

rm_date_list()
{
	if [ -e "${datelist}" ];then
	# clean up the temporary date file
	rm -f "${datelist}"
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
echo '-a'
echo ''
echo "To only download today's comic, use these flags in first arg:"
echo "-t"
echo ''
echo 'For everything else, this useless help() function gets printed to the cli.'
}

case "$1" in
	# if first arg matches these flags, then run main() to download all
	-a)
		main
		;;
	# for these flags, only download today's comic
	-t)
		today
		;;
	# for everything else, throw up our hands and behave like a child
	*)
		help
		;;
esac
