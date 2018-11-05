---
title: 同源策略与CORS
date: 2016-12-01 22:20               
tags: ['JavaScript','同源策略与CORS']
toc: true
categories: technology

---
### 0x00 同源策略
**同源策略(Same-origin policy)** 是浏览器安全的基石,其目的是为了保护用户信息的安全，具体点，同源指的是三个相同，`协议相同`, `域名相同`,` 端口相同`。如果非同源，以下三种行为将会受到限制:

* Cookie,localStorage,和 IndexDNB 无法读取
* DOM 无法获得
* AJAX 请求不能发送

对于 Cookie 的限制，在以前，我们可以通过`document.domain` 来设置相同的域名以共享 Cookie。

也可以在服务器端指定 Cookie 所属的域名为一级域名:

``` 
Set-cookie: key=value; domain=.onejustone.xyz; path= /;
```

这样二级和三级域名不用做任何设置，都可以读取这个 Cookie。

而如果两个网页不同源，则无法获取对方的 DOM，比如 `iframe` 窗口和 `window.open` 方法打开的窗口，它们与父窗口无法通信。这时如果两个窗口一级域名相同，而二级域名不同，则通过 `document.domain` 属性，即可规避同源策略，拿到 DOM。

而对于完全不同于源的网页则有三种方法: 

* 片段是识别符(fragment identifier)
* window.name
* 跨文档通信API(Cross-document messaging)

片段标识符（fragment identifier）指的是，URL的#号后面的部分，比如http://example.com/x.html#fragment的#fragment。如果只是改变片段标识符，页面不会重新刷新。

而通过 `window.name` 属性，无论是否同源，只要在同一个窗口里，前一个网页设置了这个属性，后一个网页可以读取它。但是使用`window.name` 将会非常影响页面性能。


好在 H5 引入了一个全新的 API，`跨文档通信 API(Cross-document messaging)`,它为 `window` 对象新增了一个 `window
.postMessage` 方法，运行跨窗口通信，无论这两个窗口是否同源。除此之外，连读取其它窗口的  `localStorgae` 也成为了可能。

> [本文参考](http://www.ruanyifeng.com/blog/2016/04/same-origin-policy.html)


---
### 0x01 CORS
同源策略规定，AJAX 请求只能发送给同源的网址，否则就会报错。面对这个问题，我们很三种种解决的方法:
 
 * JSONP
 * WebSocket
 * CORS
 
 JSONP 最大的特点是简单适用，兼容性好，支持几乎所有的老式浏览器，服务器改造非常下。但是只能发送 `GET` 请求，并且要判断 JSONP 请求是否失败并不容易。
 
 而 WebSocket 是一种通信协议。使用 `ws://（非加密）`和 `wss://（加密）` 作为协议前缀。该协议中 `Origin` 自动可以指定请求的请求域，即来自哪域名。也正因为有了 `Origin` 字段，WebSocket 才不实行同源策略。服务器可以根据这个字段，判断是否许可本次通信。如果该域名在白名单内，服务器就会做出如下回应。
 
 
 ``` 
 HTTP/1.1 101 Switching Protocols
 Upgrade: websocket
 Connection: Upgrade
 Sec-WebSocket-Accept: HSmrc0sMlYUkAGmm5OPpG2HaGWk=
 Sec-WebSocket-Protocol: chat
 ```

最后该我们的 CORS 登场了，可以讲 CORS(Cross-Origin Resource Sharing) 是跨源 Ajax 请求的根本解决方法。

它允许浏览器向跨域服务器，发出 `XMLHttpRequest` 请求，从而避免了 Ajax 只能同源使用的限制。

而整个 CORS 的通信过程，都是浏览器自动完成的，浏览器一旦发现 Ajax 请求跨域，就会自动添加一些附加的头信息。对于开发者，CORS 通信与同源的 Ajax 通信没有任何差别，代码完全一样。因此，实现 CORS 通信的关键是服务器。

---
#### 两种请求

浏览器将 CORS 请求分为两类: 简单请求（simple request）和 非简单请求(not-so-simple-request):

同时满足一下两大条件就属于简单请求:

1. 请求方法是以下三种之一:
 * HEAD
 * GET
 * POST

2. HTTP 头信息不超过以下几种字段:
 * Accept
 * Accept-Language
 * Content-Language
 * Last-Event-ID
 * Content-Type: 
 `application/x-www-form-urlencoded`,
 `multipart/form-data`,`text/plain`
 
 凡是不满足以上条件的就是非简单请求，浏览器对两种请求的处理是不一样的。具体的就是，对于非简单类请求，浏览器会多一个 **预检请求(preflight)**，即是在 CORS 正式通信之前会增加一次 HTTP 请求。
 
 ---
 #### 简单请求
 浏览器一旦发现本次 Ajax 跨源，并且是简单请求，那么就会自动在请求的头部添加 `Origin` 字段。该字段用来说明，本次请求来自哪个源（协议 + 域名 + 端口）。而服务器会根据这个值，决定是否同意这次请求。
 
 ``` 
 GET /cors HTTP/1.1
 Origin: http://api.bob.com
 Host: api.alice.com
 Accept-Language: en-US
 Connection: keep-alive
 User-Agent: Mozilla/5.0
 ```
 
 下面是简单请求的服务器 CORS 配置:
 
 ``` 
 
Access-Control-Allow-Origin: http://api.bob.com
Access-Control-Allow-Credentials: true
Access-Control-Expose-Headers: FooBar
 ```
 
 1. Access-Control-Allow-origin: 指定一个允许向该服务器器提交请求的 URL。对于一个不带有 `credentials` 的请求,可以指定为 `'*'`,表示允许来自所有域的请求.
 2. Access-Control-Allow-Credentials: 它的值是一个布尔值，表示是否允许发送Cookie。默认情况下，Cookie不包括在CORS请求之中。设为true，即表示服务器明确许可，Cookie可以包含在请求中，一起发给服务器。另一方面，开发者必需在 Ajax 请求中打开 `withCredentials` 属性:
 
 ``` 
 var xhr = new XMLHttpRequest();
 xhr.withCredentials = true;
 ```
 
 3. Access-Control-Expose-Headers: 设置浏览器允许访问的服务器的头信息的白名单。CORS 请求时，`XMLHttpRequest` 对象的`getResponseHeader()` 方法只能拿到6个基本字段：`Cache-Control`、`Content-Language`、`Content-Type`、`Expires`、`Last-Modified`、`Pragma`。如果想拿到其他字段(比如一些自定义的头部字段信息)，就必须在`Access-Control-Expose-Headers`里面指定。
 
 
 ---
 #### 非简单请求
  
 非简单请求，比如请方式是 `PUT` 或者 `DELETE`  ，或者 `Content-Type` 字段类型是 `applicaiton/json` 的，会在正式通信之前，增加一次 `HTTP` 查询请求，即是 **预检(preflight)** 请求。其作用是用来判断当前网页所在的域名是否在服务器的许可名单之中。
 
 预检请求的请求方法是 `OPTIONS`，这个方法是用来询问的。和预检请求相关的是以下两个字段:
 
 1. Access-Control-Request-Method: 该字段是必须的，用来列出浏览器的 CORS 请求会用到哪些HTTP方法。
 
 2. Access-Control-Request-Headers: 该字段是一个逗号分隔的字符串，指定浏览器CORS请求会额外发送的头信息字段，如一些自定义的头部信息。
 
 下面是预检请求的 HTTP 头部信息:
 
 ```  
 OPTIONS /cors HTTP/1.1
 Origin: http://api.bob.com
 Access-Control-Request-Method: PUT
 Access-Control-Request-Headers: X-Custom-Header
 Host: api.alice.com
 Accept-Language: en-US
 Connection: keep-alive
 User-Agent: Mozilla/5.0...
 ```
 
服务器接收到预检请求，并检查了 `Origin`, `Access-Control-Request-Method`,
`Access-Control-Request-Headers` 字段以后，经确认不允许跨源，会返回一个正常的 HTTP 流，但是不会包含与 CORS 通信有关的字段，如果确认可以跨源，就会返回一个包含 CORS 规定的字段作为 HTTP 响应:

``` 
HTTP/1.1 200 OK
Date: Mon, 01 Dec 2008 01:15:39 GMT
Server: Apache/2.0.61 (Unix)
Access-Control-Allow-Origin: http://api.bob.com
Access-Control-Allow-Methods: GET, POST, PUT
Access-Control-Allow-Headers: X-Custom-Header
Content-Type: text/html; charset=utf-8
Content-Encoding: gzip
Content-Length: 0
Keep-Alive: timeout=2, max=100
Connection: Keep-Alive
Content-Type: text/plain
```
 
 如上是服务器返回的 CORS HTTP 响应，其中最重要的是 `Access-Control-Allow-Origin` 字段。下面是一些其它的字段说明:
 
1. Access-Control-Allow-Methods:该字段必需，它的值是逗号分隔的一个字符串，表明服务器支持的所有跨域请求的方法。注意，返回的是所有支持的方法，而不单是浏览器请求的那个方法。这是为了避免多次"预检"请求。
 
2. Access-Control-Allow-Headers:如果浏览器请求包括Access-Control-Request-Headers字段，则Access-Control-Allow-Headers字段是必需的。它也是一个逗号分隔的字符串，表明服务器支持的所有头信息字段，不限于浏览器在"预检"中请求的字段。

3. Access-Control-Allow-Credentials:该字段与简单请求时的含义相同。

4. Access-Control-Max-Age:该字段可选，用来指定本次预检请求的有效期，单位为秒。上面结果中，有效期是20天（1728000秒），即允许缓存该条回应1728000秒（即20天），在此期间，不用发出另一条预检请求。


而一旦服务器通过了 **预检请求**,以后的每次通信，浏览器的 CORS 请求就跟普通请求一样了，
都会包含一个 **Origin** 头信息。服务器的回应，也都会有一个 **
Access-Control-Allow-Origin** 头信息字段。


下面是 **预检请求** 之后，浏览器的正常 CORS 请求:

``` 
PUT /cors HTTP/1.1
Origin: http://api.bob.com
Host: api.alice.com
X-Custom-Header: value
Accept-Language: en-US
Connection: keep-alive
User-Agent: Mozilla/5.0...
```

下面是服务器的正常回应:

``` 
Access-Control-Allow-Origin: http://api.bob.com
Content-Type: text/html; charset=utf-8
```




