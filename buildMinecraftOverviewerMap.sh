#!/bin/bash

exitCode=0
default_cfg_file=/var/tmp/share/cfg/config.txt

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

	exec >> ${HOME}/log/overviewer-buildlog-${worldName}.txt

	if [[ -r $3 ]]; then
		printf "\nCustom config file passed: " $3
		config=$3
	else
		config=$default_cfg_file
	fi

	echo $'\n'
	printf "\nBeginning build operation on `date`..."

	printf "\nCopying world to temp folder..."
	cp -pr $worldLoc /tmp/${worldName}

	printf "\nBuilding map at `date +%T`..."
	overviewer.py --config=$config

	# Only build POI if custom config passed
	if [[ -r $3 ]]; then
		printf "\nBuilding POI..."
		overviewer.py --config $config --genpoi
	else
		printf "\nNo custom config passed -- skipping POI creation..."
	fi

	printf "\nFinished operation at `date`..."
	rm -rf /tmp/${worldName}
fi

exit $exitCode
