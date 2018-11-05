---
title: 解决kali升级空间不足问题
date: 2016-02-23 21:24
tags: ['Kali渗透测试','Kali安装与环境优化']
toc: true
categories: technology

---
### 0x00 原因分析
如果/var是单独分区的，可能是分区容量过小，更新系统或者安装大型软件时，使用到了/var目录，因此提示空间不足。使用一下办法即可解决。

方法1：

```
sudo apt-get clean
sudo apt-get autoremove
```

然后重启机器,如果仍然空间不足，使用方法2。

方法2：
用symbolic links來解決

```
mv /var/spool /home //先移动/var下较大目录到/home或者
其他某一空间足够大的目录。
ln -s /home/spool /var //做一个symbolic link。
/var/spool指向/home/spool
以此来解决var空间不足的问题。
```

---
### 0x01 原因分析2
如果/var没有单独分区，则系统默认共享使用/home目录，若此时提示/var空间不足，则说明/home空间不足，这种情况，建议重新安装系统，重新规划分区结构。一般来说，/var目录2G-4G为好，或者不分区，共享/home。


