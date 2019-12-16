## To do

### 阿里云配置路由转发实现无公网IP的服务器访问外网

1.先在一台有公网IP的服务器上加开启NAT转发
```shell
#两台服务器需要在同一网段
iptables -t nat -A POSTROUTING -s 172.19.80.0/20 -o eth0 -j MASQUERADE
iptables -A FORWARD -s 172.19.80.0/20 -j ACCEPT
iptables -A FORWARD -d 172.19.80.0/20 -j ACCEPT
```

2.进入阿里云专有网络配置，在实例所在的路由表上添加一条规则
目标网段配置为0.0.0.0/0，下一跳设置为开启NAT转发的服务器，也就是：production0


然后ping smtpdm.aliyun.com成功
```shell
[alu@prodB1 ~]$ ping smtpdm.aliyun.com
PING smtpdm.aliyun.com.gds.alibabadns.com (140.205.249.1) 56(84) bytes of data.
64 bytes from 140.205.249.1 (140.205.249.1): icmp_seq=1 ttl=47 time=2.69 ms
64 bytes from 140.205.249.1 (140.205.249.1): icmp_seq=2 ttl=47 time=2.58 ms
64 bytes from 140.205.249.1 (140.205.249.1): icmp_seq=3 ttl=47 time=2.71 ms
64 bytes from 140.205.249.1 (140.205.249.1): icmp_seq=4 ttl=47 time=2.66 ms
64 bytes from 140.205.249.1 (140.205.249.1): icmp_seq=5 ttl=47 time=2.62 ms
64 bytes from 140.205.249.1 (140.205.249.1): icmp_seq=6 ttl=47 time=2.55 ms
```shell
