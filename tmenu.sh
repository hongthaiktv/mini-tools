#!/data/data/com.termux/files/usr/bin/bash

tmenu() {
  local OPTION_COLOR=${MENU_OPTION_COLOR:-2}
  local SELECTED_COLOR=${MENU_SELECTED_COLOR:-46}
  local ARROW_COLOR=${MENU_ARROW_COLOR:-91}
  local ESC_KEY=$'\033'
  local ARROW_UP='A'
  local ARROW_DOWN='B'
  unset MENU_ORDER
  MENU_OPTION=( "$@" )
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

tmenu.search() {
  declare -l local search
  local pattern
  local line_opt
  local search_result

  if [[ -z $1 ]]; then
    echo
    read -rep "Search: " search
    echo
	pattern=*"$search"*
  else
    search="$1"
	pattern="$search"*
  fi
  
  if [[ "$menu_key1" == [a-z] || "$menu_key2" == "s" && -z "$1" ]]; then
    for (( i=$(( $MENU_ORDER + 1 )) ; i<${#MENU_OPTION[@]} ; i++ )); do
      line_opt="${MENU_OPTION[$i]}"

      if [[ "${line_opt,,}" == $pattern ]]; then
        search_result="${MENU_OPTION[$i]}"
        MENU_ORDER=$i
        break
      fi
    done

    if [[ -z "$search_result" ]]; then
      for (( i=1 ; i<=$MENU_ORDER ; i++ )); do
        line_opt="${MENU_OPTION[$i]}"

        if [[ "${line_opt,,}" == $pattern ]]; then
          search_result="${MENU_OPTION[$i]}"
          MENU_ORDER=$i
          break
        fi
      done
    fi
  elif [[ "$menu_key1" == [A-Z] || "$menu_key2" == "S" && -z "$1" ]]; then
    for (( i=$(( $MENU_ORDER - 1 )) ; i>0 ; i-- )); do
      line_opt="${MENU_OPTION[$i]}"

      if [[ "${line_opt,,}" == $pattern ]]; then
        search_result="${MENU_OPTION[$i]}"
        MENU_ORDER=$i
        break
      fi
    done

    if [[ -z "$search_result" ]]; then
		for (( i=$(( ${#MENU_OPTION[@]} - 1 )) ; i>=$MENU_ORDER ; i-- )); do
        line_opt="${MENU_OPTION[$i]}"

        if [[ "${line_opt,,}" == $pattern ]]; then
          search_result="${MENU_OPTION[$i]}"
          MENU_ORDER=$i
          break
        fi
      done
    fi
  fi

  if [[ ! -z "$search_result" ]]; then
    if [[ -z $1 ]]; then
      printf "\033[3A\033[0J"
    fi
    tmenu.select "${MENU_OPTION[@]}"
  else
    if [[ -z $1 ]]; then
      read -rsn1 -p "Item not found!" key
      echo
      printf "\033[4A\033[0J"
    fi
  fi
}

tmenu.show() {
for (( i=1; i<${#MENU_OPTION[@]}; i++ ))
do
  local line_opt="${MENU_OPTION[$i]}"
  if [ ${#line_opt} -gt 44 ]; then
	  line_opt="${line_opt:0:44}..."
  fi
  if [ "$MENU_SELECTED" = "$line_opt" ]
    then
      printf "\033[%sm>>\033[0m \033[%sm%s\033[0m\n" "$ARROW_COLOR" "$SELECTED_COLOR" "$line_opt"
      if [ -z $MENU_ORDER ]
        then
          MENU_ORDER=$i
      fi
      MENU_SELECTED="${MENU_OPTION[$i]}"
    else
      printf "   \033[%sm%s\033[0m\n" "$OPTION_COLOR" "$line_opt"
  fi
done
}

tmenu.select() {
  printf "\033[$(( ${#MENU_OPTION[@]} - 1 ))A\033[0J"
  MENU_SELECTED="${MENU_OPTION[$MENU_ORDER]}"
  if [ ${#MENU_SELECTED} -gt 44 ]; then
	  MENU_SELECTED="${MENU_SELECTED:0:44}..."
  fi
  tmenu.show "$@"
}

tmenu.show "$@"

if [ -z $MENU_ORDER ]
  then
    # Set missing default option to first option
    printf "\033[$(( ${#MENU_OPTION[@]} - 1 ))A\033[0J"
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

        0)
          echo
          exit
        ;;

        [1-9])
          read -rsn1 menu_key3
          case "$menu_key3" in
            [0-9])
              local order=$menu_key2$menu_key3
              if [ $order -lt ${#MENU_OPTION[@]} ]; then
                MENU_ORDER=$order
                tmenu.select "${MENU_OPTION[@]}"
                TMENU_RESULT="$MENU_SELECTED"
                break
              else
			    echo
                read -rsn1 -p "Wrong option $order! (1-$(( ${#MENU_OPTION[@]} - 1 )))" key
                echo
                printf "\033[2A\033[0J"
              fi
            ;;
          esac
        ;;

        "c"|"C")
          echo
          read -rep "Command: " cmd
          echo
          eval "$cmd"
          echo
          read -rsn1 -p "Press any key to continue..." key
          echo
          break
        ;;

        "h"|"H")
          local dotOpt=$(shopt -p dotglob)
          if [[ "${dotOpt:7:1}" == "u" ]]; then
            shopt -s dotglob
          else shopt -u dotglob
          fi
		  break
        ;;

        "s"|"S") tmenu.search ;;

        [a-zA-Z])
          TMENU_RESULT="$ESC_KEY$menu_key2"
          break
        ;;

        "[")
          read -rsn1 menu_key3
          case "$menu_key3" in
            "$ARROW_UP")
              if [ "$MENU_ORDER" -gt "1" ]
                then
                  (( --MENU_ORDER ))
                  tmenu.select "${MENU_OPTION[@]}"
              fi
            ;;

            "$ARROW_DOWN")
				if [ $MENU_ORDER -lt $(( ${#MENU_OPTION[@]} - 1 )) ]
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
      if [ $menu_key1 -eq 0 ]; then
		TMENU_RESULT=$menu_key1
    	break
      elif [ $menu_key1 -lt ${#MENU_OPTION[@]} ] && [ "$menu_key1" -gt 0 ]; then
        MENU_ORDER=$menu_key1
        tmenu.select "${MENU_OPTION[@]}"
        TMENU_RESULT="$MENU_SELECTED"
    	break
      fi
    ;;

    [a-zA-Z]) tmenu.search "$menu_key1" ;;

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

