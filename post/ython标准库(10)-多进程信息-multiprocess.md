---
title: Python标准库(10)multiprocess
date: 2016-07-20 12:39
tags: ['Python标准库']
toc: true
categories: technology
---

### 0x00 多进程初步
__subprocess__本身就是被设计为一个shell的，而不是一个多进程的管理包，所以它存在两点局限行:1)subprocess总是运行外部的程序，而不是一个python脚本的内部函数；2）经常间只通过管道进行文本交流。

__multiprocessing__是python中的多进程管理包，与__threading.Thread__类似可以使用__multiprocessing.Process__对象来创建一个进程。该进程可以运行python内部编写的函数。与__Thread__对象一样拥有start(),run(),join()方法。此外，multiprocessing包中也包含有Lock/Event/Seamphore/Condition类，可以看到，multiprocessing包与threading包使用同一套API，但是需要注意以下:
* multiprocessing提供了threading包中没有的IPC(PIPE和Queue)，效率上可以更高,应该优先使用Pipe和Queue，而避免使用Lock/Event/Semaphore/Condition等同步方式。
* 多线程中，可以很容易的共享资源，比如全局变量或者传递参数，但是在多进程下，由于每个进程有自己的独立内存空间，以上方法并不使用。但是可以通过__共享内存__\和__Manager__方法来共享资源。但是却提高了程序的复杂度并且降低了程序的效率。


```
#!/usr/bin/python
# coding:utf-8


import os
import threading
import multiprocessing

def worker(sign, lock):
    lock.acquire() #使用Lock同步，在一个任务输出以后，再允许另一个任务输出，可以避免多个任务同时向终端输出
    print(sign, os.getpid())
    lock.release()

print('main', os.getpid()) #获得进程pid


record = []
lock = threading.Lock()#获得线程锁
for i in range(5):
    thread = threading.Thread(target=worker, args=('thread', lock))
    thread.start()
    record.append(thread)

for thread in record:
    thread.join()
#join方法，调用该方法的线程将等待直到该Thread对象完成，再恢复运行。
#与进程间调用wait()方法类似


record = []
lock = multiprocessing.Lock()

for i in range(5):
    process = multiprocessing.Process(target=worker, args=('process', lock))
    process.start()
    record.append(process)

for process in record:
    process.join()

```

---
### 0x01 Pipe和Queue

---
#### Pipe
和Linux中的管道(PIPE)和消息队列(message queue）一样，multiprocessing包中有Pipe类和Queue类来支持这两种IPC机制。

首先Pipe可以是单向(half-duplex)也可以是双向(duplex)。我们可以通过__multiprocesssing.Pipe(duplex=False)创建单向管道(默认位双向)，单向管道只允许管道一段的进程输入，而双向管道允许从两端输入。

下面是简单的Pipe使用.

```
# coding:utf-8

import multiprocessing as mul

def proc1(pipe):
    pipe.send('hello')
    print('proc1rec:', pipe.recv())

def proc2(pipe):
    print('proc2rec:', pipe.recv())
    pipe.send('hello,too')

#创建pipe对象，返回一个含有两个元素的表，每个元素代表pipe的一端
pipe = mul.Pipe()

p1 = mul.Process(target=proc1, args=(pipe[0],))

p2 = mul.Process(target=proc2, args=(pipe[1],))

p1.start()
p2.start()
p1.join()
p2.join()
```

---
#### Queue
Queue和Pipe类似，都是先进先出的结构，但是Queue允许放入/取出多个进程。Queue使用__multiprocessing.Queue(Maxsize)__来创建。Maxsize表示队列中可以存放的最大对象数量。

```
# coding:utf-8

import os
import time
import multiprocessing

def inputQ(queue):
    info = str(os.getpid()) + '(put):' + str(time.time())
    queue.put(info)

def outputQ(queue, lock):
    info = queue.get()
    lock.acquire()
    print(str(os.getpid()) + '(get):' + info)
    lock.release()

#main函数
record1 = []#存储加入的进程
record2 = []#存储输出的进程
lock = multiprocessing.Lock()#防止终端输出混淆
queue = multiprocessing.Queue(3)

#input process
for i in range(10):
    process = multiprocessing.Process(target=inputQ, args=(queue,))
    process.start()
    record1.append(process)

#output process
for i in range(10):
    process = multiprocessing.Process(target=outputQ, args=(queue, lock))
    process.start()
    record2.append(process)

for p in record1:
    p.join

queue.close()

for p in record2:
    p.join

```





