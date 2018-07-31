#!/bin/bash

read -t 15  -p "please input a num: " num1
read -t 15  -p "please input a oper[+/-/*//]: " opr
read -t 15  -p "please input a num: " num2
for i in $num1 $num2
 do
	if [ -n "$i" ] 
	then 
	   a="$(echo $i | sed 's/[0-9]//g')"
   	 if [ -n "$a" ]
		then 
		echo "qing ba $i huan cheng shuzi " && exit
    	 fi
fi
done
[ "$opr" == "+" ] && echo $(( $num1 + $num2 )) && exit 1
[ "$opr" == "-" ] && echo $(( $num1 - $num2 )) && exit 2
[ "$opr" == "*" ] && echo $(( $num1 * $num2 )) && exit 3
[ "$opr" == "/" ] && echo $(( $num1 / $num2 )) && exit 4

echo "error，please input +|-|*|/| for opr"
