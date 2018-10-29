---
title: 端口扫描-UDP
date: 2016-05-13 12:10
tags: ['kali渗透测试','主动信息收集']
toc: true
categories: technology

---
### 0x00 前言
当我们发现到存活的IP以后，那么下一步就是针对特定的主机进行端口扫描了，因为端口对应的是网络服务及其应用段的程序，端口潘多拉魔盒的入口，一旦发现开放的端口，便能以此作为后续渗透的跳板，这是完成一个完美渗透的一个重要的里程碑。

---
### 0x01 UDP端口扫描

UDP端口扫描可以得到两种结果，端口开了，端口没开(废话-.-),但是主机是活的，我们也不会死的主机进行端口扫描。

假设ICMP 返回port-unreachable 响应代表端口关闭，但是如果目标系统不响应ICMP port-unreachable时，可能产生误判，而且完整的UPD应用层请求虽然准确性高，但是耗时巨大！

了解每一种UDP的应用层协议，构成出专门对这一应用的的数据包，然后用该数据包进行扫描，将会大大得到提高！

#### Scapy UDP Scan

直接上脚本代码了:
```
#!/usr/bin/python

import logging
import subprocess
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *
import time

if len(sys.argv) != 4:
#脚本本身 ip start-port end-port
  print "Usage - ./udp_port.py [Target - TP] [First port] [Last port]"
#指定起始端口和结束端口
  print "Usage - ./udp-port.py 128.13.34.13 1 100"
  sys.exit()

ip = sys.argv[1]
start = int(sys.argv[2])
end = int(sys.argv[3])

for port in range(start,end):
  a = sr1(IP(dst=ip)/UDP(dport=port),timeout=5,verbose=0)
#udp探测命令
  time.sleep(1)
#sleep一秒，等待sr1发送完成，避免网络中的延迟误判！
  if a == None:
#None意味着没有收到响应，代表端口是开放的
    print port
  else:
#如果得到了回应，那么一定是port-unreachable回应，代表端口没开放
    pass
```

----
### 0x02 nmap 端扫描

* __{ Usage $: nmap -SU ip }__

 对特定ip端口扫描，如果不指定端口的话，namp默认会对1000常用端口进行扫描，即使是nmap如果是基于UDP的扫描话，也只是利用了UDP端口不可达的这一个特征信息！

 ```
root@jack:~/scripts/端口扫描# nmap -sU 192.168.0.1 
Starting Nmap 7.01 ( https://nmap.org ) at 2016-05-13 10:37 CST
Nmap scan report for 192.168.0.1
Host is up (0.0036s latency).
Not shown: 994 closed ports
PORT     STATE         SERVICE
53/udp   open          domain
67/udp   open|filtered dhcps
123/udp  open|filtered ntp
1026/udp open|filtered win-rpc
1027/udp open|filtered unknown
1900/udp open|filtered upnp
 ```

* __{ Usage $: nmap -sU 192.168.0.1 -p53}__ 扫描指定端口

 ```
root@jack:~/scripts/端口扫描# nmap -sU 192.168.0.1 -p53
Starting Nmap 7.01 ( https://nmap.org ) at 2016-05-13 10:40 CST
Nmap scan report for 192.168.0.1
Host is up (0.0015s latency).
PORT   STATE SERVICE
53/udp open  domain
 ```

* __{ Usaeg $: namp -iL iplist.txt -sU -p 1-20000 }__ 从文件获得IP地址信息，进行批量扫描


