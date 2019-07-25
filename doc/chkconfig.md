# 用chkconfig配置开机启动脚本
## 步骤
* **1.编写脚本autostart.sh**（这里以开机启动redis服务为例），脚本内容如下：
```shell
#!/bin/sh
#chkconfig: 2345 80 90
#description:开机自动启动的脚本程序

# 开启redis服务 端口为6379
/usr/local/service/redis-2.8.3/src/redis-server --port 6379 &

#脚本第一行 “#!/bin/sh” 告诉系统使用的shell； 
#脚本第二行 “#chkconfig: 2345 80 90” 表示在2/3/4/5运行级别启动，启动序号(S80)，关闭序号(K90)； 
#脚本第三行 表示的是服务的描述信息  
#注意： 第二行和第三行必写，负责会出现如“服务 autostart.sh 不支持 chkconfig”这样的错误。
```
* **扩展**
我们来看看官方对chkconfig自启动配置脚本的说明:
```
Each  service  which should be manageable by chkconfig needs two or more commented lines added to its
init.d script. The first line tells chkconfig what runlevels the service should be started in by 
default, as well as the start and stop priority levels.  If  the service  should  not,  by default, 
be started in any runlevels, a - should be used in place of the runlevels list.  The second line 
contains a description for the service, and may be extended across multiple lines with backslash 
continuation.

For example, random.init has these three lines:
# chkconfig: 2345 20 80
# description: Saves and restores system entropy pool for \
#              higher quality random number generation.
This says that the random script should be started in levels 2, 3, 4, and 5, that its start priority 
should be  20,  and  that  its stop  priority  should  be  80.  You should be able to figure out 
what the description says; the \ causes the line to be continued.The extra space in front of the line is ignored.
```
这里的234其实就是linux的系统启动级别：
```
0: 停机
1：单用户形式，只root进行维护
2：多用户，不能使用net file system
3：完全多用户
4：安全模式
5：图形化
6：重启
```
通过编辑 /etc/inittab 文件，可以修改系统默认启动级别
* **2.将写好的autostart.sh脚本移动到/etc/rc.d/init.d/目录下**  
* **3.给脚本赋可执行权限**
 ```shell
cd /etc/rc.d/init.d/
chmod +x autostart.sh
```
* **4.添加脚本到开机自动启动项目中**
 ```shell
chkconfig --add autostart.sh
chkconfig autostart.sh on
```
