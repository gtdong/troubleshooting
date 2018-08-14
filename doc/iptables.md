# iptables
## iptables的定义
根据维基百科的介绍:</br>

iptables是运行在用户空间的应用软件，通过控制Linux内核netfilter模块，来管理网络数据包的流动与转送。在大部分Linux系统上，可使用/usr/sbin/iptables来操作iptables，用户手册在手册页（Man page[2]）中，可以透过 man iptables 指令获取。通常iptables都需要内核层级的模块来配合运作，Xtables是主要在内核层级里面iptables API运作功能的模块。因相关动作上的需要，iptables的操作需要用到超级用户的权限。</br>
目前iptables在2.4、2.6及3.0版本的内核下运作，旧版的Linux内核（2.2）使用ipchains及ipwadm（Linux 2.0）达成类似的功能，2014年1月19日起发行的新版Linux内核（3.13后）则使用nftables取而代之。

## iptables的安装配置 
   
    实验环境centos7:
    $ systemctl stop firewalld
    $ rpm -e --nodeps firewalld
    $ yum -y install iptables-services
    $ systemctl start iptables
    $ ystemctl enable iptables

## iptables使用
   
### 1.语法构成：
    iptables  [-t 表名]  选项  [链名]  [条件]  [-j 控制类型]
    iptables -t filter -A INPUT -p tcp --dport 80 -j DROP
    几个注意事项
    不指定表名时，默认指filter表
    不指定链名时，默认指表内的所有链
    除非设置链的默认策略，否则必须指定匹配条件
    选项、链名、控制类型使用大写字母，其余均为小写
    
### 2. 数据包的常见控制类型
	  ACCEPT：允许通过
	  DROP：直接丢弃，不给出任何回应
	  REJECT：拒绝通过，必要时会给出提示
	  LOG：记录日志信息，然后传给下一条规则继续匹配
	  SNAT：修改数据包源地址
	  DNAT：修改数据包目的地址
	  REDIRECT：重定向（先经过这条链，然后再跳转到下一条链，不会匹配即停止）
    
### 3. 保存和恢复 iptables 规则
	  防火墙规则只在计算机处于开启状态时才有效。如果系统被重新引导，这些规则就会自动被清除并重设。要保存规则以便今，请使用以下命令：后载入
	  sbin/service iptables save
	  保存在 /etc/sysconfig/iptables 文件中的规则会在服务启动或重新启动时（包括机器被重新引导时）被应用。
    
### 4. 添加新的规则
    -A：在链的末尾追加一条规则
    -I：在链的开头（或指定序号）插入一条规则
    #iptables -t filter -A INPUT -p tcp -j ACCEPT
    #iptables -I  INPUT -p udp -j ACCEPT
    #iptables -I  INPUT  2 -p icmp -j ACCEPT
    
### 5. 查看规则列表
    -L：列出所有的规则条目
    -n：以数字形式显示地址、端口等信息
    -v：以更详细的方式显示规则信息
    --line-numbers：查看规则时，显示规则的序
    
### 6. 删除、清空规则
    -D：删除链内指定序号（或内容）的一条规则
    -F：清空所有的规则
    #iptables -D INPUT 3
    
### 7. 设置默认策略
    -P：为指定的链设置默认规则
    # iptables -t filter -P FORWARD DROP
    # iptables -P OUTPUT ACCEPT
    放行443、22端口，丢弃其他端口数据包的配置方法
    [root@www1 ~]# iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
    [root@www1 ~]# iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
    [root@www1 ~]# iptables -P INPUT drop
    [root@www1 ~]# iptables -L
    Chain INPUT (policy DROP)
    target     prot opt source               destination         
    ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:https 
    ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh
