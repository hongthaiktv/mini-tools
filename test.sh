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

var str="end cmd with ;";
let a = {
	name: "string name",
	value: 22
};

const json = [
	{
		"jkey": "key value",
		"boolean": true
	}
];

var arr = [ "str1", "str 2", "str 3 3" ];

let html = `
<html>
	<head>
		<title>Test Page</title>
	</head>
	<body>
		<p class="css" style="color: red;">some para text</p>
		<div><p>some <div><span class="ico">text</span></div> text</p></div>
		<div><p>para text <a href="text.txt">local link</a></p></div>
	</body>
</html>
`
1.
1.
1.
1.
1.

nmap <A-v>1 o<A-1><Esc>^
xmap <A-v>2 o<A-2><Esc>^
vmap <A-v>3 o<A-3><Esc>^
nmap <A-v>4 o<A-4><Esc>^
	nmap <A-v>5 o<A-5><Esc>^
		nmap <A-v>6 o<A-6><Esc>^
nmap <A-v>7 o<A-7><Esc>^
nmap <A-v>8 o<A-8><Esc>^
nmap <A-v>9 o<A-9><Esc>^
nmap <A-v>0 o<A-0><Esc>^

