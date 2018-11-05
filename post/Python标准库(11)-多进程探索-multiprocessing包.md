---
title: Python标准库(11)-多进程探索-multiprocessing包
date: 2016-07-12 17:02
tags: ['Python标准库']
toc: true
categories: technology
---

### 0x00 进程池
进程池(process pool)可以创建多个进程。

如下代码。

```
# coding:utf-8

import multiprocessing as mul

def f(x):
    return 2**x

pool = mul.Pool(5)
rel = pool.map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])
print(rel)
```

创建了一个可以容纳5个进程的进程池，Pool运行的每个进程都执行f()函数，并利用map()方法讲f()函数作用到表的每个元素上。

Pool还有以下常用的方法:

* __apply_async(func, args)__从进程池中取出一个进程执行func，args为func的参数。它将返回一个AsyncResult的对象，我们可以调用get()方法以获得结果。

* __close()__ 关闭进程池，不再创建新的进程

* __join()__ wait()进程池中的全部进程。但是必须对Pool先调用close()方法才能join.


---
### 0x01 共享资源

我们应该尽量避免多进程共享资源，因为多进程共享资源势必带来进程间相互竞争，而这种竞争又会造成race condition，结果有可能被竞争的不确定行所影响，但若是需要我们依然可以通过共享内存和Manage对象这么做。

---
#### 共享内存

```
# coding:utf-8

import multiprocessing as mul

def f(n, a):
    n.value = 3.14
    a[0] = 5

num = mul.Value('d', 0.0)
arr = mul.Array('i', range(10))

p = mul.Process(target=f, args=(num, arr))
p.start()
p.join()

print num.value
print arr[:]
```

对象Value被设置为双精度数（d），并初始化为0.0，而Array则有固定的类型（i，也就是整数).在Process进程中我们修改了Value和Array对象，并打印结果，主程序看到了两个对象的改变，说明资源确实在两个进程间共享。

---
#### Manager
Manager对象类似于服务器与客户之间的通信(server-client).我们用以一个进程作为服务器，简历Manager来真正存放资源。

```
# condig:utf-8

import multiprocessing as mul

def f(x, arr, l):
    x.value = 4.13
    arr[0] = 5
    l.append('hello')

server = mul.Manager()
x = server.Value('d', 0.0)
arr = server.Array('i', range(10))
l = server.list()

proc = mul.Process(target=f, args=(x, arr, l))
proc.start()
proc.join()

print(x.value)
print(arr.value)
print(l)
```

Manager利用list()方法提供了表的共享方式。


