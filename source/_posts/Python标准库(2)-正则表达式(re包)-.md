---
title: Python标准库(2)正则表达式
date: 2016-05-20 22:30
tags: ['Python标准库']
toc: true
categories: technology

---
### 0x00 前言

正则表达式(regular expression)的主要功能是从字符串(string)中通过特定的模式(pattern)，搜索想要的内容。

Python中数量词默认是贪婪的，总是匹配尽可能多的字符。非贪婪的则相反，总是尝试匹配尽可能少的字符。



---
### 0x01 正则表达式符号

* __.__ 任意一个字符
* __a|b__ 字符a或者b
* __[^m]__ 不是m的一个字符
* __\s__ 一个空格
* __\S__ 一个非空格
* __\d__ 数字等价于[0-9]
* __\D__ 非数字等价于[^0-9]
* __\w__ 数字和字母等价于[0-9a-zA-Z]
* __\W__ 非数字和字母等价于[^0-9a-zA-Z]
* __\*__ 重复前一个字符0到达无穷次
* __+__ 重复前一个字符1到无穷次
* __?__ 重复前一个字符0次或者1次
* __{m}__ 重复前一个字符m次
* __{m,n}__ 重复前一次字符m到n次
* __^__ 配比开头那个字符
* __$__ 匹配结尾那个字符

---
### 0x02 标志位 flags

* __re.I__ 忽略大小写
* __re.M__ 多行匹配
* __re.S__ 使用.匹配换行在内的所有字符
* __re.L__使预定字符类 \w \W \b \B \s \S 取决于当前区域设定
* __re.U__ 使预定字符类 \w \W \b \B \s \S \d \D 取决于unicode定义的字符属性
* __re.X__ 详细模式，表达式可以是多行，忽略空白字符，并可以加入注释。
* __关于原生字符串"r"__: 假如我们需要匹配一个数字那么我们需要在程序里写"\\d",因为"\"总是有特别的含义，但是在Python里我们还可以这么写r"\d",使用原生字符串的表达方式，如此，妈妈再也不用担心漏写的反斜杠了。
---
### 0x03 Pattern 
Pattern是一个匹配模式，需要利用__re.compile()__方法

```
pattern = re.compile(r"hello")
```
使用原生字符串，通过compile方法编译生成哟pattern对象，然后便可以利用这个对象来进行匹配。


---
### 0x04 群
有时可能会对搜索的结果进行进一步精简信息比如output_(\d{4}),该正则表达式用括号()包围了一个小正则表达式，\d{4}，这个小的正则表达式被用于从结果中筛选想要的信息，即4位数字。想这样被__括号圈起来的表达式的一部分，称为群(group)__

我们可以使用__m.group(number)__方法来查询群，group(0)是整个表达式的搜索结果，group(1)是值第一个群。

---
### 0x05 正则表达式的函数

* __re.match(pattrn, string, flages)__ 从头开始检查字符串是否符合pattern，一直向后匹配，，必须从字符的第一个字符开始就符合，直到pattern匹配完毕!,flags位标志位，用于控制正则表达式的匹配方式，如:是否区分大小写，多行匹配等!
 ```
 # -*-coding:utf-8-*-
import re
pattern = re.compile(r"hello")
result1 = re.match(pattern, 'hello')
result2 = re.match(pattern, 'helloo jdldf')
result3 = re.match(pattern, 'helo jfds!')
if result1:
    print result1.group()
else:
    print '匹配失败'
if result2:
    print result2.group()
else:
    print '匹配失败'
 if result3:
    print result3.group()
else:
    print '匹配失败'
  ```
 我们还可以使用Match提供的可读属性和方法来获取更多的信息
 
  ```
 # -*-coding:utf-8-*-
import re
pattern = re.compile(r'(\w+) (\w+)(\S.*)')
m = re.match(pattern, 'hello world!')
print m.string      # 匹配时使用的文本
print m.re          #匹配时使用的pattern对象
print m.pos        #文本中正则表达式开始搜索的索引
print m.endpos  #文本中正则表达式结束搜索的索引
print m.lastindex  #最后一个呗捕获的分组在文本中的索引
print m.lastgroup #最后一个被捕获的分组的别名，无则返回None
print m.group()#获得分组字符串，0代表整个匹配的字符串
print m.group(1,2)
print m.groups() #以元组形式返回全部分组截获的字符串
print m.groupdict()#返回以有别名的组的别名为键、以该组截获的子串为值的字典，没有别名的组不包含在内
print m.start(2)#返回指定的组截获的子串在string中的起始索引（子串第一个字符的索引）
print m.end(2)
print m.span(2)#返回(start(group),end(group))
print m.expand(r'\2 \1\3')将匹配到的分组带入template中返回，可以使用"\d","\g"进行分组
运行结果:
hello world!
<_sre.SRE_Pattern object at 0x000000000277DA98>
0
12
3
None
hello world!
('hello', 'world')
('hello', 'world', '!')
{}
6
11
(6, 11)
world hello!

  ```

* __ re.search(pattern, string, flages)__ re.search与match极其类似，区别是match()值检测re是不是在string的开始位置匹配，而search()会搜索整个string,直到发现符合的子字符串。

 ```
 import re
 pattern = re.compile(r'world')
 match = re.search(pattern,'hello word!')
 if match:
    print match.group()
 返回结果:
 world
 ```

 对re.search()使用"^"相当于re.match()
 ```
 re.search("^c", "abcdef") # 匹配失败
 re.search("^a", "abcdef") #匹配成功
 ```

 但是re.match在多行匹配中只会匹配整个字符串的开头re.search()则会匹配每一行的开头:
 ```
 re.match('X', 'A\nB\nX', re.M)  #No match
 re.search('^X', 'A\nB\nX', re.M) #Match
 ```
* __re.sub(pattern, replacement, string，count)__ 在string中利用正则表达式变化pattern进行搜索，对于搜索到的字符串，用另一个字符串replacement替换。返回替换后的字符串。count是匹配后替换的最大次数。
 ```
  import re
  pattern = re.compile(r'(\w+) (\w+)')
  s = 'i say, hello world!'
  print re.sub(pattern,r'\2 \1', s)
  def func(m):
      return m.group(1).title()+' '+m.group(2).title()
  print re.sub(pattern,func, s)
  输出:
  say i, world hello!
  I Say, Hello World!
 ```

* __re.subn(pattern,repl,string[,count])__

  返回(sub(repl,string[,count]),替换次数)
  ```
    import re
  pattern = re.compile(r'(\w+) (\w+)')
  s = 'i say, hello world!'
  print re.sub(pattern,r'\2 \1', s)
  def func(m):
      return m.group(1).title()+' '+m.group(2).title()
  print re.subn(pattern,func, s)
  输出:
  ('say i, world hello!',2)
  ('I Say, Hello World!',2)
  ```

* __re.split(pattern,string[,maxsplit] )__ 根据正则表达式分割字符串，将分割后的所有字符串放在一个表(list)中返回,maxsplit用于指定对大分割次数，不指定将全部分割

  ```
 import re
 pattern = re.compile(r'\d+')
 print re.split(pattern,'one1two2three3four4')
 输出:
 ['one', 'two', 'three', 'four', '']
  ```

* __re.findall(pattern,string,flages )__ 根据正则表达式搜素字符串，将所有符合的子字符串放在一个表(list)中返回。
 ```
 import re
 pattern = re.compile(r'\d+')
 print re.findall(pattern,'one1two2three3four4')
 输出:
 ['1', '2', '3', '4']
 ```

* __finditer(pattern,string[,flags])__
 搜索string，返回一个顺序访问每一个匹配结果的迭代器
 ```
 import re
 pattern = re.compile(r'\d+')
 for m in re.finditer(pattern,'one1two2three3four4'):
    print m.group(),
 输出:
 1,2,3,4
 ```


