---
title: Python标准库(4)文件与路径
date: 2016-05-26 22:33
tags: ['Python标准库']
toc: true
categories: technology

---
### 0x00 os.path 包

由于不同的操作系统对路径的处理方式不同，所以不同的操作系统会对应不同的os.path包。

#### os.path处理路径字符串
os.path包主要是处理路径字符串，比如提取 "/usr/bin/dev/file.txt" 里的有用信息

```
#!/usr/bin/python
#-*-coding:utf-8-*-
import os.path

path = '/usr/bin/dev/file.txt'

print(os.path.basename(path)) #查找路径中包含的文件名#
print(os.path.dirname(path)) #查找路径中包含的目录#

info = os.path.split(path) #将路径分割成文件名和目录两个部分，并放在表中#
path2 = os.path.join('/','usr','dev','file2.txt') #使用目录文件名构成一个路劲字符串#
p_list = [path, path2]
print(os.path.commonprefix(p_list))	#查询多个路径的相同部分#

运行结果:
➜  Python ./os_path.py    
file.txt
/usr/bin/dev
/usr/
```

---
#### os.path查询文件相关信息
os.path也可以查询文件的相关信息(metadata)

```
#!/usr/bin/python
#-*-coding:utf-8-*-
import os.path

path = '/usr/bin/zip'
print(os.path.exists(path)) #查询文件是否存在
print(os.path.getsize(path)) #查询文件的大小
print(os.path.getatime(path)) #查询文件最近一次读取时间
print(os.path.getmtime(path)) #查询文件最近一次修改时间
print(os.path.isfile(path))	#路径是否指向常规文件
print(os.path.isdir(path))	#路径是否指向目录文件
```

---
### 0x02 glob包
glob最适用的是查询目录下的文件，glob最常用的方法只有一个，glob.glob(),该方法类似与Linux中的ls，它可以接收一个文件名的正则表达式，列出所有符合该表达式的文件。但是需要注意的是此处的文件名正则表达式不同于Python的正则表达式，而是Linux下shell的表达式。

找出 /myblog/hexo 下的所有文件:

```
import glob
print(glob.glob('/root/MyBlogs/hexo/*'))
```


