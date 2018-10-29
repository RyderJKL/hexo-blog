---
title: SNMP扫描
date: 2016-06-10 09:56
tags: ['kali渗透测试','主动信息收集']
toc: true
categories: technology

---
### 0x00 SNMP扫描
简单网络管理协议扫描，SNMP的客户端通常使用的是162端口，而服务器通常使用的是161端口。有些类似于DHCP协议（基于UDP之上的应用层协议，服务端使用67port，客户端使用68port）了。一个小发现，服务端喜欢使用单数，而客服端会是双数。

当一网络环境已经初具规模时，若是还是使用人工进行网络的管理的，效率会很低的。这是便需要基于SNMAP的网络监控机制，负责监控内部网络的比如网络交换机，服务器，防火墙，cpu，带宽，并发连接数等系统资源。

SNMP无论是对网络管理员还是hacker而言都是信息的金矿宝地。但是很多的网络管理者往往错误的对待SNMP的配置规则，只是简单的以为只要网络连通了边万事大吉了。

比如SNMP的默认配置中会使用public来作为communicate的默认秘钥。如果是private的话，那便更好玩了，直接更改它的SNMP配置。要是manager，那简直不可想像。。。对于这些简单的SNMP配置，简单的字典爆破就可以搞定了。


---
### 0x01 SNMP 的MIB库
SNMP的工作原理其实就是通过SNMP的客户端(但是客户端必须先导入对应的MIB库)，然后通过MIB库来获得服务器信息。

国际标准组织制定了一个MIB(Management Information Base) Tree的SNMP查询标准库(树形网络设备管理功能数据库)。通过该库可以查询OS或者服务器的一些常用信息。有的设备商也会有自己的MIB库，如思科等。

---
#### 0x02 SNMP的服务端
在Windows下打开添加删除程序，添加windows组件，管理和监控工具，安装SNMTP服务。然后打开服务，可以看到现在多出了，snmp servers和

snmp中的陷进，一台电脑一旦安装snmp便成为snmp的服务端了，此时我们可以通过客户端对其发起查询请求。若是服务端没有收到查询请求，那么该服务器上关于电脑性能，流量等参数信息是不会主动向外发送的。

但若是我们对snmp的陷阱进行配置，既是对团体主机(目标主机:该主机一般会是一台监控主机)和陷阱目标进行配置，snmp变回将系统性能参数(我的某个进程down了，内存快慢了，我要没电了)发送给该目标主机。

再来看看snmp的安全选项，这是我们最感兴趣的选项，向吸血鬼闻到血一般，毫无抗拒之力，哈哈。

首先snmp,__安全选项__的默认设置本身就是不安全的，因为他__允许接收来自任何主机的SNMP数据包__。验证信息也是将默认的__public__\作为__communicate__。这将会埋下极大的安全隐患。

需要知道的是SNMP使用的明文传输。

---
### 0x03 onesixtyone
Kali里面也集成了一款常用的MIT查询工具__onesixtyone(161)__。161是SNMP服务端的端口。
但是onesixtyone并没有很强大，会想NMAP般获得大量的信息，__onesixtyone__主要作用是用于探测目标服务器的__communicate__是否是基于弱密码的，比如public:
```
➜  ~ onesixtyone 192.168.0.113 public
```
若是没有任何返回信息，那么代表目标没有使用mor的commnicate，或者目标没有安装SNMP服务端。

对于第一种情况我们可以结合字典对其进行爆破

__{ Usage $:  onesixtyone -c dict.txt -i hosts -o my.log -w 100
}__

* -i hosts:表示待扫描的主机列表。

```
➜  ~ dpkg -L onesixtyone   
#查询onesixtyone自带的字典信息                          
/usr/share/doc/onesixtyone/dict.txt
➜  ~ onesixtyone -c /usr/share/doc/onesixtyone/dict.txt 
192.168.0.103 -o my.log -w 100 
#使用字典对其进行爆破
```

---
### 0x04 snmpwalk
snmpwalk可以查询到的系统参数信息将会远远多于161扫描。

__{ Usage $: snmpwalk host -c communicate -v 2c }__

* -c:表示使用的communicate
* -v：表示使用的snmpwalk版本，目前有三个版本:1c,2c,3c。

```
➜  ~ snmpwalk 192.168.0.113 -c public -v 2c
```

使用MIB中特定的UID号查询目标主机中的特定信息。
```
➜  ~ snmpwalk -c public -v 2c 192.168.0.113 uid
```

---
### 0x05 snmapcheck
snmpcheck 获得的信息可读性会优于snmapwalk。

```
➜  ~ snmpcheck -t hosts
```
可是使用__snmpcheck -h__查询更多使用方式，




