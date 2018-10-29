---
title: TCPDUMP初识
date: 2016-04-10 11:48:52
tags: ['kali第五章','基本工具']
toc: true
categories: technology

---

TCPDUP已经默认安装在unix和linux系统的，但它是NO-GUI抓包分析工具的，所以tcpdump的一切操作都是基于字符界面的！

### 0x00 tcpdump-抓包

.默认情况下tcpdum默认情况下只抓取数据包的68个字节，所以所抓取的信息是有限的，如果需要抓取更多的数据就需要添加tcpdump的参数

---
### 0x01 TCPDUMP的常用参数
 
* 选项与参数：

```
root@$: tcpdump -i eth0 -s 0 -w file.pcap
-i:指定哪个接口来进行抓包
-s:指定抓取多少的数据，0代表无限即原始数据包有多大就抓取多杀！
-w:将抓取到的数据包保存到指定文件里
-r:查看抓取的数据包内容！
```

---
### 0x02 tcpdumpd的筛选器

抓取特定端口下的某种协议的数据包:
```
root@ $ :tcpdump -i eth0 tcp port 22
```

---
#### tcpdump的显示筛选器
```
root@ $: tcpdump -n -r http.cap | awk '(print $3)' | sort -u
选项与参数:
-n：不对IP地址进行域名解析，而是直接显示IP地址！
打印出该文件的第三列的内容(即是显示出所有的ip地址  啦)
最后剔除掉重复的内容！
```

---
#### 对源,目标ip进行显示筛选:
```
root@ $: tcpdump -n src(dst) host [IP] -r http.cap
```

---
#### 根据端口号进行筛选
```
root@ $: tcpdump -n [-X:会以16进制进行显示] udp port 53 -r http.cap
```
---
#### tcpdump的高级筛选
除了对ip，端口，协议的筛选之外，tcpdump还可以进行其他更为高级的筛选.


