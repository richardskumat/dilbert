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

ua='Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101 Firefox/68.0'

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
var="$(date +"%Y-%m-%d")"
fi

imglink="$(curl -sS -L -A "${ua}" --referer ${ref} "${url}${var}" | grep 'img-responsive\|img-comic' | awk -F'"' '{print $10}' | sed '/^\s*$/d' | sed 's/^/https:/g')"

#imglink="$(curl -sS -L -A "${ua}" --referer ${ref} https://gog.com | grep 'img-responsive\|img-comic' | awk -F'"' '{print $10}' | sed '/^\s*$/d' | sed 's/^/https:/g')"

if [ -z "${imglink}" ];then
echo "
imglink variable is empty, which means
this scipt had an issue parsing dilbert.com.

Exiting.
"
exit
fi


# the awk part separates the last part of the URL
# resulting in the random string of the image on assets.amuniversal.com
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"

curl -sS -A "${ua}" -o "${downloadfolder}/${filename}" "${imglink}"

if [ ! -e "${downloadfolder}/${filename}" ];then

echo "The downloaded image doesn't exist."

fi

# this is idiotic, I'm relying on file output for $imgtype to be stable for years
imgtype="$(file "${downloadfolder}/${filename}")"

case "${imgtype}" in


	*"JPEG image data"*) #jpg
	mv "${downloadfolder}/${filename}" "${downloadfolder}/${var}".jpg
	;;

	*"GIF image data"*) #gif
	mv "${downloadfolder}/${filename}" "${downloadfolder}/${var}".gif
	;;

	*"PNG image data"*) #png
	mv "${downloadfolder}/${filename}" "${downloadfolder}/${var}".png
	;;

esac

if [ -d "${downloadfolder}/${filename}" ];then
echo
"The temporary downloaded file from assets.universal.com
does not exist.

Exiting.
"
exit
fi

if [ -e "${downloadfolder}/${filename}" ];then
# don't use -r to prevent recursive force deletion
rm -f "${downloadfolder}/${filename}"
fi

sleep 6;
}

main()
{

# dates
# fall back to python
# on android termux python package is actually python3
py3="$(command -v python3 || command -v python || exit)"
pyscript="${DIR}/date-generator.py"

# trying to get /bin/sh to work
if [ ! -e "${pyscript}" ];then
echo "Var pyscript/date-generator.py not found, exiting."
exit
fi
datelist="${DIR}/date.list"
"${py3}" "${pyscript}" > "${datelist}"

if test $? -gt 0;then
echo "
There was an error with ${pyscript}.
Please see the output of $0.
"
exit
fi

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
	todayis="$(date +"%Y-%m-%d")"

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
	# if first arg matches is -a, then run main() to download all
	-a)
		main
		;;
	# for -t, only download today's comic
	-t)
		today
		;;
	# for everything else, throw up our hands and behave like a child
	*)
		help
		;;
esac
