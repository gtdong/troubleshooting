#!/bin/bash

date=`date  +"%Y-%m-%d"`
cp -a /root/access.log /root/"$date".access.log
echo "" > /root/access.log
