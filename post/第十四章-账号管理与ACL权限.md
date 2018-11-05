---
title: 第十四章-账号管理与ACl权限
date: 2016-04-25 20:22:52
tags: ['鸟哥的Linux读书笔记基础篇']
toc: true
categories: technology

---
### 0x00 账号与群组

----
#### 使用者标志符:UID，GID

在第六章我们提到过，每个文件都具有__使用者与群组__的属性，因为每个登录者都会有两个ID,一个是使用者ID(User ID,UID)，一个是群组ID(Group ID,检查GID)，而每个文件都会有所谓的UID与GID，当我们有要显示文件属性需求时，系统会根据/etc/passwd,/etc/group的内容，找到UID/GID对应的账号与组名在显示出来。

---
#### 使用者账号:/etc/passwd，/etc/shadow文件结构

简单的讲/etc/passwd主要记录与UID/GID有关的参数，而/etc/shadow则是就来登录密码的

##### /etc/passwd文件

 该文件结构如下:
```
root@jack:~# head -n 4 /etc/passwd
root:x:0:0:root:/root:/bin/bash
账号名称/早期口令/UID/GID/用户信息说明兰/家目录/Shell
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
```
该文件使用":"隔开，共分为7段，说明如下:
 * x:早期unix口令存放段，由于安全性，现已弃用
 * UID:UID是0是代表该账号是系统超级用户，所以只要将某个使用者的UID改为0，那么他便成为超级用户，但，最好别这样玩。
 * GID:与/etc/group有关，其实/etc/group与/etc/passwd差不多
 * 用户信息栏:无多大意义
 * 家目录:默认用户的家目录是在/home/yourIDname
 * Shell:当用户登陆系统后就会取得一个 Shell 来与系统的核心沟通以进行用户的操作任务


##### /etc/shadow文件

 该文件结构如下:
```
root@jack:~# head -n 2 /etc/shadow
root:$6$OxMBc0:16885:0:99999:7:::
daemon:*:16658:0:99999:7:::
```
同样的该文件使用":"隔开，共分为9段，说明如下:
 * 账号名称：与/etc/passwd对应
 * 密码:经过MD5加密
 * 最近更改密码日期:why?16885,这个是因为计算 Linux 日期的时间是以 1970 年 1 月 1 日作为 1 而累加的日期，1971 年 1 月 1 日则为 366 .
 至于想要知道某个日期的累积日数:
```
root@jack:~# echo $(($(date --date="2016/04/25" +%s)/86400+1))
16916
```

 * 密码不可更改天数:0代表随时可改
 * 密码需重新更改天数:为了强制要求用户变更口令，这个字段可以指定在最近一次更改口令后， 在多少天数内需要再次的变更口令才行。
 * 密码需更改期限前的警告天数
 * 密码过期后的宽限时间（密码失效日）
 * 账号失效日期: 这个账号在此字段规定的日期之后，将无法再使用。	就是所谓的『账号失效』，此时不论你的口令是否有过期，这个『账号』都不能再被使用！	这个字段会被使用通常应该是在『收费服务』的系统中，你可以规定一个日期让该账号不能再使用啦！
 * 保留

 ---
#### 关于群组:/etc/group文件结构

该文件结构如下:
```
root@jack:~# head -4 /etc/group
root:x:0:
组名/群组口令/GID/该群组支持的账号名称
daemon:x:1:
bin:x:2:
sys:x:3:
```
pass

---
### 0x01 账号管理

---
#### 增加与删除使用者

##### useradd

 __{ usage $: useradd -[u UID] [-g 初始群组] [-mM] [-d 家目录绝对路径] 账号名 }__
  
 新添加一个用户:jack
```
root@jack:~# useradd -g root -d /home jack
```

##### passwd 口令更改

 __{ usage $ : passwd 账号名 } <=root功能__

 __{ usage $ : passwd [--stdin] } <==所有人均可更改自己口令__

 在root下更改jack口令:
 ```
vroot@jack:~# passwd jack
输入新的 UNIX 密码：
重新输入新的 UNIX 密码：
 ```
使用stdin更改口令
```
root@jack:~# echo "234" | passwd --stdin jack
``
当然这个不是所有的linux发行版都支持的，比如kali就不支持了

##### userdel 用户删除

 __ { usage $ : userdel [-r] username }__
删除jack，连同家目录也删除，并删除所有jack
```
root@jack:~# userdel -r jack
```
其实用户如果在系统上面操作过一阵子了，那么该用户其实在系统内可能会含有其他文件的，如果想要完整的将某个账号完整的移除，最好可以在下达 userdel -r username 之前， 先以『 find / -user username 』查出整个系统内属于 username 的文件，然后再加以删除吧！

---
#### 用户功能

下面了解下一般使用者常用的系统命令
* __finger__:用来查询用户相关信息，大多是/etc/passwd里面信息
* __chfn__:可理解为chang finger，意义不大
* __chsh__:change shell的缩写，即是更改该用户使用的shell
* __id__:查询自己相关的uid/gid信息，__{id 账号名称}__可用来判断某账号存在不存在

---
#### 新增与删除群组

##### groupadd:增加群组
 
 __{ usage $ : groupadd [-g gid] [-r] 组名 }__

##### groupdel:删除群组

 __{ usage $ : groupdel 组名 }__
但是删除群组时要确认 /etc/passwd 内的账号没有任何人使用该群组作为initial group 才能删除

---
### 0x02 主机的细部权限规划

----
#### 什么是ACL？

ACL是针对单一使用者，对单一文件或目录来进行rwx的权限规范，对于需要特殊权限的使用状况非常有帮助！

它可以针对使用者，群组，或者在该目录下创建新文件/目录时，配置默认权限。

##### setfacl:配置某个文件/目录的ACL

  __{ usage $: setfacl [-bkRd] [{-m|-x} acl参数] filename }__

 __选项与参数:__
 * -m ：配置后续的 acl 参数给文件使用，不可与 -x 合用；
 * -x ：删除后续的 acl 参数，不可与 -m 合用；
 * -b ：移除所有的 ACL 配置参数；
 * -k ：移除默认的 ACL 参数，关于所谓的『默认』参数于后续范例中介绍；
 * -R ：递归配置 acl ，亦即包括次目录都会被配置起来；
 * -d ：配置『默认 acl 参数』的意思！只对目录有效，在该目录新建的数据会引用此默认值

 赋予jack用户test文件的rw权限
```
root@jack:~# setfacl -m u:jack:rw test
```

##### getfacl:查看某个文件/目录的ACL配置

 ```
root@jack:~# getfacl test 
# file: test
# owner: root
# group: root
user::rw-
user:jack:rw-  <===新增加的acl权限
group::r--
mask::rw-
other::r--
```
再次查看test文件，发现多了一" + "的权限，就是acl了:
```
root@jack:~# ll test 
-rw-rw-r--+ 1 root root 0 4月  26 15:37 test
```
如果想要取消文件的全部acl权限，使用__{ $ : setfacl -b filename }__就ok了！

----
### 0x03 使用者切换

----
#### su

su用户身份切换，可以直接切换到root，或由root切换到一般用户

----
#### sudo 

sudo运行root的命令串，但并非所有人都能够运行 sudo ，而是仅有规范到 /etc/sudoers 内的用户才能够运行 sudo 这个命令。

---
### 0x04 使用者的特殊shell与PAM模块

PAM 可以说是一套应用程序编程接口 (Application Programming Interface, API)，他提供了一连串的验证机制，只要使用者将验证阶段的需求告知 PAM 后， PAM 就能够回报使用者验证的结果 (成功或失败)。

---
### 0x05 用户的信息传递
我们知道查询一个用户的相关信息可以使用id和finger命令，查询最近的登录信息可以使用last，现在我们来了解的多一点。

---
#### w或者who
  想要知道目前已登录在系统上的用户，可以使用w和who
```
root@jack:~# w
 16:30:11 up  2:32,  4 users,  load average: 0.26, 0.23, 0.16
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     :0       :0               13:58   ?xdm?  11:31   0.09s gdm-session-worker [pam/gdm-password]
root     pts/0    :0               14:12    0.00s  0.57s  0.00s w
root     pts/1    :0               16:29   23.00s  0.05s  0.00s sh
#第一行显示目前时间，启动多久，几个用户，平均负载
#第二行为各个项目的说明
root@jack:~# who
root     :0           2016-04-26 13:58 (:0)
root     pts/0        2016-04-26 14:12 (:0)
```
要知道每个账号的最近登陆的时间，则可以使用 lastlog 这个命令
```
root@jack:~# lastlog
用户名           端口     来自             最后登陆时间
root                                       **从未登录过**
daemon                                     **从未登录过**
```

---
#### write,wall,mesg

 用于linux用户间的通信
```
root@jack:~# write jack pts/2 "i am fine ,thank for you "
```
wall用于广播信息，mesg用于是否接受信息__{ mesg n }:表示不接受信息__


