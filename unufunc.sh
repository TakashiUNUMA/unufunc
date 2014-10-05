#!/bin/sh
#
# unufunc.sh
#
# original script coded by Takashi Unuma, Kyoto Univ.
# Last modified: 2014/10/05
#

#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# change_time
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
change_time () {
    #
    if test $# -lt 3 ; then
	echo "USAGE: change_time [YYYYMMDDHHNN] [INT] [+/-]"
	echo " *** Note: All values must be 'integer'. *** "
    else
	#
	# Input TIME that must be '12 digits' with the format of 'YYYYMMDDHHNN'
	INPUTDATE=$1
	#
	# time difference, unit is 'second'
	INT=$2
	#
	# flag must be '+' or '-'
	FLAG=$3
	#
	# convert from TIME to UNIXTIME
	YYYY=`echo ${INPUTDATE}　| cut -c1-4`
	MM=`echo ${INPUTDATE}　| cut -c5-6`
	DD=`echo ${INPUTDATE}　| cut -c7-8`
	HH=`echo ${INPUTDATE}　| cut -c9-10`
	NN=`echo ${INPUTDATE}　| cut -c11-12`
	UTIME=$(date +%s --date "${YYYY}-${MM}-${DD} ${HH}:${NN}")
	#
	# Output modified TIME
	echo ${UTIME} ${INT} | awk '{print $1'${FLAG}'$2}' | awk '{print strftime("%Y%m%d%H%M",$1)}'
    fi
}


#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# modify_eps
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
modify_eps () {
    #
    if test $# -lt 1 ; then
	echo "USAGE: modify_eps [EPS file(s)]"
    else
	for file in $* ; do
	    bbinfo=$(gs -q -dNOPAUSE -dBATCH -sDEVICE=bbox ${file} 2>&1 | sed -e "s/\%/\\\%/g" -e "s/\:/\\\:/g" -e "s/\./\\\./g" -e "s/[[:blank:]]/\\\ /g" | awk '{printf $0}')
	    title=$(echo "%%Title: ${file}" | sed -e "s/\%/\\\%/g" -e "s/\:/\\\:/g" -e "s/\./\\\./g" -e "s/[[:blank:]]/\\\ /g")
	    sed -i -e "2c${bbinfo}" -e "3d" -e "4c${title}" ${file}
	done
    fi
}


#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# eps2pdf
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
eps2pdf () {
    #
    if test $# -lt 1 ; then
	echo "USAGE: eps2pdf [EPS file(s)]"
    else
	for file in $* ; do
	    echo "FILE: ${file}"
	    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEPSCrop -sOutputFile=${file%.eps}.pdf -c save pop -f ${file}
	done
    fi
}


#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# eps2multipdf
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
eps2multipdf () {
    #
    if test $# -lt 1 ; then
	echo "USAGE: eps2multipdf [EPS file(s)]"
    else
	gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dEPSCrop -sOutputFile=output.pdf -c save pop -f $*
    fi
}


#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# search_sentence
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
search_sentence () {
    #
    if test $# -lt 1 ; then
	echo "USAGE: search_sentence [word]"
    else
	#
	INWORD=$1
	DIR=/home/unuma/dropbox/Dropbox/file/Reference
	#
	for INFILE in $(ls ${DIR}/*.pdf) ; do
	    echo "-- $(basename ${INFILE}) --"
	    pdftotext -q ${INFILE} - | grep --color=auto "${INWORD}"
	    echo "---"
	done
    fi
}


#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# kuins_proxy
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
kuins_proxy () {
    #
    export http_proxy=http://proxy.kuins.net:8080/
    export https_proxy=http://proxy.kuins.net:8080/
    export ftp_proxy=http://proxy.kuins.net:8080/
}


#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
# unset_proxy
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
unset_proxy () {
    #
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
}

