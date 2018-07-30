# postfix
![image](https://github.com/gtdong/linuxtroubleshooting/blob/master/images/mysza.gif)

## 简介

postfix是Wietse Venema在IBM的GPL协议之下开发的MTA（邮件传输代理）软件。postfix是Wietse Venema想要为使用最广泛的sendmail提供替代品的一个尝试。在Internet世界中，大部分的电子邮件都是通过sendmail来投递的，大约有100万用户使用sendmail，每天投递上亿封邮件。这真是一个让人吃惊的数字。Postfix试图更快、更容易管理、更安全，同时还与sendmail保持足够的兼容性。

### 特点：
1.**postfix是免费的：**
postfix想要作用的范围是广大的Internet用户，试图影响大多数的Internet上的电子邮件系统，因此它是免费的。</br>
2.**更快：**
postfix在性能上大约比sendmail快三倍。一部运行postfix的台式PC每天可以收发上百万封邮件。</br>
3.**兼容性好:**
postfix是sendmail兼容的，从而使sendmail用户可以很方便地迁移到postfix。Postfix支持/var[/spool]/mail、/etc/aliases、 NIS、和 ~/.forward 文件。</br>
4.**更健壮：**
postfix被设计成在重负荷之下仍然可以正常工作。当系统运行超出了可用的内存或磁盘空间时，postfix会自动减少运行进程的数目。当处理的邮件数目增长时，postfix运行的进程不会跟着增加。</br>
5.**更灵活：**
postfix是由超过一打的小程序组成的，每个程序完成特定的功能。你可以通过配置文件设置每个程序的运行参数。
6.**安全性：**
postfix具有多层防御结构，可以有效地抵御恶意入侵者。如大多数的postfix程序可以运行在较低的权限之下，不可以通过网络访问安全性相关的本地投递程序等等。

### 结构：
postfix由十几个具有不同功能的半驻留进程组成，并且在这些进程中并无特定的进程间父子关系。某一个特定的进程可以为其他进程提供特定的服务。
大多数的postfix进程由一个进程统一进行管理，该进程负责在需要的时候调用其他进程，这个管理进程就是master进程。该进程也是一个后台程序。
这些postfix进程是可以配置的，我们可以配置每个进程运行的数目，可重用的次数，生存的时间等等。通过灵活的配置特性可以使整个系统的运行成本大大降低。

### postfix的邮件队列（mail queues)   
postfix有四种不同的邮件队列，并且由队列管理进程统一进行管理:      
1.**maildrop：**
本地邮件放置在maildrop中，同时也被拷贝到incoming中。  
2.**incoming：**
放置正在到达或队列管理进程尚未发现的邮件。</br>
3.**active：**
放置队列管理进程已经打开了并正准备投递的邮件，该队列有长度的限制。   
4.**deferred：**
放置不能被投递的邮件。

队列管理进程仅仅在内存中保留active队列，并且对该队列的长度进行限制，这样做的目的是为了避免进程运行内存超过系统的可用内存。    
**postfix对邮件风暴的处理**    
当有新的邮件到达时，postfix进行初始化，初始化时postfix同时只接受两个并发的连接请求。当邮件投递成功后，可以同时接受的并发连接的数目就会缓慢地增长至一个可以配置的值。当然，如果这时系统的消耗已到达系统不能承受的负载就会停止增长。还有一种情况时，如果postfix在处理邮件过程中遇到了问题，则该值会开始降低。
当接收到的新邮件的数量超过postfix的投递能力时，postfix会暂时停止投递deferred队列中的邮件而去处理新接收到的邮件。这是因为处理新邮件的延迟要小于处理deferred队列中的邮件。Postfix会在空闲时处理deferred中的邮件。    
**postfix对无法投递的邮件的处理**     
当一封邮件第一次不能成功投递时，postfix会给该邮件贴上一个将来的时间邮票。邮件队列管理程序会忽略贴有将来时间邮票的邮件。时间邮票到期时，postfix会尝试再对该邮件进行一次投递，如果这次投递再次失败，postfix就给该邮件贴上一个两倍于上次时[间邮票的时间邮票，等时间邮票到期时再次进行投递，依此类推。当然，经过一定次数的尝试之后，postfix会放弃]对该邮件的投递，返回一个错误信息给该邮件的发件人。    
**postfix对不可到达的目的地邮件的处理**     
postfix会在内存中保存一个有长度限制的当前不可到达的地址列表。这样就避免了对那些目的地为当前不可到达地址的邮件的投递尝试。从而大大提高了系统的性能。
### postfix的安全性
postfix通过一系列的措施来提高系统的安全性，这些措施包括：</br>
1.动态分配内存，从而防止系统缓冲区溢出；</br>
2.把大邮件分割成几块进行处理，投递时再重组；</br>
3.Postfix的各种进程不在其他用户进程的控制之下运行，而是运行在驻留主进程master的控制之下，与其他用户进程无父子关系，所以有很好的绝缘性。</br>
4.Postfix的队列文件有其特殊的格式，只能被postfix本身识别；</br>
**处理过程**

![image]()

### 接收邮件的过程
当postfix接收到一封新邮件时，新邮件首选在incoming队列处停留，然后针对不同的情况进行不同的处理：
1.对于来自于本地的邮件：local进程负责接收来自本地的邮件放在maildrop队列中，然后pickup进程对maildrop中的邮件进行完整性检测。maildrop目录的权限必须设置为某一用户不能删除其他用户的邮件。</br>
2.对于来自于网络的邮件：smtpd进程负责接收来自于网络的邮件，并且进行安全性检测。可以通过UCE（unsolicited commercial email）控制smtpd的行为。</br>
3.由postfix进程产生的邮件：这是为了将不可投递的信息返回给发件人。这些邮件是由bounce后台程序产生的。</br>
4.由postfix自己产生的邮件：提示postmaster（也即postfix管理员）postfix运行过程中出现的问题。（如SMTP协议问题，违反UCE规则的记录等等。)关于cleanup后台程序的说明：cleanup是对新邮件进行处理的最后一道工序，它对新邮件进行以下的处理：添加信头中丢失的Form信息；为将地址重写成标准的user@fully.qualified.domain格式进行排列；从信头中抽出收件人的地址；将邮件投入incoming队列中，并请求邮件队列管理进程处理该邮件；请求trivial-rewrite进程将地址转换成标准的user@fully.qualified.domain格式。
### 投递邮件的过程     
新邮件一旦到达incoming队列，下一步就是开始投递邮件，postfix投递邮件时的处理过程如图三所示。相关的说明如下：    
邮件队列管理进程是整个postfix邮件系统的心脏。它和local、smtp、pipe等投递代理相联系，将包含有队列文件路径信息、邮件发件人地址、邮件收件人地址的投递请求发送给投递代理。队列管理进程维护着一个deferred队列，那些无法投递的邮件被投递到该队列中。除此之外，队列管理进程还维护着一个active队列，该队列中的邮件数目是有限制的，这是为了防止在负载太大时内存溢出。</br>
邮件队列管理程序还负责将收件人地址在relocated表中列出的邮件返回给发件人，该表包含无效的收件人地址。</br>
如果邮件队列管理进程请求，rewrite后台程序对收件人地址进行解析。但是缺省地，rewrite只对邮件收件人是本地的还是远程的进行区别。   
如果邮件对你管理进程请求，bounce后台程序可以生成一个邮件不可投递的报告。</br>
本地投递代理local进程可以理解类似UNIX风格的邮箱，sendmail风格的系统别名数据库和sendmail风格的.forward文件。可以同时运行多个local进程，但是对同一个用户的并发投递进程数目是有限制的。你可以配置local将邮件投递到用户的宿主目录，也可以配置local将邮件发送给一个外部命令，如流行的本地投递代理procmail。在流行的linux发行版本RedHat中，我们就使用procmail作为最终的本地投递代理。</br>
远程投递代理SMTP进程根据收件人地址查询一个SMTP服务器列表，按照顺序连接每一个SMTP服务器，根据性能对该表进行排序。在系统负载太大时，可以有数个并发的SMTP进程同时运行。pipe是postfix调用外部命令处理邮件的机制.

## 配置
**实验环境**：aws RHEL7.4
注意：一般云服务器25端口默认是不允许开启的，需要提交工单开启。或者我们还可以配置加密端口465或者587解决这个问题。
### 1.设置hostname
    $ echo 'mail.dgtlinux.com' > /etc/hostname
    $ hostname -F /etc/hostname
    
### 2.安装postfix
    $ yum install postfix 
    
### 3.postfix基本配置
   Postfix的配置文件位于/etc/postfix/main.cf。一般有以下几个重要参数需要设置：
   
    *myhostname //主机名
     myhostname = mail.dgtlinux.com
    
    *myorigin //外发邮件时发件人的邮件域名
     myorigin = $myhostname  //在通过Postfix发送邮件的时候，如果From字段不完整，Postfix会根据myorigin的值将地址补全为 *@mail.aubitex.com
  
    *mydomain   //使用邮件域
     mydomain = dgtlinux.com   //mydomain 设置本地网络的邮件域
    *inet_interfaces   //监听的网卡接口
     inet_interfaces = all
       
    *mydestination  //可接受邮件地址域名
     mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
     //mydestination指定了postfix在收到这些域名地址为目标的邮件时，作为接受方收下邮件。如果收到的邮件既不符合转发规则，又不符合接受规则，则拒绝收信。
     
     *mynetworks  //需要收发的客户端的地址
      mynetworks = 127.0.0.0/8   //mynetworks指定了本地网络的IP段，默认只包含主机自己，你可以添加需要收发的客户端的地址。
      
      relay_domains = $mydomain //指定了哪些域可以通过此台服务器转发邮件。

      
      home_mailbox = Maildir/  //邮件的存放位置
      
### 4.安装dovecot
     $ yum install dovecot
     $ vim /etc/dovecot/dovecot.conf
       protocols = imap pop3 lmtp
       listen = *, ::
       
     $ vim /etc/dovecot/conf.d/10-auth.conf
       disable_plaintext_auth = yes
       auth_anonymous_username = anonymous
       auth_mechanisms = plain
       
     $ vim /etc/dovecot/conf.d/10-mail.conf
       mail_location = maildir:~/Maildir
       inbox = yes
       
     $ vim /etc/dovecot/conf.d/10-ssl.conf
       ssl = no
### 5.sasl认证配置
       sudo yum -y install cyrus-sasl
       
       sudo vim /usr/lib64/sasl2/smtpd.conf
            pwcheck_method: saslauthd
            mech_list: PLAIN LOGIN
            log_level:3
            
       sudo vim /etc/postfix/main.cf
       添加如下几行
            smtpd_client_restrictions = permit_sasl_authenticated           
            smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination
            smtpd_sasl_auth_enable = yes
            smtpd_sasl_security_options = noanonymous
            smtpd_sasl_application_name = smtpd
            smtpd_banner = Welcome to my $myhostname ESMTP!
其中：
smtpd_client_restrictions=定义客户端限制
smtpd_recipient_restrictions=	#定义收件人限制；
permit_mynetworks允许本地的网络接收；
permit_sasl_authenticated允许通过SASL验证的用户；
reject_unauth_destination拒绝无法认证的目的地；
smtpd_sasl_auth_enable = yes	#启用SASL认证功能；
smtpd_#SASL的安全选项，不支持匿名用户；
smtpd_sasl_application_path = smtpd	#指定smtpd服务器程序使用SASL；
smtpd_banner = Welcome to my **$myhostname** ESMTP!	#定义欢迎信息

### 5.MX记录配置
     方法一：直接在购买的二级域名上添加解析记录
            MX @ dgtlinux.com
            A  @ 13.230.98.28
            A  www 13.230.98.28
     方法二：自建DNS
            $ yum install bind
            
            $ vim /etc/named.conf
              listen-on port 53 { any; };
              allow-query     { any; };
              
            $ vim /etc/named.rfc1912.zones
              zone "dgtlinux.com" IN {
              type master;
              file "named.localhost";
              allow-update { none; };
            };
            
            $ vim /var/named/named.localhost
              $TTL 1D
              @       IN SOA  dgtlinux.com. rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
                      NS      dns.dgtlinux.com.
                      dns     A       13.230.98.28
                      @       MX 10   13.230.98.28
                      mail    A       13.230.98.28
                      www     A       13.230.98.28  

### 6.重启服务和测试
     service postfix restart
     service dovecot restart
     
     [ec2-user@mail ]$ sudo telnet localhost 25
     Trying ::1...
     to localhost.
     Escape character is '^]'.
     220 mail.dgtlinux.com ESMTP Postfix
     mail from: zs@dgtlinux.com.    //发送的邮件地址
     250 2.1.0 Ok
     rcpt to: 1585656556@qq.com  //接收的用湖名
     250 2.1.5 Ok 
     data                         //邮件的内容
     354 End data with <CR><LF>.<CR><LF>
     lfglk'df;g
     .                            //以“.”结束
     250 2.0.0 Ok: queued as 6690591400053
     quit                         //退出
     221 2.0.0 Bye
     Connection closed by foreign host.
     

### 补充：
    在生产环境中网站的官方邮箱会经常配置成support@xxx.com
    但这时候可能会出现可以发信但不能收信的情况。原因是：support用户在linux服务器中的别名是postmaster所以发给support的邮件都会发给postmaster，所以这时我们只要把support的别名改成support就可以收件了。
    vim /etc/aliases
        support:    support
    /usr/bin/newaliases     刷新/etc/aliases
