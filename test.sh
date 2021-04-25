#!/bin/bash

#read -rsn1 s
#read -rsn1 ss
#[[ "b" < "a" ]] && echo 'right' || echo 'wrong'
# strLU="Convert to LOWER and UPPER"

convertLUC() {
strLU="$2"
count=0
strLo=""
strUp=""
straz=( a b c d e f g h i j k l m n o p q r s t u v w x y z )
strAZ=( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z )
for (( i=0; i<${#strLU}; i++ ))
do
char="${strLU:$i:1}"
if [[ "$char" == [[:alpha:]] ]]
then
  for (( j=0; j<26; j++ ))
  do
  if [[ "$char" == "${straz[$j]}" ]] || [[ "$char" == "${strAZ[$j]}" ]]
  then
  strLo+="${straz[$j]}"
  strUp+="${strAZ[$j]}"
  break
  fi
  done
else
  strLo+="$char"
  strUp+="$char"
fi
done
([ "$1" = "-l" ] && echo "$strLo") || ([ "$1" = "-u" ] && echo "$strUp")
}

str=( "Zzz Sleep hELlO" "Hello ZZzzzZZ" "HeLLo World" "heLLo world" "patten DEF" "patten ABC" "ABC" "123" "def" "hEll yeah" )
sortAZ() {
unset sort_list
sstr=( "$@" )
tmpstr=( "$@" )
sort_list=()
temp_result=""
counter=""
if [[ ${#tmpstr[@]} -eq 1 ]]
then
sort_list+=("${tmpstr[0]}")
return
fi
for (( i=0; i<${#sstr[@]}; i++ ))
do
temp_result="${tmpstr[0]}"
counter=0
  for (( j=0; j<${#tmpstr[@]}; j++ ))
  do
    if [[ "${tmpstr[$j]}" < "$temp_result" ]]
    then
      temp_result="${tmpstr[$j]}"
      counter=$j
    fi
  done
sort_list+=("$temp_result")
if [[ ${#tmpstr[@]} -gt 1 ]]
then
  unset tmpstr[$counter]
  tmpstr=( "${tmpstr[@]}" )
  if [[ ${#tmpstr[@]} -eq 1 ]]
  then
  sort_list+=("${tmpstr[0]}")
  break
  fi
fi
done
}

patten=""
Lpatten=""
while :
do
read -rsn1 key
[ -z "$key" ] && patten+=" " || patten+="$key"
Lpatten="$(convertLUC -l "$patten")"
echo -e "\033[96m$patten\033[0m"
sort_result=()
for i in "${str[@]}"
do
Lstr="$(convertLUC -l "$i")"

if [[ "$Lstr" == *"$Lpatten"* ]]
  then
    sort_result+=("$i")
fi
done
sortAZ "${sort_result[@]}"
printf "%s\n" "${sort_list[@]}"
done

read -rsn1 endkey
