---
title: JS服务器编程(5)CROS   
date: 2016-12-20 19:32  
tags: ['JavaScript','CROS']
toc: true
categories: technology

---
### 0x00 跨域资源共享
CORS(Cross-Origin Resource Sharing, 跨域资源共享)是W3C的一个工作草案，定义了在必须访问跨资源请求时，浏览器与服务器应该怎样沟通。

其中具体的实现是为发送请求时为其添加一个额外的 Origin 头部，包含请求页面的源信息(协议，域名，端口)，以便服务器根据这个头部信息来决定是否给予响应。

浏览器请求的 Origin 头部:

```
Origin: http://www.sina.com
```

如果服务器认为这个请求是可以接受的，就在 `Access-Control-Allow-Origin` 头部中会发相同的源信息(公共资源，可以会发 "*").

```
Access-Control-Allow-Origin： http://wwww.sina.com
```

如果该头部不存在，或者有这个头部但信息源不匹配，浏览器就会驳回请求。

---
### 0x01 IE CORS
微软从 IE8 开始引用了 XDR(XDomainRequest) 类型来实现跨域通信。

与 XHR 对象类似，使用 XDR 对象首先需要创建一个 `XDomianRequest` 实例,调用 `open()` 方法以后再调用 `send()` 方法。不过 XDR 的 open 方法只接收两个参数: 请求的类型和 URL。即 XDR 的请求都是异步的。

请求返回之后会触发 `load` 事件，响应的数据也会保存在 `responseText`  属性中。

```
var xdr = new XDomainRequest()
xdr.onload = function () {
    console.log(xdr.responseText)
}

xdr.onerror = function () {
    console.log("An error occurred."
}

xdr.timeout = 1000
xdr.ontimeout = function (){
    console.log("Request too long")
}

xdr.open("get", "http://wwww.sina.com/pag")
xdr.send(null)
```

> 由于 XDR 请求失败的因素很多，最好使用 onerror 事件处理程序来捕获该事件；否则，即使请求失败也不会有任何提示

为支持 `POST` 格式，XDR 对象提供了 `ContentType` 属性，用来表示发送数据的格式。

```
var xdr = new XDomainRequest()
xdr.onlode = function (){
    console.log(xdr.responseText)
}

xdr.onerror = functinon () {
    console.log("An error occurred)
}
xdr.open("POST", "http://www.sina.com/pages")
xdr.contentType = "application/x-www-form-urlencoded"
xdr.send("formData")
```

---
### 0x02 其它浏览器 CORS
除 IE 以外的绝大部分浏览器都通过 `XMLHttpRequest` 对象实现了对 CORS 的原生支持。要请求另一域中的资源，只需要用标准的 XHR 对象并在 `open` 方法中传入绝对 URL 即可。

```
let xhr = new XMLRequest()
xhr.onreadystatechange = function () {
    if ((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304){
        console.log(xhr.responseText
    } else {
        console.log("Unsuccessful:" + xhr.status)
    }
}
xhr.open("get", "http://www.somewhere.con/page/", true)
xhr.send(null)
```

与 IE 中的 XDR 对象不同,通过跨域 XHR 对象可以访问 `staus` 和 `statusText` 属性，并且支持同步请求。当然，处于安全考虑，也为 XHR 添加了一些必要的限制。

* 不能使用 `setRequestHeader()` 设置自定义头部
* 不能发生和接收 cookie
* 调用 `getAllResponseHeader()` 方法会返回空字符

---
### 0x03 跨浏览器的 CORS
检测 XHR 是否支持 CORS 的最简单的方式，就是检测是否存在 `withCredentials` 属性。再结合 `XDomainRequest` 对象是否存在，就可以实现以最基本的(以最简单的方式支持)跨 CORS 方案，兼顾所有的浏览器了。

```
function createCORSRequest(method, url){
	let xhr = new XMLHttpRequest()
	if ("widthCredentials" in xhr){
		xhr.open(method, url, true)
	} else if ( typeof XDomainRequest != "undefined"){
		xhr = new XDomainRequest()
		xhr.open(method, url)
	} else {
		xhr = null
	}
	return xhr
}

let request = createCORSRequest("get","http://www.somewhere.com/page/")
if (request){
	request.onload = function (){
		//deal request.responseText
	}
	request.send(null)
}
```

所有的浏览器都提供了一些通用的接口,即 `XMLRequest` 对象和 `XDomainRequest` 对象共有的属性/方法:

* abort(): 停止正在发送的请求
* onerror(): 用于替代 `onreadystatechange` 检测错误
* onload()： 用于替代 `onreadystatechaneg` 检测成功
* responseText: 用于取得响应内容
* send(): 用于发送请求

以上成员都包含在 `createCORSRequest()` 函数返回的对象中,在所有的浏览器中都能正常使用。

---
### 0x04 其它跨域技术
未完待续。。。


