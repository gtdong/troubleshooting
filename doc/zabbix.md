# zabbix4.0 on CentOS7
## Install zabbix
点击下面的链接，可以获得zabbix安装包的官方下载地址，和官方文档，并且有安装步骤，您可以选择自己喜欢的安装方式和版本，我这里选择的是Install from package,也就是rpm包安装，这种安装方式相对简单，对于小白用户来说比较方便。  
https://www.zabbix.com/download
https://www.zabbix.com/documentation/
## configure zabbix
这里我主要想讲的是zabbix的初始化配置和添加监控主机等基础配置。
## 前端的初始化
安装方的给的安装步骤安装完后，我们需要执行`systemctl restart zabbix-server zabbix-agent httpd`这个命令，这时zabbix服务器就起了了，下一步就是初始化
前端配置：

在浏览器中输入：http://服务器IP/zabbix进入配置页面,第一步是数据库连接设置
![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix1.jpg)
分别配置数据库类型、端口、数据库名(在Istall zabbix时设置的数据库)、数据库用户、密码，然后点击next step

设置zabbix server,前两项默认，Name自己定义即可，比如叫zabbix监控。
![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix2.png)

![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix3.png)

![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix4.png)

![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix5.png)

安装完成，进行登录。默认用户是Admin，密码是zabbix，当然这些都可以登录后进行修改。

## 语言、乱码、时区问题
1.语言设置：   
依次点击Administration ---> Users ---> Admin,然后在language选项选择相应的语言，然后记得Update。刷新后访问配置就会生效。

2.乱码设置：   
  在使用中文时可能会出现乱码的问题，解决方法是替换字体：
  
     1、从Window服务器找到相应的字休复制到zabbix Server服务器上：

     控制面板-->字体-->选择一种中文字库例如“楷体”（simkai.ttf）
     
     2、将字体上传到zabbix server服务器上的字体目录中，/usr/share/zabbix/fonts/    
     修改此/usr/share/zabbix/include/defines.inc.php文件中字体的配置，将里面关于字体设置从graphfont替换成simkai
     define('ZBX_GRAPH_FONT_NAME',           'graphfont'); // font file name
3.时区设置:  
    很多人在初次安装的时候会出现监控时间和系统时间不一致的情况，这时就需要修改zabbix的时区设置
    
     vim /etc/httpd/conf.d/zabbix.conf
          php_value date.timezone Asia/Shanghai
     #这里我用的是上海时区
     
## 添加监控主机

以上我们是对zabbix的server端进行的配置，接下来我们需要配置客户端，也就是被监控端。

1.安装zabbix-agent，负责从被监控端搜集主机信息，这一步在在被监控端安装。

      # rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
      
      # yum -y install zabbix-agent
      
2.修改配置文件

      # vim /etc/zabbix/zabbix_agentd.conf
          Server=server端IP
          Hostname=front1   #主机名，自定义即可
          
          #ServerActive=127.0.0.1   #这一行注释掉
3.启动zabbix客户端
      
      # systemctl start zabbix-agent
      
4.web监控后台添加主机

依次点击 配置 ---> 主机 ---> 创建主机 

![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix6.png)

主机名称必须和配置文件中的Hostname一样，主机群组可以自定义也可以任意选择一个，IP填客户端IP。   

然后配置模版，也就是配置监控项，勾选完点击添加。
![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix7.png)

## 配置邮件报警
1.建立告警脚本

    # cd /usr/lib/zabbix/alertscript
    # vim sendEmail.py
      #!/usr/bin/env python
      #coding:utf-8
      import time
      import smtplib
      import logging
      from email.mime.text import MIMEText
      import sys
      LOG_FILENAME="/var/log/email_python.log"
      mail_host = 'mstp.163.com'
      mail_user = 'xxxx@xxxx.com'
      mail_pass = 'xxxxx'
      mail_postfix = 'xxxxx'
      def send_mail(to_list,subject,content,format='html'):
       try:
        me=mail_user+"<"+mail_user+"@"+mail_postfix+">"
        msg=MIMEText(content,format,'utf-8')
        msg["Accept-Language"]="zh-CN"
        msg["Accept-Charset"]="ISO-8859-1,utf-8"
        msg['Subject']=subject
        msg['From']=me
        msg['to']=to_list
        s=smtplib.SMTP()
        s.connect(mail_host,"25")
        s.login(mail_user,mail_pass)
        s.sendmail(me,to_list,msg.as_string())
        s.close()
      except Exception,e:
        logging.basicConfig(filename = LOG_FILENAME, level = logging.DEBUG)
        logging.error(time.strftime('%Y-%m-%d %H:%I:%M',time.localtime(time.time()))+e)
      if __name__ == "__main__":
      send_mail(sys.argv[1],sys.argv[2],sys.argv[3])
      
      设置告警脚本的权限

      sudo chmod zabbix:zabbix sendEmail.py

      sudo chown 755 sendEmail.py
    
![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix8.png)

![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix9.png)

![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix10.png)

![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix11.png)

![image](https://github.com/gtdong/troubleshooting/blob/master/images/zabbix12.png)





     
     


