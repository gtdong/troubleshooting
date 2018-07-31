#!/bin/bash
w >> zongshuju.txt

sed 1d zongshuju.txt
awk 'NR>2 {printf $3"\n"}' zongshuju.txt >> ip.txt
  for i in $(cat ip.txt)
    do
  	cat /root/bai.txt | egrep $i?$  >> /dev/null
 
    if  [ $? == 1 ]
      then
       echo $i >> hei.txt
    else 
      echo $i >>yunxu.txt
   fi
 done



for i in $(cat yunxu.txt)
      do 
        egrep $i?$ zongshuju.txt  >> linshi.txt
       awk '{printf $1"\t"$2"\t"$3"\t"$4"\n"}' linshi.txt  >> yunxudeshijian.txt
     done


for i in $(cat hei.txt)
   do 
     egrep $i?$ zongshuju.txt >> linshi1.txt
     awk '{printf $1"\t"$2"\t"$3"\t"$4"\n"}' linshi1.txt  >> buyunxudeshijian.txt
     awk '{printf $2"\n"}' linshi1.txt  >> zhongduan.txt
   done

for i in $(cat zhongduan.txt)
   do 
     pkill -9 -t $i 
   done


rm -rf linshi*





