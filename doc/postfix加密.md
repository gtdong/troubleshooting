# postfix加密端口配置

上篇文章我们介绍了postfix服务器的基本配置。但是在生产环境中，光有基本配置还是不行的，我们可以通过配置postfix加密，来使我们的邮件传输更加的安全。 
下面我们就来了解postfix加密的相关知识和配置方法。

* **邮件端口**
* **加密配置**    

## 邮件端口
    邮件服务器端口有25，109，110，143，465，587，993，995
    其中25，465，587为smtp发信端口，
       109，110，143，993，995为收信端口；
    而且25，109，110，143为未加密的邮件端口，
        465，487，993，995为加密端口
**25端口（SMTP）**：英文（Simple mail transfer protocol）,用于发送邮件。但是25端口被很多木马程序所开放，比如Ajan、Antigen、Email Password Sender、ProMail、trojan、Tapiras、Terminator、WinPC、WinSpy等等。拿WinSpy来说，通过开放25端口，可以监视计算机正在运行的所有窗口和模块。所以，如果不是要架设邮件服务器，最好将此端口关闭。

**109端口（POP2）**：109端口是为POP2（Post Office Protocol Version2，邮局协议2）服务开放的，是用于接收邮件的。

**110端口**：110端口是为POP3（Post Office Protocol Version 3，邮局协议3）服务开放的，是用于接收邮件的。

**143端口**：143端口是为IMAP（INTERNET MESSAGE ACCESS PROTOCOL）服务开放的，是用于接收邮件的。
      
IMAP协议，和POP3协议一样是用来接收邮件的，但是它有它的特别和新颖之处，它是面向用户的，它和POP3协议的主要区别是：用户可以不用把所有的邮件内容全部下载，而是只下载邮件标题和发件人等基本信息，用户可以由标题等基本信息，去决定是否下载邮件全文，用户可以通过客户端的浏览器直接对服务器上的邮件进行操作（比如：打开阅读全文、丢进垃圾箱、永久删除、整理到某文件夹下、归档、）。再简单来说就是：浏览器用的IMAP协议（143端口）来为你接收邮件以及让你很方便的操作服务器上的邮件。邮件客户端用的POP3协议（110端口）来为你接收邮件的全部信息和全文内容保存到你的本地机器成为一个副本，你对邮件客户端上的副本邮件的任何操作都是在副本上，不干涉邮件服务器上为你保存的邮件原本。

上面介绍的SMTP协议、POP2协议、POP3协议、IMAP协议都是不安全的协议。因考虑到网络安全的因素，下面给你介绍基于SSL（SecureSockets Layer)
安全套接层协议的安全的邮件收发协议。你的邮件在传输过程中可能被网络黑客截取邮件内容，如果你的邮件机密性非常强，不想被收件人以外的任何人和任何黑客截取，或者是涉及国家机密安全的，等等。那么你的邮件就不该使用上述的三种协议进行收发。

若你采用SMTP协议发邮件，那么你发出的邮件从你的机器传到服务器的过程中，可能被黑客截取从而泄露。若你采用POP2或者POP3协议收取邮件，那么你的邮件从服务器传至你当前机器的过程可能被黑客截取从而泄露。

**465端口（SMTPS）**：465端口是为SMTPS（SMTP-over-SSL）协议服务开放的，这是SMTP协议基于SSL安全协议之上的一种变种协议，它继承了SSL安全协议的非对称加密的高度安全可靠性，可防止邮件泄露。SMTPS和SMTP协议一样，也是用来发送邮件的，只是更安全些，防止邮件被黑客截取泄露，还可实现邮件发送者抗抵赖功能。防止发送者发送之后删除已发邮件，拒不承认发送过这样一份邮件。

**587端口（SMTP+TLS）**：587端口是为（SMTP-over-SSL）开放的。

`那么SSL和TLS有什么区别呢？`

最新版本的TLS（Transport Layer Security，传输层安全协议）是IETF（Internet Engineering Task Force，Internet工程任务组）制定的一种新的协议，它建立在SSL 3.0协议规范之上，是SSL 3.0的后续版本。在TLS与SSL3.0之间存在着显著的差别，主要是它们所支持的加密算法不同，所以TLS与SSL3.0不能互操作。

　　1．TLS与SSL的差异</br>
　　1）版本号：TLS记录格式与SSL记录格式相同，但版本号的值不同，TLS的版本1.0使用的版本号为SSLv3.1。</br>
　　2）报文鉴别码：SSLv3.0和TLS的MAC算法及MAC计算的范围不同。TLS使用了RFC-2104定义的HMAC算法。SSLv3.0使用了相似的算法，两者差别在于SSLv3.0中，填充字节与密钥之间采用的是连接运算，而HMAC算法采用的是异或运算。但是两者的安全程度是相同的。</br>
　　3）伪随机函数：TLS使用了称为PRF的伪随机函数来将密钥扩展成数据块，是更安全的方式。</br>
　　4）报警代码：TLS支持几乎所有的SSLv3.0报警代码，而且TLS还补充定义了很多报警代码，如解密失败（decryption_failed）、记录溢出（record_overflow）、未知CA（unknown_ca）、拒绝访问（access_denied）等。</br>
　　5）密文族和客户证书：SSLv3.0和TLS存在少量差别，即TLS不支持Fortezza密钥交换、加密算法和客户证书。</br>
　　6）certificate_verify和finished消息：SSLv3.0和TLS在用certificate_verify和finished消息计算MD5和SHA-1散列码时，计算的输入有少许差别，但安全性相当。</br>
　　7）加密计算：TLS与SSLv3.0在计算主密值（master secret）时采用的方式不同。</br>
　　8）填充：用户数据加密之前需要增加的填充字节。在SSL中，填充后的数据长度要达到密文块长度的最小整数倍。而在TLS中，填充后的数据长度可以是密文块长度的任意整数倍（但填充的最大长度为255字节），这种方式可以防止基于对报文长度进行分析的攻击。

　　2．TLS的主要增强内容</br>
　　TLS的主要目标是使SSL更安全，并使协议的规范更精确和完善。TLS 在SSL v3.0 的基础上，提供了以下增强内容：</br>
　　1）更安全的MAC算法</br>
　　2）更严密的警报</br>
　　3“灰色区域”规范的更明确的定义</br>
  
　　3．TLS对于安全性的改进</br>
　　1）对于消息认证使用密钥散列法：TLS 使用“消息认证代码的密钥散列法”（HMAC），当记录在开放的网络（如因特网）上传送时，该代码确保记录不会被变更。SSLv3.0还提供键控消息认证，但HMAC比SSLv3.0使用的（消息认证代码）MAC 功能更安全。</br>
　　2）增强的伪随机功能（PRF）：PRF生成密钥数据。在TLS中，HMAC定义PRF。PRF使用两种散列算法保证其安全性。如果任一算法暴露了，只要第二种算法未暴露，则数据仍然是安全的。</br>
　　3）改进的已完成消息验证：TLS和SSLv3.0都对两个端点提供已完成的消息，该消息认证交换的消息没有被变更。然而，TLS将此已完成消息基于PRF和HMAC值之上，这也比SSLv3.0更安全。</br>
　　4）一致证书处理：与SSLv3.0不同，TLS试图指定必须在TLS之间实现交换的证书类型。</br>
　　5）特定警报消息：TLS提供更多的特定和附加警报，以指示任一会话端点检测到的问题。TLS还对何时应该发送某些警报进行记录。</br>

**995端口（POP3S）**：995端口是为POP3S（POP3-over-SSL）协议服务开放的，这是POP3协议基于SSL安全协议之上的一种变种协议，它继承了SSL安全协议的非对称加密的高度安全可靠性，可防止邮件泄露。POP3S和POP3协议一样，也是用来接收邮件的，只是更安全些，防止邮件被黑客截取泄露，还可实现邮件接收方抗抵赖功能。防止收件者收件之后删除已收邮件，拒不承认收到过这样一封邮件。

**993端口（IMAPS）**：993端口是为IMAPS（IMAP-over-SSL）协议服务开放的，这是IMAP协议基于SSL安全协议之上的一种变种协议，它继承了SSL安全协议的非对称加密的高度安全可靠性，可防止邮件泄露。IMAPS和IMAP协议一样，也是用来接收邮件的，只是更安全些，防止邮件被黑客截取泄露，还可实现邮件接收方抗抵赖功能。防止收件者收件之后删除已收邮件，拒不承认收到过这样一封邮件。

## 加密配置

### 1.生成证书
     $ cd /etc/pki/tls/misc
     $ ./CA -newca  生成根证书
     
     $ openssl req -new -nodes -keyout mailkey.pem -out mailreg.pem -days 365
     
     $ openssl ca -out mail_signed_cert.pem -infiles mailreg.pem        签发SMTP服务器用证书
     如果报错
     rm -rf /etc/pki/CA/index.txt
     touch /etc/pki/CA/index.txt
### 2.安装证书到postfix，并配置postfix
     $ cp CA/cacert.pem /etc/postfix/
     $ cp mailkey.pem /etc/postfix/
     $ cp mail_signed_cert.pem /etc/postfix/
     
### 3.打开加密端口(smtp +SSL:465)
     $ vim /etc/postfix/master.cf
     加入如下几行：
     smtps     inet  n       -       n       -       -       smtpd
     -o syslog_name=postfix/smtps
     -o smtpd_tls_wrappermode=yes
     -o smtpd_sasl_auth_enable=yes
     -o smtpd_reject_unlisted_recipient=no
     
### 打开加密端口（smtp +TLS:587）
     $ vim /etc/postfix/master.cf
     加入如下几行：
     submission inet n       -       n       -       -       smtpd
     
     
### dovecot加密配置（993、995）
     $ vim /etc/dovecot/dovecot.con
         protocols = imap pop3 lmtp pop3s
         
     $ vim /etc/dovecot/conf.d/10-ssl.conf
         ssl = required
         ssl_cert = </etc/pki/dovecot/certs/dovecot.pem
         ssl_key = </etc/pki/dovecot/private/dovecot.pem


    
