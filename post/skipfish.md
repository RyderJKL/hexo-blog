---
title: skipfish
date: 2016-09-06 15:23
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### 0x00 skipfish前言
skipfish是由谷歌开发，使用c语言编写的实验性的主动web安全评估工具，他可以递归爬网，并进行基于字典的探测。优点是扫描速度快，因为是多路单线程，全异步网路I/O，消除内存管理和调度开销，并且支持启发式自动内容识别，有利于发现wep code中的bug。

---
### 0x01 skipfish
首先skipfish是基于命令行的。

##### skipfish -o test host
将扫描结果保存到test目录下

```
root@kali:~# skipfish -o test1 http://192.168.234.129/dvwa
```

等待skipfish扫描完成，然后在test1目录下使用浏览器打开index.html页面，查看扫描结果。

但是观察报告页面，可以看到，skipfish不仅扫描了http://192.168.234.129/dvwa这个url，还扫描了http://192.168.234.129下的其它站点，这显然不是我想要的结果。



#### skipfish -o test @url.txt

使用@调用url.txt文件，并且从中批量提取要扫描的url地址进行扫描:

```
root@kali:~# skipfish -o test @url.txt -I 
```

#### skipfish -0 test -S world.wl url
通过指定skipfish中的自带字典，去探测扫描可能隐藏的网站目录和隐藏页面。

默认情况，skipfish已经集成了多个字典在kali中:

```
root@kali:~# dpkg -L skipfish | grep wl
/usr/share/skipfish/dictionaries/medium.wl
/usr/share/skipfish/dictionaries/minimal.wl
/usr/share/skipfish/dictionaries/extensions-only.wl
/usr/share/skipfish/dictionaries/complete.wl

# skipfish中的worldlist以.wl结尾
```

使用-S参数指定脚本文件jFuzzing:

```
root@kali:~# skipfish -o test3 -I /dvwa  -S /usr/share/skipfish/dictionaries/minimal.wl http://192.168.234.129
```

#### skipfish -0 test -S complet.wl -W a.wl url
complet.wl  -W a.wl 使用特定的只读worldList.wl文件对目标网站Fuzzing，并且将该网站下的特殊字符或者目录保存到a.wl
文件中去。

对后续的Debug也许有一定的帮助。

##### -I 只检查包含`string`的URL

```
root@kali:~# skipfish -o test1 -I /dvwa/ http://192.168.234.129/dvwa
```

添加-I参数，扫描只包含/dvwa的url。

##### -X 不检查包含`string`的URL

```
root@kali:~# skipfish -o test1 -X  logout.php http://192.168.234.129/dvwa
```

##### -D 跨站爬取

偶尔，我们可能也许同时扫描多个网站，比如提交一个from，但是该from的action是iframe中的，那么此时有必要对该iframe中url进行fuzzing。

在skipfish中可以使用-D参数，进行跨域扫描。


```
root@kali:~# skipfish -o test1 -I /dvwa/ -D www.w3c.com http://192.168.234.129/dvwa
```

当HTTP://192.168.234.129，中存在www.w3c.com的链接时，则同时对www.w3c.com进行fuzzing，若是不存在，则不fuzzing。


##### -l 每秒的最大请求数

```
root@kali:~# skipfish -o test1 -I /dvwa/ -l 2000 http://192.168.234.129/dvwa
```

##### -m 每IP最大连接并发数

```
root@kali:~# skipfish -o test11 -l 2000 -m 5 http://192.168.234.129/dvwa
```

---
### 0x02 skipfish 身份认证

skipfish没有GUI，但是它仍然可以进行身份认证。

---
#### cookies身份认证 -C

在Firefox中使用Firebug，选择cookies选项，导出cookies为txt文件，获得cookies的字段和值。

使用-C参数，将cookies填充到shell command中。

```
root@kali:~# skipfish -o test19 -C "PHPSESSID=7edae86d27b4a18843d88d52e4062e58" -C "security=high" -I /dvwa -X logout.php http://192.168.234.129/dvwa
```

---
#### 身份认证 -A/--author
skipfish除了可以使用cookies认证，还提供更强大的user:pass形式以直接提交表单的方式去认证。

* --author-form <URL>:指定表单所在的url地址 : 192.168.234.129/dvw/login.php
* --author-username <username> :用户登录名 admin 
* --author-pass <password> 登录密码: password 
* --author-verfiy-url <URL> 验证表单是否登录成功: 当进入到192.168.234.129/dvwa/index.php 页面时代表登陆成功。

* --auth-form-target <URL> 指定表单要提交的后台地址，既form的action

* --auth-user-field :指定登录名所在位置的field

*  --auth-pass-field :指定登录密码所在field

```
root@kali:~# skipfish -o test --auth-form http://192.168.234.129/dvwa/login.php \
--auth-form-target http://192.168.234.129/dvwa/login.php  \
--auth-user-field username \
--auth-user admin \
--auth-pass-field password \
--auth-pass password \
--auth-verify-url http://192.168.234.129/dvwa/index.php \
-I dvwa http://192.168.234.129/dvwa
```

等待扫描完毕，使用firefox打开test下index.html文件查看扫描报告:

```
root@kali:~# firefox test/index.html 
```


