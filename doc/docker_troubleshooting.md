## docker troubleshooting
### swarm节点宕机
```shell
1.docker swarm节点的状态为down
当我们执行docker node ls的时候会出现以下这种情况：
[dev@stage1 ~]$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
80e8rnq58nm9cjeioeef89lfq *   stage1              Down                Active              Leader              18.09.5
 
进行以下操作即可恢复：
systemctl stop docker
rm /var/lib/docker/swarm/worker/tasks.db
systemctl start docker
 
     
[dev@stage1 ~]$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
80e8rnq58nm9cjeioeef89lfq *   stage1              Ready               Active              Leader              18.09.5
 
备注：
   什么是tasks.db文件
     
Docker manager nodes store the swarm state and manager logs in the /var/lib/docker/swarm/ directory.In 1.13 and higher, this data inclu
des the keys used to encrypt the     Raft logs. Without these keys, you cannot restore the swarm.
 
2.查看所有镜像ID
docker image ls -q
 
3.移除所有已经停止的容器
docker container prune -f
 
4.导入数据库到container
docker exec -i 9cb mysql -uroot -proot connect_staging < connect_staging.sql
#这里我们是将connect_staging.sql这个sql文件导入到id开头为9cb的容器里，导入的库为connect_staging
```
