---
title: Python标准库(11)-math与random包
date: 2016-07-12 19:12
tags: ['Python标准库']
toc: true
categories: technology
---

### 0x00 math包
math主要处理数学相关的运算，math包定义了两个常数:

* __math.e__ 自然常数e
* __math.pi__ 圆周率pi

下面是常用的运算函数:
* __math.ceil(x)__ 对x向上取整，如x=1.2，返回2
* __math.floor(x)__　对ｘ向下取整，如ｘ＝1.2，返回1
* __math.pow(x, y)__　指数运算，得到ｘ的ｙ次方
* __math.log(x)__ 对数，默认基底为e，可以使用base参数来改变对数的基底，比如math.log(100, base=10)
* __math.sqrt(x)__ 平方根

三角函数,接受一个弧度为单位的x作为参数:
math.sin(x),math.cos(x),math.tan(x),math.asin(x),math.acos(x),math.atan(x)

角度和弧度互换:math.degress(x),math.radians(x)

---
### 0x01 random包
* __random.seed()__ 可以改变随机数生成器的种子seed.
* __random.choice()__ 从序列的元素中随机挑选一个元素,如:random.choice(range(10)
* __random.sample()__ 从序列中随机挑选k个元素
* __random.shuffle()__ 将序列中的所偶元素随机排序
* __random.random(a, b)__ 随机生成一个实数，在[a, b)范围内
* __random.uniform(a, b)__ 随机生成一个实数，在[a, b]范围内

```
import random

all_people = ['jack', 'machl', 'chen', 'wnag', 'haha']
random.shuffle(all_people)
for i, name in enumerate(all_people):
    print(i, ':' + name) 
```
 


