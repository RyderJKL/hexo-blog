---
title: Python标准库(7)-信号(singal包)
date: 2016-06-4 22:16
tags: ['Python标准库']
toc: true
categories: technology

---
### 0x00
singal包负责在Python程序内部处理信号，比如预设信号处理函数，暂停并等待信号，以及定时发出SIGALRM等。但要注意的是，signal包主要是针对的UNIX平台，定义windows的支持并不完备。

Python中所用的信号名和Linux一致，比如导入signal
```
import signal

print signal.SIGALRM
print signal.SIGCONT
print signal.SIGKILL
运行结果:
14
18
9
```
---
### 0x01 预设信号处理函数
signal包的核心是使用signal.signal()函数来预设(register)信号处理函数:
```
signal.signal(signalnum, handler)
```
signalnum为某个信号，handler为该信号的处理函数。
首先执行以下test.py脚本
```
#!/usr/bin/python
import signal
def myhandler(signum, frame):
    print('i received:', signum)
    
signal.signal(signal.SIGTSTP, myhandler)
signal.pause()
print("end of signal demo")
```
在主程序中，我们首先使用signal.signal()函数来预设信号处理函数。然后执行signal.pause()来让该进程暂停以等待信号。当有信号传递给该进程时，进程从暂停中恢复，并根据预设，执行SIGTSTP信号处理函数myhandler().

myhandler()的两个参数一个用来识别信号(signum),另一个用来获得信号发生时，进程栈的状况(stack frame),这两个参数都由signal.signal()来传递。

---
### 0x02 定时发送SIGALRM信号
函数signal.alarm()用于在一定时间后，向进程自身发送SIGALRMX信号:
```
#!/usr/bin/python

import signal

def myhandler(signum, frame):
    print("now,it's the time")
    exit()

signal.signal(signal.SIGALRM, myhandler)
signal.alarm(5)
while True:
    print("nor yet")

运行结果:
......
nor yet
nor yet
nor yet
nor yet
now,it's the time
```
在signal.alarm()执行5秒之后，进程将向自己发送SIGALRM信号，然后，信号处理函数myhandler开始执行。

---
### 0x03 发送信号
signal包的核心是设置信号处理函数，但是除了signal.alarm()能向自身发送信号之外，并没有其它的发送信号的功能。但在os包中，有类似与Linux kill命令的函数:
* os.kill(pid, sid)
* os.killpg(pgid, sid)

可以分别向进程和进程组发送信号，sid为信号所对应的整数或者signal.SIG*。


