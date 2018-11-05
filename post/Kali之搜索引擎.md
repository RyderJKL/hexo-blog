---
title: Kali之搜索引擎
date: 2016-03-27 19:37
tags: ['Kali第六章','被动信息收集']
toc: true
categories: technology
---

没错，就是通过度娘，google，必应等搜索引擎,但是我们今天讲的是__语法__，搜索引擎的语法!是的今天教你怎么会用搜索引擎！

---
### 0x00 SHODAN
SHODAN不同于我们所理解的百度，google，它不爬网页页面，而是爬互联上的设备，未来我们将处于一个__物联网__的世界，家里的电视，冰箱，微波炉，所有带电的东东只要给它一个__IP__就都能连接互联网，而SHODAN的作用就是找到他们，找到全世界所有联网的设备，当然现在国内也有类似的网站了，比如知道创宇的zoomeye，而于此相对的是，目前物联网领域内的网络安全却是非常薄弱的！

_因为默认密码的存在，你可以登录互联网上一半的设备_

_SHODAN_
>http://www.shodan.io 

建议注册一个shodan账号，非会员只能显示出10个相关信息。

---
#### SHOADN 常用参数

##### net对特定的IP进行互联网设备爬取

 _search_ net:114.114.114.114

##### 使用country参数爬取某一特定国家

  _search_ country:CN
##### 使用city参数爬去城市信息

  _ search_ country:CN city:beijing

#### 使用port参数搜索开放了22端口的设备

 _search_ contry:CN city:beijing port:22

#### 使用os参数过滤操作系统

 _search_ country:CN city:beijing port:22 os:linux

##### 使用hostname指定主机名或域名

 _search_ country:CN city:beijing port:22 os:linux hostname:baidu.com

##### 用server参数指定服务器端运行的软件

 _search_  country:CN city:beijing port:22 os:linux hostname:baidu.com server: Apache

---
#### 自定义创造字符串搜索

  * _search_   200 OK ciso server: IIS country:JP
  * _search_ user:admin pass:admin
  * _search_ linux upnp avtech

----
#### SHODAN的简单特性

 * SHODANM的账号信息:
API key:每个注册用户都会有一个API key，这样我们就可以在编程中使用其API key集成到程序中，使用其搜索引擎！

 * firefox基于shodan的插件:
 shodan firefox add-on 下载安装以后当我们在访问一个网站时，便会自动找到并显示其网站相关信息！

---
### 0x02 Google
同样，虽然google也有基于搜索互联网设备的搜索功能(即banner)，但这并不是google的强项，而是基于互联网内容的搜索！

google很强大，正是源于它的强大，所以每次当我使用google搜索时会得到海量的信息，然而对我们有用或者只是其中一小部分，所有我们有必要使用使用一些技巧（过滤指令）对其进行过滤！

##### 设置倒计时:
```
search: set timer 30 minutes
```
##### 显示城市距离
```
search: city to city distance
```

##### 显示我的位置和ip
```
search: what's my location/ip
```

##### 绘制多远方程及辅助方程式
```
search: graph for x^8 
        : graph for sin(x)+tan(x)
```

##### 搜索关键字“支付"但过滤另一个关键字"充值"：
```
srearch: +支付 -充值
```

##### 善用引号" "
搜索一个比较长的内容，但是中间含有空格的，你又想将其作为一个完整的语义，这时我们可以使用""(双引号)将其括起来:

这样会显示含有支付或充值的页面
```
search:"支付 充值"
```

##### 基于html网页内容搜索

搜索关键字北京，并且html页面的title为电子商务，内容包含法人，电话信息的网站。
```
search: 北京 intitle:电子商务 intext:法人 intext:电话
```

##### 找出阿里巴巴网站在北京的联系人。
```
search: 北京 site:alibaba.com inurl:contact
site:表示要搜索的站点(可以是国家，网站域名)
inurl:在浏览器的url带有contact关键字的
```
##### 搜索python的PDF文档
```
search: Python filetyep:pdf
```

##### 搜索指定国家范围的payment关键字
```
search: payment site:usa
```
---
#### 几个好玩的惊喜:
```
search: google sphere
search: google gravity
search: zerg rush
```

---
### 0x03 下面开启hacking模式

##### 实例一

当cicso交换机启用了HTTP访问时，用户是分权限级别的，15级拥有高级权限，利用google搜索可得其交换机内部数据。
```
search: inurl:"level/15/exec/-/show"
```
 
##### 实例二
通过google搜索联网设备实现shodan功能

```
search:intitle:"netbotz appliance" "ok"
```

 ##### 实例三

```
search: inurl:/admin/login.php
```

##### 实例四:

```
search:inurl:qq.txt
```

##### 实例五
```
search: filetype:xls "username|password"
``` 

##### 实例六
这是一个关于Fronpage的漏洞
```
search: Service.pwd
```

最后介绍一个google的网站，简单的说就是google引擎搜索语法大全!
>https://www.exploit-db.com/

---
### 0x04 第四大搜索引擎 yandex 俄罗斯
> https://www.yandex.com
每个搜索引擎都有自己的搜索语法。

---
### 0x05 Kali命令行实现并发搜索

---
#### theharvester

```
root@jack:~#  theharvester -d microsoft.com -l 500 -b google
```

选项与参数:
* -d: 搜索域名信息和公司记录，类似dig
* -b: 指定搜索引擎[google,googleCSE,bing,bingapi,twitter,googleus,]
* -l: 限制并发搜索结果的数量(避免搜索引擎的限制)，默认为每次并发50搜索次数！

当然由于众所周时的原因，我们需要墙出去才能使用到theharverstr，但gogent使用的是公用ip，这里我们会启用TOR进行代理哦！


 > 进一个小插曲，介绍一个终端复用工具，tmux，谁用谁知道！

因为搜索引擎的自我保护机制，同一个IP搜索次数太多时，将会被禁止搜索，所以这时我们就需要用到之前的一个工具了，proxychains，vi查看proxychais配置文件是否已经配置完毕:

```
vi /etc/proxychains.conf
```

查看tor的侦听端口是否已经开启(tor默认侦听9150端口):
```
root: netstat -pantu | grep 9150
```

现在使用proxychains代理链区调用theharverster去检查microsoft的邮箱记录和主机记录，限制搜索结果数500并指定google进行搜索！

```
root@jack:~# proxychains theharvester -d microsoft.com -l 500 -b google
```

---
### 0x06 Maltego
一款综合型的信息收集软件，作为kali十大工具之一，它的不仅拥有图形化界面，并且用户体验也是很棒的，当然他是开源的。

首次启动我们需要注册一Maltego的账号
此部分未完待续。。。。

---
### 0x07 其他途径
社交网络，工商注册，新闻组/论坛，招聘网站。
一个专门记录互联网上过去网页是什么样子的网站(需要FQ):
> http://www.archive.org/web/web.php

---
### 0x08 个人专属的密码字典
对于目前阶段，我们破解一个密码的，方式最有效，最便捷的方式莫过于使用字典破解了，个人专属密码字典就是按个人信息生成其专属的密码字典，而CUPP可以个人的信息，并对其进行整理，CUPP是使用python编写的，kali默认不集成,所有我们需要在github上下载安装:
```
root@jack:~# git clone https://github.com/Mebus/cupp.git
```
使用方法:
```
root@jack:~/cupp# python cupp.py -i
[+] Insert the informations about the victim to make a dictionary
[插入受害者的个人信息制作字典]
[+] If you don't know all the info, just hit enter when asked! ;)
[如果不知道的信息，按回车跳过]

> First Name: vicent     
> Surname: fan
> Nickname: ghao
> Birthdate (DDMMYYYY): 18041984


> Partners) name: vicent
> Partners) nickname: fan
> Partners) birthdate (DDMMYYYY): 09191945


> Child's name: vicent
> Child's nickname: fan
> Child's birthdate (DDMMYYYY): 09191998


> Pet's name: wangcai
> Company name: peking university


> Do you want to add some key words about the victim? Y/[N]: y
> Please enter the words, separated by comma. [i.e. hacker,juice,black], spaces will be removed: student china geek music football love fuck
> Do you want to add special chars at the end of words? Y/[N]: y
> Do you want to add some random numbers at the end of words? Y/[N]y
> Leet mode? (i.e. leet = 1337) Y/[N]: 1314

[+] Now making a dictionary...
[+] Sorting list and removing duplicates...
[+] Saving dictionary to vicent .txt, counting 15948 words.
[+] Now load your pistolero with vicent .txt and shoot! Good luck!
```
根据我们输入的特定的个人信息，我们可以看到程序已经生成了一个名为vicent.txt的个人信息字典，其中该字典包含了15948个单词!
```
root@jack:~/cupp# cat vicent.txt 
 tneciV
 tneciV!
 tneciV!#!
 tneciV!##
....
```

---
#### 0x007 METADATA
Exit信息:所有拍摄的照片都可以获得以下照片信息，比如GPS，相机品牌，快门次数，kali也内置了可以查看图片Exit信息的命令行工具:
使用Exiftool查看照片GPS信息:
```
root@jack:~/桌面# exiftool IMG_0026.JPG
GPS Altitude                    : 80 m Above Sea Level
GPS Date/Time                   : 2015:12:10 12:45:59.17Z
GPS Latitude                    : 86 deg 15' 43.38" N
GPS Longitude                   : 125 deg 8' 82.13" E
GPS Position                    : 146 deg 25' 43.38" N, 225 deg 8' 42.13" E
```

---
#### GPS坐标单位(度分秒)的换算方法:

度分秒(DMS): E 108度54分22.2秒 N 34度12分60.0秒
度(DDD): E 108.90592度 N 34.21630度
将度(DDD):108.90592度换算成度分秒(DMS):E E 108度54分22.2秒?
$ 将108.90592整数位不变直接取108(度),然后用0.90593*60=54.3558,取整数位获得54(分),0.3558*60=21.348在取整数为21(秒)即得108度54分21秒。
$ 将度分秒(DMS)转化成度(DDD):108度54分22.2秒=108+(54/60)+(22.2/3600)=108.90616度

> windows下图片METADATA信息查看工具:foca


