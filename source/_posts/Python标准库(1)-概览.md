---
title: Python标准库(1)概览
date: 2016-05-26 22:30
tags: ['Python标准库']
toc: true
categories: technology

---
## 0x00 概览
Python标准库(Standard Library)会随着Python解释器一起安装于电脑，这些标准库是Python的利器，可以让编程事半功倍，我们主要使用标准库中三个方向的包(package):

* Python增强
* 系统互动
* 网络编程

----
## 0x01 Python增强

----
#### 文字处理

Python的string类提供了对字符串的处理方法，更进一步，标准库的re包，可以使用正则表达式(regular expression)来处理字符串。此外，Python标准库还为字符串的输出提供更加丰富的格式，比如:string包，textwrap包。

#### 数据对象
Pyhton标准库除了定义了如表，词典之外的对象以外，还提供了数组(Array),队列(Queue)等数据对象，此外，我们也经常使用copy包，以复制对象。

#### 日期和时间

Python标准库对时间和日期的管理比较完善(利用time包管理时间，利用datatime包管理日期和时间)，可以进行日期和时间的查询和变换，可以对时间进行运算，还可以根据需要控制时间输出的文本格式

#### 数学运算
Python中定义了一些新的数字类型(decimal包，fractions包),以弥补之前数字类型可能的不足，同时也包含了random包，用于处理随机数相关的功能，math包也补充了一些重要的数学常数和数学函数

## 存储

Python除了简单文本的输入输出外，还可以输入输出任意的对象。这些对象可以通过标准库中的pickle包转换为二进制格式(binary)，然后存储于文件中，也可以反向从二进制文件中读取对象。

----
## 0x02 系统互动
主要是指Python和操作系统，文件系统的互动，Python可以实现操作系统的许多功能，能够像bash脚本一样管理操作系统，这也是Python有时被称为脚本语言的原因。

----
#### Python运行控制
sys包用于管理Python本身的运行环境。其另一个重要的功能是和Python自己的命令行互动，从命令行读取命令和参数。

#### 操作系统
os包是Python与操作系统的接口，os包可以实现操作系统的很多功能，但是os包是建立在Linux基础上的，所有许多功能在Windows上是无法实现的。

subprocess包用于执行外部命令，其功能相当于我们在操作系统的命令行中输入命令执行，还可以是可以在命令行中执行的程序。

#### 进程与线程
Python支持多线程(threading包)运行和多线程(multiprocessing包)运行。通过多线程和多进程，可以提高系统资源的利用率，提高计算机的处理速度。

----
## 网络编程
----
#### 基于socket层的网络应用
socket是网络可编程部分的底层。通过socket包，我们可以直接管理socket，如将socket赋予某个port，连接远程端口，以及通过连接传输数据。我们也可以利用socketserver包方便的建立服务器。此外，通过asyncore包实现异步处理，也是改善服务器性能的一个方案。

#### 互联网应用
Python标准库中有http的服务端和客户端的应用支持(BaseHTTPServer包；urllib包；urllib2包)，并且可以通过urlparse包对url进行理解和操作


