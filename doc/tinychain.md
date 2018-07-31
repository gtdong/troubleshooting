# tinychain

## environment 

### 1.docker
### 卸载旧版本

    $ sudo yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine
                  
### 安装使用依赖

    $ sudo yum install -y yum-utils 
      device-mapper-persistent-data 
      lvm2
    $ sudo yum-config-manager \
    --add-repo \
    https://github.com/jamesob/tinychain.git
    $ sudo yum-config-manager --enable docker-ce-edge
    
### 安装docker-ce

    $ sudo yum install docker-ce

### 开始安装docker

    $ dockerd &

### 通过运行hello-world镜像确认docker成功安装

    $ docker run hello-world

### 2.python3.6


### 安装python3.6可能使用的依赖

    $ yum -y install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel`
    $ tar -xzvf Python-3.6.1.tgz `
    $ cd  Python-3.6.1/`

### 把Python3.6安装到 /usr/local 目录

    $ ./configure  --prefix=/usr/local/`
    $ make
    $ make altinstall`

python3.6程序的执行文件：/usr/local/bin/python3.6

python3.6应用程序目录：/usr/local/lib/python3.6

pip3的执行文件：/usr/local/bin/pip3.6

pyenv3的执行文件：/usr/local/bin/pyenv-3.6

--------------------------------------------------------------

### 更改/usr/bin/python链接

    $ cd/usr/bin
    $ mv  python python.backup
    $ ln -s /usr/local/bin/python3.6 /usr/bin/python
    $ ln -s /usr/local/bin/python3.6 /usr/bin/python3
    $ rm -rf /usr/bin/python2
    $ ln -s /usr/bin/python2.6 /usr/bin/python2

### 更改yum脚本的python依赖

    $ cd /usr/bin
    $ ls yum*
      yum yum-config-manager yum-debug-restore yum-groups-manager
      yum-builddep yum-debug-dump yumdownloader
### 更改以上文件头为

    #!/usr/bin/python 改为 #!/usr/bin/python2


## building tinychain
### 克隆这个repo:
    $ git clone https://github.com/jamesob/tinychain.git

### 获取本地python依赖关系:

    $ pip install -r requirements.txt 

### 运行`docker-compose up`。这会产生两个tinychain节点。

    node2_1  | [2018-01-29 05:12:46,577][tinychain:371] INFO block accepted height=463 txns=1
    node2_1  | [2018-01-29 05:12:46,593][tinychain:351] INFO connecting block 000000141d5c4cecf9f01cb08ec663c252e395dd093586fc8dd66e67d7a1c440 to chain 0
    node2_1  | [2018-01-29 05:12:46,594][tinychain:518] INFO adding tx outpoint OutPoint(txid='888abf119c7ce3c1fafbc25168390be9aa98c62a6020325496dceeafafa02e45', txout_idx=0) to utxo_set
    node2_1  | [2018-01-29 05:12:46,595][tinychain:371] INFO block accepted height=464 txns=1
    node1_1  | [2018-01-29 03:45:21,840][tinychain:351] INFO connecting block 0000002475c81ffe8fccf5d006f37e91c86c488af4998710973f94aa9e18b806 to chain 0
    node1_1  | [2018-01-29 03:45:21,841][tinychain:518] INFO adding tx outpoint OutPoint(txid='fff67d165869e1ff1a1eb0a10c828442f1d42cbca476693c634f6e40ef98db4d', txout_idx=0) to utxo_set
    node1_1  | [2018-01-29 03:45:21,841][tinychain:371] INFO block accepted height=56 txns=1
    node1_1  | [2018-01-29 03:45:21,843][tinychain:351] INFO connecting block 000000e582d9c1a371d504ecd83ce669480d9ab7b2afba073f8c878c42ad205a to chain 0
    node1_1  | [2018-01-29 03:45:21,843][tinychain:518] INFO adding tx outpoint OutPoint(txid='0730c9475bf8172dc8bb44c2f8c0c8acbdebebf07e542195371fc17a40d166e6', txout_idx=0) to utxo_set

### 在另一个窗口中运行`./bin/sync_wallets`,这将来自Docker容器的钱包数据导入您的主机。

    $ ./bin/sync_wallets
    Synced node1's wallet:
    [2017-08-05 12:59:34,423][tinychain:1075] INFO your address is 1898KEjkziq9uRCzaVUUoBwzhURt4nrbP8
    0.0 ⛼ 

    Synced node2's wallet:
    [2017-08-05 12:59:35,876][tinychain:1075] INFO your address is 15YxFVo4EuqvDJH8ey2bY352MVRVpH1yFD
    0.0 ⛼

### 运行`./client.py balance -w wallet1.dat;`尝试运行另一个钱包

    $ ./client.py balance -w wallet2.dat
    [2017-08-05 13:00:37,317][tinychain:1075] INFO your address is 15YxFVo4EuqvDJH8ey2bY352MVRVpH1yFD
    0.0 ⛼

### 尝试在钱包之间进行转账
    $ ./client.py send -w wallet2.dat 1898KEjkziq9uRCzaVUUoBwzhURt4nrbP8 1337
    [2017-08-05 13:08:08,251][tinychain:1077] INFO your address is 1Q2fBbg8XnnPiv1UHe44f2x9vf54YKXh7C
    [2017-08-05 13:08:08,361][client:105] INFO built txn Transaction(...)
    [2017-08-05 13:08:08,362][client:106] INFO broadcasting txn 2aa89204456207384851a4bbf8bde155eca7fcf30b833495d5b0541f84931919`
### 查看交易状态
    $ ./client.py status e8f63eeeca32f9df28a3a62a366f63e8595cf70efb94710d43626ff4c0918a8a
    [2017-08-05 13:09:21,489][tinychain:1077] INFO your address is 1898KEjkziq9uRCzaVUUoBwzhURt4nrbP8
    Mined in 0000000726752f82af3d0f271fd61337035256051a9a1e5881e82d93d8e42d66 at height 5

