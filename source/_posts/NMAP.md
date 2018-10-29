---
title: NMAP
date: 2016-06-13 10:58
tags: ['kali渗透测试','主动信息收集']
toc: true
categories: technology

---
### 0x00 NMAP常用参数介绍


---
### 0x01 TARGET SPECIFICATION 目标发现
##### -iL 添加扫描待ip列表文件

##### -iR 随机选择目标
不用指定目标ip，nmap对自动对全球的ip随机选择100个进行扫描

```
root@kali:~# nmap -iR 100  -p100
```

#####  --exclude 排除扫描
当想要对某个ip地址段进行扫描，但是并不扫描其中特定的一些ip

```
root@kali:~# nmap 192.168.1.0/24 --exclude 192.168.1.1-100
```

#####  --excludefile 
从文件列表中排除不需要扫描的ip





---
### 0x02 HOST DISCOVERY 主机发现

##### -sn 端口扫描
Ping Scan - disable port scan
  

##### -Pn  完全扫描
Treat all hosts as online -- skip host discovery
通常用于扫描防火墙


#####  -PS/PA/PU/PY[portlist]　协议扫描
TCP SYN/ACK, UDP or SCTP discovery to given ports
基于何种协议去进行扫描


#####   -PO[protocol list] 使用ip协议扫描
IP Protocol Ping


##### -n/-R
 Never do DNS resolution/Always resolve [default: sometimes]
* -n：不进行nds解析
* -R：对其进行反向解析

##### --dns-servers 更换DNS服务器
<serv1[,serv2],...>: Specify custom DNS servers
更换系统默认DNS服务器，以得到不同的扫描结果

```
root@kali:~# nmap --dns-servers 8.8.8.8 www.sina.com
```


##### --traceroute 路由追踪
Trace hop path to each host
基本等同于__traceroute__命令

```
root@kali:~# nmap www.baidu.com --traceroute -p80
```

---
### 0x03 端口发现 SCAN TECHNIQUES(扫描技术) 

##### -sS/sT/sA/sW/sM 基于TCP的端口发现
TCP SYN/Connect()/ACK/Window/Maimon scans
基于TCP的SYN/全连接/ACK/窗口/Maimon 扫描

##### -sU 基于UPD协议的扫描
但是UDP的扫描的准确率并不高  

##### -sN/sF/sX 基于TCP的空/finish/xmas的扫描
TCP Null, FIN, and Xmas scans

##### --scanflags <flags>
Customize TCP scan flags
其实以上对于TCP的扫描都是对tcpflags位的组合，所以我们自然是可以自定义组合的。

##### -sI 僵尸扫描 
<zombie host[:probeport]>: Idle scan

##### -sY/sZ 基于SCTP协议(少用)
SCTP INIT/COOKIE-ECHO scans
  
##### -b 基于FTP的中继扫描
<FTP relay host>: FTP bounce scan


---
### 0x04 指定端口和扫描菜单
PORT SPECIFICATION AND SCAN ORDER

##### -p 扫描特定类型端口/范围
<port ranges>: Only scan specified ports
Ex: -p22; -p1-65535; -p U:53,111,137,T:21-25,80,139,8080,S:9

##### --exclude-ports 排除不需扫描的端口范围
<port ranges>: Exclude the specified ports from scanning

##### -F 快速扫描
Fast mode - Scan fewer ports than the default scan
  
##### -r 按顺序扫描
Scan ports consecutively - don't randomize
如果我们对1-1000个端口发起扫描，namp默认会在每次扫描中随机选择，-r会使namp按照从大到小的顺序进行。

#### --top-ports <number>
只扫描常用端口的top n
Scan <number> most common ports

---
### 0x05 服务/版本探测
SERVICE/VERSION DETECTION

##### -sV 
Probe open ports to determine service/version info
-sV会使用nmap中的大量特征库去进行探测比对

##### --version-intensity 
<level>: Set from 0 (light) to 9 (try all probes)
虽然-sV会nmap会调用自身大量的特征库资料去进行匹配，但是这样势必会增加比对的时间成本，所以我们可以探测阶段扫描的强度去最大限度的节省扫描的时间成本。

##### --version-trace
Show detailed version scan activity (for debugging)
对扫描过程进行跟踪，显示扫描的具体过程

---
### 0x06 SCRIPT SCAN 脚本扫描

##### -sC: equivalent to --script=default

##### --script=<Lua scripts>: <Lua scripts> is a comma separated list of directories, script-files or script-categories
具体的脚本文件

##### --script-args=<n1=v1,[n2=v2,...]>
provide arguments to scripts
脚本扫描的参数

##### --script-trace
Show all data sent and received
脚本扫描追踪

##### --script-updatedb
Update the script database.
更新nmap脚本库中的文件

#### --script-help=<Lua scripts>
Show help about scripts.
<Lua scripts> is a comma-separated list of script-files or script-categories.
脚本帮助文件，但对于一个陌生脚本时可以使用--script-help来查看该文件的使用说明

```
root@kali:/usr/share/nmap/scripts# nmap --script-help=http-xssed.nse
```



---
### 0x07 OS DETECTION 操作系统检测

##### -O
Enable OS detection
启用操作系统检测

##### --osscan-limit
Limit OS detection to promising targets
限制操作系统的检测，比如只发现Linux的或者，Windows的。

---
### 0x08 时间和性能
TIMING AND PERFORMANCE 
由于nmap的强大，甚至有时会带来破坏性的扫描，因此很容易被主机发现，此时我们有必要限制nmap的扫描性能。当然也能最大限度的开放nmap的扫描性能。

Options which take <time> are in seconds, or append 'ms' (milliseconds),
  's' (seconds), 'm' (minutes), or 'h' (hours) to the value (e.g. 30m).
  -T<0-5>: Set timing template (higher is faster)

##### --min-hostgroup/max-hostgroup <size>
Parallel host scan group sizes
指定并行扫描的主机数量，每次最大或者最小扫描多少个主机

##### --min-parallelism/max-parallelism <numprobes>
Probe parallelization

##### --max-retries <tries>
Caps number of port scan probe retransmissions.
最大的探测次数

##### --host-timeout <time>
Give up on target after this long
超时时间

##### --scan-delay/--max-scan-delay <time>
Adjust delay between probes
delay 扫描探测的延时时间/间隔时间

##### --min-rate <number>
Send packets no slower than <number> per second
每秒发包数不少于多少
 
##### --max-rate <number>
Send packets no faster than <number> per second
每秒发包数不多于多少


---
### 0x09 防火墙躲避/欺骗
FIREWALL/IDS EVASION AND SPOOFING

#### -f --mtu <val>
fragment packets (optionally w/given MTU)
设置MTU之

#### -D <decoy1,decoy2[,ME],...>
Cloak a scan with decoys
伪造源地址，但并不是正真的源地址，而是增加一些噪声源，用以迷惑目标ip，增加对方的分析难度。如果你始终都会发现我的话，我也会挣扎一下的，就像真假悟空一样。

#### -S  -e  -Pn 源地址ip伪造
-S <IP_Address>: Spoof source address
-e <iface>: Use specified interface
-Pn :防火墙扫描
使用指定源地址伪造源地址ip

```
root@kali:~# nmap -S 192.169.1.123 -e eth0 -Pn 192.168.0.1
```

##### -g/--source-port <portnum>
Use given port number
使用指定的源端口

```
root@kali:~# nmap -g10000 192.168.0.1
```

##### --proxies <url1,[url2],...>
Relay connections through HTTP/SOCKS4 proxies
如果软件本身不支持代理的话，那么我们只有使用系统代理链了。但，幸运的是nmap本身死支持代理的。

##### --data <hex string>
Append a custom payload to sent packets
添加用户自定义的数据字段,但是字段必须是16进制数。

##### --data-string <string>
Append a custom ASCII string to sent packets
添加用户自定义的数据字段

##### --spoof-mac 欺骗mac地址
<mac address/prefix/vendor name>
Spoof your MAC address
伪造一个mac地址，以混淆视听

##### --badsum
Send packets with a bogus TCP/UDP/SCTP checksum
差错校验值


