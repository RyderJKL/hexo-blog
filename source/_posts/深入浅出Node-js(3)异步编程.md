---
title: 深入浅出Node.js(3)异步编程
date: 2017-01-21 13:11
tags: ['Node.js','深入浅出Node.js学习笔记']
toc: true
categories: technology

---
> V8 和 异步 I/O 在性能上的提升，前后端 Javascript 编程风格的一致，是 Node 能够迅速成功并流行起来的原因。

---
### 0x00 优缺点
Node 最大的优势莫过于基于事件驱动的非阻塞 I/O 模型，这是它的灵魂所在。非阻塞 I/O 可以使得 CPU 与 I/O 并不相互依赖等待，让资源得到更好的利用。

但也正是为了解决编程模型中阻塞 I/O 的性能问题，采用了单线程模型，这使得 Node 更像一个处理 I/O 密集问题的高手，而 CPU 密集型问题则取决于 Javascript 的单线程处理能力。

---
### 0x01 难点

---
#### 异常处理
Node 异步 I/O 的实现主要有两个阶段: _提交请求和处理结果_。这两个阶段中间有事件循环的调度，两者彼此不关联。异步方法则通常在第一个阶段提交请求以后立即返回，但异常并不一定发生在这个阶段，`try/catch` 功效在此处不会发生任何作用。

```
let async = function (callback){
    process.nextTick(callback);
};

try {
    async(callback);
} catch (e) {
    //TODO
};
```

Node 在处理异常上形成了一种约定: _将异常作为回调函数的第一个实参传回，如果为空值，则表明异步调用没有异常抛出_

而在我们自行编写的异步方法上，也需要去遵循这样一些原则:

* 必需执行调用者传入的回调函数；
* 正确传递回异常供调用者判断。

示例如下:

```
var async = function (callback){
	process.nextTick(function (){
		var results = something;
		if (error) {
			return callback(error);
		}
		callback(null, results);
	})
}
```

---
#### 函数嵌套
DOM 事件相对而言不会存在相互依赖或者多个事件一起协作的场景，较少存在异步多级依赖的情况，但在 Node 而言，事务中存在多个异步调用的场景比比皆是。

---
#### 阻塞代码
Javascript 中没有 `sleep()` 这样的线程沉睡功能，唯独能用于延时操作的只有 `setInterval()` 和 `setTimeout()` 这两个函数，而正常情况这两个函数并不能阻塞后续代码的执行，因为它们本身就是异步的。

---
#### 多线程编程
在浏览器中 javascript 执行线程与 UI 渲染共用同一个线程，为了使得 javascript 执行与 UI 渲染分离，浏览器端提出了 **Web Works**，它可以很好的利用多核 CPU 为大量计算服务。而对于 Node，在服务器端，若服务器是多核 CPU 单个 Node 进程实际上并没有充分利用到多核 CPU,Node 借鉴了 Web Works 的工作模式，将 **child_process** 作为其基础 API，而 **cluster** 模块则是更深层次的应用，基于此，开发人员可以在 javascript 中进行跨线程的编程了。

---
### 0x02 异步编程解决方案
以下是异步编程的三种解决方案:

* 事件监听模式
* Promise/Deferred 模式
* 流程控制库

---
#### 事件监听模式
事件监听模式是回调函数的事件化，一种广泛用于异步编程的模式，有称为 **发布/订阅模式**。



 




