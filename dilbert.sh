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


downloadfolder="$HOME/Downloads/dilbert"
downloadparent="$HOME/Downloads"

# Pictures folder
# actual place to save the images
picturesfolder="$HOME/Pictures/dilbert"

if [ ! -d "${picturesfolder}" ];then
	mkdir -p "${picturesfolder}"
fi

# if downloadfolder doesn't exist, make it
if [ ! -d "${downloadfolder}" ];then
	mkdir -p "${downloadparent}"
	ln -s "${picturesfolder}" "${downloadfolder}"
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

# exceptions list
# 2018-11-26
# this needs revision
# because links die
# add some archive.org or archive.is links?

if [ "${var}" = 1993-02-11 ];then
# http://www.amureprints.com/reprints/dt/02/11/1993
# due to dilbert.com 500 server error on this comic
# and no trace on archive.org either
imglink="http://assets.amuniversal.com/34234d209ab5013331d7005056a9545d"
# imglink="https://i.imgur.com/HsD2OqV.gif"
# archive.is link
# archive.org won't work due to site's robots.txt file
#imglink="https://archive.is/AaFbK/d02c205bd76613bac31ded5f2ca1b0306493422f"
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"
fi

if [ "${var}" = 2011-11-28 ];then
# 500
imglink="http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111128.gif"
# archive.org link
#imglink="https://web.archive.org/web/20170906182004if_/http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111128.gif"
# archive.is link
#imglink="https://archive.is/IW99h/6694a659973aedabf83b368e17e3b1997d2cf257.gif"
#imglink="https://i.imgur.com/d3Q5ipC.gif"
# $NF = last match
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"
fi

if [ "${var}" = 2011-11-29 ];then
# 500
imglink="http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111129.gif"
# archive.org link
#imglink="https://web.archive.org/web/20170906182519if_/http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111129.gif"
# archive.is link
#imglink="https://archive.is/yE1PY/9b072aaf2dde4e5140c37810ae92539a9506408f.gif"
#imglink="https://i.imgur.com/2iJliFP.gif"
# $NF = last match
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"
fi

if [ "${var}" = 2011-11-30 ];then
# 500
imglink="http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111130.gif"
# archive.org link
#imglink="https://web.archive.org/web/20170906182939if_/http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111130.gif"
# archive.is link
#imglink="https://archive.is/ruSyK/f334d9a11a368a70181f30052a745fa0ccb85388.gif"
# imglink="https://i.imgur.com/kgGKt9J.gif"
# $NF = last match
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"
fi

if [ "${var}" = 2011-12-01 ];then
# another case of se 500
imglink="http://web-pm.ru/dilbert/archive/2011-12-01.gif"
# archive.org link
#imglink="https://web.archive.org/web/20170906183137if_/http://web-pm.ru/dilbert/archive/2011-12-01.gif"
# archive.is link
#imglink="https://archive.is/vmNxa/15293b1c0d530a451120fb16b26ba945efc1cf59.gif"
#imglink="https://i.imgur.com/O9ZMV9k.gif"
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"
fi

if [ "${var}" = 2011-12-02 ];then
# 500
imglink="http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111202.gif"
# archive.org link
#imglink="https://web.archive.org/web/20170906183334if_/http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111202.gif"
# archive.is link
#imglink="https://archive.is/hcKfr/97104ccbbc4bf549034771fcbedd6987d31acb2c.gif"
# $NF = last match
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"
fi

if [ "${var}" = 2011-12-03 ];then
# 500
imglink="http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111203.gif"
# archive.org link
#imglink="https://web.archive.org/web/20170906183446if_/http://www.acc.umu.se/~zqad/webcom3/dilbert/2011/111203.gif"
# archive.is link
#imglink="https://archive.is/N8HJE/e3cfd8f50c07d2ccf9919019f75c772768ebc835.gif"
#imglink="https://i.imgur.com/RnXfBUw.gif"
# $NF = last match
filename="$(echo "${imglink}" | awk -F'/' '{print $NF}')"
fi

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
echo "You should specify the following arguements for $0 in the first arguement: "
echo "eg: bash -x $0 --first-arguement"
echo ''
echo 'To download all images or continue an interrupted job, use these flags for first arguement:'
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
