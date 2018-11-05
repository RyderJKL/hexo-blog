---
title: NESSUS
date: 2016-06-27 16:16
tags: ['Kali渗透测试','漏洞扫描']
toc: true
categories: technology

---
### 0X00 前言
OPENVAS是免费开源的，所以对于用户的是使用体验便不会太尽如人意了。那么与此对应的便是收费版本的NESSUS了，当然NESSUS也有免费版的，而且就弱点扫描这一块来说，NESSUS的商业版和免费版的功能是一样的。

首先进入NESSUS官网下载kali.deb安装包:http://www.tenable.com/products/nessus/select-your-operating-system#tos

---
### 0x01 NESSUS的安装

安装完成以后得到如下界面:

```
- You can start Nessus by typing /etc/init.d/nessusd start
- Then go to https://jack:8834/ to configure your scanner
```

首先启动NESSS:

```
➜  /etc/init.d/nessusd start
Starting Nessus : .
➜ /etc/init.d/nessusd status
Nessus is running
```

然后打开nessus的本地网站:https://jack:8834/,
填写账号和密码，然后会提示你输入激活码，这时可以进入这个网站:http://tenable.com/products/nessus-home 去获得激活码。

最后得到激活码，开始安装nessus，此过程会比较漫长。。。。

NESSUS的安装目录是在:/opt/nessus/下的。

---
### 0x02 NESSUS的使用

等待NESSUS安装完成以后通过访问本地web页面登录nessus:http://127.0.0.01/8834

---
#### Scanner Templates 扫描模板
nessus已经集成了一些扫描模板，UPGRADE是仅仅对于商业版才能使用的。

---
#### Aavanced Scan 高级扫描
进入Adacande Scan制定一个扫描策略。


---
#### Basic Network Scan
这是一个主机扫描，可以任何操作系统的主机进行扫描。


---
### Bash Shellshocks Detection 
检查破壳应用的一个扫描，破壳是一个linux系统上的漏洞，由于系统环境变量造成的。

---
### GHOST Detection 幽灵病毒
关于black c最底层的一个漏洞

---
#### Web Application Tests
网页应用层扫描，NESSUS针对网页应用层的扫描是十分有限的。

---
#### Windows 
针对windows恶意程序扫描。


