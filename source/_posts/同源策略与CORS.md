---
title: 同源策略与CORS
date: 2017-01-22 12:45         
tags: ['前端漫话之网络']
toc: true
categories: technology

---
### 0x00 同源策略
**同源策略(Same-origin policy)** 是浏览器安全的基石,其目的是为了保护用户信息的安全，具体点，同源指的是三个相同，`协议相同`, `域名相同`,` 端口相同`。如果非同源，以下三种行为将会受到限制:

* Cookie,localStorage,和 IndexDB 无法读取
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

---
### 0x01 CORS
同源策略规定，AJAX 请求正发送给同源的网址，否则就会报错。面对这个问题，我们很多种解决的方法:

 * JSONP
 * Cmment

