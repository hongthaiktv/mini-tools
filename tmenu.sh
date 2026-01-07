#!/data/data/com.termux/files/usr/bin/bash

tmenu() {
	local OPTION_COLOR=${MENU_LIST_COLOR:-2}
	local SELECTED_COLOR=${MENU_SELECTED_COLOR:-46}
	local ARROW_COLOR=${MENU_ARROW_COLOR:-91}
	local ESC_KEY=$'\033'
	local ARROW_UP='A'
	local ARROW_DOWN='B'
	local MENU_OPTION=( "-c" "-n" "-s" )
	declare -a user_option
	MENU_LIST=( "$@" )

	unset MENU_ORDER
	unset TMENU_RESULT
	printf "\033[?25l"

	for (( i=0 ; i<${#MENU_LIST[@]} ; i++ )); do
		local setOpt="${MENU_LIST[$i]}"
		for option in "${MENU_OPTION[@]}"; do
			if [[ "$setOpt" == "$option" ]]; then
				user_option=( "$setOpt" "${user_option[@]}" )
				unset MENU_LIST[$i]
				MENU_LIST=( "${MENU_LIST[@]}" )
				(( --i ))
			fi
		done
	done

	MENU_SELECTED="${MENU_LIST[0]}"

	if [ ${#MENU_SELECTED} -gt 44 ]; then
		MENU_SELECTED="${MENU_SELECTED:0:44}..."
	fi

	tmenu.color() {
		MENU_LIST_COLOR=${1:-2}
		MENU_SELECTED_COLOR=${2:-46}
		MENU_ARROW_COLOR=${3:-91}
	}

	if [[ "$1" == "--color" ]]; then
		if [[ "$2" == "-s" ]]; then
			tmenu.color "$3" "$4" "$5"
		else
			tmenu.color "$2" "$3" "$4"
			echo "Menu color changed to '$MENU_LIST_COLOR $MENU_SELECTED_COLOR $MENU_ARROW_COLOR'."
			echo
		fi
		return
	elif [[ "$1" == "--help" ]]; then
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
		declare -l search=""
		local pattern
		local list_item=""
		local search_result=""

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
			for (( i=$(( $MENU_ORDER + 1 )) ; i<${#MENU_LIST[@]} ; i++ )); do
				list_item="${MENU_LIST[$i]}"
				if [[ "${list_item,,}" == $pattern ]]; then
					search_result="${MENU_LIST[$i]}"
					MENU_ORDER=$i
					break
				fi
			done

			if [[ -z "$search_result" ]]; then
				for (( i=1 ; i<=$MENU_ORDER ; i++ )); do
					list_item="${MENU_LIST[$i]}"
					if [[ "${list_item,,}" == $pattern ]]; then
						search_result="${MENU_LIST[$i]}"
						MENU_ORDER=$i
						break
					fi
				done
			fi

		elif [[ "$menu_key1" == [A-Z] || "$menu_key2" == "S" && -z "$1" ]]; then
			for (( i=$(( $MENU_ORDER - 1 )) ; i>0 ; i-- )); do
				list_item="${MENU_LIST[$i]}"
				if [[ "${list_item,,}" == $pattern ]]; then
					search_result="${MENU_LIST[$i]}"
					MENU_ORDER=$i
					break
				fi
			done

			if [[ -z "$search_result" ]]; then
				for (( i=$(( ${#MENU_LIST[@]} - 1 )) ; i>=$MENU_ORDER ; i-- )); do
					list_item="${MENU_LIST[$i]}"
					if [[ "${list_item,,}" == $pattern ]]; then
						search_result="${MENU_LIST[$i]}"
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
			tmenu.select "${MENU_LIST[@]}"
		else
			if [[ -z $1 ]]; then
				read -rsn1 -p "Item not found!" key
				echo
				printf "\033[4A\033[0J"
			fi
		fi
	}

	tmenu.show() {
		for (( i=1 ; i<${#MENU_LIST[@]} ; i++ )); do
			local list_item="${MENU_LIST[$i]}"
			if [[ ${#list_item} -gt 44 ]]; then
				list_item="${list_item:0:44}..."
			fi
			if [[ "$MENU_SELECTED" == "$list_item" ]]; then
				printf "\033[%sm>>\033[0m \033[%sm%s\033[0m\n" "$ARROW_COLOR" "$SELECTED_COLOR" "$list_item"
				if [[ -z $MENU_ORDER ]]; then
					MENU_ORDER=$i
				fi
				MENU_SELECTED="${MENU_LIST[$i]}"
			else
				printf "   \033[%sm%s\033[0m\n" "$OPTION_COLOR" "$list_item"
			fi
		done
	}

	tmenu.select() {
		printf "\033[$(( ${#MENU_LIST[@]} - 1 ))A\033[0J"
		MENU_SELECTED="${MENU_LIST[$MENU_ORDER]}"
		if [[ ${#MENU_SELECTED} -gt 44 ]]; then
			MENU_SELECTED="${MENU_SELECTED:0:44}..."
		fi
		tmenu.show "${MENU_LIST[@]}"
	}

	tmenu.show "${MENU_LIST[@]}"

	if [[ -z $MENU_ORDER ]]; then
		# Set missing default option to first option
		printf "\033[$(( ${#MENU_LIST[@]} - 1 ))A\033[0J"
		MENU_LIST=( "${MENU_LIST[0]}" "${MENU_LIST[@]}" )
		tmenu.show "${MENU_LIST[@]}"
	fi

	while :; do
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
								if [[ $order -lt ${#MENU_LIST[@]} ]]; then
									MENU_ORDER=$order
									tmenu.select "${MENU_LIST[@]}"
									TMENU_RESULT="$MENU_SELECTED"
									break
								else
									echo
									read -rsn1 -p "Wrong option $order! (1-$(( ${#MENU_LIST[@]} - 1 )))" key
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
						else
							shopt -u dotglob
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
								if [[ "$MENU_ORDER" -gt "1" ]]; then
									(( --MENU_ORDER ))
									tmenu.select "${MENU_LIST[@]}"
								fi
							;;

							"$ARROW_DOWN")
								if [[ $MENU_ORDER -lt $(( ${#MENU_LIST[@]} - 1 )) ]]; then
									(( ++MENU_ORDER ))
									tmenu.select "${MENU_LIST[@]}"
								fi
							;;
						esac
					;;
				esac
			;;  

			[0-9])
				if [[ $menu_key1 -eq 0 ]]; then
					TMENU_RESULT=$menu_key1
					break
				elif [[ $menu_key1 -lt ${#MENU_LIST[@]} && $menu_key1 -gt 0 ]]; then
					MENU_ORDER=$menu_key1
					tmenu.select "${MENU_LIST[@]}"
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

# Call tmenu "${MENU_LIST[@]}" if compile to binary

