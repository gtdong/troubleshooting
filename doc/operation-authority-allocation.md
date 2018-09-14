运维权限分配

### 前言
可能大家都听过这样的新闻:某某公司的运维工程师因为在服务器上执行了`rm -rf /*`这个命令导致系统损坏、用户数据全部丢失。这也太可怕了吧！但有一些运维知识的人都明白:在没有sudo权限的情况下，`rm -rf /*`是删除不了系统所有数据的,除非操作者是root用户或者在执行`sudo rm -rf /*`的时候拥有root权限。所以，我们可以通过控制的用户的sudo权限来限制用户，从而避免用户的误操作

### sudo权限分配方案
1.召集公司技术人员(运维和开发人员)开会，商讨服务器权限分配问题，分别对运维、开发、测试人员的权限分配进行讨论。会议内容需记录，由运维主管整理出方案，并公示出去，确认无误后进行执行，执行完毕告知相关人员，进行权限测试。

2.执行方案:
用户权限分配:
运维人员赋予运维权限，非运维人员分配普通用户权限，权限给到最小，尤其是 rm 、vim 、chmod 等权限，慎重赋予。
详细如下:
 
角色|权限|
------|------------------------|
初级运维|CY_CMD_1=/usr/bin/free,/usr/bin/iostat,/usr/bin/top,/bin/hostname,/sbin/ifconfig,/bin/netstat    
高级运维|
GY_CMD_1=/usr/bin/free,/usr/bin/iostat,/usr/bin/top,/bin/hostname,/sbin/ifconfig,/bin/netstat,/sbin/route,/sbin/iptables,/etc/init.d/network,/bin/nice,/bin/kill,/usr/bin/killall,/bin/rpm,/usr/bin/yum,/sbin/fdisk,/sbin/sfdiak,/sbin/parted,/sbin/partprobe,/bin/mount,/bin/umount
初级开发|CK_CMD_1=/usr/bin/tail,/bin/grep,/bin/cat,/bin/ls
高级开发|GK_CMD_1=/sbin/service,/sbin/chkconfig,/bin/tail ,/bin/grep ,/bin/cat,/bin/ls

配置:
a、useradd 创建用户     
`User_Alias CHUJIADMINS =chuji001,chuji002,chuji003 User_Alias GAOJIADMINS =gaoji001，gaoji002 ，gaoji003 User_Alias CHUJI_KAIFA = cjkf001，cjkf002，cjkf003 User_Alias GAOJI_KAIFA = gjkf001，gjkf002 ，gjkf003`     
b、通过 visudo 编辑/etc/sudoers,添加如下内容: ##User_Alias by dgt (用户别名首字母大写)      
`##Runas_Alias by dgt ##2018     
Runas_Alias OP=root (用 root 的角色去做)
#config(权限赋予)
CHUJIADMINS ALL=(OP) CY_CMD_1
GAOJIADMINS ALL=(OP) GJ_CMD_1 CHUJI_KAIFA ALL=(OP) CK_CMD_1 GAOJI_KAIFA ALL=(OP) GK_CMD_1`

