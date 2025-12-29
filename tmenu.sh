#!/data/data/com.termux/files/usr/bin/bash

tmenu() {
  local OPTION_COLOR=${MENU_OPTION_COLOR:-2}
  local SELECTED_COLOR=${MENU_SELECTED_COLOR:-46}
  local ARROW_COLOR=${MENU_ARROW_COLOR:-91}
  local ESC_KEY=$'\033'
  local ARROW_UP='A'
  local ARROW_DOWN='B'
  MENU_OPTION=( "$@" )
  MENU_ORDER=""
  MENU_SELECTED="$1"

  if [ ${#MENU_SELECTED} -gt 44 ]; then
	  MENU_SELECTED="${MENU_SELECTED:0:44}..."
  fi

unset TMENU_RESULT
printf "\033[?25l"

tmenu.color() {
  MENU_OPTION_COLOR=${1:-2}
  MENU_SELECTED_COLOR=${2:-46}
  MENU_ARROW_COLOR=${3:-91}
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
  if [ ${#line_opt} -gt 44 ]; then
	  line_opt="${line_opt:0:44}..."
  fi
  if [ "$MENU_SELECTED" = "$line_opt" ]
    then
      printf "\033[%sm>>\033[0m \033[%sm%s\033[0m\n" "$ARROW_COLOR" "$SELECTED_COLOR" "$line_opt"
      if [ -z $MENU_ORDER ]
        then
          MENU_ORDER="$i"
      fi
      MENU_SELECTED="${@:$MENU_ORDER:1}"
    else
      printf "   \033[%sm%s\033[0m\n" "$OPTION_COLOR" "$line_opt"
  fi
done
}

tmenu.select() {
  printf "\033[$(( $# - 1 ))A\033[0J"
  MENU_SELECTED="${@:$MENU_ORDER:1}"
  if [ ${#MENU_SELECTED} -gt 44 ]; then
	  MENU_SELECTED="${MENU_SELECTED:0:44}..."
  fi
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
  case "$menu_key1" in
    "$ESC_KEY")
      read -rsn1 menu_key2
      case "$menu_key2" in
        "$ESC_KEY")
          TMENU_RESULT="$ESC_KEY"
          break
        ;;

        [a-z])
          TMENU_RESULT="$ESC_KEY$menu_key2"
          break
        ;;

        "[")
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
        ;;
      esac
    ;;  

    [0-9])
      if [ "$menu_key1" -eq 0 ]; then
		TMENU_RESULT="$menu_key1"
    	break
      elif [ "$menu_key1" -lt "${#MENU_OPTION[@]}" ] && [ "$menu_key1" -gt 0 ]; then
        MENU_ORDER=$(( menu_key1 + 1 ))
        tmenu.select "${MENU_OPTION[@]}"
        TMENU_RESULT="$MENU_SELECTED"
    	break
      fi
    ;;

    [A-Z])
      TMENU_RESULT="$menu_key1"
      break
    ;;
	
    "")
      # export TMENU_RESULT if compile to binary
      TMENU_RESULT="$MENU_SELECTED"
      break
    ;;
  esac
done
echo
printf "\033[?25h"
}

# Call tmenu "$@" if compile to binary

