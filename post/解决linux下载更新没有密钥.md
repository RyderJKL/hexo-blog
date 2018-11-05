---
title: 解决linux下载更新没有密钥
date: 2016-05-20
tags: ['Kali安装与环境优化']
toc: true
categories: technology

---

出现如下错误:

```
正在读取软件包列表... 完成
  W: 以下 ID 的密钥没有可用的公钥：
1397BC53640DB551
```

解决办法：

```
root@jack:~# gpg --keyserver subkeys.pgp.net --recv 640DB551
# xxx改为公钥中最后8位即可！
```
