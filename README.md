# node多版本管理
 nvm 使用攻略
安装：
`curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash`

使用
使用nvm ls-remote看一下node有哪些版本可以安装
安装多版本

→ nvm install v4.5.0 Downloading https://nodejs.org/dist/v4.5.0/node-v4.5.0-darwin-x64.tar.gz..######################## 100.0%


nvm 轻松切换 node 版本
nvm会将各个版本的node安装在~/.nvm/versions/node目录下
→ nvm ls
         v4.5.0
->       v5.9.0
         system
node -> stable (-> v5.9.0) (default)
stable -> 5.9 (-> v5.9.0) (default)
iojs -> N/A (default)

箭头（➡️）选择当前版本
使用nvm use切换版本
→ nvm use v4.5.0
Now using node v4.5.0 (npm v2.15.9)
→ node -v
v4.5.0


查看当前 node 版本
nvm current

注意
新打开一个bash，输入nvm current会发现显示为
→ nvm current
system

使用nvm alias default <version>命令来指定一个默认的node版本
       nvm alias default v8.9.4
