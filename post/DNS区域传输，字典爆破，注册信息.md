---
title: DNS区域传输，字典爆破，注册信息
date: 2016-03-24 13:26
tags: ['Kali第六章','被动信息收集']
toc: true
categories: technology
---


### 0x00 DNS区域传输
为了减轻单台DNS服务器的负载，有时要将同一DNS区域的内容保存在多个DNS服务器中，这时，就要用到DNS的“区域传输”功能，可以简单的理解为数据备份。正常情况之下，DNS区域传输只发生在本域的域名服务器之间，一旦dns服务器管理员dns区域传输配置不当，我们便可以使用以下两条常用的命令[并不仅限与这两种方法哈]获得其dns服务器中的所有记录！


---
### 0x01 方法一
__依旧使用强大的dig命令实现。__

我们知道一个域名上可能存在多个域名服务器，所以在区域传输需要指定域名中的某一个dns服务器。

---
#### 区域传输命令:dig[axfr]

```
root@jack:~# dig @s1.example.com example.com axfr
```

下面以新浪为例进行实例演示：

---
#### 首获得新浪NS记录:

 ```
root@jack:~# dig +noall +answer sina.com ns
sina.com.		61070	IN	NS	ns1.sina.com.
sina.com.		61070	IN	NS	ns3.sina.com.
```

---
#### 选择第一条NS记录执行区域传输:

``` 
root@jack:~# dig +noall +answer @ns1.sina.com. sina.com axfr
;; communications error to 114.134.80.144#53: end of file
```
可以看到连接结果为failed，尝试连接ip:114.134.80.144 53失败，当然只是由于新浪的管理员不是菜鸟哦！

ok，下面我们换一个域名试试，拿我亲爱的学校域名看看

```
root@jack:~# dig @dns2.dqpi.edu.cn. dqpi.edu.cn axfr
; <<>> DiG 9.9.5-9+deb8u6-Debian <<>> @dns2.dqpi.edu.cn. dqpi.edu.cn axfr
; (1 server found)
;; global options: +cmd
dqpi.edu.cn.		86400	IN	SOA	dns2.dqpi.edu.cn. root.dns2.dqpi.edu.cn. 916622846 10800 3600 604800 86400
dqpi.edu.cn.		86400	IN	MX	10 mta1.dqpi.edu.cn.
dqpi.edu.cn.		86400	IN	MX	20 mta2.dqpi.edu.cn.
dqpi.edu.cn.		86400	IN	NS	dns1.dqpi.edu.cn.
dqpi.edu.cn.		86400	IN	NS	dns2.dqpi.edu.cn.
15th-games.dqpi.edu.cn.	86400	IN	A	61.167.120.181
50.dqpi.edu.cn.		86400	IN	A	61.167.120.181
cacti.dqpi.edu.cn.	86400	IN	A	61.167.120.82
dqpi.edu.cn.		86400	IN	SOA	dns2.dqpi.edu.cn. 
;; WHEN: Sat Mar 26 09:16:13 CST 2016
;; XFR size: 45 records (messages 1, bytes 1032)
```
一条命令，轻松获得所有DNS记录！

---
### 0x02 方法二: host

简单点，直接上命令:
```
root@jack:~# host -T -l dqpi.edu.cn dns2.dqpi.edu.cn. 
关键参数[-l]执行axfr的全区域差异传输，-T表示时间。
返回结果：
Using domain server:
Name: dns2.dqpi.edu.cn.
Address: 210.46.136.6#53
wysf.dqpi.edu.cn has address 61.167.120.174
zsb.dqpi.edu.cn has address 61.167.120.181
```

---
### 0x03 DNS字典爆破
制作自己的DNS字典，使用常用的DNS域名字符串形成自己的字典，但如果觉得制作字典太过麻烦，便可以使用kali内置的一些爆破命令。这些工具的命令和功能都是大同小异的，初阶的我们熟练掌握一个就好了！

以下是常用的DNS爆破工具:

---
#### fierce

__{ Usage $:  firece -dnsserver 8.8.8.8 -dns sina.com.cn -wordlist a.txt n}__

使用fierce时需要指定一个DNS服务器，可以时任意的缓存DNS服务器，本地联通\\电信，google等等，_-dns_参数后面指定需要查询的域名，_-worldlist_参数后指定使用的字典！
```
root@jack:~# fierce -dnsserver 8.8.8.8 -dns sina.com.cn -wordlist a.txt
DNS Servers for sina.com.cn:
	ns4.sina.com.cn
	ns1.sina.com.cn
	ns2.sina.com.cn
	ns3.sina.com.cn
Unsuccessful in zone transfer (it was worth a shot)
Okay, trying the good old fashioned way... brute force
Can't open a.txt or the default wordlist
Exiting...
```
可以看到，即使不存在a.txt的字典，firece依旧会执行一些操作，因为firece自动集成了axfr全区域差异传输，所以它会首先指定axfr功能，当失败以后才会 使用字典进行爆破！

>这里使用命令dpkg命令来查询fierce中所携带的所有安装在系统上的文件:

```
root@jack:~# dpkg -L fierce
/.
/usr
/usr/share
/usr/share/fierce/hosts.txt
```

怀疑hosts.txt文件即是fierce所携带的字典:

```
root@jack:~# cat /usr/share/fierce/hosts.txt | grep www
www
www-
www-01
www-02
```

ok,下面更换字典进行爆破：
```
root@jack:~# fierce -dnsserver 8.8.8.8 -dns sina.com.cn -wordlist /usr/share/fierce/hosts.txt
```

---
#### dnsdict6

__{ Usage $: dnsdict6 -d4  -t 16 -x sina.com }__

dnsdict6携带多个不同级别的爆破字典，并且最大支持16个进程同时爆破。
-t指定线程数，-x指定使用那种级别的字典！
[-s][-m][-x][-u]分别代表小字典，中型字典，大字典，超大字典！

---
#### dnsenum 

__{ Usage $: dnsenum -f dns.txt -dnsserver 8.8.8.8 sina.com -a sina.xml }__

dnsenum可以将查询的结果保存为特定格式的文件。

> 下面使用find命令查询dnsenum所携带的字典文件。

```
root@jack:~# find / -name dnsenum
/usr/bin/dnsenum
/usr/share/dnsenum
/usr/share/doc/dnsenum
```
首先find会从/根目录开始查询，找到所有与dnsenum相关的目录！
然后再逐个查看:
```
root@jack:~# ls /usr/share/dnsenum
dns.txt
```

ok,现在已经找到了dnsenum所携带的字典，尝试进行dns爆破！
```
root@jack:~# dnsenum -f /usr/share/dnsenum/dns.txt -dnsserver 8.8.8.8 sina.com -a sina.xml

返回结果:
-----   sina.com   -----
Host's addresses:
__________________
sina.com.                                58       IN    A        66.102.251.33

Name Servers:
______________
Mail (MX) Servers:
___________________
Trying Zone Transfers and getting Bind Versions:
_________________________________________________
Trying Zone Transfer for sina.com on ns3.sina.com ... 
_______________________________________________
ads.sina.com.                            59       IN    CNAME    region.sina.usgcac.cdnetworks.net.
```

---
####  dnsmap

__{ Usage $: dnsmap sina.com -w dns.txt }__

---
#### dnsrecon

__{ Usage $: dnsrecon -d sina.com --lifetime 10 -t brt -D dnsbig.txt }__

* [-d]:指定查询的域名 !
* [-lifetime]:超时时间，超过时间找不到就认为不存在了！
* [-t]:指定查询的强度!
* [-D]:指定字典进行爆破！

```
root@jack:~# dnsrecon -d sina.com --lifetime 10 -t brt -D /usr/share/dnsrecon/namelist.txt
[*] Performing host and subdomain brute force against sina.com
[*] Do you wish to continue? y/n 
Y
[*] 	 A 02.sina.com 219.147.255.138
[*] 	 A 1.sina.com 219.147.255.138
```

---
### 0x04 爆破字典组合

我们可以收集以上所有的工具中的字典构成一自己的大字典，然后使用自己认为很好用的一款工具进行爆破！

---
### 0x05 DNS注册信息
有时除了对dns进行爆破之外我们还需要通过whois来查询DNS注册人的信息，方便进行社工攻击！

当然不同地区有不同地区的whois，下面是常用的whois查询地址:
AFRINIC  非洲地区      http://www.afrinic.net
APNIC      太平洋地址  http://www.apnic.net
ARIN         http://ws.arin.net
LANA       国际组织      http://www.iana..com
ICANN       http://www.icann.org
LACNIC     http://www.lacnic.net
NRO          http://www.nro.net
RIPE         http://www.ripe.net
InterNic     http://www.internic.net

其中InterNic是全球最早的IP地址分配机构组织！

下面在kali中使用命令行查询DNS人注册信息:

---
####  whois

```
root@jack:~# whois wooyun.org
Domain Name: WOOYUN.ORG
Domain ID: D159099935-LROR
WHOIS Server:
Referral URL: http://www.net.cn
Tech Email: xssshell@gmail.com
Name Server: NS1.DNSV2.COM
Name Server: NS2.DNSV2.COM
DNSSEC: unsigned
```

---
#### whois 查询IP:

```
root@jack:~# whois 202.106.2.2
% [whois.apnic.net]
% Whois data copyright terms    http://www.apnic.net/db/dbcopyright.html
% Information related to '202.106.0.0 - 202.106.255.255'
country:        CN
admin-c:        CH1302-AP
```


