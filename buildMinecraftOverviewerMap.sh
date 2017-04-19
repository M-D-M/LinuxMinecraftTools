#!/bin/bash

. $(dirname $0)/src/common.bash

_EXITCODE=0
_CONFIG="${__BASE_DIR}/src/config.txt"
_LOGFILEDIR=${HOME}/log
outputDir="/var/www/html/Minecraft_Maps/"
textureFile="${__DEFAULT_CLIENT_JAR_LOC}"

if [ $# -lt 2  ]; then
	printf "\nUsage: $0 [world data location] [world name] {custom config file} {only generate POI = true|false}\n\n"
	_EXITCODE=1
elif [ ! -x /usr/bin/overviewer.py ]; then
	printf "\nOverviewer not installed -- please install overviewer to use this script.\n\n"
	_EXITCODE=1
else
	export worldName=$2
	export worldLoc=$1
	export curDate=`date`
	export outputDir
	export textureFile

	exec >> ${_LOGFILEDIR}/overviewer-buildlog-${worldName}.txt

	if [[ -r $3 ]]; then
		printf "\nCustom config file passed: "$3
		_CONFIG=$3
	fi

	if [[ $4 != "true" ]]; then	
		printf "\nBuilding map at `date`..."
		overviewer.py --config=${_CONFIG}
	fi

	# Only build POI if custom config passed
	if [[ -r $3 ]]; then
		printf "\nBuilding POI..."
		overviewer.py --config ${_CONFIG} --genpoi --skip-scan
	fi

	printf "\nFinished operation at `date`...\n"
fi

exit $_EXITCODE
