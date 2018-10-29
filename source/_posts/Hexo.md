---
title: hexo建站笔记
date: 2016-05-26 20:25:52
tags: ['hexo','博客']
toc: true
categories: technology

---

### 0x00 安装准备
---
#### 安装Node.js
安装Node最好的方式是使用nvm进行安装，首先从git上克隆nvm项目:
```
root@jack:~# git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
```
克隆完成使用,使用source命令，激活nvm:
```
root@jack:~# . ~/.nvm/nvm.sh
```
然后在～/.bashrc添加nvm全局变量:
```
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
```
ok,搞定，开始安装nvm:
```
root@jack:~# nvm install 5.0
Downloading https://nodejs.org/dist/v5.0.0/node-v5.0.0-linux-x64.tar.xz...
```
启动nvm
```
root@jack:~# nvm use 5.0
Now using node v5.0.0 (npm v3.3.6)
```

---
#### uninstal nvm

```
rm -rf ~/.nvm
rm -rf ~/.npm
rm -rf ~/.bower
```

#### 安装Git


当然，kali已经默认安装git了。
ubuntu安装git:sudo apt-get install git-core

----
### 0x01 安装Hexo

一切准备就绪，开始安装Hexo吧:
```
root@jack:~# mkdir MyBlog #新建一个MyBlog目录,作为博客的存放地
root@jack:~/MyBlog# npm install -g hexo-cli
```

等待Hexo安装完毕，然后依次使用以下命令对hexo进行初始配置
```
root@jack:~/MyBlog# hexo init hexo
INFO  Start blogging with Hexo!
```

----
### 0x02 建站配置

#### Hexo建站


Hexo安装完毕以后依次执行以下命令可以建立Hexo站了
```
root@jack:~/MyBlog# hexo init hexo  #执行命令时没有“<>”
#新建一个网站。如果没有设置 folder ，Hexo 默认在目前的文件夹建立网站，"hexo"文件夹即是我们的博客网站。
root@jack:~/MyBlog# cd hexo/
root@jack:~/MyBlog/hexo# npm install
#Hexo随后会自动在目标文件夹建立网站所需要的配置文件
root@jack:~/MyBlog/hexo# hexo generate
#生成静态文件
root@jack:~/MyBlog/hexo# hexo server
INFO  Start processing
INFO  Hexo is running at http://localhost:4000/. Press Ctrl+C to stop.
#启动hexo本地服务器访问网址为： http://localhost:4000/
```
----
#### 配置Hexo主题


以hexo下的huno主题为例:[https://github.com/onejustone/huno](https://github.com/onejustone/huno)

在当前目录中/root/MyBlog/hexo
{即已经部署了hexo基本配置文件的文件夹}
```
root@jack:~/MyBlog/hexo# git clone git://github.com/someus/huno.git themes/huno
```
然后更改更目录下_config.yml的theme属性为:huno即可更换主题
```
root@jack:~/MyBlog/hexo# vim _config.yml

# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: huno
```
用浏览器打开localhost:4000查看是否成功！

其它主题:
Maupassant一款极简的主题:
[https://github.com/tufu9441/maupassant-hexo/](https://github.com/tufu9441/maupassant-hexo/)

----
### 0x03 第一篇文章
执行下列命令来创建一篇新文章
```
$ hexo new [layout] <title>
```
我们可以在命令中指定文章的布局（layout），默认为 post，可以通过修改 config.yml 中的 default_layout 参数来指定默认布局。

----
### 0x04 部署Hexo
#### 配置和使用Github
Git安装完成后注册Github账号:[http://www.github.com/](http://www.github.com/)
github上创建onejustone.git.io仓库
以建立个人博客登录后系统，在github首页，点击页面右下角「New Repository」project name:onejustone.github.io
description:--保持自己的独立思维--
要在Pages上建立个人博客，Repository名字是特定的，即是必须是user_name.github.io的形式！点击【Creat Repository】完成创建，之后通过[http://onejustone.github.io](http://onejustone.github.io/) 去访问我们的博客页面!

通过SSH keys让本地git项目与远程的github建立联系:

首先我们需要检查你电脑上现有的ssh key:
```
$ cd ~/. ssh 检查本机的ssh密钥
# 如果提示：No such file or directory 说明你是第一次使用git。
```
生成新的SSH Key：
```
$ ssh-keygen -t rsa -C "邮件地址@youremail.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/your_user_directory/.ssh/id_rsa):<回车就好>

注意1: 此处的邮箱地址，你可以输入自己的邮箱地址；注意2: 此处的「-C」的是大写的「C」

然后系统会要你输入密码：

Enter passphrase (empty for no passphrase):<输入加密串>
Enter same passphrase again:<再次输入加密串>

在回车中会提示你输入一个密码，这个密码会在你提交项目时使用，如果为空的话提交项目时则不用输入。这个设置是防止别人往你的项目里提交内容。

注意：输入密码的时候没有*字样的，你直接输入就可以了。
```
最后看到这样的界面，就成功设置ssh key了：
```
root@jack:~# cd ~/.ssh
bash: cd: /root/.ssh: 没有那个文件或目录
root@jack:~#  ssh-keygen -t rsa -C "807527097@qq.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
4f:1c:9c:fa:91:53:8f:d2:16:9c:2b:6a:76:8a:3c:9b 807527097@qq.com
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|         . o .   |
|          + =    |
|         o = =   |
|        S O = .  |
|         = *     |
|        + +      |
|     ..= o       |
|      Eo.        |
+-----------------+
```
----
#### 配置SSH keys

生成SSH keys以后:

* 将id_rsa.pub里的字符复制下，准备添加到GitHub的SSH keys里。
* 登陆github系统。点击右上角的 Settings--->SSH  keys ---> New SSH key
* 把你本地生成的密钥复制到里面（key文本框中）， 点击 add key 就ok了

----
#### 测试SSH keys


可以输入下面的命令，看看设置是否成功，git@github.com的部分不要修改：
```
$ ssh -T git@github.com

如果是下面的反馈：
The authenticity of host 'github.com (207.97.227.239)' can't be established.
RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.Are you sure you want to continue connecting (yes/no)?
不要紧张，输入yes就好(此处会提示你输入刚才设置的密码)，然后会看到：
Hi onejustone! You've successfully authenticated, but GitHub does not provide shell access.
```

----
#### 设置用户信息


现在你已经可以通过SSH链接到GitHub了，还有一些个人信息需要完善的。

Git会根据用户的名字和邮箱来记录提交。GitHub也是用这些信息来做权限的处理，输入下面的代码进行个人信息的设置，把名称和邮箱替换成你自己的，名字必须是你的真名，而不是GitHub的昵称。
```
$ git config --global user.name "jack"//用户名
$ git config --global user.email  "onejustone@gmail.com"//写自己的邮箱
SSH Key配置成功
```
ok,本机已成功连接到github。

----
#### 将Hexo部署到Github

部署到github需要安装一个插件
```
root@jack:~/MyBlog/hexo#  npm install hexo-deployer-git --save
```

然后，进入MyBlog/hexo根目录下对_config.yml文件进行配置:
```
root@jack:~/MyBlog/hexo# vim _config.yml
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: git
  repository: git@github.com:onejustone/onejustone.github.io.git
  branch: master
```
博主这里使用的是SSH Keys如果你用了https Keys的话直接在github里复制https的就行了，总共就两种协议。

然后命令行进入MyBlog/hexo里:
```
$ hexo clean
$ hexo generate
$ hexo deploy
```
ok，我们的小窝棚已经基本搭建好了，现在可以访问你的个人github页面查看一把了我的是http://onejustone.github.io 对应的将onejustone改成你自己的github账户名就行了！

---
### 0x05 绑定域名


* GitHub Pages的设置:在onejustone.github.io Repository的根目录下面，新建一个名为CNAME的文本文件，里面写入你要绑定的域名，比如www.onejustone.xyz.
*  阿里万维网下注册域名:[http://wanwang.aliyun.com/domain](http://wanwang.aliyun.com/domain),然后登陆阿里云控制台，找到“云解析”，选择解析设置，点击新手设置，添加gitpages的IP地址: 192.30.252.153
* 通过浏览器，访问http://www.onejustone.xyz， 就打开了我们建好的博客站点。
* 为防止hexo部署后，CNAME会被自动删除，需要在source文件夹，创建CNAME(同时favicon.ico、images也可以在
source文件下创建).

---
### 0x06 关于windows下中文乱码问题

在编辑文件的时候将文本的保存格式设置为UTF8格式保存！



