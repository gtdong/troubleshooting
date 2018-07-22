# git多账户配置

## 问题描述
公司git账号：company         项目名称：CompanyApp

个人git账号：self            项目名称：SelfApp 

公司项目在push时正常，但是在个人项目push到远程时提示错误：

    zww:SelfApp mac$ git push -u origin master
    ERROR: Permission to self/SelfApp.git denied to company.
    fatal: Could not read from remote repository.
    
    Please make sure you have the correct access rights

或者个人项目push正常时，公司项目push出现

    zww:CompanyApp mac$ git push -u origin master
    ERROR: Permission to company/CompanyApp.git denied to self.
    fatal: Could not read from remote repository.

    Please make sure you have the correct access rights

因为github是使用SSH key的fingerprint来判定你是哪个账户，而不是通过用户名。这种情况下github无法判断使用哪个`.ssh/id_rsa.pub`所对应的账户进行登陆。

## 解决方法：

### 第一步：配置SSH-Key：

1.生成对应公司和个人git账号的rsa，rsa.pub文件

    ssh-keygen -t rsa -C "xxxxx@xxxxx.com"

#这里为了方便区分改变id_rsa文件名字：

    Enter file in which to save the key (/Users/mac/.ssh/id_rsa): /Users/mac/.ssh/company_id_rsa  

#两次回车即密码设置为空

    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again: 

    Your identification has been saved in /Users/mac/.ssh/company_id_rsa.
    Your public key has been saved in /Users/mac/.ssh/company_id_rsa.pub.


2.将上面ssh密钥生成步骤重复一次生成`self_id_rsa`密钥，最后得到四个文件：`company_id_rsa、company_id_rsa.pub和self_id_rsa、self_id_rsa.pub`

分别把`company_id_rsa.pub，self_id_rsa.pub`的内容粘贴到公司和个人git账号的ssh里面，用户名字随便起，可以相同

 

### 第二步：配置config文件：

1.配置config文件，如果不存在config文件直接在该目录创建并编辑

    vim ~/.ssh/config

配置规范如下：

    #Host host（Host简称，使用命令ssh host可连接远程服务器，如：ssh github）
    #User/Email 登录用户名(如：zlzsam/zlzsam@hotmail.com)
    #HostName 主机名用ip或域名，建议使用域名(如:github.com)  
    #Port 服务器open-ssh端口（默认：22,默认时一般不写此行
    #IdentityFile 证书文件路径（如~/.ssh/id_rsa_*)

具体例子：

    #company
    Host github.com
    HostName github.com
    User zww
    IdentityFile ~/.ssh/company_id_rsa

    #self
    Host self.github.com
    HostName github.com
    User zww
    IdentityFile ~/.ssh/self_id_rsa

注意：IdentityFile路径不要写错，IdentityFile文件位置是rsa私钥，不是.pub公钥 ；

这样的话，我们就可以通过使用github.com 别名 self.github.com来明确说你要是使用self_id_rsa的SSH key来连接github，即使用工作账号进行操作也可以判断。

 

### 第三步：给项目添加对应Host的远程仓库

1.回到自己要管理的项目目录下查看

    zww:SelfApp mac$ git remote -v
    origin git@github.com:self/SelfApp.git (fetch)
    origin git@github.com:self/SelfApp.git (push)

发现ssh-url 是github上显示的是 `git@github.com:self/SelfApp.git`，注意：git上这个链接不会因为你的config配置而对应改变的！

因为我们在config文件里设置了：

公司git账号Host为（默认）：github.com，

个人git账号Host设置为别名：self.github.com

所以这里个人项目不再使用git显示的默认链接（新建一个个人项目时也要记得修改 ssh-url链接，否则无法正常push）

修改ssh-url 为对应的`git@self.github.com:self/SelfApp.git：`

    zww:SelfApp Mac$

    git remote set-url  origin git@self.github.com:self/SelfApp.git

 

再次查看：

    zww:SelfApp mac$ git remote -v

    origin git@self.github.com:self/SelfApp.git (fetch)

    origin git@self.github.com:self/SelfApp.git (push)

证明已经替换成功

此时在自己项目目录下push就可以正常操作了

    zww:SelfApp mac$ git push

    Everything up-to-date

回到公司项目目录下测试push也成功

好的，大功告成！

[原文链接]（https://blog.csdn.net/wei371522/article/details/79163805）

