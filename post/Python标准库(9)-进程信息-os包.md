---
title: Python标准库(9)-进程信息-os包
date: 2016-07-13 
tag: Python标准库
---

---
### 0x00 os包中的相关函数
##### os.uname() 
返回操作系统相关信息，类似于Linux中的uname命令

##### os.umask() 
设置该进程创建文件时的权限mask，类似于Linux中的umask命令
get

##### os.get(*)
查询，*由以下代替
uid,euid,resuid,gid,egid,resgid:权限相关，其中resuid主要用来返回saved UID，最小权限。
pid,pgid,ppid,sid:进程相关。

#### put(*)
设置，(*)由以下代替
euid,egid:用于改写euid,egid
uid,gid:改写进程的uid，gid。只用super user才有改写uid，gid的权利。
pgid,sid:改写进程所在进程组（process group）和会话(session)。
getenviron():获得进程的环境变量
setenviron():更改进程的环境变量


##### saved uid 和saved gid
要想要使得saved uid和saved gid始终保持最好的最小原则工作很难。因为当运行一个Python脚本时，实际运行的是Python这个解释器，而不是Python脚本文件，不同于C语言直接有C语言编译成的可执行文件。我们必须更改Python解释器本身的权限来运用saved UID机制，但这又很危险。只需执行一个由普通用户拥有的脚本，就可以得到super user的权限！



