---
title: http模块(1)之客户端  
date: 2016-12-27 09:18               
tags: ['Node.js','http模块']
toc: true
categories: technology

---
### 0x00 http 模块对 HTTP 客户端的支持
`http` 模块提供了创建HTTP客户端对象的方法，使用客户端对象可以创建对HTTP服务的访问。

我们有两种方式去创建出一个 HTTP 客户端。 `http.request` 和 `http.get`，以向服务器发送请求。

`http.get()`方法实际上是一个快捷方法，因为在HTTP请求中，使用最多的是没有报文体的 GET 请求，所以Node提供了这个简便的方法。和 `http.request()`不同点在于，这个方法会自动设置HTTP请求方式为 `GET`，并自动调用`req.end()`方法。

---
#### http.request() 创建 HTTP 客户端

`http.request(optons [, callback])` 方法用于创建HTTP请求，该方法会返回一个 `http.ClientRequest` 对象的实例。  

`ClientRequest` 实例是一个可写流对象。当使用POST请求给服务器发送数据时，就要将其写入到 `ClientRequest` 对象。

此外,`options` 可以是一个对象或一个字符串。如果 `options` 是一个字符串, 它将自动使用 `url.parse()` 解析。如果是一个对象，可能包含以下值：

* host：请求的服务器域名或 IP 地址。默认：`localhost`
* hostname：用于支持 `url.parse()`。`hostname`优于`host`
* port：远程服务器端口。 默认： 80.
* localAddress：用于绑定网络连接的本地接口
* socketPath：`Unix域socket`（使用host:port或socketPath）
* method：HTTP请求方法。默认：`GET`。
* path：请求路径。默认：'/'。如果有查询字符串（查询参数），则需要包含。例如 `/index.html?page=12`。请求路径包含非法字符时抛出异常。目前，只有空格不支持，以后可能改变。
* headers：包含请求头的对象
* auth：用于计算认证头的基本认证，即 `user:password`
* agent：控制`Agent`的行为。当使用了一个`Agent`的时候，请求将默认为 `Connection: * keep-alive`。可能的值为：
    * undefined (default)：在这个主机和端口上使用 `global Agent`
    * Agent object：在`Agent`中显式使用 `passed`
    * false：选择性停用连接池，默认请求为：`Connection: close`
* keepAlive：{Boolean} 用于保持资源池周围的socket，未来可能会用于其它请求。默认值为false。
* keepAliveMsecs：{Integer} 使用HTTP KeepAlive的时候，通过正在保持活动的sockets发送TCP KeepAlive包的频繁程度。默认值为1000。仅当keepAlive为true时才可用。




---
### 0x01 http.ClientRequest 客户端请求对象
`http.ClientRequest` 对象由 `http.request()` 或者 `http.get()` 创建后返回。其表示的是一个 _正在处理的 HTTP 请求_ ，其头部已经进入请求队列，但是依然可以通过 `setHeader(name, value`),`getHeader(name)`,`removeHeader(name)` 等对其进行修改。实际的头部会随着第一个数据块发送，或在连接关闭时发送。

 `http.request()` 方法的 `callback` 参数或`response`事件监听器，获得的是服务端响应对象，即 `http.IncomingMessage` 实例。

在 `response` 事件期间，可以为响应对象添加监听器，尤其是监听 `data` 事件，即可获取服务端响应数据。如果没有添加 `response` 处理函数，响应将被完全忽略。

`ClientRequest` 是一个 `Writable Stream`，同时还是一个 `EventEmitter`。

---
#### http.ClientRequest 中的事件

##### response 事件

监听函数 `function (response) { }`。
当接收到请求的响应时触发，该事件只被触发一次。`response` 参数是 `http.IncomingMessage` 的一个实例。

##### socket 事件
监听函数 `function (socket) { }` Socket 附加到这个请求的时候触发。

##### connect 事件
监听函数 `function (response, socket, head) { }`
每次服务器使用 `CONNECT` 方法响应一个请求时触发。如果该事件未被监听，接收 `CONNECT` 方法的客户端将关闭它们的连接。


---
#### http.ClientRequest 中的方法

##### request.write(chunk, [encoding])

发送一块请求体。通过多次调用这个函数，用户可以流式地发送请求体至服务器。在这种情况下，创建请求时建议使用 `['Transfer-Encoding', 'chunked']` 头。

参数：`chunk` 必须是Buffer或字符串。`encoding` 参数是可选的, 只能在 `chunk` 是 `string` 类型的时候才能设置，默认是 `utf8`。

##### request.end([data], [encoding])

结束发送请求。如果请求体中还有未发送数据，该函数将会把它们flush到流中。

如果指定了 `data`，那么相当于 先调用 `request.write(data, encoding)` 方法，再调用 `request.end()` 方法。

##### request.abort()

终止一个请求。

##### request.setTimeout(timeout, [callback])

一旦一个套接字被分配给该请求并且完成连接，`socket.setTimeout()` 将会被调用。



---
### 0x02 创建一个HTTP客户端

创建一个HTTP客户端，`GET` 请求 baidu.com网站的根目录：

```
'use strict';

let http = require('http')

let options = {
    host:'itbilu.com',
    method:'GET',
    path:'/'
}

let req = http.request(options)
req.on('response', function (res) {
    res.setEncoding('utf-8')
    res.on('data', function (chunk) {
        console.log('收到数据: %s',chunk);
    })
})

req.end()
```

