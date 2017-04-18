#!/bin/bash

exitCode=0
_BASE_DIR=$(dirname $0)
defaultCfgFile="${_BASE_DIR}/src/config.txt"
logFileDir=${HOME}/log
outputDir="/var/www/html/Minecraft_Maps/"
textureFile="${_BASE_DIR}/src/minecraft_client.jar"

if [ $# -lt 2  ]; then
	printf "\nUsage: $0 [world data location] [world name] {custom config file} {only generate POI = true|false}\n\n"
	exitCode=1
elif [ ! -x /usr/bin/overviewer.py ]; then
	printf "\nOverviewer not installed -- please install overviewer to use this script.\n\n"
	exitCode=1
else
	export worldName=$2
	export worldLoc=$1
	export curDate=`date`
	export outputDir
	export textureFile

	exec >> ${logFileDir}/overviewer-buildlog-${worldName}.txt

	if [[ -r $3 ]]; then
		printf "\nCustom config file passed: "$3
		config=$3
	else
		printf "\nNo custom config passed -- skipping POI creation..."
		config=$defaultCfgFile
	fi

	if [[ $4 != "true" ]]; then	
		printf "\nBuilding map at `date`..."
		overviewer.py --config=$config
	else
		printf "\nOnly rendering POI -- skipping map creation..."
	fi

	# Only build POI if custom config passed
	if [[ -r $3 ]]; then
		printf "\nBuilding POI..."
		overviewer.py --config $config --genpoi --skip-scan
	fi

	printf "\nFinished operation at `date`...\n"
fi

exit $exitCode
