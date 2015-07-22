#!/bin/bash

downloadurl="https://minecraft.net/download"
serverurl=""
loc=$([[ -n $1 ]] && printf $1 || printf "/tmp/minecraft_server.jar")

if [[ -a $loc ]]; then
	printf "$loc exists -- moving to ${loc}.old\n"
	mv $loc ${loc}.old
fi

printf "Getting download URL for minecraft server...\n"

serverurl=`curl -s $downloadurl | egrep -io 'https.*versions\/(.*)\/minecraft_server.\1.jar'`

printf "URL = "$serverurl"\n"

printf "Downloading server jar...\n"

wget -q -O $loc $serverurl
