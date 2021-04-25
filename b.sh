#!/bin/bash

checkArgs() {
    local __main_opt__=($1)
    local __main_args__=("$@")
    local __main_var__=""
    local __var_list__=()
    local __opt_list__=()
    local __opt_args__=()

    unset __main_args__[0]
    __main_args__=("${__main_args__[@]}")
    printf "%s\n" "${__main_args__[@]}"
    echo ${#__main_args__[@]}
    echo ---------------
    #printf "%s\n" "${main_opt[@]}"
    #echo ${#main_opt[@]}
    for (( i=0; i<${#__main_opt__[@]}; i++ ))
    do
        __var_list__+=("${__main_opt__[$i]}")
        __opt_list__+=("${__main_opt__[$((i+1))]}")
        __opt_args__+=("${__main_opt__[$((i+2))]}")
        let i+=2
    done
    echo "Variables: ${__var_list__[@]}"
    echo "Option: ${__opt_list__[@]}"
    echo "Option Args: ${__opt_args__[@]}"
    echo ---------------
    local __main_args_length__=${#__main_args__[@]}
    for (( i=0; i<$__main_args_length__; i++ ))
    do
        for (( j=0; j<${#__opt_list__[@]}; j++ ))
        do
            if [ "${__main_args__[$i]}" = "${__opt_list__[$j]}" ]
            then
                if [ "${__opt_args__[$j]}" -eq 0 ]
                then
                    read -ra "${__var_list__[$j]}" <<< "${__opt_list__[$j]} true"
                    unset __main_args__[$i]
                elif [ "${__opt_args__[$j]}" -eq 1 ]
                then
                    read -ra "${__var_list__[$j]}" <<< "${__opt_list__[$j]} ${__main_args__[$((i+1))]}"
                    #IFS=' '
                    unset __main_args__[$i]
                    unset __main_args__[$((i+1))]
                fi
            fi
            if [ "${__opt_list__[$j]}" = "--main" ]
            then
                __main_var__="$j"
            fi
        done
    done
    #declare -A dynVar=($main)
    main=("${__main_args__[@]}")
    #dynVar[$main]=("${main_args[@]}")
    #"${var_list[$main_var]}"=("${main_args[@]}")
}

callCheck() {
    local main_args="main_args @ @"
    declare -A option_args
    option_args[help] ="--help 0"
    local opt_color="opt_color --color 1"
    local opt_optionN="opt_optionN -n 0"
    local opt_one="opt_one --one 1"
    checkArgs "$main $opt_one $opt_help $opt_color $opt_optionN" "$@"

    printf "%s\n" "${main[*]} : ${#main[@]}"
    printf "%s\n" "${opt_help[*]} : ${#opt_help[@]}"
    printf "%s\n" "${opt_color[*]} : ${#opt_color[@]}"
    printf "%s\n" "${opt_optionN[*]} : ${#opt_optionN[@]}"
    printf "%s\n" "${opt_one[*]} : ${#opt_one[@]}"
}
callCheck --help "main arg1" "main arg2" "main arg3" --color "46 47 48" -n --one "only one"
