---
title: Nikto
date: 2016-07-3 20:13
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### Dvwa
Dvwa是metasplotiable中的一个应用网站，该应用网站集成了大量的网站漏洞，值得我们探索和研究。

首先我们获得metasploitable的ip地址：192.168.86.130
Kali的ip地址:192.168.86.134

然后访问Metasplotiabel的ip地址，进入Dvwa应用网站，选择__DVWA Security__的安全等级选择为__low__。

---
### 0x01 
基于之前的渗透方法，现在要更进一步的减少与目标主机的交互。Htttrack可以将目标网站克隆下来，以实现离线分析目标网站。


---
### 0x02 手动扫描
除了使用扫描工具之外，还可以人为的去观察目标网站，作为一个客户去访问该网站显示存在的漏洞，但是纯手动的扫描一般只能看到网站开发者能让你看到的页面，这时便可以使用扫描工具来提高手动扫描的效率，去发现一些鲜为人知的页面。


---
### 0x03 NIKTO
Nikto是一个用来发现默认网页文件、检查网页服务器和CGI安全问题的工具，它是开源的，使用Perl开发，可以对网页服务器进行全面的多种扫描，包含超过3300种有潜在危险的文件CGIs；超过625种服务器版本；超过230种特定服务器问题；以及一些WEB Application层面的漏洞它也会去扫描。

Nikto的作者是Chris Sullo，他是开放安全基金会(Open Security Foundation) 的财务总监。

---
#### 避免404误判
很多服务器不遵守RFC标准，比如对于不存在的对象返回200相应代码。那么当扫描器遇到这种情况下便会产生误判。

扫描器是如何尝试解决的？
Nikto的解决方发是:在开始扫描以前，在每条命令执行之前，会在自己的数据库中将web中常见文件的扩展名提取出来，随机使用一些文件名拼接这些扩展名(这些随机的文件名+扩展名的文件对于目标服务器来说通常是不存在的)让后再向目标服务器发起请求。然后根据不同扩展名返回的信息，进行HASH摘要，以此得到该文件不存在时得到的响应信息。然后Nikto再开始真正的扫描发起。

如果这些还是不能得到404响应的真实性，那么最新版本的Nikto还会将得到的响应内容去除时间信息后取得MD5值进行hash校验。

同时也可以使用参数-non404，去掉前期判断，但是这种提高性能而舍弃准确率的做法，并不建议。

---
#### Nickto的使用

首先升级Nikto:

```
$: nikto -update
```

但是由于伟大的墙的存在，不一定能更新成功，此时可以访问到Nikto官网下载安装包:http://cirt.net/nikto/UPDATES.


---
#### nikto host 扫描

```
root@kali:~# nikto -host 192.168.86.130 -port 80
```

##### nikto 进行ssl扫描

```
root@kali:~# nikto -host www.baidu.com -port 443 -ssl 
```

##### -ouput 将扫描结果输出保存


##### 对host列表进行批量扫描

```
$: nikto host -host.txt
```

-host.txt 的文本格式如下:

```
---host.txt---
192.168.0.1:80
https://192.168.1.1:8333
192.168.0.2
```

##### nmap与nikto

```
$: nmap -p80 192.168.1.4/24 -oG - | nikto -host -
```

将nmap获得的ip地址结果作为输出通过管道传送给nikto

##### nikto代理

同样nikto可以通过代理扫描：

```
$: nikto -host https://www.baidu.com -useproxy htpp://localhost:1080
```

##### -vhost
当一个网站存在多个端口时可以使用-vhost遍历所有网站进行扫描


---
#### nikto的配置文件

有些网站需要登录以后才可以进行扫描，此时可以设置nikto的配置文件手动将cookie添加到nikto的中。nikto的配置文件是

```
$: vi /etc/nikto.conf

#########################################################################################################
# CONFIG STUFF
# $Id: config.txt 94 2009-01-21 22:47:25Z deity $
#########################################################################################################

# default command line options, can't be an option that requires a value.  used for ALL runs.
# CLIOPTS=-g -a

# ports never to scan
SKIPPORTS=21 111

# User-Agent variables:
 # @VERSION 	- Nikto version
 # @TESTID 	- Test identifier
 # @EVASIONS 	- List of active evasions
USERAGENT=Mozilla/5.00 (Nikto/@VERSION) (Evasions:@EVASIONS) (Test:@TESTID)

# RFI URL. This remote file should return a phpinfo call, for example: <?php phpinfo(); ?>
# You may use the one below, if you like.
RFIURL=http://cirt.net/rfiinc.txt?

# IDs never to alert on (Note: this only works for IDs loaded from db_tests)
#SKIPIDS=

# The DTD
NIKTODTD=/var/lib/nikto/docs/nikto.dtd

# the default HTTP version to try... can/will be changed as necessary
DEFAULTHTTPVER=1.0

# Nikto can submit updated version strings to CIRT.net. It won't do this w/o permission. You should
# send updates because it makes the data better for everyone ;)  *NO* server specific information
# such as IP or name is sent, just the relevant version information.
# UPDATES=yes  	- ask before each submission if it should send
# UPDATES=no   	- don't ask, don't send
# UPDATES=auto 	- automatically attempt submission *without prompting*
UPDATES=yes

# Warning if MAX_WARN OK or MOVED responses are retrieved
MAX_WARN=20

# Prompt... if set to 'no' you'll never be asked for anything. Good for automation.
#PROMPTS=no

# cirt.net : set the IP so that updates can work without name resolution -- just in case
CIRT=107.170.99.251

# Proxy settings -- still must be enabled by -useproxy
#PROXYHOST=127.0.0.1
#PROXYPORT=8080
#PROXYUSER=proxyuserid
#PROXYPASS=proxypassword

# Cookies: send cookies with all requests
# Multiple can be set by separating with a semi-colon, e.g.:
# "cookie1"="cookie value";"cookie2"="cookie val" 
#STATIC-COOKIE=

# The below allows you to vary which HTTP methods are used to check whether an HTTP(s) server 
# is running. Some web servers, such as the autopsy web server do not implement the HEAD method
CHECKMETHODS=HEAD GET

# If you want to specify the location of any of the files, specify them here
EXECDIR=/var/lib/nikto				# Location of Nikto
PLUGINDIR=/var/lib/nikto/plugins			# Location of plugin dir
DBDIR=/var/lib//nikto/databases			# Location of database dir
TEMPLATEDIR=/var/lib/nikto/templates		# Location of template dir
DOCDIR=/var/lib/nikto/docs			# Location of docs dir

# Default plugin macros
@@MUTATE=dictionary;subdomain
@@DEFAULT=@@ALL;-@@MUTATE;tests(report:500)

# Choose SSL libs: 
# SSLeay        - use Net::SSLeay 
# SSL           - use Net::SSL 
# auto          - automatically choose whats available 
#                 (SSLeay wins if both are available) 
LW_SSL_ENGINE=auto

# Number of failures before giving up
FAILURES=20
```

* __User-Agent:__\ 默认的是firefox浏览器。此外还可以下载firefox的User-Agent插件，比如基于freifox浏览器的__User-Agent Switcher__可以进行移动端，PC端，以及操作系统的组合伪装。

```
# User-Agent variables:
 # @VERSION 	- Nikto version
 # @TESTID 	- Test identifier
 # @EVASIONS 	- List of active evasions
USERAGENT=Mozilla/5.00 (Nikto/@VERSION) (Evasions:@EVASIONS) (Test:@TESTID)
```

* __RFI URL:__用于验证远程文件的正确性

* __Proxy settings:__代理设置

```
# Proxy settings -- still must be enabled by -useproxy
PROXYHOST=127.0.0.1
PROXYPORT=1080
#PROXYUSER=proxyuserid
#PROXYPASS=proxypassword
```

* cookies设置
将已经登录网站的cookies存放再nikto.conf中，便可以登陆该网站了。
随便打开一个网站，对该网站启用Firebug，并启用cookies功能，登录该网站，分析cookies信息，比如百度，分析firebug的cookies项可以看到过期时间(Expires)，将过期时间下对应的有会话(Session)字段的项中的名称(Name)和内容(Value)copy，添加到
/etc/nikto.conf中

```
# Cookies: send cookies with all requests
# Multiple can be set by separating with a semi-colon, e.g.:
"HBDRCVFR[Fc9oatPmwxn]="12345678";"BD_CK_SAM"="cookie val" ;"BD_HOME"="cookie val";"H_PS_PSSID"="cookie val";....
""
#STATIC-COOKIE=
```


---
#### -evasion IDS躲避技术

##### IDS(instruion Detection System) 入侵检测系统
IDS可以被定义为对计算机和网络资源的恶意使用行为进行识别和相应处理的系统，包括系统外部的入侵和内部用户的非授权行为，是为保证计算机系统的安全而设计与配置的一种能够及时发现并报告系统中未授权或异常现象的技术，是一种用于检测计算机网络中违反安全策略行为的技术。

所以当一个目标中存在IDS技术时可以使用参数-evasion来逃避，nikto的逃避方式一共有八种,可以同时指定多种:

* 随机URL编码(非utf-8)
* 自选择路径
* 过早结束的URL
* 优先考虑长随机字符串
* 参数欺骗
* 使用TAB作为命令的分隔符
* 使用变化的URL
* 使用Windows路径分隔符

比如:

```
$: nikto -host http://192.168.1.34/dvwa/ -evasion 167
```



