## postgresql

### Installing
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


