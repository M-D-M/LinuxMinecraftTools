#!/bin/bash

. $(dirname $0)/src/common.bash

function main {
        MCJSON=$(curl -s $__MC_JSON_URL)
        LATEST_VER=$(getJSONVal "$(getJSONData "$MCJSON" latest)" release)
	
	printf "${LATEST_VER}"
}

main "$@"
