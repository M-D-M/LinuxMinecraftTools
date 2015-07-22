#!/bin/bash

exitCode=0

if [ $# -lt 1 ]; then
	echo ""
	echo "Usage: $0 [Minecraft Game Jar Version]"
	echo ""

	exitCode=1
else
	VERSION=$1
	mv src/minecraft.jar src/minecraft.jar.old
	wget -O src/minecraft.jar https://s3.amazonaws.com/Minecraft.Download/versions/$VERSION/${VERSION}.jar
fi

exit $exitCode
