---
title: Httrack，vega
date: 2016-06-30 21:35
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### 0x00 DVWA
**DVWA (Dam Vulnerable Web Application)DVWA**是用PHP+Mysql编写的一套用于常规WEB漏洞教学和检测的WEB脆弱性测试程序。包含了SQL注入、XSS、盲注等常见的一些安全漏洞。


![DVWA.png](http://upload-images.jianshu.io/upload_images/1571420-b101a308968f12a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

可以设置不同难度的演练模式，low，medium，hight，low模式下的漏洞较多并且容易发现。

更详细的操作以后再说。

---
### 0x01 Httrack
HTTrack Website Copier是一个免费并易于使用的线下浏览器工具,它能够让你从互联网上下载整个网站进行线下浏览。浏览线下站点和线上并没有什么不同。HTTrack同样可以进行线下线上站点同步,支持断点续传。

使用Httrack可以讲一个网站拷贝下来，以此进行下线的探测发现，以此减少对目标网站的直接交互。

Httrack的使用很简单，只需要根据其向导按步骤进行就好了。

```
root@kali:~# httrack

Welcome to HTTrack Website Copier (Offline Browser) 3.48-21
Copyright (C) 1998-2015 Xavier Roche and other contributors
To see the option list, enter a blank line or try httrack --help

Enter project name :Dvwa
#工程名称
Base path (return=/root/websites/) :/root/httrackWeb
#这是一个大的目录，所有httrackcopy网将会根据域名或者ip
分为不同的小路劲
Enter URLs (separated by commas or blank spaces) :http:192.168.86.130/dvwa/
#要copy的网站地址
Action:
(enter)	1	Mirror Web Site(s)#直接镜像
	2	Mirror Web Site(s) with Wizard#在向导指示下进行镜像
	3	Just Get Files Indicated#获得特定文件的格式文件比如doc，pdf
	4	Mirror ALL links in URLs (Multiple Mirror)#惊醒当前url下的所有连接
	5	Test Links In URLs (Bookmark Test)#测试连接
	0	Quit

:2

Proxy (return=none) :
#代理地址
You can define wildcards, like: -*.gif +www.*.com/*.zip -*img_*.zip
Wildcards (return=none) :

You can define additional options, such as recurse level (-r<number>), separed by blank spaces
To see the option list, type help
Additional options (return=none) :

---> Wizard command line: httrack http:192.168.86.130/dvwa/ -W -O "/root/httrackWeb/Dvwa"  -%v  

Ready to launch the mirror? (Y/n) :y

WARNING! You are running this program as root!
It might be a good idea to run as a different user
Mirror launched on Sun, 31 Jul 2016 05:12:03 by HTTrack Website Copier/3.48-21 [XR&CO'2014]
mirroring http:192.168.86.130/dvwa/ with the wizard help..
Done.
Thanks for using HTTrack!
* 
```
同时httrack也支持代理模式，可以到**hidemyass**免费获得代理链。


