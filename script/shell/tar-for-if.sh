#!/bin/bash

cd /lamp

ls * > ./list.txt

for a in $(cat list.txt)
do
	if [[ "$a" =~ "tar" ]]
	then
		tar -xf $a
	elif [[ "$a" =~ "tgz" ]]
	then
		tar -xf $a
	elif [[ "$a" =~ "gz" ]]
	then
		gunzip $a
	elif [[ "$a" =~ "bz" ]]
	then 
		bunzip2 $a
	elif [[ "$a" =~ "zip" ]]
	then
		unzip $a
	else
		echo "$a is not a zip file."
	fi
done

