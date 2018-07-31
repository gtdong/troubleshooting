#!/bin/bash
 base_path='/var/log/nginx'
 log_path=$(date -d yesterday +"%Y%m%d")
 mv $base_path/access.log $base_path/${log_path}_access.log
 tar -zcvf $base_path/${log_path}_access.log.tar.gz $base_path/${log_path}_access.log > /dev/null 2>&1
 rm -rf $base_path/${log_path}_access.log
 kill -USR1 $(cat /run/nginx.pid)
 
