#!/bin/bash

# [ 1 -eq 2 ] && echo right
a="ABC"

fn() {
    a="DEF"
    args=("$@")
    local args_list="$1"
    local opt=""
    unset args[0]
    args=("${args[@]}")
    #check arguments
    for (( i=0; i<$(($#-1)); i++ ))
    do
        if [ "${args[$i]}" == "$args_list" ]
        then
            opt="${args[$((i+1))]}"
            unset args[$i]
            unset args[$((i+1))]
            break
        fi
    done
    args=("${args[@]}")
    echo "main: ${args[@]}"
    echo "$opt"
}

    echo "color option: $(fn "--color" "space text" --color "4 5 6" "end args" --help "text")"
    echo ---------------------
    echo "$a"

