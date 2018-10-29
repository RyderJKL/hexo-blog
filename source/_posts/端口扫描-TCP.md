---
title: 端口扫描-TCP
date: 2016-05-15 16:14
tags: ['kali渗透测试','主动信息收集']
toc: true
categories: technology

---
### 0x00 前言
相比于UDP的端口扫描，基于TCP的扫描将会复杂很多。TCP的扫描方式都是基于连接的三次握手的变化来判断目标端口的状态。TCP可以进行隐蔽扫描，僵尸扫描(比隐蔽扫描更隐蔽的扫描方式)，全连击扫描(基于完整的三次握手)。

* __ 隐蔽扫描__
 不建立完整的连接，而是只发送syn包，如果对方回复ack表示目标端口是开放的，如果回复rst表示目标端口未开放。无论如何我不再发送第三次的ACK确认，由此也不会建立起正常的tcp连接，应用层日志不会有任何记录，但是网络层还是会有些迹象的！

* __僵尸扫描__
极度隐蔽，但是实施条件苛刻，可伪造源地址。僵尸扫描的苛刻条件之一就是发起方必须伪造IP地址；二是选择的僵尸机必须是闲置状态的并且这些操作系统的IPID(ip包头里的ip字段)必须是递增的，IPID不能是随机的或者永远是0。

---
### 0x01 隐蔽端口扫描 
#### 本地测试环境
* __kali 2.0:__ 系统参数{IP:192.168.129}
* __ubuntu 14.04LTS:__ 系统参数{ IP:192.168.86.131}
* __windows xp 英文版:__ 系统参数{IP:192.168.86.132}
* __metasploitable2:__ 系统参数{IP:192.168.86.130}

#### 使用Scapy构成TCP syn包探测目标端口

syn是tcp包，所以先构造一个tcp包，tcp包由tcp包头+ip包头组成，默认情况先tcp扫描80端口

```
root@kali:~# scapy
WARNING: No route found for IPv6 destination :: (no default route?)
Welcome to Scapy (2.2.0)
a=sr1(IP(dst="192.168.86.130")/TCP(flags="S"),timeout=1,verbose=0)
a<IP  version=4L ihl=5L tos=0x0 len=44 id=0 flags=DF chksum=0xff85 urgptr=0 options=[('MSS', 1460)] |<Padding  load='\x00\x00' |>>>
a.display()###[ IP ]###
  version= 4L
  chksum= 0xc78
  src= 192.168.86.130
  dst= 192.168.86.129
  \options\###[ TCP ]###
     sport= http
     reserved= 0L
     flags= SA  <===TCP包头的flags字段变成了SA=syn+ack  ###[ Padding ]###load= '\x00\x00'
```
查看目标441端口是否开放
```
a=sr1(IP(dst="192.168.86.130")/TCP(flags="S",dport=441),timeout=1,verbose=0)
a
<IP version=4L ihl=5L tos=0x0 len=40 id=0 flags=DF frag=0L ttl=64 proto=tcp chksum=0xc7c src=192.168.86.130 dst=192.168.86.129 options=[] 
|<TCP sport=441 dport=ftp_data seq=0 ack=1 dataofs=5L reserved=0L __flags=RA__ window=0 chksum=0x7fae urgptr=0 |<Padding load='\x00\x00\x00\x00\x00\x00' 
```
可以看到，当端口未开放时，TCP的flags字段将会变成RA=rst+ack

scapy python脚本扫描:
```
#!/usr/bin/python

import logging
import subprocess
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *
import time

if len(sys.argv) != 4:
  print "Usage - ./udp_port.py [Target - TP] [First port] [Last port]"
  print "Usage - ./udp-port.py 128.13.34.13 1 100"
  sys.exit()

ip = sys.argv[1]
start = int(sys.argv[2])
end = int(sys.argv[3])

for port in range(start, end):
  a = sr1(IP(dst=ip)/TCP(dport=port),timeout=1,verbose=0)
  if a == None:
    pass
  else:
    if int(a[TCP].flags) == 18:
      print port
    else:
      pass
```

---
#### NMAP 的TCP 隐蔽端口扫描


* __{ Usage $: namp -sS ip start-port end-port }__

* __{ Usage $: namp -sS ip start-port end-port  --open}__只显示端口状态为open的端口

---
#### hping3 syn 隐蔽端口扫描

* __{Usage $: hping3 192.168.0.106 --scan 80 -S }__

* __{Usage $:hping3 -c 10 -S --spoof poof_ip -p ++1 dst_ip }__ 伪造源地址扫描
将IP伪造成poof_ip实现对源IP的隐藏，然后向目标主机发送10个syn包进行探测，从端口1开始，每次增加1.
 这里存在的问题是当目标主机的端口是开放的那么它会发送一个ack包个poof_ip，如果我们想要知道扫描的结果的话，那么我们必须具有登录poof_ip主机的权限，才能查看到扫描的结果！

### 0x03 TCP全连接端口扫描

syn在存在防火墙，或者网络条件十分苛刻时，可能扫描不出什么来，以此我们这时需要通过三次握手跟目标主机建立完整的TCP连接来进行试探，全连接的扫描结果准确率是最高的，但是不隐蔽，很容易触发网络层的报警系统。

```
#-*-coding:utf-8-*-
#！/usr/bin/python
import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *

SYN = IP(dst="192.168.86.132")/TCP(dport=25,flags="S")

print("---SENT---")
SYN.display()
#显示要发的包

print"\n\n---RECEIVED---"
response = sr1(SYN,timeout=1,verbose=0)
#将定义好的SYN包发送出去
response.display()
#显示收到的回包的信息，若对方端口开放，将会收到SYN+ACK相应
#----------------
#但是这里存在一个问题，就是我们的电脑系统内核会认为SYN/ACK
#是非法包，将会直接发送RST断开连接，这很蛋疼。。。
#解决方式是使用linux的自带防火墙iptables直接DROP掉由系统发出的RST包
#iptables -A OUTPUT -p tcp --tcp-flags RST RST -d 192.168.86.132 -j DROP
#-A新家一条规则，出站，-p tcp表示使用TCP协议 -d表示目标ip，-j表示动作
#----------------
if int(response[TCP].flags)==18:
#如果收到的回包是SYN+ACK，那么TCP包头的flags将会是18
  print("\n\n---SENT---")
  A = IP(dst="192.168.86.132")/TCP(dport=25,flags="A",ack=(response[TCP].seq+1))
#确定收到syn+ack相应，再次向目标发送ACK包确认，同时序列号加1
  A.display()
  print("\n\n---RECRIVED---")
  response2 = sr1(A,timeout=1,verbose=0)
  response2.display()
else:
#如果没有收到syn+ack回应，将不做任何相应
  print"SYN.ACK not returned" 
```

#### NMAP实现全连接的扫描

* __{ Usage $: namp -sT 192.168.86.134 -p 1-100 }__

当然基于TCP的全连接扫描会较慢非全连接扫描

### 其它扫描工具　

* __dmitry { Usage $: dmitry -P 192.168.86.34 }__

* __nc { Usage $: nv -w 1 -z 192.168.14.112 1-100 }__
   
   * __for x in $(seq 20 400);do nv -nv -w 1 -z 192.168.123.33 $x: done | grep open__
   * __for x in $(seq 1 254);do nc -nv -w 1 -z 192.168.3.$x 80;done__


