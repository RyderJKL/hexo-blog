---
title: 使用Nmap批量提取IP以及MAC地址
date: 2017-02-08 12:19
tags: ['渗透手册']
toc: true
categories: technology

---

### 0x00 使用 Nmap 


使用nmap -sV命令以后提取网段中的ip:

```
$ ifconfig 
$ nmap 192.168.0.* >>IP1.txt  

$ cat IP1.txt | grep 'report for' | cut -d" " -f6 | cut -d '(' -f2| cut -d ')' -f1 >> allip.txt

$ cat IP1.txt | grep "MAC" >> mac.txt         
$ cat -n mac.txt | cut -d":" -f  2-7 | cut -d ' ' -f 2 >> allmac.txt
```

