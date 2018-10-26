# zabbix4.0 on CentOS7
## Install zabbix
点击下面的链接，可以获得zabbix安装包的官方下载地址，和官方文档，并且有安装步骤，您可以选择自己喜欢的安装方式和版本，我这里选择的是Install from package,也就是rpm包安装，这种安装方式相对简单，对于小白用户来说比较方便。  
https://www.zabbix.com/download
https://www.zabbix.com/documentation/
## configure zabbix
这里我主要想讲的是zabbix的初始化配置和添加监控主机等基础配置。
## 1.前端的初始化
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

## 2.
