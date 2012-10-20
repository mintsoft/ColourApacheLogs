#!/bin/bash
#Reads from standard in and provides some higlighting to a common format apache log file
# 2011 - RE

while getopts :ru opt
do case "$opt" in
     r) stripReferrer="1";;
     u) stripUA="1";;
    \?) echo -e "Will provide highlighting to common format Apache Logs on STDIN\nArguments:\n\t-r to strip the referrer\n\t-u to String the UA " && exit 1;;
esac
done

if [[ ! -z $stripUA ]]; then
    EXTRA_SED=" -e "'s/\("[^"]\+"[^"]\+"[^"]\+"\)[[:space:]]"\([^"]\+\)"/\1/'
fi

if [[ ! -z $stripReferrer ]]; then
    EXTRA_SED="${EXTRA_SED} -e "'s/\("[^"]\+"[^"]\+\)[[:space:]]"\([^"]\+\)"/\1/'
fi

#sed's IN ORDER:
#Higlight IP
#Date
#Time
#URL accessed & Status Code
#UserAgent
#Internet Explorer
#Firefox/Chrome/Safari
#Windows Version
#Macintosh

COL_CHAR=$(echo -e "\033")
sed -e \
  's/\(\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}\)/'${COL_CHAR}'[0;32m\1'${COL_CHAR}'[0m/' -e \
  's/\[\([0-9]\{1,2\}\/[A-Za-z]\{3\}\/[0-9]\{4\}\):\([0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}\) /['${COL_CHAR}'[0;33m\1'${COL_CHAR}'[0m:'${COL_CHAR}'[1;31m\2'${COL_CHAR}'[0m /' -e\
  's/"\([A-Z]\{3,8\}\) \([^"]\+\) \(HTTP\/[0-9]\(\.[0-9]\)\?\)" \([0-9]\{3\}\)/"\1 '${COL_CHAR}'[1;36m\2 '${COL_CHAR}'[0m\3" '${COL_CHAR}'[1;35m\5'${COL_CHAR}'[0m/'  -e \
  's/\("[^"]\+"[^"]\+"[^"]\+"\) "\([^"]\+\)"/\1 "'${COL_CHAR}'[1;37m\2'${COL_CHAR}'[0m"/' -e \
  's/\(MSIE [0-9]\+\.[0-9]\)/'${COL_CHAR}'[0;31m\1'${COL_CHAR}'[0m/' -e \
  's/\(\(Chrome\|Firefox\|Safari\)[^ ";]\+\)/'${COL_CHAR}'[0;31m\1'${COL_CHAR}'[0m/g' -e \
  's/\(Windows [^";\)]\+\)/'${COL_CHAR}'[1;33m\1'${COL_CHAR}'[0m/' -e \
  's/\(Macintosh\)/'${COL_CHAR}'[1;33m\1'${COL_CHAR}'[0m/' -e \
  ${EXTRA_SED}


