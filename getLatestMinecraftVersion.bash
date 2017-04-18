#!/bin/bash

JSON_URL='https://launchermeta.mojang.com/mc/game/version_manifest.json'
LOCAL_FILE=
SERVER_URL=
SERVER_FILE_SHA1=

function getJSONData {
        echo $1 | egrep -o "\"$2\": ?[^\}]*(\}|\")" | sed "s/\"$2\"://"
}

function getJSONVal {
        echo $1 | egrep -o "\"$2\": ?\"[^\"]*" | sed "s/\"$2\"://" | tr -d '{}" '
}

function main {
        MCJSON=$(curl -s $JSON_URL)
        LATEST_VER=$(getJSONVal "$(getJSONData "$MCJSON" latest)" release)
	
	printf "${LATEST_VER}"
}

main "$@"
