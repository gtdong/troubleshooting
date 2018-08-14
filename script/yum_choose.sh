#!/bin/bash
cd /etc/yum.repos.d/

read -p "请选择要用的yum源:1代表本地 2代表网络:" b
 if [ $b == 1 ]
   then
       mv CentOS-Base.repo CentOS-Base.repo.bar
        sed  -i '19s/1/0/g' CentOS-Media.repo
        sed -i '19s/0/1/g' CentOS-Media.repo
        sed -i '16c baseurl=file:///mnt' CentOS-Media.repo
      sed -i '17c file:///media' CentOS-Media.repo
      sed 18d CentOS-Media.repo
   elif [ $b == 2 ]
      then
      rm -rf  CentOS-Base.repo*
       wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
       mv CentOS-Base* CentOS-Base.repo
   else
        echo "输入错误"
       exit
   fi
