## TMP

### 阿里云配置路由转发实现无公网IP的服务器访问外网

1.先在一台有公网IP的服务器上加开启NAT转发
```shell
#两台服务器需要在同一网段
iptables -t nat -A POSTROUTING -s 172.19.80.0/20 -o eth0 -j MASQUERADE
iptables -A FORWARD -s 172.19.80.0/20 -j ACCEPT
iptables -A FORWARD -d 172.19.80.0/20 -j ACCEPT
```

2.进入阿里云专有网络配置，在实例所在的路由表上添加一条规则
目标网段配置为0.0.0.0/0，下一跳设置为开启NAT转发的服务器，也就是有公网IP的服务器


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
```

```
it创建新分支并提交到github
1.git checkout -b dev

2.git push origin HEAD -u

Git合并分支到master

1.假如我们现在在dev分支
git  checkout master

2.如果是多人开发的话 需要把远程master上的代码pull下来
git pull origin master

如果是自己一个开发就没有必要了，为了保险期间还是pull
然后我们把dev分支的代码合并到master上

3.git  merge dev
然后查看状态
git status

On branch master
Your branch is ahead of 'origin/master' by 12 commits.
  (use "git push" to publish your local commits)
nothing to commit, working tree clean
上面的意思就是你有12个commit，需要push到远程master上
执行下面命令即可

git push origin master
这样就可以了

git永久保存账号密码，免去git重复输入账号密码操作

git config --global credential.helper store
在输入一次账号密码就可以保存了


git clone url(主仓库)
拉取子仓库代码
cd 子仓库
git fetch
git pull origin master

```
