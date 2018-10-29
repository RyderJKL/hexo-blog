---
title: Java-I/O
date: 2016-07-23
tags: ['Java应用']
toc: true
categories: technology

---
### 0x00 字节流与字符流，缓冲区
不同于其它语言，对IO的处理是封装好的，在Java中往往需要多个层次的__装饰(decoration)__才能实现文件读取。复杂带来的好处是对IO操作的灵活处理。

其实对文件内容的操作主要分为两类:
* **字符流**:用于操作文本文件和带有较多字符内容的文件。字符流有两个抽象类，__Write__\和__Reader__,其对应子类__FileWrite__\和__FileReader__可实现文件的读写操作，__BufferredWrite__\和__BufferedReader__能够提供缓冲区功能。

* **字节流**:操作那些无法直接获得文本信息的二进制文件，如图片，MP3，视频等。同样字节流也有两个抽象类：**InputStream** 和 **OutputStream**
其对应子类有**FileInputStream**和**FileOutputStream**实现文件读写
**BufferedInputStream**和**BufferedOutputStream**提供缓冲区功能

I/O中缓冲区的作用:简单的理解就是，如果对硬盘边读边写，会很慢，也伤硬盘。缓冲区其实内存里的一块区域，把数据先存内存里，然后一次性写入，类似数据库的批量操作，这样效率比较高。


