---
title: Kali实验环境的搭建
date: 2016-02-23 21:24
tags: ['Kali渗透测试','Kali安装与环境优化']
toc: true
categories: technology

---
### 0x00 搭建本地实验环境的必要性
* 渗透非授权系统的弊端，从法律和学习的角度是必须的。
* 搭建自己的实验环境，自己的环境自己爱怎么搞怎么搞，搭建实验环境过程可以更加了解系统的安装配置和特性，以及基础架构的安装配置，代码构建，作为一个安全工作者是十分有必要的。

---
### 0x01 安装windows虚拟机作为渗透对象

* 微软最新版本软件官方下载:http://msdn.microsoft.com/en-ca/subscriptions/aa336856
* windows虚拟机:http://dev.modern.ie/tools/vms/

---
### 0x01 安装Linux虚拟机作为渗透对象:

Turnkey Linux 是一个基于 Ubuntu 8.04 LTS 的Linux 发行版 ,基于linux的虚拟机。
* tuenkey的官方下载地址:http://tuenkeylinux.org

 ---
### 0x02 Linux ubuntu 下LAMP环境

Linux+appache+mysql+php环境的搭建

---
#### 安装apache2

 ```
 $ sudo apt-get install apache2 apache2-utils
 ```

安装完成以后查看80端口是否已经开始真侦听:
```
$ netstat -anol |grep :80
```

apache2是否已经启动了:
```
$ ps aux | grep apache
```

重启apache:
```
$ sudo service apahce2 restart
```

apache重启常见错误:“fully qualified domain”

解决方法:新建fadn.conf文件并添加代码:~ServerNname  locahost~

```
$ sudo vi /etc/apache2/conf-avaliable/fqdn.conf

ServerName localhost
```
:wq! 保存退出！

启用文件:
```
$ sudo a2enconf fqdn
```

---
#### 安装Mysql

```
$ sudo apt-get install mysql-server libapache2- mod-auth-mysql php5-mysql
$ mysql_install_db  '建立数据库目录'
$ mysql_secure_installation  '对数据库进行安全设置'
$ mysql:mysql -u root  -p  '进入Mysql'
```

---
#### 安装php

```
$ sudo apt-get install php5 php5-mysql php-pear php5-mcrypt php5-curl
```

---
### 0x03 Metasploitable2

基于linux的一个靶机测试环境
Metasploitable2虚拟系统是一个特别制作的ubuntu操作系统，本身设计作为安全工具测试和演示常见漏洞攻击。版本2已经可以下载，并且比上一个版本包含更多可利用的安全漏洞。这个版本的虚拟系统兼容VMware，VirtualBox,和其他虚拟平台。默认只开启一个网络适配器并且开启NAT和Host-only，本镜像一定不要暴漏在一个易受攻击的网络中。

  _默认登录名:msfadmin 密码:msfadmin_

通过ifconifg查看默认IP地址，Metasploit的默认端口是192.168.1.107，首次使用默认的metasploitable需要进行一项配置，否则会造成所有测试失败:
     > cd 进入文件 /var/www/mutillidae ，vi config.inc 文件将 $dbname一项改为“owasp10”

---
### 0x03 在虚拟机中模拟真实网络:

M0n0wall防火墙:

> http://m0n0.ch/wall/downloads.php

---
#### 首先建立防火墙

需要至少为虚拟机添加三卡网卡，即是在vm中添加三块虚拟网卡，host-only的网卡接内网(LAN)对应VMnet8(le2)，第二块网卡桥接到物理网络（WAN）对应VMnet0(le0)，第三块网卡服负者连接到DMZ区对应VMnet0(le1)，如图所示:
  ![网卡配置图示](http://upload-images.jianshu.io/upload_images/1571420-8e66a4248a20eae9.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 * 得到M0m0wall的光盘安装包，为vm新建虚拟机，将M0mwall光盘安装包添加到虚拟机以安装防火墙：

   ![添加镜像.png](http://upload-images.jianshu.io/upload_images/1571420-6cd718aa8a859eb8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

  * 第三步:安装完成以后会进入DOS界面 输入数字"7" 选择 install on hard drive 将防火墙从光盘安装到虚拟机的物理硬盘里，选择7以后添加"ad0",待重启过程立刻停止客户机然后关机，移除cd硬盘！

 * 第四步:输入数字"1" 配置网络

   ![开始界面.png](http://upload-images.jianshu.io/upload_images/1571420-43f4f19d718db0da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 防火墙至少需要三块网卡，外网，内网，DMZ，host-only的网卡接内网(LAN)le2，第一块网卡桥接到物理网络（WAN）le0，第二块网卡服负者连接到DMZ区，指定网口(interfaces:assign network port)哪个是接外的，哪个死接内的：为网卡添加tag标签，指定lan网卡le2和wan网卡le0以及Optional网卡le1:

    ![初始化防火墙.png](http://upload-images.jianshu.io/upload_images/1571420-3a6ddaab441dcb9d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

  * 第五步:输入数字"2":
为局域网lan网卡指定ip地址:192.168.14.1  sub mark:24  启动DHCP服务 设置dhcp网段的起始地址:192.168.14.20 结束地址:192.168.14.100 配置完成以后局域网网卡的ip地址为:http://192.168.14.1,当lan的ip地址配置完成以后就可以通过web页面对防火墙进行配置了

 * 第六步:reset webgui password 重设web登录密码 mono默认密码
 * 第七步:通过web页面对防火墙进行配置:登录名:damin 密码:mono
   ![配置防火墙-1.png](http://upload-images.jianshu.io/upload_images/1571420-964c3c697acf251b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

  * 最后点击Rules添加防火墙规则,设置protocol为“any”允许客户机支持所有的协议， source 为“LAN subnet”即是只有处于192.168.14.x下的ip网段才能上网了,然后选择OPT1为DWNZ区添加ip地址网段"192.168.56.10/24"
  ![配置防火墙-2.png](http://upload-images.jianshu.io/upload_images/1571420-958a1e69dcc13a5a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但是由于设置的是私有类ip，还需要进入WAN设置项里将默认的"block private networks"一项的钩钩去掉。自此linux虚拟环境下的网络防火墙经部署完成！

---
### 0x04 大型公司的防火墙
背靠背防火墙,即是双层防护墙:Pfsense，即是第一层使用momo防火墙，再建立一层pfsense防火请。

> https://pfsense.org/

**如此kali的渗透环境就算搭建完成了哦!**
