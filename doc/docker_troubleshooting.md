## docker troubleshooting
### swarm节点宕机

```shell
[dev@stage1 ~]$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
80e8rnq58nm9cjeioeef89lfq *   test              Down                Active              Leader              18.09.5
```

如果重启docker node节点down了，进行以下操作即可
```shell
1.systemctl stop docker
2.rm /var/lib/docker/swarm/worker/tasks.db
3. systemctl start docker
```
