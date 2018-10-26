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
     
     


