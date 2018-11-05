---
title: Linux缓冲区溢出
date: 2017-01-1 18:30
tags: ['Kali渗透测试']
toc: true
categories: technology

---
### 0x00 前言
其实无论是 Windows 还是 Linux ，当我们对目标进行渗透的时候针对的都是运行目标系统上的软件的，而不是 OS 本身的系统级别的漏洞，那太牛逼了，这事儿应该是 FBI 或者 NAS 玩儿的。

---
### 0x01 Linux 下的环境准备
* 目标软件: CrossFire（穿越火线）,一款在线多人 RPG 游戏，其 1.9.0 版本的服务端接受入站 socket 连接(客户端向服务器发起连接)时存在缓冲区溢出漏洞
* 调试工具： edb
* 运行平台: Kali i486(CPU 32位)(不是 64 位的Kali哦！)

我们选择 Kali i486 目标是，32 位 CPU 的最大寻址空间是 2^32 次方，而 64 位是 2^64 次方，差的不是一点点啊。

---
#### 安装 CrossFire
因为 CrossFire 是一个游戏软件，而在 Linux 系统中是所有游戏都有一个指定的存放目录 `/usr/games` 下:

```
root@kali:~/Desktop# mv crossfire.tar.gz /usr/games/
root@kali:~/Desktop# cd /usr/games/
root@kali:/usr/games# tar zxpf crossfire.tar.gz 
root@kali:/usr/games# cd crossfire/
root@kali:/usr/games/crossfire# ls
bin  etc  lib  man  share  var
root@kali:/usr/games/crossfire# cd bin/
root@kali:/usr/games/crossfire/bin# ./crossfire
// 执行 crossfire 文件，以运行软件
// 看到如下信息，代表运行成功
Waiting for connections...

root@kali:~# netstat -pantu
// 通过 netstat 命令，查看 corssfire 运行在哪个端口上
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:13327           0.0.0.0:*               LISTEN      2766/./crossfire  
```

我们主要针对该游戏服务器端的下的 `crossfire/bin/crossfire` 文件。

打开 Kali 中 `edb` 调试工具，在 `Appicaiton -> Reverse Engineering` 中。


![edb](http://upload-images.jianshu.io/upload_images/1571420-4ecd1d5e1d9df61c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以看到，其操作界面与 Windows 平台下的 `Debugger` 相差无几。

---
#### Linux 内核的保护机制
于 Windows 一样,Linux 也具有自己的内存保护机制，比如 DEP，ASLR，堆栈cookies，堆栈粉碎等等。

---
#### 配置防火墙设置仅本机访问
我们在自己的计算机上运行一个具有缓冲区漏洞的软件，而当我们暴露在网络中时，这样很有可能会导致我们自己被而已利用。 

下面，我们将对 Linux 自带的 Iptables 防火墙添加对应的规则，规定只要本机才可以访问 13327 端口:

```
root@kali:~# iptables -A INPUT -p tcp --destination-port 13327 \! -d 127.0.0.1 -j DROP
// 为 crossfire 增加规则
root@kali:~# iptables -A INPUT -p tcp --destination-port 4444 \! -d 127.0.0.1 -j DROP
// 4444 端口为后续的 shellcode 做准备
```

使用 `iptables -L` 查看防火墙配置是否生效：

```
root@kali:~# iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
DROP       tcp  --  anywhere            !localhost            tcp dpt:13327
DROP       tcp  --  anywhere            !localhost            tcp dpt:4444
```

---
### 0x02 开始调试






