---
title: DNS信息收集-DIG
date: 2016-03-21 19:34
tags: ['Kali第六章','被动信息收集']
toc: true
categories: technology
---

DIG很多方面的特性和nclookup是相似的，但是DIG本身是比nslookup更强大的,使用也很方便，不用像nslookup总是set不停！
Dig是Domain Information Groper的缩写，知道了来源想必大家也就容易记住这条命令了。

---
### ox00 DIG简单使用
最简单最常用的查询是查询一台主机，但是默认情况下，Dig的输出信息很详细，有时我们你不需要那么多的的输出，但它确实值得知道。

```
root@jack:/# dig www.baidu.com

输出:
; <<>> DiG 9.9.5-9+deb8u5-Debian <<>> www.baidu.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 36238
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1
;; WHEN: Fri Mar 11 09:16:16 CST 2016
;; MSG SIZE  rcvd: 101
```

#### 参数：any

```
root@jack:~# dig sina.com any

返回结果:
; <<>> DiG 9.9.5-9+deb8u5-Debian <<>> sina.com any
;; global options: +cmd
sina.com.		97	IN	MX	10 freemx3.sinamail.sina.com.cn.
sina.com.		97	IN	MX	10 freemx2.sinamail.sina.com.cn.
sina.com.		204	IN	A	66.102.251.33
```

#### 参数: noall + answer
查询163邮箱的邮件服务器记录

```
root@jack:~# dig +noall +answer mail. 163.com

返回结果：
mail.			0	IN	A	219.147.255.138
163.com.		383	IN	A	123.58.180.8
163.com.		383	IN	A	123.58.180.7
```

##### 查询主机记录并管道过滤
查询163邮箱的邮件服务器记录，并使用管道命令进行过滤！
```
  root@jack:~# dig +noall +answer mail 163.com any | awk '{print $5}'

返回结果：
219.147.255.138
123.58.180.7
123.58.180.8
```

---
#### 反向域名解析(PTR记录)[dig参数-x的使用]：
##### 首先dig 163的mx记录
```
root@jack:~# dig +noall +answer 163.com mx

返回结果
1.163.com.		14869	IN	MX	10 163mx02.mxmail.netease.com.
2.163.com.		14869	IN	MX	10 163mx03.mxmail.netease.com.
3.163.com.		14869	IN	MX	50 163mx00.mxmail.netease.com.
4.163.com.		14869	IN	MX	10 163mx01.mxmail.netease.com.
```

##### 查找CNAME对应IP
选择第一个CNAME记录查询其对应的IP地址：
```
root@jack:~# dig +noall +answer 163mx02.mxmail.netease.com.

返回结果：
163mx02.mxmail.netease.com. 563	IN	A	220.181.14.155
163mx02.mxmail.netease.com. 563	IN	A	220.181.14.147
```

##### 对IP进行反向解析
对第一个ip进行反向解析：
```
root@jack:~# dig +noall +answer -x 220.181.14.155

返回结果：
155.14.181.220.in-addr.arpa. 86385 IN	PTR	m14-155.188.com.
```

从最后的返回结果我们会发现，ptr解析记录和最初所查询的域名并不一致，这是很正常的，因为ip和域名之间通常的都是一对多的。

---
### 0x03 Dig特性

----
####  查询DNS bind的版本信息：
__{ Usage $: dig +noall +answer www.xx.com }__

大部分的厂商使用的DNS服务器所使用的都是BIND，查询bind的目的，从我们之前的查询已经知道了，每个域名会对应许多个记录，对渗透目标最完美的DNS查询结果就是将其注册的所有DNS注册记录都查询出来，www/news/adc.sian.com，再将这些fqdn对应的所有IP地址全部都解析出来。但是当使用dig命令时，我们是不能直接查询不出它所有的fqdn记录的，却可以借用dig查询的到它的bind信息，如果bind是比较老的，且有漏洞的，便可以通过入侵bind获得dns的记录！

下面是强大的dig bind命令:

---
#### dig网站NS记录
首先获得sina.com的NS记录：
```
root@jack:~# dig +answer sina.com

返回结果：
;; QUESTION SECTION:
;sina.com.			IN	NS
;; ANSWER SECTION:
sina.com.		59596	IN	NS	ns1.sina.com.cn.
sina.com.		59596	IN	NS	ns3.sina.com.
sina.com.		59596	IN	NS	ns2.sina.com.cn.
```

----
#### 查询dns的bind版本
```
root@jack:~# dig +noall +answer txt chaos VERSION.BIND ns1.sina.com.cn.

返回结果：

VERSION.BIND.		0	CH	TXT	"Why query me?Your IP had been logged!"
```
我们可以看到返回的结果为空，这是因为sina DNS服务器设置了保护模式，我们不能通过此方式查询！bind信息对于黑客是很感兴趣的，所有现在绝大多数的互联网公司都会隐藏的的bind信息！

---
### 0x04  DNS追踪

__{ Usage $: [dig +trace example.com] }__

直接运行命令：
```
root@jack:~# dig +trace www.sina.com

返回结果：
; <<>> DiG 9.9.5-9+deb8u2-Debian <<>> +trace www.sina.com
;; global options: +cmd
.			19560	IN	NS	m.root-servers.net.
.			19560	IN	NS	f.root-servers.net.
.			19560	IN	NS	g.root-servers.net.
.			19560	IN	NS	d.root-servers.net.
.			19560	IN	NS	a.root-servers.net.
.			19560	IN	NS	e.root-servers.net.
.			19560	IN	NS	j.root-servers.net.
.			19560	IN	NS	k.root-servers.net.
.			19560	IN	NS	l.root-servers.net.
.			19560	IN	NS	b.root-servers.net.
.			19560	IN	NS	h.root-servers.net.
.			19560	IN	NS	c.root-servers.net.
.			19560	IN	NS	i.root-servers.net.
;; Received 239 bytes from 112.100.100.100#53(112.100.100.100) in 82 ms
<a>首先trace通过本机访问13个根（.）服务器,随机挑选一个查询.com域的NS记录</a>
com.			172800	IN	NS	a.gtld-servers.net.
com.			172800	IN	NS	b.gtld-servers.net.
com.			172800	IN	NS	c.gtld-servers.net.
com.			172800	IN	NS	d.gtld-servers.net.
com.			172800	IN	NS	e.gtld-servers.net.
com.			172800	IN	NS	f.gtld-servers.net.
com.			172800	IN	NS	g.gtld-servers.net.
com.			172800	IN	NS	h.gtld-servers.net.
com.			172800	IN	NS	i.gtld-servers.net.
com.			172800	IN	NS	j.gtld-servers.net.
com.			172800	IN	NS	k.gtld-servers.net.
com.			172800	IN	NS	l.gtld-servers.net.
com.			172800	IN	NS	m.gtld-servers.net.
com.			86400	IN	DS	30909 8 2 E2D3C916F6DEEAC73294E8268FB5885044A833FC5459588F4A9184CF C41A5766
com.			86400	IN	RRSIG	DS 8 1 86400 20160403050000 20160324040000 54549 . ZySdwNEXufOygOza5asIf7Aa4JZSVuaNDAW+fJhd9w5F1w29hO8ffNYs mUf4FsC5dHgZOYSikbyZJeyKryqTnvCqU+2OQcbYxvF8l9ahETNxJE8m FTnEVtaQJK+e72h+9BDAyO022v6wAo8P9+OC0u9P2yooIbUr7Ys/ODHc SfE=
;; Received 736 bytes from 192.58.128.30#53(j.root-servers.net) in 210 ms
<a>再从获得的从com域名中随机挑选一个查询sina.com的NS记录</a>
sina.com.		172800	IN	NS	ns1.sina.com.cn.
sina.com.		172800	IN	NS	ns2.sina.com.cn.
sina.com.		172800	IN	NS	ns3.sina.com.cn.
sina.com.		172800	IN	NS	ns1.sina.com.
sina.com.		172800	IN	NS	ns2.sina.com.
sina.com.		172800	IN	NS	ns4.sina.com.
sina.com.		172800	IN	NS	ns3.sina.com.
CK0POJMG874LJREF7EFN8430QVIT8BSM.com. 86400 IN NSEC3 1 1 0 - CK0Q1GIN43N1ARRC9OSM6QPQR81H5M9A NS SOA RRSIG DNSKEY NSEC3PARAM
CK0POJMG874LJREF7EFN8430QVIT8BSM.com. 86400 IN RRSIG NSEC3 8 2 86400 20160331045906 20160324034906 28259 com. bHlKyZIPRgtRjaONiuYtTtkWRNb08sDePoBAoTw49t9YRU6KYSJgn7se +OfmBIA1rvCx3YIE82z0Q9A64s4z7XwRAhWqjW++lDACLsIzJ/tUP3TO DBucmG/NOBmAXUpRwo91zFjukbPOZ1PeYVpBjTmaRaI23MGJ0ANHbFUW oDs=
TGAFTKK08BOUSKO3P3B8A4U84C84DTHM.com. 86400 IN NSEC3 1 1 0 - TGAIGAA7UE2B06LAN5KC5MT51RE8U42A NS DS RRSIG
TGAFTKK08BOUSKO3P3B8A4U84C84DTHM.com. 86400 IN RRSIG NSEC3 8 2 86400 20160330043912 20160323032912 28259 com. UfPPJ9326mLBJIz60EgkDgT6fif4fOcgieasgz4a752Gc9e6LKTtMPvF KpLu2R4lfKMj/edVf637U4eQKo8C+Mvatv1qVxvqufiQRM15uOqdvejb muvJncBomFxfgjAOTmIHD0dIE5ho/R/8RW4xjCxAYrYkdumoDgvg1tc9 s44=
;; Received 727 bytes from 192.26.92.30#53(c.gtld-servers.net) in 429 ms
<a>再从获得的sina.com域名中随机挑选一个查询www.sina.com的NS记录，此后将会一次逐级解析下去，知道全部记录解析完毕！</a>
www.sina.com.		60	IN	CNAME	us.sina.com.cn.
us.sina.com.cn.		60	IN	CNAME	news.sina.com.cn.
news.sina.com.cn.	60	IN	CNAME	jupiter.sina.com.cn.
jupiter.sina.com.cn.	3600	IN	CNAME	hydra.sina.com.cn.
hydra.sina.com.cn.	60	IN	A	218.30.108.183
hydra.sina.com.cn.	60	IN	A	218.30.108.184
hydra.sina.com.cn.	60	IN	A	218.30.108.185
hydra.sina.com.cn.	60	IN	A	218.30.108.186
hydra.sina.com.cn.	60	IN	A	218.30.108.187
hydra.sina.com.cn.	60	IN	A	218.30.108.188
hydra.sina.com.cn.	60	IN	A	218.30.108.189
hydra.sina.com.cn.	60	IN	A	218.30.108.190
hydra.sina.com.cn.	60	IN	A	218.30.108.191
hydra.sina.com.cn.	60	IN	A	218.30.108.192
hydra.sina.com.cn.	60	IN	A	218.30.108.180
hydra.sina.com.cn.	60	IN	A	218.30.108.181
hydra.sina.com.cn.	60	IN	A	218.30.108.182
sina.com.cn.		86400	IN	NS	ns3.sina.com.cn.
sina.com.cn.		86400	IN	NS	ns1.sina.com.cn.
sina.com.cn.		86400	IN	NS	ns2.sina.com.cn.
sina.com.cn.		86400	IN	NS	ns4.sina.com.cn.
;; Received 474 bytes from 123.125.29.99#53(ns3.sina.com.cn) in 36 ms
```
__从上的追踪过程其实就是所谓的迭代查询过程！__
下面我们来看看递归查询的结果:

```
root@jack:~# dig sina.com
```
从wireshark所获得的抓包数据我们可以看到关于dns的记录就两条！
关于递归查询与迭代查询请参考相关资料。


