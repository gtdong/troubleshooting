#!/bin/sh
 
webnode=(
192.168.1.223
192.168.1.224
)
webpass="wangyang"

#自动回答提示
for host  in  ${webnode[@]}
do
  /usr/bin/expect << EOF
  set timeout 30
  expect {
  spawn rsync  -avz  /root/$1  $host:/root/$1      #spwan是用来打开一个新的进程，spawn后的send和expect命令都是和spawn打开的进程进行交互的
          "(yes/no)" {send "yes\r"; exp_continue}  #当进程返回（yes/no）时，向系统输入“yes\r”  然后继续exp匹配
          "password:" {send "$webpass\r"}           #当进程返回 “password”的时候  向系统输入已经定义好的密码的参数。
  }     
  expect eof 
EOF
done
ret=$?                              #通过$?的返回值  来确定rsync同步的是否成功。
if [ $ret -eq 0 ]
        then
        echo   "$1 分发完毕"
else
        echo   "$1  分发失败，请检查"
fi


注释：
Expect是一个用来处理交互的命令。借助Expect，我们可以将交互过程写在一个脚本上，使之自动化完成。形象的说，ssh登录，ftp登录等都符合交互的定义。

send：用于向进程发送字符串（即帮你输入什么）
expect：从进程接收字符串（即返回的选项）
spawn：启动新的进程
interact：允许用户交互
