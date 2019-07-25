#!/bin/bash

function sm () {
			
	sum=0
	for  ((i=1;i<=$a;i++))
	do
		sum=$(( $sum + $i ))
	done          
	echo    "1+2+3+....+$a=$sum"
}
		
read -p "please input a number:" a

if [ -z "$a" ]
        then
                echo "input cannot be null"
				exit 10
        else
                b=$( echo $a | sed 's/[0-9]//g') 
   
	if [ -z "$b" ]
		then
			sm $a
		else
			echo "$a is not number! "
			
	fi
fi
