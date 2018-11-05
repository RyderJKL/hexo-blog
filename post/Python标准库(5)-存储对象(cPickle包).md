---
title: Python表状况(5)-存储对象(cPickle包)
date: 2016-05-27 19:36
tags: ['Python标准库']
toc: true
categories: technology

---
### 0x00 
Python中一切皆对象，当Python运行时，对象存储在内存中，随时等待调用，然而内存中的数据会随着计算机的关机而消失，我们有如何将对象保存到文件进而存储在硬盘上？

我们直接将某个对象所对应位置的数据抓取下来，转换成__文本流__这个过程叫做(serialize),然后将文本流保存到文件中。而但我们从文本中读取对象时，必须要知道该对象的定义，才能懂得如何去重建这一对象。当然，对于Python的内建对象(built-in)由于其类定义已经载入内存，所以不必再在程序中定义这类。但对于用户自行定义的对象，就必须要先定义类。但是对于用户自定义的类，便必须先定义对象对应的类，才能从文件中载入对象 。

### 0x01 将内存中的对象转换为文本流

```
#!/usr/bin/python
#-*-coding:utf-8-*-
import cPickle
#定义一个类
class bird(object):
	have_feather = True
	way_of_reprduction = 'egg'

summer = bird() #创建一个bird对象

fn = 'cpickle.txt'
with open(fn, 'w') as f:
	cpicklestring = cPickle.dump(summer, f)
```
对象summer存储在cpickle.txt文件中

### 0x02 重建对象
从文本中读取文本，存储到字符串中，然后使用cPickle.load()方法将字符串转换成为对象。而此时，程序中必须已经有了该对象的定义。

```
#!/usr/bin/python
#-*-coding:utf-8-*-

import cPickle

class bird(object):
	have_feather = True
	way_of_reproduction = 'egg'

fn = 'cpickle.txt'

with open(fn,'r') as f:
	summer = cPickle.load(f)
```

cPickle包的功能与pickle包几乎相同，而cPickle的速度比pickle包快很多。


