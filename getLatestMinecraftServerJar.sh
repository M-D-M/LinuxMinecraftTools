#!/bin/bash

tmpfile=/tmp/minecrafttempfile.tmp
downloadurl="https://minecraft.net/download"
serverurl=""
loc=$([[ -n $1 ]] && echo $1 || echo "/tmp/minecraft_server.jar")

echo "Grabbing minecraft download page..."

curl $downloadurl > $tmpfile

echo "Getting download URL for minecraft server..."

serverurl=`egrep -io 'https.*versions\/(.*)\/minecraft_server.\1.jar' $tmpfile`

echo "URL = "$serverurl

echo "Downloading server jar..."

wget -q -O $loc $serverurl
