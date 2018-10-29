---
title: Python标准库(13)-循环器-itertools
date: 2016-07-12 20:11
tags: ['Python标准库']
toc: true
categories: technology
---

### 0x00 
循环器时对象的容器，包含多个对象。通过调用循环器的next()方法，循环器将依次返回一个对象，直到所有对象遍历穷尽，循环器将举出__StopIteration__错误。

使用Python的内置函数__iter()__函数，我们可以将诸如表，字典等容器变为循环器。

```
for i in iter([2, 5, 7, 0]):
    print(i)
```

但是标准库中的__itertools包__提供了更加灵活的生成循环器的工具。这些工具大多时已经有的循环器。

```
from itertools import *
```

---
### 0x01 无穷循环器
* __count(5, 2)__ 从5开始的整数循环器，每次增加2
* __cycle('abc')__ 重复序列的元素
* __repeat(1.2)__ 重复1.2,既1.2,1.2,1.2....
* __repeat(10, 5)__ 重复10，5次


---
### 0x02 函数式工具
函数式编程时将函数本身作为处理对象的编程范式，Python也是对象，所以也可以进行一些函数式的处理，比如map()函数，filter()函数,reduece()函数。itertools包包含了类似的工具。这些函数接收函数作为参数，并将结果返回为一个循环器。

```
from itertools import *

rlt = imap(pow, [1, 2, 3], [2, 4, 6])

for num in rlt:
    print(num)
```

imap函数的功能与map函数的功能类似，只是返回的不是序列，而是循环器，pow函数以此作用于后面两个列表的每个元素，并收集函数的结果，组成返回的循环器。

此外，还可以时使用下面的函数:

```
starmap(pow, [(1, 1), (2, 2), (3, 3)})
```

__starmap()__函数将以此作用于表中的每个tuple。


__ifilter()__\函数与__filter()__函数类似，同样ifilter函数返回的是一个循环器。


```
from itertools import *

for i in ifilter(lambda x: x > 5, [2, 3, 4, 5, 6, 90]):
    print i

```

__ifilterfalse()__与上面类似，但是收集的是False的元素。

__takewhile()__ 当函数返回Ture时，收集到循环器。一旦函数返回False则停止。


```
from itertools import *

for i in takewhile(lambda x: x < 5, [2, 3, 4, 5, 6, 90]):
    print i

```

__dropwhile()__ 当函数返回Ture时，跳过元素，一旦函数返回False，则开始收集剩下的所有元素到循环器。


```
from itertools import *

for i in dropwhile(lambda x: x < 5, [2, 3, 4, 5, 6, 90, 1, 2, 87, 89, 3, 4, 100]):
    print i

```


---
### 0x03 groupby()
将key函数作用于原循环器的各个元素。根据key函数的结果，将拥有相同函数结果的元素分到一个新的循环器。每个新的循环器以函数返回结果为标签。

但是分组之前需要使用__sorted()__函数对原循环器根据key函数进行排序，让同组元素先在位置上靠拢。

```
from itertools import *

def height_class(h):
    if h > 180:
        return "tall"
    elif h < 160:
        return "short"
    else:
        return "middle"

friends = [102, 191, 180, 111, 210, 123, 145, 160, 171]

friends = sorted(friends, key=height_class)

for m, n in groupby(friends, key=height_class):
    print(m)
    print(list(n))
```


---
### 0x04 其他工具

* __compress('abcd', [1, 1, 1, 0])__根据[1, 1, 1, 0]的真假值情况，选择第一个参数'abcd'中的元素,a,b,c。
* __islice()__ 类似slice()函数，只是返回的是一个循环器。
* __izip()__ 类似于zip()函数，只是返回的是一个循环器。






