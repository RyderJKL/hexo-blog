---
title: http模块(2)之服务器端  
date: 2016-12-26 14:45               
tags: ['Node.js','http模块']
toc: true
categories: technology

---
### 0x00 http 模块
通过 Node.js  的 `http` 模块中的 `http.createServer` 方法我们可以很轻松的创建出一个 `http` 服务器或者使用 `http.request` 方法创建出一个 `http` 客户端。 Node 对 HTTP 协议及其相关的 API 的封装是比较底层的其仅能处理流和消息，对于消息的处理，也仅解析成报文头和报文体，但是不解析实际的报文头和报文体内容。如此使得其对 HTTP 的应用更加灵活。

---
### 0x01 http 模块对 HTTP 服务端的支持

我们需要通过一个 `http.Server` 对象来创建一个 HTTP 服务器。
有两种方式可以创建出 `http.Server` 对象，`http.createServer()` 或 `new http.Server()`。

---
#### http.Server() 创建 HTTP 服务器

```
'use strict';
let http = require('http')

// 创建 server 对象，并通过 server 对象的 request 事件添加事件监听器
let server = new http.Server()
server.on('request',function (req, res) {
    res.writeHead(200, {'Content-Type':'text/html'})
    res.end("<h1>hello world!</h1>")
})

server.listen(8088)
```

---
#### http.createServer([requestListener]) 创建 HTTP 服务器

```
'use strict';
let http = require('http')

// 创建 server 对象，并添加 request 事件监听器
let server = http.createServer(function (request, response) {
    console.log(request.method+':'+request.url)
    response.writeHead(200, {'Content-Type':'text/html'})
    response.end('<h1>hello world</h1>')
})

server.listen(8088)
```

---
### 0x02 关于 http.Server 对象

`http.Server` 对象其实是一个事件发射器 `EventEmitter`。在其事件监听器中也会创建一些对象，如：`request` 事件会创建http.`IncomingMessage`和`http.ServerResponse`。


---
#### http.Server 对象中的事件
在此只列出来几个常用的事件。

##### request 事件
`request` 事件监听函数为 `function (request, response) {}`，其接收的两个参数:`request` 是一个 `http.IncomingMessage` 实例，而 `response` 是一个 `http.ServerResponse` 实例。

##### close 事件
其监听函数格式为 `function () { }` ，当此服务器关闭时触发。

##### clientError 事件
其监听函数格式为`function (exception, socket) { }`

当客户端连接触发了一个`error`事件时，事件会被传送到这里.


---
#### http.Server 对象中的方法

##### server.listen([hostname],port,callbakc)
调用 `http.Server` 对象的 `server.listen` 事件监听方法以后就可以接受客户端的连接了。

##### server.close([callback])

服务器停止接收新的连接，保持现有连接。当所有连接结束的时候服务器会关闭，并会触发 `close` 事件。

##### server.setTimeout(msecs, callback)
设置 `Socket` 套接字的超时时间，单位 msecs 为秒。如果一个超时发生，那么Server对象上会分发一个`timeout` 事件，同时将套接字作为参数传递。Server默认超时时间为 2 分钟，如果超时将会销毁 `Socket`。

---
#### http.Server 对象中的属性

##### server.maxHeadersCount
最大请求头的数量限制，默认 1000。如果设置为 0，则不做任何限制

##### server.timeout
`Socket` 套接字被判断为超时时间，单位为毫秒，默认 12000（2分钟）。设置为 0后，则不受超时限制。

---
### 0x03 http.ServerResponse 对象

`http.ServerResponse` 是一个由 `http.Server` 创建的服务器响应对象。在触发`request`事件后，做事件回调函数的第二个参数传递给回调函数。`http.ServerResponse` 实现了Writable Stream接口，它同样也是一个 `EventEmitter`。

---
#### http.ServerResponse 中的事件

##### close 事件
事件：`close`，其监听函数格式为 `function () { }`

在调用 `response.end()`，或准备 `flush` 前触发，触发后底层连接结束。

##### finish 事件
事件：`finish`，其监听函数格式为 `function () { }`

发送完响应后（服务器响应完成）触发。响应头和响应体最后一段数据离开操作系统，通过网络来传输时被触发，这并不代表客户端已经收到数据。这个事件之后,`http.ServerResponse` 不会再触发任何事件。


---
#### http.ServerResponse 中的方法

##### response.writeContinue()

发送HTTP/1.1 100 Continue 消息给客户端，表示请求体可以发送，会触发 `http.Server` 的`checkContinue` 事件。

##### response.writeHead(statusCode[, statusMessage][, headers])
向客户端请求发送一个响应头。`statusCode` 状态码是 3 位数字，如：404。可通过 `statusMessage` 设置状态消息。最后一个参数 `headers` 是响应头。

该方法方法在当前请求中仅能调用一次，而且必须在 `response.end()` 前调用:

```
let body = 'example.com'
response.writeHead(200, 'OK',{
    'Content-Length':body.length,
    'Content-Type':'text/plain'
})
```

##### response.setHeader(name, value)

为默认或者已存在的头设置一条单独的头内容。如果这个头已经存在于，将会覆盖原来的内容。如果想设置多个值， 就使用一个相同名字的字符串数组。

```
response.setHeader('Content-Type', 'text/html')
response.setHeader('Set-Cookie', ['userName = jack','password=123'])
```

##### response.setTimeout(msecs, callback)

设置`Socket`套接字的超时时间，单位 `msecs` 为秒。如果提供了回调函数，其将会做为响应对象的`timeout`事件的监听器。


##### response.write(chunk, [encoding])

向响应流发送一个数据块。这个方法可能被调用多次，以提供响应体内容。如果调用了这个方法，但还没有调用 `response.writeHead()`，将会向响应体提供默认的 `header`。


参数chunk可以是字符串或者Buffer缓存。

##### response.end([data], [encoding])

当所有的响应报头和报文被发送完成时这个方法将信号发送给服务器，服务器会认为这个消息完成了。 每次响应完成之后必须调用该方法。

如果指定了参数 `data`，就相当于先调用 `response.write(data, encoding)` 再调用 `response.end()`。


---
#### http.ServerResponse 中的属性

##### response.statusCode

当使用默认 `header` 时（没有显式地调用 `response.writeHead()` 来修改 `header`），这个属性决定 `header` 更新时被传回客户端的HTTP状态码。当响应头已经被发送回客户端，那么这个属性则表示已经被发送出去的状态码。

##### response.headersSent

`Boolean` 值(只读)，如果 `headers` 发送完毕，则为 `true`，否则为 `false`。

##### response.sendDate

默认值为 `true`。若为 `true`，当 `headers` 里没有 `Date` 值时，自动生成 `Date` 并发送。只有在测试环境才能禁用，因为HTTP要求响应包含 `Date` 头。

---
### 0x04 http.IncomingMessage 对象

`IncomingMessage` 对象是由 `http.Server` 或 `http.ClientRequest` 创建的，并作为第一参数分别传递给 `http.Server `的 `request` 事件和 `http.ClientRequest` 的 `response` 事件。它也可以用来访问应答的状态、头文件和数据等。 `IncomingMessage` 对象实现了 `Readable Stream` 接口，对象中还有一些事件，方法和属性。`在http.Server` 或 `http.ClientRequest` 中略有不同。

---
#### http.IncomingMessage 对象中的事件

##### close 事件
`close` 事件表示在 `response.end()` 被调用或强制刷新之前，底层的连接已经被终止了。


---
#### http.IncomingMessage 对象中的方法

#####  message.setTimeout(msecs, callback)
设置连接超时，参数 `msecs` 为超时时间（秒）。该方法本质是调用 `message.connection.setTimeout(msecs, callback)` 方法。

---
#### http.IncomingMessage 对象中的属性

##### message.httpVersion
`message.httpVersion`：在http.Server中表示客户端向服务器发出请求时，客户端发送的HTTP版本；在http.ClientRequest中表示服务器向客户端返回应答时，服务器的HTTP版本

##### message.headers
`message.headers`: 请求/响应头对象。只读的文件头信息的键值对的集合，全小写。

##### message.method
`message.method`：仅对http.Server有效，表示客户端的HTTP请求方式

##### message.url
`message.url`：仅对http.Server有效，表示客户端请求的URL字符串。

##### message.statusCode
`message.statusCode`：仅对 `http.ClientRequest` 有效，表示HTTP服务器的响应状态，如：200、404等。

##### message.statusCode
`message.statusCode`：仅对 `http.ClientRequest` 有效，表示HTTP服务器的响应状态信息，如：OK、Internal Server Error等。

###### message.socket
`message.socket`：与此连接关联的net.Socket对象

---
### 0x05 完备的 HTTP 服务器

##### 1.创建一个 http.Server
不同于 `new http.Server()` 的方式，使用 `http.createServer` 方法来创建一个 `http.Serve` 的实例，不需要为其显示的添加 `request` 事件处理程序，因为它将会自动在服务端监听来自客户端的  `request` 事件,然后在其回调函数中会返回一个 `http.IncomingMessage(req)` 实例和一个  `http.ServerResponse(res)` 实例。

```
/**
 * Created by onejustone on 2016/12/26.
 *
 * @param {Object} req 是一个http.IncomingMessag实例
 * @param {Object} res 是一个http.ServerResponse实例
 */
 
'use strict';

let http = require('http')
// 导入 http m模块

let server = http.createServer(function (req, res) {
// 创建 http server
    res.writeHeader(200, {'Content-Type':'video/mp4'})
    // 改写响应的头部信息 
    let rs = require('fs').createReadStream('./臭屁虫2.mp4')
    // 创建一个流文件，读取 MP4 媒体数据
    rs.pipe(res)
    // 将 MP4 文件流通过管道输送到 HTTP 响应中
})

server.maxHeadersCount = 1000;
// 设置最大请求头限制
server.setTimeout(1000,function () {
// 设置套接字超时时间
    console.log("oh, time out~~")
})


server.listen(8088, function () {
// 监听本地端口。启动服务器
    console.log('服务器已启动！')
})
```

`http.ServerResponse` 实例是一个可写流，所以可以将一个文件流转接到 `res` 响应流中，然后传输给客户端。

此外，我们还有可以通过 `req.headers` 来查看客户端的请求信息。

```
let server = http.createServer(function (req, res) {
    console.log(req.headers)
    res.writeHeader(200, {'Content-Type':'text/plain'})
    res.end()
})
```

