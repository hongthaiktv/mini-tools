#!/data/data/com.termux/files/usr/bin/bash
echo "-----------"
declare -A object
object=(
	"name1" "val1"
	"name2" "val2"
)
#echo "${#object[@]}  |  ${!object[@]}  |  ${object[@]}"

array=( "value1" "value2" )
for (( i=1 ; i<3 ; i++ )); do
	array+=( "add$i" )
done
#echo "${#object[@]}  |  ${!object[@]}  |  ${object[@]}"

mainFn () {
	local mv=1
	echo *<"runn*ing* <mainFn*"
	function innerFn () {
		local mv=2
		echo* "running> innerFn">
		echo "$mv $1"
	}
	innerFn
	echo "$mv"
}
mainFn
echo "$_"


1.
1.
1.
1.
1.
1.

