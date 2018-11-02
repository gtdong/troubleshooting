
## rsync同步服务器搭建

### server端

    mkdir -p /server/rsync    #创建内容同步目录
    vim /etc/rsyncd.conf      #修改rsync配置文件
        uid = nobody                             
        gid = nobody
        use chroot = yes
        port 873                                 #服务端口，
        hosts allow = *                          #允许同步的主机地址
        log file = /var/log/rsync.log
        pid file = /var/rsyncd.pid
        max connections = 200                    #允许的最大连接数
        timeout = 200                            #超时时间
        transfer logging = yes                   #记录传输日志
        read only = no
        [DATA]                                   #模块名(用于配置具体需要同步的目录、文件类型等等属性)
        comment = rsync server
        path = /server/rsync                     #内容同步目录
        charset = UTF-8
        ignore errors
        dont compress = *.gz *.tgz *.bz2         #不压缩的文件类型
        auth users = upload                      #用于同步的虚拟用户
        secrets file = /etc/rsyncd_users.db      #用户密码文件
        
    vim /etc/rsyncd_users.db                     #创建用户密码文件
        upload:password                          #密码（格式必须为：username:password）
    chmod 600 /etc/rsyncd_users.db               #必须修改权限，否则会报错
        
    service rsyncd restart    #重启服务
    
### client端

    mkdir -p /client/rsync    #创建内容同步目录
    
    vim /etc/profile
      export RSYNC_PASSWORD=password             #声明密码的全局变量（同步时不用输密码，系统会自动去这个环境密码中去找密码）
      
### 同步测试

    rsync -avzP upload@服务器ip::DATA /client/rsync
    
