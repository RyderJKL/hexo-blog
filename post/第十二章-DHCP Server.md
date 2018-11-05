---
title: DHCP Server
date: 2016-09-01
tags: ['鸟哥服务器篇读书笔记']
toc: true
categories: technology
---

### 0x00 DHCP初识
DHCP(Dynamic Host Configuration Protocol)，动态主机配置协议，DHCP服务可以自动分配IP与相关的网络参数，以次客户端可以使用DHCP提供的网络参数自动连接上Internet。

### 0x01 DHCP的运行原理
首先，DHCP通常是用于区域网的通信以协议，当客户端发送广播包给整个物理网络中的所有主机时，若该区域网下有DHCP服务器，那么它会自动响应客户端的IP参数请求。

一般DHCP会通过客户端的MAC地址为其分配相应的网络参数。

##### 观察自己的MAC地址

```
$ ifconfig | grep HW
```

##### 观察别人的MAC地址

```
$ ping -c 3 192.168.1.235
$ arp -n
```



