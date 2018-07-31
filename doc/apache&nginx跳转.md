
### apache&nginx跳转

### 地址跳转</br>
A．	什么是地址跳转？
地址跳转，又叫URL（统一资源定位符）跳转。简单来说，就是当你访问a网址时，服务器直接跳转到b网址。举个例子：当你浏览器的地址栏输入www.abc.com时，服务器直接跳转到www.cde.com。

B．	配置地址跳转
a.	apache地址跳转配置（www.abc.com跳转到www.cde.com）     

    (1）vim /usr/local	/apache2/conf/htttpd.conf   
        开启虚拟主机模块    <br>
        LoadModule vhost_alias_module modules/mod_vhost_alias.so</br>
        开启网页重写模块    </br>
        LoadModule rewrite_module modules/mod_rewrite.so      
        加载模块    
        Include conf/extra/httpd-vhosts.conf

    (2）vim /usr/local/apache2/conf/extra/httpd-vhosts.conf 
        <VirtualHost *:80>
         DocumentRoot "/usr/local/apache2/htdocs/abc"
         ServerName www.abc.com
        </VirtualHost>
        <Directory "/usr/local/apache2/htdocs/abc">
         options indexes followsymlinks
         allowoverride All
         require all granted
        </Directory>
        <VirtualHost *:80>
         DocumentRoot "/usr/local/apache2/htdocs/cde"
         ServerName www.cde.com
        </VirtualHost>

    （3）cd /htdocs/abc    vi .htaccess
         rewriteengine on
         rewritecond %{HTTP_HOST} www.abc.com
         rewriterule .* http://www.cde.com

b.	nginx地址跳转配置     

    vi  nginx.conf
    #gzip  on;
        server {
        listen 80;
        server_name www.abc.com;
        rewrite ^(.*)$ http://www.cde.com permanent;
     }

        server {
        listen       80;
        server_name  www.cde.com;
        location / {
            root   html/b;
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
     }
 

    sudo service nginx reload

