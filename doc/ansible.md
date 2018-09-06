## ansible

### 什么是ansible？
    
Ansible是一款基于python语言的自动化运维工具。
Ansible 有三个最吸引人的地方：无客户端、简单易用和日志集中控管。   
使用Ansible我们可以自动化地完成我们平时的工作任务，从而有更多的时间把精力集中在更值得关注的事上。

### Ansible环境搭建
**Ubuntu (Apt)**  
```
安装 add-apt-repository 必要套件。

$ sudo apt-get install -y python-software-properties software-properties-common
使用 Ansible 官方的 PPA 套件来源。

$ sudo add-apt-repository -y ppa:ansible/ansible; sudo apt-get update
安装 Ansible。

$ sudo apt-get install -y ansible
```

**CentOS (Yum)**
```
新增 epel-release 第三方套件来源。

$ sudo yum install -y epel-release
安装 Ansible。

$ sudo yum install -y ansible
```

**macOS (Homebrew)**

```
请先安装 homebrew，已安装者请略过。

$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
安装 Ansible。

$ brew install ansible

```

**Python (Pip)**
```
Ansible 近来的释出速度很快，若想追求较新的版本可改用 Pip 的方式进行安装，较不建议初学者使用。

需请先安装 pip，已安装者请略过。

# Debian, Ubuntu
$ sudo apt-get install -y python-pip

# CentOS
$ sudo yum install -y python-pip

# macOS
$ sudo easy_install pip
升级 pip。

$ sudo pip install -U pip
安装 Ansible。

$ sudo pip install ansible
```

### Ansible配置

```
安装好python之后，我们可以在/etc/ansible下找到ansible的两个配置文件: ansible.cfg 和 hosts 。
ansible.cfg是主配置文件，而我们常用的地址清单列表可以在hosts里进行配置。

1.需要配置的常见选项
#ansible_ssh_host: 远端主机地址
#ansible_ssh_port: 远端主机ssh端口(不配置此选项默认端口就是22)
#ansible_ssh_user: 远端主机登录用户名(也可以在使用ansible命令时用-u指定)
#ansible_ssh_private_key_file: 本机ssh私钥路径
#ansible_ssh_pass: 远端主机ssh登录密码（建议使用密钥登录）

其实通常下，不用配置这么多:
[webservers]
alpha.example.org
beta.example.org

其中，webserver代表的是主机组，alpha.example.org和beta.example.org是主机里面的主机，也可以用主机IP表示。

2.配置ssh免密码登录
这个配置我在这就不多做描述了，只要把你的本机公钥(通常是is_rsa.pub)内容上传到远端主机上就行
cat id_rsa.pub >> ~/.ssh/authorized.keys (注意这里要用">>",不要用>,否则就会把之前的内容覆盖，导致你连不上主机了。)

```   

### ansible命令的用法

```
例如，我们想查看webservers主机组中所有主机的内存使用情况就可以这样执行命令:
ansible -u ec2-user webservers -a 'free -m'
其中: -u指定连接远程主机使用的用户名, webservers代表需要连接的远程主机组(也可以使用all，表示连接所有主机),'free -m'表示钥在远程主机上执行的命令。
```
参考: https://www.cnblogs.com/wzhuo/p/7128502.html
