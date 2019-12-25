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

### 开机自动脚本
```
Linux设置服务开机自动启动的方式有好多种，这里介绍一下通过chkconfig命令添加脚本为开机自动启动的方法。
 
1. 编写脚本autostart.sh（这里以开机启动redis服务为例），脚本内容如下：
 
#!/bin/sh
#chkconfig: 2345 80 90
#description:开机自动启动的脚本程序
 
# 开启redis服务 端口为6379
/usr/local/service/redis-2.8.3/src/redis-server --port 6379 &
脚本第一行 “#!/bin/sh” 告诉系统使用的shell； 
脚本第二行 “#chkconfig: 2345 80 90” 表示在2/3/4/5运行级别启动，启动序号(S80)，关闭序号(K90)； 
脚本第三行 表示的是服务的描述信息
 
注意： 第二行和第三行必写，负责会出现如“服务 autostart.sh 不支持 chkconfig”这样的错误。
 
2. 将写好的autostart.sh脚本移动到/etc/rc.d/init.d/目录下
 
3. 给脚本赋可执行权限
 
cd /etc/rc.d/init.d/
chmod +x autostart.sh
4. 添加脚本到开机自动启动项目中
 
chkconfig --add autostart.sh
chkconfig autostart.sh on
到这里就设置完成了，我们只需要重启一下我们的服务器，就能看到我们配置的redis服务已经可以开机自动启动了。
```

webhook代码自动更新
  ```
  1.     服务器上生成公钥

ssh-keygen  

2.  将公钥上传到github上，实现免密码push和pull

登录github >> settings >> SSH and GPG keys >> New SSH key >>

将上一步生成的.pub公钥内容复制粘贴到过来

3.  在服务器上开启API:当代码发生merge操作时会自动调用这个API,API调用写好的脚本实现更新代码及其他相关操作。

 

(1)写api

vim webhook.php

 

<?php

 

 

    //密钥

    $secret = "******";

    $wwwUser = 'dev';  #程序执行用户（最好和apache用户，服务器用户一致，否则会出现权限问题，这里我使用的是dev用户在服务器上操作，相应的apache的用户和用户组我也设置为dev）

    $wwwGroup = 'dev';  #程序执行用户组

 

    //日志文件地址

    $fs = fopen('gitHubAuto_hook.log', 'a');

 

    //获取GitHub发送的内容

    $json = file_get_contents('php://input');

    $content = json_decode($json, true);

    //github发送过来的签名

    $signature = $_SERVER['HTTP_X_HUB_SIGNATURE'];

 

    if (!$signature) {

       fclose($fs);

       return http_response_code(404);

     }

 

    list($algo, $hash) = explode('=', $signature, 2);

    //计算签名

    $payloadHash = hash_hmac($algo, $json, $secret);

 

    // 判断签名是否匹配

    if ($hash === $payloadHash) {

 

        $cmd1 = "/usr/bin/sh update.sh";

        shell_e x e c($cmd1);

 

        $res_log .= 'Success:'.PHP_EOL;

        $res_log .= $content['head_commit']['author']['name'] . ' 在' . date('Y-m-d H:i:s') . '向' . $content['repository']['name'] . '项目的' . $content['ref'] . '分支push了' . count($content['commits']) . '个commit：' . PHP_EOL;

        $res_log .= $res.PHP_EOL;

        $res_log .= '======================================================================='.PHP_EOL;

 

        fwrite($fs, $res_log);

        $fs and fclose($fs);

 

 

      } else {

            $res_log  = 'Error:'.PHP_EOL;

            $res_log .= $content['head_commit']['author']['name'] . ' 在' . date('Y-m-d H:i:s') . '向' . $content['repository']['name'] . '项目的' . $content['ref'] . '分支push了' . count($content['commits']) . '>个commit：' . PHP_EOL;

            $res_log .= '密钥不正确不能pull'.PHP_EOL;

            $res_log .= '======================================================================='.PHP_EOL;

           fwrite($fs, $res_log);

           $fs and fclose($fs);

      }

 

（2）配置apache实现可外网访问

 

        Vim httpd-vhosts.conf添加如下内容

 

listen 81

<VirtualHost *:81>

ServerAdmin localhost

ErrorLog "/var/www/github_web/error_log"

CustomLog "/var/www//github_web/access_log" combined

DocumentRoot "/var/www/github_web"

<Directory "/var/www/github_web">

AllowOverride None

Order allow,deny

Allow from all

</Directory>

</VirtualHost>

 

   重启apache

   service httpd restart

 

4.     github配置webhook接口

 

登录github >> 选择要配置自动更新的repository >> Settings

>> 点击左边栏 Webhooks >> Add webhook

 

（1）  在Payload URL 填写上一步配置的API

http://服务器ip:81/webhook.ip

   (2) Content type一栏选择 application/json

 

   (3) Secret 填写第3步定义的secret

 

   (4) Which events触法条件配置，也就是在什么情况下会调用这个api,

   这里我们配置的是：在对PR进行merge的时候触发api.

 

      在Let me select individuals events中选择Pull requests

 

5.  自动更新代码的脚本配置

 

vim update.sh

cd 项目路径 && /usr/local/git/bin/git pull origin master && /usr/bin/python3 mail.py

 

注意：shell命令要用绝对路径，否则有可能会出问题

 

6.  邮件通知脚本配置

 

vim mail.py

 

#!/usr/bin/env python3

import smtplib

from email.mime.text import MIMEText

from email.header import Header

 

sender = 'admin@example.com'

pwd = 'admin'

receivers = ['user@exmaple.com']# 接收邮件，可设置为你的QQ邮箱或者其他邮箱

# 三个参数：第一个为文本内容，第二个 plain 设置文本格式，第三个 utf-8 设置编码

message = MIMEText('项目已经更新', 'plain', 'utf-8')

message['From'] = Header("github", 'utf-8')

#message['To'] =  Header("admin", 'utf-8')

 

subject = '项目更新'

message['Subject'] = Header(subject, 'utf-8')

 

 

try:

    smtpObj = smtplib.SMTP_SSL('smtp.mxhichina.com',465)

    smtpObj.login(sender,pwd)

    smtpObj.sendmail(sender, receivers, message.as_string())

    print ("邮件发送成功")

except smtplib.SMTPException:

    print ("Error: 无法发送邮件")


  ```
