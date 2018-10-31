#!/bin/bash
base_path='/usr/local/nginx/logs'
log_path=$(date +"%Y%m%d")
mv $base_path/access.log $base_path/${log_path}_access.log
tar -zcvf $base_path/${log_path}_access.log.tar.gz $base_path/${log_path}_access.log > /dev/null 2>&1
mv $base_path/${log_path}_access.log.tar.gz /data/log/nginx/
mv $base_path/${log_path}_access.log /data/log/nginx/
kill -USR1 $(cat /usr/local/nginx/logs/nginx.pid)
