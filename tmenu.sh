#!/bin/bash

tmenu() {
  local OPTION_COLOR=${TMENU_OPTION_COLOR:-2}
  local SELECTED_COLOR=${TMENU_SELECTED_COLOR:-46}
  local ARROW_COLOR=${TMENU_ARROW_COLOR:-91}
  local ESC_KEY=$'\033'
  local ARROW_UP='A'
  local ARROW_DOWN='B'
  local MENU_SELECTED="$1"
  local MENU_ORDER=""
  local MENU_OPTION=( "$@" )
  local MENU_TITLE=()

[ $# -eq 0 ] && printf "\033[91m%s\033[0m\n" "ERROR: Please input at least 1 option." && return 99

unset TMENU_RESULT
printf "\033[?25l"

tmenu.color() {
  TMENU_OPTION_COLOR=${1:-2}
  TMENU_SELECTED_COLOR=${2:-46}
  TMENU_ARROW_COLOR=${3:-91}
}

if [ "$1" = "--color" ]
  then
    if [ "$2" = "-s" ]
      then
        tmenu.color "$3" "$4" "$5"
      else
        tmenu.color "$2" "$3" "$4"
        echo "Menu color changed to '$MENU_OPTION_COLOR $MENU_SELECTED_COLOR $MENU_ARROW_COLOR'."
        echo
    fi
    return

elif [ "$1" = "--help" ]
  then
    printf "
Syntax: tmenu [default] [option 1] [option 2]... [option n]
        tmenu --color -s [OPTION SELECTED ARROW] color code.

--color	: Set color option for tmenu.
	  (--color with no argument to set default color).
-s	: Silent - Do not echo message to terminal.
--help	: This help screen.

Exp: tmenu 'tmenu' 'tmenu' 'so' 'cool'
Will generate menu with 3 option and select 'tmenu' option as default.
If no default argument, first option will be set as default.
Press 'q' to quit tmenu.

Variable:
TMENU_RESULT: Get selected result.

Using 'source /path/tmenu.sh' to add to your script before call tmenu.

"
    return
fi

tmenu.show() {

for (( i=2; i<=$#; i++ ))
do
  local line_opt=${@:$i:1}
  if [ "$MENU_SELECTED" = "$line_opt" ]
    then
      printf "\033[%sm>>\033[0m \033[%sm%s\033[0m\n" "$ARROW_COLOR" "$SELECTED_COLOR" "$line_opt"
      if [ -z $MENU_ORDER ]
        then
          MENU_ORDER="$i"
      fi
    else
      printf "   \033[%sm%s\033[0m\n" "$OPTION_COLOR" "$line_opt"
  fi
done
}

tmenu.select() {
  printf "\033[$(( $# - 1 ))A\033[0J"
  MENU_SELECTED=${@:$MENU_ORDER:1}
  tmenu.show "$@"
}

tmenu.show "$@"

if [ -z $MENU_ORDER ]
  then
    # Set missing default option to first option
    printf "\033[$(( $# - 1 ))A\033[0J"
    MENU_OPTION=( "$1" "$@" )
    tmenu.show "${MENU_OPTION[@]}"
fi

while :
do
  read -rsn1 menu_key1
  if [ "$menu_key1" = "$ESC_KEY" ]
    then
      read -rsn1 menu_key2
        if [ "$menu_key2" = "[" ]
          then
            read -rsn1 menu_key3
            case "$menu_key3" in
              "$ARROW_UP")
                  if [ "$MENU_ORDER" -gt "2" ]
                    then
                    (( --MENU_ORDER ))
                    tmenu.select "${MENU_OPTION[@]}"
                  fi
              ;;
              "$ARROW_DOWN")
                  if [ "$MENU_ORDER" -lt "${#MENU_OPTION[@]}" ]
                    then
                    (( ++MENU_ORDER ))
                    tmenu.select "${MENU_OPTION[@]}"
                  fi
              ;;
            esac
	fi
    elif [ "$menu_key1" = "q" ] || [ "$menu_key1" = "Q" ]
      then
        break
    elif [ -z $menu_key1 ]
      then
        # export TMENU_RESULT if compile to binary
        TMENU_RESULT=$MENU_SELECTED
        break
  fi
done
echo
printf "\033[?25h"
}

# Call tmenu "$@" if compile to binary

