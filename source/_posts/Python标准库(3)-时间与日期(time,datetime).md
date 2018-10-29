---
title: Python标准库(3)时间与日期
date: 2016-05-11 15:30
tags: ['Python标准库']
toc: true
categories: technology

---
### 0x00
计算机只会为何一个挂钟时间(wall clock time),这个时间是从某个固定的起点到现在的时间间隔，时间点的选择与计算机相关，但一台计算机而言，这个时间点事固定的，其它日期也是基于此时间点计算而来的。此外计算机还可以测量CPU实际上的运行时间，即处理器时间(processor clock time),以测量计算机性能！

### 0x00 time包

```
# -*-coding:utf-8-*-
import time
print(time.time())#挂钟时间，单位:秒
print(time.clock())#c处理器时间，单位:秒
print(time.gmtime())#返回struct_time格式的UTC时间
print(time.localtime())#返回struct_time格式的当地时间
print(time.mktime(st))#将struct_time格式转换成wall clock time
```

### 0x02 datetime包

datetime包是基于time的高级包，可以理解为两部分time包(对应datetime.date类)和date包(对应datetime.time类)，只讲datetime.datetime类。

```
# -*-coding:utf-8-*-
import datetime
t = datetime.datetime(2016,5,12,19,31)
print(t)
输出:
2016-05-12 19:31:00
```
所有返回的t包含的属性有:hour, minute, second, microsecond(微秒), year, month, day, weekday(周几)

* __运算__

datetime包还定义了时间间隔对象(timedelta),一个时间点(datetime)加上一个时间间隔(timedelta)可以得到一个新的时间点(datetime),同理，两个时间点相减会得到一个时间间隔。

```
import datetime

t = datetime.datetime(2016,5,12,19,31)
t_next = datetime.datetime(2016,5,22,18,23)
deltal1 = datetime.timedelta(seconds = 4000)
deltal2 = datetime.timedelta(weeks = 4)
print(t+deltal1)
print(t+deltal2)
输出:
2016-05-12 20:37:40
2016-06-09 19:31:00
```
datetime.timedelta的参数可以是seconds, weeks, days, hours, milliseconds, miroseconds.
datetime对象之间还可以进行比较
```
print(t > t_next)
返回:False
```

* __datetime对象与字符串转换__

一种方法是使用格式化读取的方式读取时间信息
```
# -*-coding:utf-8-*-

from datetime import datetime

format = "output-%Y-%m-%d-%H%M%S.txt"
str = "output-1992-3-21-203234.txt"
t = datetime.strptime(str, format)
print t
输出:
1992-03-21 20:32:34
```
也可以反过来调用datetime的strftime()方法将datetime对象装换为特定格式的字符串
```
print(t.strftime(format))
输出:
output-1992-03-21-203234.txt
```


