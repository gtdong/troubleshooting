# iptables防火墙
## iptables简介
   防火墙是指设置在不同网络或网络安全域之间的一系列部件的组合，它能增强机构内部网络的安全性。它通过访问控制机制，确定哪些内部服务允许外部访问。它可以根据网络传输的类型决定IP包是否可以传进或传出内部网。   
   防火墙通过审查经过的每一个数据包，判断它是否有相匹配的过滤规则，根据规则的先后顺序进行一一比较，直到满足其中的一条规则为止，然后依据控制机制做出相应的动作。如果都不满足，则将数据包丢弃，从而保护网络的安全。
   
### 1.防火墙机制：
   一种机制是拦阻传输流通行  
	一种机制是允许传输流通过  
	一些防火墙偏重拦阻传输流的通行，而另一些防火墙则偏重允许传输流通过。
   
### 2.防火墙实现功能：

   可以保护易受攻击的服务；
   控制内外网之间网络系统的访问；
	集中管理内网的安全性，降低管理成本；
   提高网 络的保密性和私有性；
   记录网络的使用状态，为安全规划和网络维护提供依据。
   
### 3.防火墙过滤器

   netfilter/iptables 分别是内核态模块和用户态工具，netfilter位于Linux内核中的包过滤功能体系，iptables位于/sbin/iptables，用来管理防火墙规则的工具，管理员通过iptables给netfilter变更规则实现防火作用。
	
	kernel 2.0.x 	firewall	ipfw
	kernel 2.2.x 	firewall 	ipchains
	kernel 2.4.x 	netfilter	iptables
	kernel 3.13.x 	netfilter	firewall
	
   **tcp数据包结构**
   ![image](https://github.com/gtdong/linuxtroubleshooting/blob/master/images/ip1.png)
   
   **包过滤简化模式**
   ![image](https://github.com/gtdong/linuxtroubleshooting/blob/master/images/ip2.jpeg)
   
### 4.规则表&规则链

**netfilter/iptables 预设的规则表:**	 </br>
      
>>表作用：容纳各种规则链</br>
>>划分依据：根据防火墙对数据的处理方式
 
**规则表：**</br>

>> raw表：确定是否对该数据包进行状态跟踪   
>> mangle表：为数据包设置标记  
>> nat表：修改数据包中的源、目标IP地址或端口  
>> ilter表：确定是否放行该数据包（过滤）

**netfilter/iptables 预设的规则链:**

>> 规则的作用：对数据包进行过滤或处理  
>> 链的作用：容纳各种防火墙规则  
>> 链的分类依据：处理数据包的不同时机
	
**规则链：**
>> INPUT：处理入站数据包  
>> OUTPUT：处理出站数据包  
>> FORWARD：处理转发数据包  
>> POSTROUTING链：在进行路由选择后处理数据包  
>> PREROUTING链：在进行路由选择前处理数据包

![image](https://github.com/gtdong/linuxtroubleshooting/blob/master/images/ip3.jpeg)

**应用顺序**  
规则表之间的顺序:  
>> raw—mangle—nat—filter

规则链之间的顺序:
>> 入站：PREROUTING  INPUT  
>> 出站：OUTPUT  POSTROUTING  
>> 转发：PREROUTING  FORWARD  POSTROUTING

规则链内的匹配顺序:
>> 按顺序依次检查，匹配即停止（LOG策略例外）
>> 找不到相匹配规则，则按该链的默认策略处理

**数据匹配流程图**
![image](https://github.com/gtdong/linuxtroubleshooting/blob/master/images/ip4.png)







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
    
## iptables配置实例
    
**1.删除已有规则**

在新设定iptables规则时，我们一般先确保旧规则被清除，用以下命令清除旧规则：

    iptables -F
    (or iptables --flush)
 

**2.设置chain策略**   

对于filter table，默认的chain策略为ACCEPT，我们可以通过以下命令修改chain的策略：

    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT DROP
以上命令配置将接收、转发和发出包均丢弃，施行比较严格的包管理。由于接收和发包均被设置为丢弃，当进一步配置其他规则的时候，需要注意针对INPUT和OUTPUT分别配置。当然，如果信任本机器往外发包，以上第三条规则可不必配置。

**3.屏蔽指定ip**   

有时候我们发现某个ip不停的往服务器发包，这时我们可以使用以下命令，将指定ip发来的包丢弃：

    BLOCK_THIS_IP="x.x.x.x"
    iptables -A INPUT -i eth0 -p tcp -s "$BLOCK_THIS_IP" -j DROP
以上命令设置将由x.x.x.x ip发往eth0网口的tcp包丢弃。

**4.配置服务项**  

利用iptables，我们可以对日常用到的服务项进行安全管理，比如设定只能通过指定网段、由指定网口通过SSH连接本机：

    iptables -A INPUT -i eth0 -p tcp -s 192.168.100.0/24 --dport 22 -m state --state NEW,ESTABLESHED -j ACCEPT
    iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    
若要支持由本机通过SSH连接其他机器，由于在本机端口建立连接，因而还需要设置以下规则：

    iptables -A INPUT -i eth0 -p tcp -s 192.168.100.0/24 --dport 22 -m state --state ESTABLESHED -j ACCEPT
    iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
    
类似的，对于HTTP/HTTPS(80/443)、pop3(110)、rsync(873)、MySQL(3306)等基于tcp连接的服务，也可以参照上述命令配置。

 
**5.对于基于udp的dns服务，使用以下命令开启端口服务：**

    iptables -A OUTPUT -p udp -o eth0 --dport 53 -j ACCEPT
    iptables -A INPUT -p udp -i eth0 --sport 53 -j ACCEPT
 
**5.网口转发配置**

对于用作防火墙或网关的服务器，一个网口连接到公网，其他网口的包转发到该网口实现内网向公网通信，假设eth0连接内网，eth1连接公网，配置规则如下：

    iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
 
**6.端口转发配置**

对于端口，我们也可以运用iptables完成转发配置：

    iptables -t nat -A PREROUTING -p tcp -d 192.168.102.37 --dport 422 -j DNAT --to 192.168.102.37:22
以上命令将422端口的包转发到22端口，因而通过422端口也可进行SSH连接，当然对于422端口，我们也需要像以上“4.配置服务项”一节一样，配置其支持连接建立的规则。

**7.DoS攻击防范** 

利用扩展模块limit，我们还可以配置iptables规则，实现DoS攻击防范：

    iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
         --litmit 25/minute 指示每分钟限制最大连接数为25
         --litmit-burst 100 指示当总连接数超过100时，启动 litmit/minute 限制

 

**8.配置web流量均衡**
我们可以将一台服务器作为前端服务器，利用iptables进行流量分发，配置方法如下：

    iptables -A PREROUTING -i eth0 -p tcp --dport 80 -m state --state NEW -m nth --counter 0 --every 3 --packet 0 -j DNAT --to-destination     192.168.1.101:80
    iptables -A PREROUTING -i eth0 -p tcp --dport 80 -m state --state NEW -m nth --counter 0 --every 3 --packet 0 -j DNAT --to-destination     192.168.1.102:80
    iptables -A PREROUTING -i eth0 -p tcp --dport 80 -m state --state NEW -m nth --counter 0 --every 3 --packet 0 -j DNAT --to-destination     192.168.1.103:80
以上配置规则用到nth扩展模块，将80端口的流量均衡到三台服务器。

 

**9.将丢弃包情况记入日志**

使用LOG目标和syslog服务，我们可以记录某协议某端口下的收发包情况。拿记录丢包情况举例，可以通过以下方式实现。

首先自定义一个chain：

    iptables -N LOGGING
其次将所有接收包导入LOGGING chain中：

    iptables -A INPUT -j LOGGING
然后设置日志前缀、日志级别：

    iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables Packet Dropped: " --log-level 7
最后将包倒向DROP，将包丢弃：

    iptables -A LOGGING -j DROP
