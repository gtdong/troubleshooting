#!/bin/bash
sudo cp -r /var/log/nginx/ log/
sudo chmod 777 -R log/
sudo rm -rf log/nginx/access*
sudo rm -rf log/nginx/error*
for i in `ls /home/ec2-user/log/nginx/`
do
         sudo tar -zxvf /home/ec2-user/log/nginx/"$i" > /dev/null
done
for i in `sudo ls /home/ec2-user/var/log/nginx/`
do
    cat /home/ec2-user/var/log/nginx/"$i" >> nginx.txt
done
head -10 nginx.txt
echo 
for((i=2;i<=31;i++))
do
    sudo cat nginx.txt | grep "$i"/Jan | awk '{printf $1"\n"}'|wc -l >> jieguo.txt
done
cat jieguo.txt
