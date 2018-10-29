---
title: 定时器     
date: 2016-12-13         
tags: ['JavaScript','JS高阶']
toc: true
categories: technology

---
### 0x00 非异步
`setTimeout` 和 `setInterval` 并非异步调用, 所谓的”异步调用”, 只是因它们都往 js 引擎的 待处理任务队列 末尾插入代码, 看起来像”异步调用”而已.

---
### 0x01 重复定时器
很多情况下，我们都需要使用 **setInterval()** 重复的执行同一段代码去做同一件事情，而在这时，最大的问题在于定时器可能在代码再次被添加到队列之前还没有被执行完成，从而导致某些间隔被跳过或者多个定时器的代码执行时间间隔被缩短。

为了避免以上缺点，可以使用链式调用 **setTimeout()** 模式

```
setTimeout(function(){
	// do something

	setTimeout(arguments.callee, interval);
}, interval)
```


一个例子:

```
setTimeout(function(){
	$("#block").css({
		'left': $('#block').position().left -1,
	})
	if($('#block').position().left > 0){
		setTimeout(arguments.callee, 30);
	}

}, 30)
```

---
### 0x01 数组分块
为了防止恶意程序猿将用户的计算机搞挂，浏览器对 JavaScript 能够使用的资源进行了限制，如果代码的运行时间超过特定时间或者特定语句数量就不让其继续运行。

而脚本运行时间过长的两个主要原因是:1)过长，过深嵌套的函数调用；2)进行大量处理的循环。

针对第二种问题，使用定时器是解决方法之一。使用定时器分隔循环，是一种叫作 **数组分块(array chunking)** 的技术。

在数组分块模式中，array 变量本质上就是一个 “代办事项” 列表，它包含了要处理的项目，而 **shift()** 可以获取队列中下一个要处理的项目，然后将其传递个某个函数。当队列中还剩下其它项目时，则设置另一个定时器，并通过 **arguments.callee** 调用同一个匿名函数。

```
function chunk(array, process, context){
	setTimeout(function(){
		var item = array.shift()
		process.call(context, item)

		if(array.length > 0){
			setTimeout(arguments.callee, 100)
		}
	}, 100)
}
```

**chunk()** 方法接收三个参数： 要处理项目的数组，用于处理项目的函数，可选的运行该函数的环境。


在函数内部，通过 **call()** 调用 **process()** 函数，这样可以设置一个合适的执行环境。为定时器设定的时间间隔使得 JavaScript 进程有时间在处理项目的事件之间转入空闲。

调用实例:

```

var data = [12,124,343,56,76767,43,654,34645,56456,767,4645]
function printValue(item){
	var div = $('#block').html()
	$('#block').html(div + item + '<br>')
}

chunk(data, printValue)
```

如上，函数 `printValue()` 将 `data` 数组中的每个值输出到一个 `div` 元素中。由于函数处于全局作用域中，因此无需给 `chunk()` 函数传递 `context` 对象。


如果想保持原数组不变，则应将该数组的克隆传递给 `chunk()`

```
chunk(data.concat(), printValue)
```

调用某个数组的`.contact()`,如果不传递任何参数，将返回和原来数组中项目一样的数组。

