---
title: 漏洞扫描
date: 2016-06-23 18:16
tags: ['Kali渗透测试','漏洞扫描']
toc: true
categories: technology

---
### 0x00 NMAP之漏洞扫描

进入nmap的scripts文件夹下
```
➜  scripts pwd
/usr/share/nmap/scripts
➜  scripts less script.db| wc -l
527
```

可以看到已经有500多个脚本文件了。

```
➜  scripts less script.db| grep vuln | wc -l
83
```

其中有83个是和漏洞攻击/监测有关的。

---
#### smb-vuln-ms 10-061.nse
该漏洞是Stuxnet蠕虫利用的4个0day之一，既是著名的震网病毒，美国为了攻击伊朗的核设施而发动的人类历史上第一个数字核武器。

其主要是利用LAMMAN API去枚举目标系统的共享打印机，通过低版本的windows，Print Spooler权限配置不当不当，使得印请求可在系统目录创建文件，执行任意代码。

所以10-061首先会去探测目标是否有共享打印机，然后去探测目标系统共享打印机的名称，最后再去进行攻击。

但若是该脚本没有发现共享打印机呢？那么我们还可以利用Kali中的__smb-enum-shares.nse__脚本去枚举目标系统中的共享打印机。但是存在一种情况是有时需要知道目标的账号和密码才能实现枚举:__smb-enum-shares.nse --script-args=smbuser=admin,smbpassword=pass__。利用该脚本去发现目标是否存在共享打印机，然后再使用10-061去执行特意功能。

其具体使用方式是连接目标系统的445端口。

对目标进行共享枚举检查:
```
➜  scripts nmap -445 --script=smb-enum-shares.nse 192.168.1.102 
//登陆目标主机以提高探测精确度： 
//--script-args=smbuser=admin,smbpassword=123
```



