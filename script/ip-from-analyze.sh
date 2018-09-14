#!/bin/bash
log_path=$(date -d yesterday +"%Y%m%d")
cd /log/
#查看异常访问日志（尝试sql注入,或者获取sql文件）
sudo cat ${log_path}_access.log |egrep '(sqlmap|sql|select|union|php|phpMyadmin)'
echo "--------------------------------------------------------------------------"
echo '昨日的访问量为:'

#访问量统计
sudo cat ${log_path}_access.log |wc -l
echo '昨日访问量前十的IP是:'

#统计访问量前十的IP
sudo cat ${log_path}_access.log|awk '{printf $1"\n"}'|sort|uniq -c|sort -rn|head -10
echo "--------------------------------------------------------------------------"
#通过第三方接口获取IP归属地
for ip in $(sudo cat ${log_path}_access.log|awk '{printf $1"\n"}'|sort|uniq -c|sort -rn|head -10|awk '{printf $2"\n"}')
    do
        echo $ip 
        curl http://freeapi.ipip.net/$ip
        sleep 1
        echo "--------------------------------------------------------------------------"
    done
