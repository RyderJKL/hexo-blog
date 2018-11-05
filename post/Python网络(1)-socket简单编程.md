---
title: Python网络(1)-socket简单编程
date: 2016-08-17 10:21
tags: ['Python网络']
toc: true
categories: technology

---
### 0x00 前言
socke是进程间通信的一种方法，它是基于网络传输协议的上层接口，两个建立socket通信的进程可以分别属于两台不懂计算机。

双向管道(duplex PIPE)存活于同一台计算机,因此部分区分两台计算的地址，但是socket必须包含地址信息，以便实现网路通信。

一个socket包含四个地址信息:两台计算机的IP地址和两个进程所使用的端口(port)号。IP地址用于定位计算机，而port用于定位进程。

---
### 0x01 相关函数与模块

#### 

---
### 0x02 编程实现sock TCP连接
socket有很多类型，比如基于TCP协议和UDO协议。其中又以TCP socket最常见。

TCP 是一种面向连接的传输层协议，TCP Socket 是基于一种 Client-Server 的编程模型，服务端监听客户端的连接请求，一旦建立连接即可以进行传输数据。那么对 TCP Socket 编程的介绍也分为客户端和服务端：


#### 客户端

```
# !/usr/bin/python
# coding:utf-8

import socket
import sys

# 创建sokcet实例

try:
    # 如果创建失败，抛出socke.error异常
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except socket.error, msg:
    print 'Failed to create socket.Error code:' + str(msg[0]) + ', Error message' + msg[1]
    sys.exit()

print 'socket created'

# 连接服务器

# 获得要连接的主机ip地址
HOST = 'www.google.com'
PORT = 80

try:
    remote_ip = socket.gethostbyname(HOST)
except socket.gaierror:
    # 如果不能解析，抛出异常
    print "host name could not be resolved. Exiting"
    sys.exit()

print 'ip address of ' + HOST + ' is ' + remote_ip

# 连接到服务器特定端口上
s.connect((remote_ip, PORT))

print 'Socket Connected to ' + HOST + ' on ip ' + remote_ip

# 发送数据
message = 'GET /HTTP/1.1 \r\n\r\n'

try:
    s.sendall(message)
except socket.error:
    print 'send failed'
    sys.exit()

print 'message send successfully'

# 数据发送完毕以后，客户端还得接受服务器的响应
reply = s.recv(4096)
print reply

# 最后关闭socket连接
s.close()
```

从上我们知道了:
1.创建 socket
2.连接到远程服务器
3.发送数据
4.接收数据
5.关闭 socket

当我们打开 www.google.com 时，浏览器所做的就是这些，知道这些是非常有意义的。在 socket 中具有这种行为特征的被称为**CLIENT**，客户端主要是连接远程系统获取数据。
socket 中另一种行为称为**SERVER**，服务器使用 socket 来接收连接以及提供数据，和客户端正好相反。所以 www.google.com 是服务器，你的浏览器是客户端，或者更准确地说，www.google.com 是 HTTP 服务器，你的浏览器是 HTTP 客户端。
那么上面介绍了客户端的编程，现在轮到服务器端如果使用 socket 了。

#### 服务器端

服务器端主要做以下工作：
1.打开 socket
2.绑定到特定的地址以及端口上
3.监听连接
4.建立连接
5.接收/发送数据

上面已经介绍了如何创建 socket 了，下面一步是绑定。

```
# !/usr/bin/python

# coding:utf-8

import socket
import sys

HOST = ''
# 意味着socket连接面向所有可以用的接口
PORT = 8888

# 创建一个socket实例
s = socket.socket(socket.AF_INET, socket.SOCKET_STREAM)
print 'socket created'

# 开始绑定socket
# 函数 bind 可以用来将 socket 绑定到特定的地址和端口上，
# 它需要一个 sockaddr_in 结构作为参数：
try:
    s.bind(HOST, PORT)
except socket.error, msg:
    print 'Bind failed. Error code:' + str(msg[0]) + 'message' + msg[1]
    sys.exit()

print 'socket bind successfully'

# 开始监听
# 该函数带有一个参数称为 backlog，用来控制连接的个数。
s.listen(10)
print 'socket now listening'


# 接收连接
conn, addr = s.accept()

# display client information
print 'connected with' + addr[0] + ':' + str(addr[1])
```

此时，该程序在 8888 端口上等待请求的到来。不要关掉这个程序，让它一直运行，现在客户端可以通过该端口连接到 socket。

下面要做的是，服务器建立连接之后，接收客户端发送来的数据，并立即将数据发送回去，下面是完整的服务端程序：

```
# !/usr/bin/python
# coding:utf-8

import socket
import sys

HOST = ''
# 意味着socket连接面向所有可以用的接口
PORT = 8888

# 创建一个socket实例
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print 'socket created'

# 开始绑定socket
# 函数 bind 可以用来将 socket 绑定到特定的地址和端口上，
# 它需要一个 sockaddr_in 结构作为参数：
try:
    s.bind((HOST, PORT))
except socket.error, msg:
    print 'Bind failed. Error code:' + str(msg[0]) + 'message' + msg[1]
    sys.exit()

print 'socket bind successfully'

# 开始监听
# 该函数带有一个参数称为 backlog，用来控制连接的个数。
s.listen(10)
print 'socket now listening'


# 等待接收连接
conn, addr = s.accept()

# display client information
print 'connected with' + addr[0] + ':' + str(addr[1])

# 现在，连接与客户端的会话
# 接收来自客户端的数据
data = conn.recv(1024)
# 将数据原封不动的返回给客户端
conn.sendall(data)

# 关闭与客户端的数据连接
conn.close()
# 关闭socket
s.close()
```

在一个终端中运行这个程序，打开另一个终端，使用 telnet 连接服务器，随便输入字符串，你会看到：

```
 root  ~  PycharmProjects  First  1  telnet localhost 8888             1 
Trying ::1...
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
hello world!
hello world!
Connection closed by foreign host.
```

客户端（telnet）接收了服务器的响应，单是在完成一次响应之后服务器立即断开了连接，而像 www.google.com 这样的服务器总是一直等待接收连接的。我们需要将上面的服务器程序改造成一直运行，最简单的办法是将 accept 放到一个循环中，那么就可以一直接收连接了。

```
# !/usr/bin/python
# coding:utf-8

import socket
import sys

HOST = ''
# 意味着socket连接面向所有可以用的接口
PORT = 8888

# 创建一个socket实例
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print 'socket created'

# 开始绑定socket
# 函数 bind 可以用来将 socket 绑定到特定的地址和端口上，
# 它需要一个 sockaddr_in 结构作为参数：
try:
    s.bind((HOST, PORT))
except socket.error, msg:
    print 'Bind failed. Error code:' + str(msg[0]) + 'message' + msg[1]
    sys.exit()

print 'socket bind successfully'

# 开始监听
# 该函数带有一个参数称为 backlog，用来控制连接的个数。
s.listen(10)
print 'socket now listening'




# 等待接收连接
while 1:
    conn, addr = s.accept()
    # display client information
    print 'connected with' + addr[0] + ':' + str(addr[1])
    # 现在，连接与客户端的会话
    # 接收来自客户端的数据
    data = conn.recv(1024)
    reply = 'ok...' + data
    if not data:
        break

    conn.sendall(data)
    # 关闭与客户端的数据连接
    conn.close()

# 关闭socket
s.close()
```

现在开启三个终端，分别telnet服务器，会发现，如果一个终端连接之后不输入数据其他终端是没办法进行连接的，而且每个终端只能服务一次就断开连接。

但是，实际上确实需要多个客户端可以随时建立连接，而且每个客户端可以跟服务器进行多次通信，这该怎么修改呢？

#### 处理连接
为了处理每个连接，我们需要将处理的程序与主程序的接收连接分开。一种方法可以使用线程来实现，主服务程序接收连接，创建一个线程来处理该连接的通信，然后服务器回到接收其他连接的逻辑上来。

```
# !/usr/bin/python
# coding:utf-8

import socket
import sys
from thread import *

HOST = ''
PORT = 8888

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print 'socket created'

# 绑定本地主机和端口号

try:
    s.bind((HOST, PORT))
except socket.error, msg:
    print 'bind failed. Error code:' + str(msg[0]) + 'message:' + msg[1]
    sys.exit()

print 'socket bind complete'

# 开始监听
s.listen(10)
print 'Socket now listening'

# 函数用于处理数据，该函数将会用于创建线程
def clientThread(conn):
    # 发送消息给连接到服务器的客户端
    conn.send('welcome to server.')
    # 定义一个循环体，保证函数和线程的持续运行
    while 1:
        # 接收客户端的数据
        data = conn.recv(1024)
        rely = 'ok ...' + data
        if not data:
            break

        conn.sendall(rely)

        # 退出循环时，关闭连接
    conn.close()

# 保持与客户端的连接
while True:
    # 等待接收连接
    conn, addr = s.accept()
    print 'Connected with ' + addr[0] + ':' + str(addr[1])
    # 开始一个新的的线程，start_new_thread的第一参数是要运行的函数名
    # 第二个参数时该函数所需要的参数列表
    start_new_thread(clientThread, (conn, ))

# 最后关闭socket
s.close()
```






本文参考链接: 
> http://www.cnblogs.com/hazir/p/python_socket_programming.html

