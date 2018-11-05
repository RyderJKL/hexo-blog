---
title: SMTP扫描
date: 2016-06-10 09:56
tags: ['kali渗透测试','主动信息收集']
toc: true
categories: technology

---
### 0x00 SMTP
SMTP扫描最主要的作用是发现目标主机上的邮件账号。

通过主动对目标的SMTP（邮件服务器）发动扫描。

简单点，我们首先可以使用nc去尝试连接目标邮件服务器，然后使用__VRFYroot__命令探测目标是否有root账号。

---
### 0x01 NMAP之SMTP扫描
当然在使用NMAP扫描SMTP之前我们需要确认对方SMTP端口已经开放了的，这便需要前期的端口扫描了。

然后我们便可以使用NMAP调用与之有关的smtp脚本对其进行扫描了。

```
root@kali:~# nmap smtp.163.com -p25 --script=smtp-enum-users.nse --script-args= smtp-enum-users.methods={VRFY}
#返回结果，并没有发现账号
|_  Couldn't find any accounts
```
NMAP中与smtp扫描有光的脚本程序是smtp-enum-users.nse 
参数:smtp-enum-users.methods={VERY}实际上是指定使用什么方式对其smtp账号进行验证。这里使用能了VERY的方法。

此外我们除了扫描smtp的用户账号之外，还可以扫描smtp是否开放__中继__，就是可以使用邮件服务器中的账号对任意账号发送邮件。


当然我们自己也可以编写Python脚本扫描SMTP服务器，使用VRFY等方式对验证是否存在我们想要的一些账号。


