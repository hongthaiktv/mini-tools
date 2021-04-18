#!/bin/bash

source ./tmenu.sh
tmenu --help
tmenu --color 33 41 96
tmenu "option 1" "option 2" "option 3" "option 4"
echo "You select $TMENU_RESULT."
echo

tmenu --color
tmenu "option 7" "option 5" "option 6" "option 7" "option 8"
echo "You select $TMENU_RESULT."

read -rsn1 key

