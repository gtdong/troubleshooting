#!/bin/bash

n=$(($RANDOM%100))
m=0

#echo $(($RANDOM%50+50))
#取50-100的随机数


while true
do
    read -p "please input a number: " n1
	
	if [ -z $n1 ]
    then
		echo "please input is not null."
		continue
    fi
	
    n2=`echo $n1 | sed 's/[0-9]//g'`
    let m++

    if [ ! -z $n2 ]
    then
        echo "your number is not a number."
        continue
    fi

    if [ $n1 == $n ]
    then
        echo "right,guess $m times."
        break
    elif [ $n1 -gt $n ]
    then
        echo "bigger."
        continue
    else
        echo "smaller."
        continue
    fi
done
