
## ngrok服务器搭建
添加DNS解析记录<br>
添加ngrok 和 *.ngrok这两条A记录，解析到我们的ngrokd服务器的外网IP

### 1 ngork服务端、客户端编译
#### 1.1 下载ngrok源码
```shell
# ngrok的源码是用go，写的，所以在搭建之前得安装go环境.
$ yum -y install golang


#下载源码
$ git clone https://github.com/inconshreveable/ngrok.git
```
#### 1.2 生成自签名证书
```shell
# 自建ngrokd服务时我们需要生成自己的证书，并且构建携带该证书的客户端
# 如果提供服务的地址为：ngrok.eyexpo.com.cn ,那么这里的 NGROK_BASE_DOMAIN 变量就应该是 ngrok.eyexpo.com.cn

$ cd ngrok
$ openssl genrsa -out rootCA.key 2048
$ openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=ngrok.eyexpo.com.cn" -days 5000 -out rootCA.pem
$ openssl genrsa -out device.key 2048
$ openssl req -new -key device.key -subj "/CN=ngrok.eyexpo.com.cn" -out device.csr
$ openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 5000

# ngrok通过bindata将ngrok源码目录下的assets目录（资源文件）打包到可执行文件(ngrokd和ngrok)中 去，assets/client/tls和assets/server/tls下分别存放着用于
# ngrok和ngrokd的默认证书文件，我们需要将它们替换成我们自己生成的：(因此这一步务必放在编译可执行文件之前)

$ cp rootCA.pem assets/client/tls/ngrokroot.crt
$ cp device.crt assets/server/tls/snakeoil.crt
$ cp device.key assets/server/tls/snakeoil.key
```
#### 1.3 编译ngrokd和ngrok
```shell
# 在ngrok目录命令下执行如下命令，编译ngrokd:
$ make release-server

# 编译ngrok客户端
$ make release-client    #linux平台客户端

$ GOOS=darwin GOARCH=amd64 make  release-client    #mac平台客户端

$ GOOS=windows make release-client    #windows平台客户端

```
### 2 服务端启动
#### 2.1 启动ngrokd
```shell
$ nohup ngrokd  -tlsKey=assets/server/tls/snakeoil.key -tlsCrt=assets/server/tls/snakeoil.crt -domain="ngrok.eyexpo.com.cn" -httpAddr=":8080"
 -httpsAddr=":8081" -tunnelAddr=":4443" &
 # -tlsKey : ssl证书的key
 # -tlsCrt : crt证书
 # -domain : 提供服务的域名
 # httpAddr : http服务暴露在外的端口
 # -tunnelAddr : ngrokd服务通道的端口，用于与客户端的交互
 ```
### 3 启动客户端
#### 3.1 将生成的ngrok客户端下载到自己的电脑上
#### 3.2 创建配置文件
```shell
$ vim ngrok.cfg
server_addr: "ngrok.eyexpo.com.cn:4443"
trust_host_root_certs: false
tunnels:
  ssh:                    #通道名
    remote_port: 35714    #映射到外网的端口
    proto:
      tcp: 22             #内网端口
  http:
    subdomain: "local"
    proto:
      http: "80"
```
#### 3.3 执行ngrok映射本地22端口和80端口
```shell
$ setsid ./ngrok -config=ngrok.cfg start ssh #setsid让程序在后台运行 ssh通道名 subdomain自定义的域名记录
$ setsid ./ngrok -config=ngrok.cfg start http

#除了上述写配置文件指定配置，我们还可以直接命令行直接指定配置
$ setsid ./ngrok -config=ngrok.cfg -proto=tcp 22
$ setsid ./ngrok -subdomain=local -config=ngrok.cfg -proto=http 80
```
#### 3.4 访问测试
```shell
$ ssh -p 35714 dev@local.ngrok.eyexpo.com.cn
Last login: Thu Jul 18 11:24:31 2019 from localhost
$

# 这里我们就成功从外网连接到我们的内网主机啦！
```
