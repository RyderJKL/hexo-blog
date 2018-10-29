---
title: Python标准库(8)-threading包-多线程
date: 2016-06-4 23:16
tags: ['Python标准库']
toc: true
categories: technology

---
### 0x00 OOP创建线程
Python主要通过标准库中的threading包来实现多线程。
下面来看一个使用OOP(Object-Oriented programming)的方法实现多线程。

OOP方法的核心是继承__threading.Thread__类。

```

import threading
#导入threading包以实现多线程
import time
import os

def doChore():
    #doChore相当于额外的函数功能
    time.sleep(0.5)


class BoothThread(threading.Thread):
#BoothThread继承自threading.Thread类
    def __init__(self,tid,monitor):
        self.tid = tid
        self.monitor =monitor
        threading.Thread.__init__(self)
#由于继承于threading.Thread类，执行初始化时调用父类
    def run(self):
        while True:
            monitor['lock'].acquire()
            #互斥锁，尝试获得锁，加锁或者当其它使用者得到锁时进行等待
            if monitor['tick'] != 0:
                monitor['tick'] = monitor['tick']-1
                print(self.tid, ':now lef:', monitor['tick'])
                doChore()
            else:
                print("Thread_id", self.tid, "no more tickets")
                os.eixt(0)
                #当tickets售完以后立刻退出
            monitor['lock'].release()
            #释放锁
            doChore()

monitor = {'tick': 100, 'lock': threading.Lock()}
#使用一个词典monitor来存放全局变量，由于词典是可变对象，所以当它被传递给函数时，函数使用的依然是同一个对象，
#相当于被多个线程所共享，这算是一个多进程乃至多线程的编程的一个技巧。
#其中lock是threading.Lock的一个对象
for k in range(10):
    new_thread = BoothThread(k, monitor)
    new_thread.start()
```

线程中除了__star()__方法\和__run()__方法之外，还有__join()__方法，调用该方法的线程将等待直到Thread对象完成，在恢复运行，这与进程调用__wait()__方法是类似的。


对象一旦被建立，就可以被多个线程共享，下面的对象用于处理多线程同步:

*  __threading.Lock对象__:互斥锁，mutex，有__acquire()__和__release()__方法。

* __threading.Condition对象__:conditon variabe和mutex是一起使用的，所以当对象建立时，会包含一个Lock对象。可以对Condition对象调用acquire()和release()方法。
 
* __wait()__方法:相当于cond_wait()
* __notify_all()__方法:相当于cond_broadcast()
* __notify()__:与notify_all()功能类似，但是只唤醒一个等待的线程，而不是全部。

__threading.Semaphore__对象，semaphore也就是计数锁。创建对象的时候可以使用一个整数作为一个计数上限，与Lock类似，也有Lock的两个方法。

__threading.Event__对象: 与threading.Condition相类似，相当于没有潜在的Lock保护的condition variable。对象有True和False两个状态。可以多个线程使用wait()等待，直到某个线程调用该对象的set()方法，将对象设置为True。线程可以调用对象的clear()方法来重置对象为False状态。


