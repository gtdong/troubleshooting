## Python安装

安装python3.6可能使用的依赖

    yum -y install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel
    tar -xzvf Python-3.6.1.tgz 
    cd  Python-3.6.1/

把Python3.6安装到 /usr/local 目录

    ./configure  --prefix=/usr/local/
    make
    make altinstall

python3.6程序的执行文件：/usr/local/bin/python3.6
python3.6应用程序目录：/usr/local/lib/python3.6
pip3的执行文件：/usr/local/bin/pip3.6
pyenv3的执行文件：/usr/local/bin/pyenv-3.6

--------------------------------------------------------------

更改/usr/bin/python链接

    cd/usr/bin
    mv  python python.backup
    ln -s /usr/local/bin/python3.6 /usr/bin/python
    ln -s /usr/local/bin/python3.6 /usr/bin/python3

    rm -rf /usr/bin/python2 
    ln -s /usr/bin/python2.6 /usr/bin/python2    *****

更改yum脚本的python依赖

    cd /usr/bin
    ls yum*
    yum yum-config-manager yum-debug-restore yum-groups-manager
    yum-builddep yum-debug-dump yumdownloader
    
更改以上文件头为

    #!/usr/bin/python 改为 #!/usr/bin/python2

-------------------------------------------------------------
常用的科学计算、数据挖掘机器学习等python第三方库主要有：Numpy、Scipy、Matplotlib、Pandas、StatsModels、Scikit-Learn、Keras、Gensim

    pip install 库名 
