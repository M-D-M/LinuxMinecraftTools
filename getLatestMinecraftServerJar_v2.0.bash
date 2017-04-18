#!/bin/bash

JSON_URL='https://launchermeta.mojang.com/mc/game/version_manifest.json'
SERVER_URL=
SERVER_FILE_SHA1=

function getJSONData {
        echo $1 | egrep -o "\"$2\": ?[^\}]*(\}|\")" | sed "s/\"$2\"://"
}

function getJSONVal {
        echo $1 | egrep -o "\"$2\": ?\"[^\"]*" | sed "s/\"$2\"://" | tr -d '{}" '
}

function grabLatestMCServerJar {
        MCJSON=$(curl -s $JSON_URL)
        LATEST_VER=$(getJSONVal "$(getJSONData "$MCJSON" latest)" release)

        LATEST_URL_DATA=$(echo $MCJSON | egrep -o "\"id\":\"${LATEST_VER}\"[^}]*")
        LATEST_VER_URL=$(getJSONVal "$LATEST_URL_DATA" url)

        MCURLJSON=$(curl -s $LATEST_VER_URL)
	SERVER_JAR_NAME=minecraft_server_${LATEST_VER}.jar

        SERVER_URL=$(getJSONVal "$(getJSONData "$MCURLJSON" server)" url)
        SERVER_FILE_SHA1=$(getJSONVal "$(getJSONData "$MCURLJSON" server)" sha1)

	if [ $1 == "config" ]; then
		printf ${SERVER_URL}
	else
		wget -O /tmp/${SERVER_JAR_NAME} ${SERVER_URL}

		DOWNLOAD_FILE_SHA1SUM=$(sha1sum /tmp/${SERVER_JAR_NAME} | awk '{print $1}')

		if [ $(sha1sum /tmp/${SERVER_JAR_NAME} | awk '{print $1}') != ${SERVER_FILE_SHA1} ]; then
			printf "\nSHA1 of downloaded file does not match!"
			rm /tmp/${SERVER_JAR_NAME}
		else
			printf "\nFile downloaded at: /tmp/${SERVER_JAR_NAME}"
		fi
	fi
}

grabLatestMCServerJar "$@"
