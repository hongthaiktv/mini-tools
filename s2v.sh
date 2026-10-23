#!/data/data/com.termux/files/usr/bin/bash

convert() {
	local exeFile="/data/data/com.termux/files/home/svg2vector/Svg2VectorAndroid-1.1.1.jar"
	local msg
	if [[ -z "$1" ]]; then
		msg="Missing path argument."
	else
		java -jar "$exeFile" "$1"
		echo
		msg="SVG files converted to Android XML successful."
	fi


	read -rsn1 -p "$msg" key
	echo
}

convert "$1"

