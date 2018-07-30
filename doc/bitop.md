##bitop.io on RHEL 7.4

###1.	Install Postgresql 9.2.23
    sudo yum install postgresql postgresql-server
修改如下配置，允许本地用户访问数据库

    sudo vim /var/lib/pgsql/data/pg_hba.conf
    # "local" is for Unix domain socket connections only
    local   all       all                      trust                                   
    # IPv4 local connections:
    host    all       all        127.0.0.1/32  trust
    # IPv6 local onnections:
    host    all       all             ::1/128  trust   
    
启动化数据库：

    sudo service postgresql start
创建数据库用户，和数据库

    sudo su – postgres 
    psql
    postgres=#  CREATE USER hkico WITH PASSWORD 'hkico';
    postgres=#  CREATE DATABASE hkico OWNER hkico;
    postgres=#  GRANT ALL PRIVILEGES ON DATABASE hkico TO hkico;
###2.	Install reids 3.2.10
    sudo yum install redis
    service redis start
###3.	Install nodejs 6.12.3
    sudo yum intall nodejs
###4.	Setup production environment
    git clone https://github.com/tonliyp/hkico.server.git
    cd ~/hkico.server
    npm install
    npm install forever
    forever start app.js
    git clone https://github.com/tonliyp/hkico.git
    cd ~/hkico
    yarn 
    yarn build
    yarn start
###5.	Install nginx
    sudo yum install nginx
    sudo vim /etc/nginx/conf.d/default.conf
    server {
          listen       80;
          server_name  bitop.io;
        gzip on;
        gzip_disable "msie6";
        gzip_comp_level 6;
        gzip_min_length 1100;
        gzip_buffers 16 8k;
        gzip_proxied any;
        gzip_types    text/plain application/javascript application/x-javascript text/javascript text/xml text/css application/octet-stream;

        location / {
           proxy_set_header X-Real-IP  $remote_addr;
           proxy_set_header Host $host;
           proxy_set_header X-Forwarded-For
           $proxy_add_x_forwarded_for;
           proxy_pass http://127.0.0.1:8081;
                   }
        location /hkico/ {
           proxy_set_header X-Real-IP  $remote_addr;
           proxy_set_header Host $host;
           proxy_set_header X-Forwarded-For 
           $proxy_add_x_forwarded_for;
           proxy_pass http://127.0.0.1:8101/hkico/;
                         }
           }
    sudo service nginx start

