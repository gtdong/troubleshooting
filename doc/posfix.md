##postfix邮件服务器搭建
###1.设置hostname
    $ echo 'mail.aubitex.com' > /etc/hostname
    $ hostname -F /etc/hostname
    
###2.安装postfix
    $ yum install postfix 
    
###3.postfix基本配置
   Postfix的配置文件位于/etc/postfix/main.cf。一般有以下几个重要参数需要设置：
   
    *myhostname //主机名
     myhostname = mail.aubitex.com
    
    *myorigin //外发邮件时发件人的邮件域名
     myorigin = $myhostname  //在通过Postfix发送邮件的时候，如果From字段不完整，Postfix会根据myorigin的值将地址补全为 *@mail.aubitex.com
  
    *mydomain   //使用邮件域
     mydomain = aubitex.com   //mydomain 设置本地网络的邮件域
    *inet_interfaces   //监听的网卡接口
     inet_interfaces = all
       
    *mydestination  //可接受邮件地址域名
     mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain localhost.qq.com localhost.163.com localhost.foxmail.com localhost.sina.com localhost.msn.com localhost.hotmail.com localhost.126.com localhost.gmail.com
     //mydestination指定了postfix在收到这些域名地址为目标的邮件时，作为接受方收下邮件。如果收到的邮件既不符合转发规则，又不符合接受规则，则拒绝收信。
     
     *mynetworks  //需要收发的客户端的地址
      mynetworks = 127.0.0.0/8   //mynetworks指定了本地网络的IP段，默认只包含主机自己，你可以添加需要收发的客户端的地址。
      
      relay_domains = $mydomain  //指定了哪些域可以通过此台服务器转发邮件。
      
      home_mailbox = Maildir/  //邮件的存放位置
      
###4.安装dovecot
     $ yum install dovecot
     $ vim /etc/dovecot/dovecot.conf
       protocols = imap pop3 lmtp
       listen = *, ::
       
     $ vim /etc/dovecot/conf.d/10-auth.conf
       disable_plaintext_auth = no
       auth_anonymous_username = anonymous
       auth_mechanisms = plain
       
     $ vim /etc/dovecot/conf.d/10-mail.conf
       mail_location = maildir:~/Maildir
       inbox = yes
       
     $ vim /etc/dovecot/conf.d/10-ssl.conf
       ssl = no
###5.安装sasl(登录认证)
     $ yum -y install cyrus-sasl
     $ vim /usr/lib64/sasl2/smtpd.conf(这个文件默认是不存在的)
       pwcheck_method: saslauthd
       mech_list: PLAIN LOGIN
       log_level:3
        
      
###6.MX记录配置
     方法一：直接在购买的二级域名上添加解析记录
            MX @ aubitex.com
            A  @ 13.230.98.28
            A  www 13.230.98.28
     方法二：自建DNS
            $ yum install bind
            
            $ vim /etc/named.conf
              listen-on port 53 { any; };
              allow-query     { any; };
              
            $ vim /etc/named.rfc1912.zones
              zone "aubitex.com" IN {
              type master;
              file "named.localhost";
              allow-update { none; };
            };
            
            $ vim /var/named/named.localhost
              $TTL 1D
              @       IN SOA  aubitex.com. rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
                      NS      dns.aubitex.com.
                      dns     A       13.230.98.28
                      @       MX 10   13.230.98.28
                      mail    A       13.230.98.28
                      www     A       13.230.98.28  

###7.重启服务和测试
     service postfix restart
     service dovecot restart
     
     [ec2-user@mail ]$ sudo telnet localhost 25
     Trying ::1...
     to localhost.
     Escape character is '^]'.
     220 mail.aubitex.com ESMTP Postfix
     mail from: zs@aubitex.com.    //发送的邮件地址
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
     
##smtpd加密配置
###1.生成证书
     $ cd /etc/pki/tls/misc
     $ ./CA -newca  生成根证书
     
     $ openssl req -new -nodes -keyout mailkey.pem -out mailreg.pem -days 365
     
     $ openssl ca -out mail_signed_cert.pem -infiles mailreg.pem        签发SMTP服务器用证书
     如果报错
     rm -rf /etc/pki/CA/index.txt
     touch /etc/pki/CA/index.txt
###2.安装证书到postfix，并配置postfix
     $ cp CA/cacert.pem /etc/postfix/
     $ cp mailkey.pem /etc/postfix/
     $ cp mail_signed_cert.pem /etc/postfix/
     
###3.打开加密端口(smtps:465)
     $ vim /etc/postfix/master.cf
     加入如下几行：
     smtps     inet  n       -       n       -       -       smtpd
     -o syslog_name=postfix/smtps
     -o smtpd_tls_wrappermode=yes
     -o smtpd_sasl_auth_enable=yes
     -o smtpd_reject_unlisted_recipient=no
     
###打开加密端口（tls:587）
     $ vim /etc/postfix/master.cf
     加入如下几行：
     submission inet n       -       n       -       -       smtpd
     
     
##dovecot加密配置
     $ vim /etc/dovecot/dovecot.con
         protocols = imap pop3 lmtp pop3s
         
     $ vim /etc/dovecot/conf.d/10-ssl.conf
         ssl = required
         ssl_cert = </etc/pki/dovecot/certs/dovecot.pem
         ssl_key = </etc/pki/dovecot/private/dovecot.pem
     
     
