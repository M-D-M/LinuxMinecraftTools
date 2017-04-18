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

function grabLatestMCServerJar {
        MCJSON=$(curl -s $JSON_URL)
        LATEST_VER=$(getJSONVal "$(getJSONData "$MCJSON" latest)" release)

        LATEST_URL_DATA=$(echo $MCJSON | egrep -o "\"id\":\"${LATEST_VER}\"[^}]*")
        LATEST_VER_URL=$(getJSONVal "$LATEST_URL_DATA" url)

        MCURLJSON=$(curl -s $LATEST_VER_URL)
	SERVER_JAR_NAME=minecraft_server_${LATEST_VER}.jar

        SERVER_URL=$(getJSONVal "$(getJSONData "$MCURLJSON" server)" url)
        SERVER_FILE_SHA1=$(getJSONVal "$(getJSONData "$MCURLJSON" server)" sha1)

	LOCAL_FILE=$([[ -n $1 ]] && printf $1 || printf /tmp/$SERVER_JAR_NAME)

	if [[ -a "${LOCAL_FILE}" ]]; then
		printf "${LOCAL_FILE} exists -- moving to ${LOCAL_FILE}.old\n"
		mv ${LOCAL_FILE} ${LOCAL_FILE}.old
	fi

	printf "\nDownloading ${SERVER_JAR_NAME}..."
	wget -q -O ${LOCAL_FILE} ${SERVER_URL}
	printf "\nFile downloaded at: ${LOCAL_FILE}"

	printf "\nChecking sha1sum of ${LOCAL_FILE}..."
	DOWNLOAD_FILE_SHA1SUM=$(sha1sum ${LOCAL_FILE} | awk '{print $1}')

	if [ $(sha1sum "${LOCAL_FILE}" | awk '{print $1}') != "${SERVER_FILE_SHA1}" ]; then
		printf "\nSHA1 of downloaded file does not match!"
		rm ${LOCAL_FILE}
	else
		printf "\nSHA1 matches!\n"
	fi
}

grabLatestMCServerJar "$@"
