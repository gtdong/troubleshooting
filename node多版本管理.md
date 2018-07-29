# node多版本管理
## nvm安装   
nvm是node的多版本管理器，所以在我们安装node之前我们要先安装nvm：

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh | bash
    
## nvm使用
1.**查看当前可以使用的所有node版本**
 
    nvm ls-remote
    
2.**安装指定版本**

    nvm install <version>
    eg:
       -> nvm install v8.9.4
       
3.**切换node版本**
 
    nvm use <version>
    eg:
       -> nvm use v8.9.4
       v8.9.4
       
4.**查看当前安装的所有版本**

    nvm ls
             v8.9.4
    ->       v6.12.3
             system
    node -> stable (-> v6.12.3) (default)
    stable -> 6.12 (-> v6.12.3) (default)
    iojs -> N/A (default)

箭头指的是当前使用的版本

5.**查看当前 node 版本**

    nvm current

6.**指定默认node版本**

    nvm alias default <version>
    eg:
       nvm alias default v8.9.4
**注意:这一步非常重要，如果你想在下一次打开终端时还使用这个版本，你就要使用`nvm alias default <version`指定一个默认版本**
