#!/bin/bash

#[ "" ] && echo right || echo wrong

fn() {
declare -A arr=()
# [ $# -eq 0 ] && printf "\033[91m%s\033[0m\n" "right" && return || printf "\033[92m%s\033[0m\n" "wrong"
    fn2() {
        
        arr+=([--help]='B B')
        arr+=([--color]='C C')
        arr+=([-n]='A A')
        declare -p arr
        for i in ${!arr[@]}
        do
            [ '-n' = "$i" ] && printf "%s\n" $i || echo "not found"
        done

    }
    fn2


}

fn 'a' 'b'

