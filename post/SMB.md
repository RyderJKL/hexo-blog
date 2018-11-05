---
title: SMB扫描
date: 2016-06-10 15:16
tags: ['kali渗透测试','主动信息收集']
toc: true
categories: technology

---
### 0x00
SMB(Server Message Block)协议，服务消息块协议，最开始是用于微软的一种消息传输协议，因为颇受欢迎，现在已经成为跨平台的一种消息传输协议。同时也是微软历史上出现安全问题最多的协议。它的实现复杂，并且默认在所有windows上开放。

---
### 0x01 nmap -v  smb扫描

__{ Usage $: ➜  ~ nmap -v -p port hosts }__

```
➜  ~ nmap -v -p139,445 192.168.0.105 
```
SMB常用的端口有两个139和445，较新的操作系统会使用445端口。

当然我们不能简单的单凭一个端口就去断定OS一定是windows的。NMAP提供了更高级的扫描方式。

```
root@kali:~# nmap 192.168.86.132 -p139,445 --script=smb-os-discovery.nse


PORT    STATE SERVICE
139/tcp open  netbios-ssn
445/tcp open  microsoft-ds
MAC Address: 00:0C:29:10:88:B3 (VMware)

Host script results:
| smb-os-discovery: 
|   OS: Windows XP (Windows 2000 LAN Manager)
|   OS CPE: cpe:/o:microsoft:windows_xp::-
|   Computer name: my-xp
|   NetBIOS computer name: MY-XP
|   Workgroup: WORKGROUP
|_  System time: 2016-06-10T18:49:22-07:00


```

同样上一个机器只是用来发现机器上是否有运行SMB协议的，但仅仅是发现远远不够，我们还可以更高效使用nmap去发现该端口是否有漏洞存在:

```
➜  ~ nmap -v -p135,445 --script=smb-check-vulns --script-args=unsafe=1 hosts -Pn
```
* 脚本smb-check-vulns对目标进行smb漏洞检查
* 脚本smb-check-vulns可以携带参数对其进行unsafe扫描
* -Pn：尝试绕过防火墙

unsafe将会对目标主机造成较大破坏，需警慎使用。

以上脚本信息都是只针对windows的哦！






---
### 0x02 nbtscan
nbtscan优势在于可以在同意局域网下进行夸网段扫描，比如主机
所在网段为192.168.1.*,nbscan可以对192.168.86.*所在网段的主机进行扫描。

```
root@kali:~# nbtscan -r 192.168.0.1
```


---
### 0x03 enum4linux
在linux上枚举出windows的命令，同样可以进行夸网段的扫描，并且扫描返回的信息量比较多。但是它不支持大范围的网路扫描，但是这个不是问题，一个Python脚本就搞定了。

```
root@kali:~# enum4linux -a 192.168.86.132
```


