## ssr科学上网搭建

### Requirements
* 一台国外的服务器,任意品牌即可。
这里我是用的是[BandwagonHost](https://bandwagonhost.com/),一款性价比比较高的vps服务器，大家可以试一试。

### Setup

配置过程很简单，采用一键安装脚本配置，具体配置跟着指示一步一步来即可：</br>

1.进入安装脚本后输入数字 1 开始安装</br>
2.然后配置端口、加密、方式，这些可以默认回车，也可以按自己的需要配置。这三个选项配好就可以使用啦，其他的选项根据自己的需求配置即可，或者默认就行。</br>
3.配置完成，你的帐号信息就会显示到屏幕上</br>
4.最后一步选择一款客户端输入你的帐号相关信息就可以啦</br>
    
    $ yum -y install wget

    $ wget -N --no-check-certificate https://softs.fun/Bash/ssr.sh && chmod +x ssr.sh && bash ssr.sh

    ShadowsocksR 一键管理脚本 [v2.0.37]
    ---- Toyo | doub.io/ss-jc42 ----

    1. 安装 ShadowsocksR
    2. 更新 ShadowsocksR
    3. 卸载 ShadowsocksR
    4. 安装 libsodium(chacha20)
    ————————————
    5. 查看 账号信息
    6. 显示 连接信息
    7. 设置 用户配置
    8. 手动 修改配置
    9. 切换 端口模式
    ————————————
    10. 启动 ShadowsocksR
    11. 停止 ShadowsocksR
    12. 重启 ShadowsocksR
    13. 查看 ShadowsocksR 日志
    ————————————
    14. 其他功能
    15. 升级脚本
 
    当前状态: 未安装

    请输入数字 [1-15]：1
    [信息] 开始设置 ShadowsocksR账号配置...
    请输入要设置的ShadowsocksR账号 端口
    (默认: 2333):33333

     ——————————————————————————————
	   端口 : 33333
     ——————————————————————————————

     请输入要设置的ShadowsocksR账号 密码
     (默认: doub.io):

     ——————————————————————————————
    	密码 : doub.io
     ——————————————————————————————

     请选择要设置的ShadowsocksR账号 加密方式
     1. none
     [注意] 如果使用 auth_chain_a 协议，请加密方式选择 none，混淆随意(建议 plain)
 
     2. rc4
     3. rc4-md5
     4. rc4-md5-6
 
     5. aes-128-ctr
     6. aes-192-ctr
     7. aes-256-ctr
     8. aes-128-cfb
     9. aes-192-cfb
     10. aes-256-cfb
 
     11. aes-128-cfb8
     12. aes-192-cfb8
     13. aes-256-cfb8
 
     14. salsa20
     15. chacha20
     16. chacha20-ietf
    [注意] salsa20/chacha20-*系列加密方式，需要额外安装依赖 libsodium ，否则会无法启动ShadowsocksR !

    (默认: 5. aes-128-ctr):10

    ——————————————————————————————
	  加密 : aes-256-cfb
    ——————————————————————————————

    请选择要设置的ShadowsocksR账号 协议插件
    1. origin
    2. auth_sha1_v4
    3. auth_aes128_md5
    4. auth_aes128_sha1
    5. auth_chain_a
    6. auth_chain_b
    [注意] 如果使用 auth_chain_a 协议，请加密方式选择 none，混淆随意(建议 plain)

    (默认: 2. auth_sha1_v4):

    ——————————————————————————————
  	协议 : auth_sha1_v4
    ——————————————————————————————

    是否设置 协议插件兼容原版(_compatible)？[Y/n]

    请选择要设置的ShadowsocksR账号 混淆插件
    1. plain
    2. http_simple
    3. http_post
    4. random_head
    5. tls1.2_ticket_auth
    [注意] 如果使用 ShadowsocksR 加速游戏，请选择 混淆兼容原版或 plain 混淆，然后客户端选择 plain，否则会增加延迟 !

    (默认: 5. tls1.2_ticket_auth):

     ——————————————————————————————
	  混淆 : tls1.2_ticket_auth
    ——————————————————————————————

    是否设置 混淆插件兼容原版(_compatible)？[Y/n]

    请输入要设置的ShadowsocksR账号 欲限制的设备数 ( auth_* 系列协议 不兼容原版才有效 )
    [注意] 设备数限制：每个端口同一时间能链接的客户端数量(多端口模式，每个端口都是独立计算)，建议最少 2个。
    (默认: 无限):

    请输入要设置的每个端口 单线程 限速上限(单位：KB/S)
    [注意] 单线程限速：每个端口 单线程的限速上限，多线程即无效。
    (默认: 无限):


    请输入要设置的每个端口 总速度 限速上限(单位：KB/S)
    [注意] 端口总限速：每个端口 总速度 限速上限，单个端口整体限速。
    (默认: 无限):


    
    
    
     
