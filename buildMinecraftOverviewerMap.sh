#!/bin/bash

exitCode=0
defaultCfgFile=/var/tmp/share/LinuxMinecraftTools/src/config.txt
logFileDir=${HOME}/log
outputDir="/var/www/html/Minecraft_Maps/"
textureFile="/var/tmp/share/LinuxMinecraftTools/src/minecraft.jar"

if [ $# -lt 2  ]; then
	printf "\nUsage: $0 [world data location] [world name] {custom config file}\n\n"
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

	printf "\nBuilding map at `date`..."
	overviewer.py --config=$config

	# Only build POI if custom config passed
	if [[ -r $3 ]]; then
		printf "\nBuilding POI..."
		overviewer.py --config $config --genpoi --skip-scan
	fi

	printf "\nFinished operation at `date`..."
fi

exit $exitCode
