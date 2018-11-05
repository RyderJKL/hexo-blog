---
title: Python标准库(14)-数据库-sqlite3
date: 2016-07-13 11:31
tags: ['Python标准库']
toc: true
categories: technology
---

SQLite是一个轻量级的数据库，Python自带。SQLite作为后端数据库，可以搭配python建立网站。

---
### 0x00 创建数据库


```
# coding:utf-8
import sqlite3
# 导入SQLite3接口


conn = sqlite3.connect("test.db")
# 连接数据库
c = conn.cursor()

c.execute('''CREATE TABLE category ( id INT PRIMARY  KEY,sort int, name text)''')

c.execute('''CREATE TABLE book (id int primary key, sort int, name text, price real, category int, FOREIGN KEY (category)
REFERENCES category (id))''')
# #创建category表和book表

c.execute("INSERT  INTO  category VALUES (1, 1, 'bird')")
c.execute("INSERT INTO category VALUES (?, ?, ?)", (6, 9, 'computer'))

#查询数据
c.execute("SELECT * FROM book")
print(c.fetchone())

for row in c.execute('select * from category'):
    print(row)

#更新数据
c.execute("UPDATE  category set sort = ? where id = ?", (1000, 1))

#删除表
c.execute("DROP TABLE category")

#提交(保存)
conn.commit()

#关闭数据库连接
conn.close()
```

SQLite时磁盘上的一个文件。test.db开始并不存在，SQLite将自动创建一个新的文件。

让后调用__execute()__函数执行SQL语句。

SQL语句中的参数，使用__"?"__作为替代符号，并在后面的参数中给出具体的值，这样可以增加程序的安全性。

执行查询语句以后，python将返回一个循环器，包含查询的全部记录，我们可以使用__fetchone()__方法\和__fetchall()__方法读取记录，也可以循环读取。





