
---
title: Linux-PID进程追踪
date: 2017-03-17 08:34
tags: ['渗透手册']
toc: true
categories: technology

---
### 0x00 Shadowsocks

关于 shadowsocks 不只能正常运行的一次pid进程追踪:

```
: 1463919806:0;ps -aux
: 1463919844:0;lsof -p 4468
: 1463919891:0;cat /root/.config/shadowsocks-gui/Local\ Storage/file__0.localstorage
: 1463919909:0;vim /root/.config/shadowsocks-gui/Local\ Storage/file__0.localstorage
: 1463919935:0;cd /root/.config/shadowsocks-gui
: 1463919935:0;ls
: 1463919941:0;cd Local\ Storage
: 1463920055:0;rm file__0.localstorage
: 1463920057:0;rm file__0.localstorage-journal
: 1463920062:0;./start.sh
```

