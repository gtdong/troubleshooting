## postgresql

### 安装
1.实验环境: RHEL-7.5

2.安装:
```
$ yum -y install postgresql postgresql-server

# 初始化数据库
$ service postgresql initdb

# 启动数据库
$ service postgresql start

# 修改postgres用户密码
$ su - postgres
-bash-4.2$ psql

ALTER USER postgres WITH PASSWORD 'password';

# 客户端认证配置
$ vim /var/lib/pgsql/data/pg_hba.conf
  常用配置
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    # "local" is for Unix domain socket connections only
    local   all             all                                     md5
    # IPv4 local connections:
    host    all             all             127.0.0.1/32            md5
    # IPv6 local connections:
    host    all             all             ::1/128                 md5
 注：这里md5表示在连接数据库时采用密码认证，如果改成trust表示不用输密码也可登录，这种方式不建议在生产环境中使用。
 
$ service postgresql restart

```

### pg_hba.conf文件解析
pg_hba.conf是客户端认证配置文件，定义了认证客户端的认证方式。这里我采用的是9.2.24版本，以下是常用配置:
```
# TYPE  DATABASE  USER  CIDR-ADDRESS  METHOD
 
# "local" is for Unix domain socket connections only
local    all      all                 ident
# IPv4 local connections:
host     all      all   127.0.0.1/32  md5
# IPv6 local connections:
host     all      all   ::1/128       md5
```
TYPE定义了多种连接PostgreSQL的方式，分别是：“local”使用本地unix套接字，“host”使用TCP/IP连接（包括SSL和非SSL），“host”结合“IPv4地址”使用IPv4方式，结合“IPv6地址”则使用IPv6方式，“hostssl”只能使用SSL TCP/IP连接，“hostnossl”不能使用SSL TCP/IP连接。

DATABASE指定哪个数据库，多个数据库，库名间以逗号分隔。“all”只有在没有其他的符合条目时才代表“所有”，如果有其他的符合条目则代表“除了该条之外的”，因为“all”的优先级最低。如下例：
```
local    db1      user1      reject
local    all      all        ident
```
这两条都是指定local访问方式，因为前一条指定了特定的数据库db1，所以后一条的all代表的是除了db1之外的数据库，同理用户的all也是这个道理。

USER指定哪个数据库用户（PostgreSQL正规的叫法是角色，role）。多个用户以逗号分隔。

CIDR-ADDRESS项local方式不必填写，该项可以是IPv4地址或IPv6地址，可以定义某台主机或某个网段。

METHOD指定如何处理客户端的认证。常用的有ident，md5，password，trust，reject。

ident是Linux下PostgreSQL默认的local认证方式，凡是能正确登录服务器的操作系统用户（注：不是数据库用户）就能使用本用户映射的数据库用户不需密码登录数据库。用户映射文件为pg_ident.conf，这个文件记录着与操作系统用户匹配的数据库用户，如果某操作系统用户在本文件中没有映射用户，则默认的映射数据库用户与操作系统用户同名。比如，服务器上有名为user1的操作系统用户，同时数据库上也有同名的数据库用户，user1登录操作系统后可以直接输入psql，以user1数据库用户身份登录数据库且不需密码。很多初学者都会遇到psql -U username登录数据库却出现“username ident 认证失败”的错误，明明数据库用户已经createuser。原因就在于此，使用了ident认证方式，却没有同名的操作系统用户或没有相应的映射用户。解决方案：1、在pg_ident.conf中添加映射用户；2、改变认证方式。

md5是常用的密码认证方式，如果你不使用ident，最好使用md5。密码是以md5形式传送给数据库，较安全，且不需建立同名的操作系统用户。

password是以明文密码传送给数据库，建议不要在生产环境中使用。

trust是只要知道数据库用户名就不需要密码或ident就能登录，建议不要在生产环境中使用。

reject是拒绝认证。

　

本地使用psql登录数据库，是以unix套接字的方式，附合local方式。

使用PGAdmin3或php登录数据库，不论是否本地均是以TCP/IP方式，附合host方式。如果是本地（数据库地址localhost），CIDR-ADDRESS则为127.0.0.1/32。

　

例：

1、允许本地使用PGAdmin3登录数据库，数据库地址localhost，用户user1，数据库user1db：

    host    user1db    user1    127.0.0.1/32    md5
2、允许10.1.1.0~10.1.1.255网段登录数据库：

    host    all    all    10.1.1.0/24    md5
3、信任192.168.1.10登录数据库：

    host    all    all    192.168.1.10/32    trust
　

pg_hba.conf修改后，使用pg_ctl reload重新读取pg_hba.conf文件，如果pg_ctl找不到数据库，则用-D /.../pgsql/data/　指定数据库目录，或export PGDATA=/.../pgsql/data/　导入环境变量。

　

另：PostgreSQL默认只监听本地端口，用netstat -tuln只会看到“tcp 127.0.0.1:5432 LISTEN”。修改postgresql.conf中的listen_address=*，监听所有端口，这样远程才能通过TCP/IP登录数据库，用netstat -tuln会看到“tcp 0.0.0.0:5432 LISTEN”。




