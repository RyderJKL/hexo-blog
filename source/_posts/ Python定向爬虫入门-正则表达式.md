---
title: Python爬虫之正则表达式
date: 2016-02-23 20:44
tags: ['Python爬虫']
toc: true
categories: technology

---
### 0x00 正则表达式的符号与方法

* 常用符号：点号，星号，问号与括号
* 常用方法：findall，search，sub
* 简单技巧：from re import *;from re import findall,search,sub,S

---
#### 常用符号

. :	匹配任意字符，换行符\n除外

\*:	匹配前一个字符0次或者无限次

?:	匹配前一个字符0次或1次

.\*:	贪心算法

.\*?:	非贪心算法

():	括号内的数据作为返回结果

---
#### 常用方法

 * findall:匹配所有符合规律的内容，返回包含结果的列表
 * Search：匹配并提取地一个符合规律的内容，返回一个正则表达式对象(object)
 * Sub:替换符合规律的内容，返回替换后的值

---
### 0x01 实例演示

```
import re
sec_code='sdfsalfxxixxfslf34xxlovexxdkfslexxyouxxfsllfd'
```

---
####  .\* 贪心算法
```
b=re.findall('xx.*xx',sec_code)
print b

输出: ['sdfsalfxxixxfslf34xxlovexxdkfslexxyouxxfsllfd', '']
```

---
#### \*?非贪心算法
```
b=re.findall('xx.*?xx',sec_code)
print b

输出：['xxixx', 'xxlovexx', 'xxyouxx']
```

---
#### (.\*?) 内容提取
使用括号将需要的内容提取出来，括号之外的内容被剔除。
 ```
d=re.findall('xx(.*?)xx',sec_code)
print d

输出: ['i', 'love', 'you']
```

---
### re.S
让点(.)匹配任何字符并且包括换行符号(\n)
```
s='''dfllxxhello
	xxjfkdjxxworldxx'''
d=re.findall('xx(.*?)xx',re.S)

输出：['hello\n','world']
```

findall与search的区别,findall返回的是列表,search当找到第一个匹配内容后便不会在继续向下匹配，而findall将会遍历完整个内容返回所有匹配的数据
```
s2='dlslfxxixx123xxlovexxdjfkdjsf'
f=re.search('xx(*?)xx123xx(.*?)xx',s2).group(2)
print f
2=re.findall('xx(.*?)xx123xx(.*?)xx',s2)
print f2[0][1]

输出: love love
```

---
#### sub的使用，实现替换的功能
```
h='123sdfsfefds123'
output=re.sub('123(.*?)123','123%d123'%7899,h)
print output

输出:1237899123
```

---
#### (\d+)匹配纯数字
```
a='jksjdi#$$#%1233jdks4545434jflksj'
b=re.findall('(\d+)',a)
print b

输出: ['1233', '4545434']
```

