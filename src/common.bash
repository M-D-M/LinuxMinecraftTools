#!/bin/bash

__MC_JSON_URL='https://launchermeta.mojang.com/mc/game/version_manifest.json'
__DEFAULT_CLIENT_JAR_LOC="$(dirname $0)/src/minecraft_client.jar"
__BASE_DIR=$(dirname $0)

function getJSONData {
        echo $1 | egrep -o "\"$2\": ?[^\}]*(\}|\")" | sed "s/\"$2\"://"
}

function getJSONVal {
        echo $1 | egrep -o "\"$2\": ?\"[^\"]*" | sed "s/\"$2\"://" | tr -d '{}" '
}
