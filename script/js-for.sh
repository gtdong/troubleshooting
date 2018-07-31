#!/bin/bahs

sum=0

for ((i=1;i<=100;i++))
do
	sum=$(($sum+$i))
done

echo "1+2+3+4+...+100=$sum"
