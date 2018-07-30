##Byteball on Mac

Overview

1.Install NW.js v0.14.7 LTS  
2.Install Node.js v5.12.0

###1.Install NW.js v0.14.7 LTS
      nw install 0.14.7
      nw ls  查看是否安装成功
      
###2. Node.js v5.12.0
      这里的安装方法有两种，一种是下载二进制包，一种是编译安装
      wget https://nodejs.org/download/release/v5.12.0/node-v5.12.0.pkg
      ------------------------------
      wget https://nodejs.org/download/release/v5.12.0/node-v5.12.0.tar.gz
      tar -xvf node-v5.12.0.tar.gz
      cd node-v5.12.0
      ./configure
      make
      make install
      node -v 查看是否安装成功
      
###3. Install byteball
   Clone the source:
   
    git clone https://github.com/byteball/byteball.git
    cd byteball
   If you are building for testnet, switch to testnet branch:

    git checkout testnet   切换到测试网络分支

   Install bower and grunt if you haven't already:

    npm install -g bower
    npm install -g grunt-cli
Build Byteball:

    bower install
    npm install
    grunt
  After first run, you'll likely encounter runtime error complaining about node_sqlite3.node not being found, copy the file from the neighboring directory to where the program tries to find it, and run again. (e.g. from byteball/node_modules/sqlite3/lib/binding/node-v47-darwin-x64 to byteball/node_modules/sqlite3/lib/binding/node-webkit-v0.14.7-darwin-x64)
  
    mv node_modules/sqlite3/lib/binding/node-v0.14.7-darwin-x64/ node_modules/sqlite3/lib/binding/node-webkit-v0.14.7-darwin-x64/
    nw .
 After second run,if you see like this:
 
Your profile can not be used because it is from a newer version of NW.js. Some features unavailable. Please specify a different profile directory or use a newer version of NW.js.

   you should run 
   
    rm -rf /Users/xxx/Library/Application Support/byteball    删除安装时产生的一些缓存文件
   Then run Byteball desktop client:
   
    nw .
    
    