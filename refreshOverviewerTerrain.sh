#!/bin/bash

_EXITCODE=0
_DEFAULT_CLIENT_JAR_LOC='/tmp/minecraft_client.jar'
_BASE_DIR=$(dirname $0)

function main {
	LOCAL_FILE=$([[ -n $1 ]] && printf $1 || printf ${_DEFAULT_CLIENT_JAR_LOC})

	if [[ -a "${LOCAL_FILE}" ]]; then
		printf "${LOCAL_FILE} exists -- moving to ${LOCAL_FILE}.old\n"
		mv ${LOCAL_FILE} ${LOCAL_FILE}.old
	fi

	VERSION=$(${_BASE_DIR}/getLatestMinecraftVersion.bash)
	printf "\nDownloading minecraft client version ${VERSION} to ${LOCAL_FILE}..."
	wget -q -O ${LOCAL_FILE} https://s3.amazonaws.com/Minecraft.Download/versions/${VERSION}/${VERSION}.jar
}

main "$@"
exit $_EXITCODE
