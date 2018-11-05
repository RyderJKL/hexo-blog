---
title: Kali网络配置
date: 2016-07-31 21:24
tags: ['Kali渗透测试','Kali安装与环境优化']
toc: true
categories: technology
---
### 0x00 Kali 网络配置
当在一个有DHCP服务器的网络环境中，kali会自动获取到IP地址，如果获取失败则将手动配置网络。

#### 临时ip地址(电脑重启后失效)

自动获得ip地址：

```
$ dhclient eth0
```

手动获得ip地址：

```
$ ifconfig eth0 192.168.1.10/11
```

查看网络配置:

```
$ ifconfig eth0
```

添加网关:

```
$ route add default gw 192.168.1.1
```

查看：

```
$ netstat -nr
```

静态路由的添加并指定网卡:

```
$ route add -net 192.168.0.0/24 gw 192.168.1.100 eth0
```

编辑DNS:

```
$ echo nameserver 8.8.8.8 > /etc/resolv.conf
```

重启网卡:

```
$ /etc/init.d/networking restart
```

重启网络管理:

```
$ /etc/init.d/network-manager restart
```

#### 设置固定ip
编辑网卡配置文件路径:

```
$ vi  /etc/network/interfaces

    allow hotplug eth0
    iface eth0 inet static
    address 192.168.0.1
    netmask 255.255.255.0
    gateway 192.168.0.254
    dns-nameservers 192.168.0.10 8.8.8.8

#auto lo
#iface  to  inet loop back
```

当然也可以安装wicd，它可是比系统自带的`network-manager`好用多了：

```
$ apt-get install wicd
$ /etc/init.d/network-manager stop             //停用network-manager
$ update-rc.d network-manager disable      //禁止network-manager开机启动
$ wicd-client                             //启动wicd
```




