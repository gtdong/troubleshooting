#!/bin/bash
yuan=$1
mudi=$2
echo "$yuan"
echo "$mudi"
cd "$yuan"

ls "$yuan"/*.tar.gz > /tmp/tar.gz.txt
ls "$yuan"/*.gz > /tmp/tar.gz.txt
ls "$yuan"/*.tar.bz2 > /tmp/tar.bz2.txt
ls "$yuan"/*.zip > /tmp/zip.txt

b=0

ls "$yuan" > /tmp/tongji.txt
tongji=$( wc -l /tmp/tongji.txt | cut -d " " -f 1 )

lueguo=$( grep -Ev "*.tar.gz|*.zip|*.tar.bz2|*.gz" /tmp/tongji.txt )

for i in `cat "/tmp/tar.gz.txt"`
	do
		tar -zxvf "$i" -C "$mudi"
		b=$(( $b+1 ))
	done 
for n in `cat "/tmp/tar.bz2.txt"`
	do
		tar -jxvf "$n" -C "$mudi"
		b=$(( $b+1 ))
	done 
for m in `cat "/tmp/zip.txt"`
	do
		unzip "$m" -d "$mudi"
		b=$(( $b+1 ))
	done 

echo "-----------------------------------------------------------------"
echo "不能识别的文件内容为"
echo "$lueguo"
echo "-----------------------------------------------------------------"

rm -rf  /tmp/tar.gz.txt
rm -rf  /tmp/tar.gz.txt
rm -rf  /tmp/tar.bz2.txt
rm -rf  /tmp/zip.txt
rm -rf  /tmp/tongji.txt
