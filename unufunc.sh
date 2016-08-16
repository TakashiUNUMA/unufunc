#!/bin/sh
#
# unufunc.sh
#
# original script was coded by Takashi Unuma, Kyoto Univ.
#                  modified by Takashi Unuma, JMA
# last modified: 16th August, 2016
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
# mm2MMM
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
mm2MMM () {
    #
    if test $# -lt 1 ; then
	echo "USAGE: mm2MMM mm"
	echo "   ex) mm2MMM 05"
    else
	#
	mm=$1
	#
	if test ${mm} = "01" ; then
	    MMM=JAN
	elif test ${mm} = "02" ; then
	    MMM=FEB
	elif test ${mm} = "03" ; then
	    MMM=MAR
	elif test ${mm} = "04" ; then
	    MMM=APR
	elif test ${mm} = "05" ; then
	    MMM=MAY
	elif test ${mm} = "06" ; then
	    MMM=JUN
	elif test ${mm} = "07" ; then
	    MMM=JUL
	elif test ${mm} = "08" ; then
	    MMM=AUG
	elif test ${mm} = "09" ; then
	    MMM=SEP
	elif test ${mm} = "10" ; then
	    MMM=OCT
	elif test ${mm} = "11" ; then
	    MMM=NOV
	elif test ${mm} = "12" ; then
	    MMM=DEC
	else
	    echo "Unrecognized month!!"
	fi
	#
	echo "${MMM}"
	#
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
# preset_script
#ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
preset_script () {
    #
    nowtime=`date`
    echo "#!/bin/bash"
    echo "#"
    echo "# "
    echo "#"
    echo "# original script was coded by Takashi Unuma, Japan Meteorological Agency"
    echo "# last modified: ${nowtime}"
    echo "#"
    #
}
