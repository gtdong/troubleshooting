#!/bin/bash

for(( i=0;i>-2;i=i+1 ))
  do
	echo  `date` >> /root/access.log
	sleep 1s
done
