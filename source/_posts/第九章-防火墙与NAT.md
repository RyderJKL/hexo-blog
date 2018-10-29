---
title: 防火墙与NAT
date: 2016-8-31 
tags: ['鸟哥服务器篇读书笔记']
toc: true
categories: technology
---

### 0x00 防火墙初识
防火墙三大守护原则：
* 划分出被信任与不被信任的网络
* 切割出可以提供Internet的服务与必须受保护的服务
* 分析出可以接受与不可接受的数据包状态



---
### 0x01 TCP Wrappers
对TCP Wrappers的设定是针对`etc/hosts.{allow|deny}`来设置的：

* 首先以`/etc/hosts.allow`为优先比较对象，符合该规则就放行
* 再以`/etc/hosts.deny`对比，符合规则就屏蔽掉
* 若是以上两条都不符合，择默认为通过

```
$ vim /etc/hosts.allow

ALL: 127.0.0.1 #代表接受本机的去不服务
```



---
### 0x02 iptables
iptables利用封包过滤机制来分析数据包头，将分析结果与之前定义的规则进行对比，以次判断该数据包是否可以进入主机或者被丢弃。

注意防火墙的比对规则是有顺序的，并且该顺序不可逆。

Linux中的iptables默认有三个表格`filter`,`nat`,`mangel`:

##### filter
filter（过滤器）主要与进入Linux本机的数据包有关
* INPUT:主要与进入本机Linux的数据包有关
* OUTPUT:主要与Linux本机发送的数据包有关

##### nat(地址转换)
nat是Network Address Translation的缩写，主要用于网络路由转发有关。
* PREROUTING:在进行路由判断之前所进行的规则
* POSTROUTING:在进行路由判断之后要进行的规则。
* OUTPUT:与发送出去的数据包有关

##### mangel(破坏者)
这个少用。


---
### 0x03 防火墙简单实例


---
### 0x04 NAT服务器设定
NAT(Network Address Translations)服务器的两个主要作用，一个是修改来源IP，一个是修改目标IP，于此对应的是来源NAT(Source NAT)与目标NAT(Destination NAT)。

SNAT主要用来处理内部LAN连接到internet的使用方式，而DNAT则是主要用在内部主机想要架设可以让internet访问的服务器。

NAT服务器与路由器的区别:

通常，NAT服务器一定是路由器，但是NAT服务器会修改IP包头的资料，所以与单纯转发封包的路由器不同。

