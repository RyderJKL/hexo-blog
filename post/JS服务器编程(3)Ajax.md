---
title: JS服务器编程(3)Ajax      
date: 2016-12-01 22:20  
tags: ['JavaScript','Ajax']
toc: true
categories: technology

---
### 0x00 前言
Ajax 的核心技术是 `XMLHttpRequest` 对象(简称 XHR)。通过 XHR 可以以异步的方式从服务器获得更多的信息，这意味着，我们不必刷新整个页面就可以得到新数据。


> Ajax 是一种从页面项服务器端请求数据的技术，而 comet 是一种从服务器端向页面推送数据的技术。可以说 Comet 是一种更高级的 Ajax 技术。

---
### 0x01 XMLHttpRequest
要使用 XHR 对象，首先需要调用 `open()` 方法:

```
var xhr = new XMLHttpRequest()
xhr.open("get", "example.php", false)
```

`open()` 方法接收三个参数:请求类型(get,post), URL, 以及是否异步发送请求的布尔值。

调用 `open()` 方法并不会真的发送数据，而是启动一个请求以备发送。

要发送请求需要调用 `send()` 方法。

```
var xhr = new XMLHttpRequest();
xhr.open("get", "example.php", false)
xhr.send(null)
```

`send()` 接收一参数，即作为请求主体发送的数据，若不存在，则必须传入 null。

如上，我们发送了一个同步请求，这样， JS 代码只会在得到服务器响应之后才会继续执行。而收到响应的数据会自动填充 XHR 对象的属性。

* status:响应的 HTTP 状态
* statusText: HTTP 状态说明
* responseText:作为响应主体被返回的文本
* responseXML:如果响应的内容类型时 text/xml 或者application/xml 则这个属性中保存包含着响应数据的 XML DOM 文档。

接收到相应后首先检查 status 返回 200 状态码则表示响应成功返回，意味着 responseText 属性的内容已经准备就绪，如果 内容类型正确的话， responseXML 也可以访问了。

如果状态码为 304 表示所请求的资源并没有被修改，可以直接使用浏览器缓存内容。


为确保响应正确，可以做以下检查：

```
if((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304){
    console.log(xhr.responseText)
} else {
    console.log("is unsuccessful" + xhr.status)
}
```

如上，我们对服务器发送了一个同步请求，但多数情况下需要的是异步请求，从而让 JavaScript 可继续执行而不必等待响应。


---
### 0x02 readySate and readystatechange
XHR 对象的 `readyState` 属性表示请求/响应过程的当前活动阶段。该属性的可取值如下:
* 0: 未初始化。尚未调用 `open()` 方法
* 1: 启动。已经调用 `open()` 方法
* 2: 发送。已经调用 `send()` 方法
* 3: 接收。已经接收到部分响应数据
* 4: 完成。已经接收到全部响应数据，并且可以在客户端使用了

只要 `readyState` 属性的值由一个值变成另一位一个值，都会触发 `readystatachange` 事件，可以据此来检测每次状态变化以后的 `readyState` 值。

```
var xhr = new XMLHttpRequest()
xhr.onreadystatechange = function(){
	if(xhr.readyState == 4){
		if((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304){
			console.log(xhr.responseText)
		}else{
			console.log("Request was unsuccessful:" + xhr.status)
		}
	}
}

xhr.open('get','response.php',true)
xhr.send(null)
```

使用 DOM0 级方法为 XHR 对象添加事件，是因为并非所有的浏览器都支持 DOM2 级方法。考虑到不同浏览器对 XHR 兼容性，也没有向 `onreadystatechange()` 事件处理程序传递 `event` 对象，并且没有在该事件处理程序中使用 `this` 对象。

---
#### 构建兼容版本的 Ajax

```
function createXHR(){
		//如果浏览器支持XMLHttpRequest那么直接创建返回该对象
		if (typeof XMLHttpRequest != 'undefined'){
			return new XMLHttpRequest();
		}else if(typeof ActiveXObject != 'undefined'){
			if (typeof arguments.callee.activeXString != 'string'){
				var versions = ['MSXML2.XMLHttp.6.0', 'MSXML2.XMLHttp.3.0','MSXML2.XMLHttp'];
				for(var i = 0; i < versions.length;i++){
					try{
						new ActiveXObject(versions[i]);
						arguments.callee.activeXString = versions[i]
					}catch(e){

					}
				}
			}
			return new ActiveXObject(arguments.callee.activeXString);
		}else{
			throw new Error("没法正常的创建ajax对象");
		}
	}
```

---
### 0x03 GET 请求的 URL 编码
`GET` 请求，通常用于向服务器查询某些信息。对 XHR 而言，传入 `open()` 方法的 URL 末尾的查询字符串必须经过 `encodeURIComponent()` 进行编码。而所有的 `键值对` 之间必须由 `&` 号隔开。

```
xhr.open('get', 'response.php?name1=valuea&name2=valueb', true)
```

下面的 `addURLParam()` 函数可以辅助向现有的 URL 末尾添加查询字符串参数:

```
function addURLParam(url, name, value){
	url += (url.indexOf("?") == -1?"?":"&")
	url += encodeURIComponent(name) + "=" + encodeURIComponent(value)
	return url
}
```


```
var url = 'response.php'

// 添加参数
url = addURLParam(url, 'name', 'jack')
url = addURLParam(url, 'book', '质素的一')

// 初始化请求
xhr.open('get',url, true)
```


---
### 0x04 POST 请求模仿表单提交
`POST` 请求，通常用于向服务器发送应该被保存的数据。

我们可以使用 XHR 来模仿表单提交，首先将 `Content-Type` 头部信息设置为  `applicaiton/x-www-form-urlencodeed` 即表单提交时的内容类型，然后使用 `serialize()` 函数对页面中要提交的数据进行表单格式化。

```
function submitData(){
	let xhr = new XMLHttpRequest()
	xhr.onreadystatechange = function(){
		if(xhr.readyState == 4){
			if ((xhr.status >=200 && xhr.status < 300)  || xhr.status == 304){
				console.log(xhr.responseText)
			} else {
				console.log("Request was unsuccessful:" + xhr.status)
			}
		}
		
	}

	xhr.open("POST", url , true)
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	let form = document.querySelector("#form1")
	xhr.send(serialize(form))
}
```



