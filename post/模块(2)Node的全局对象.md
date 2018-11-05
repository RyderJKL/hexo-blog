---
title: 模块(2)Node的全局对象  
date: 2016-12-23 09:45                
tags: ['Node.js','模块']
toc: true
categories: technology

---
### 0x00 
Node.js  内置的常用模块实现了基本的服务器功能。比如,接收网络请求，读写文件，处理二进制内容，此外，也没有了浏览器的各种安全限制。


---
### 0x01 global
JavaScript 在浏览中有一个全局对象，`window` 对象，而在 Node.js 中,同样具有一个唯一的全局对象 `global`。


---
### 0x02 process 
`process` 对象是 Node.js 中以很重要的对象，它代表当前 Node.js 进程。JavaScript 程序是由事件驱动执行的单线程模型，Node.js 也不例外。


如果想要在下一次事件响应中执行代码，可以调用 `process.nextTick()`：

```
/**
 * Created by onejustone on 2016/12/23.
 */
'use strict';

process.nextTick(function () {
    console.log("nextTick callback!");
});

console.log("nextTick was set!");
```

输出:

```
nextTick was set!
nextTick callback!
```

这说明传入 `process.nextTick()` 的函数不是立刻执行，而是要等到下一次事件循环。

Node.js 进程本身的事件就由 `process` 对象来处理。如果我们响应 `exit` 事件，就可以在程序即将退出时执行某个回调函数：

```
/**
 * Created by onejustone on 2016/12/23.
 */
'use strict';

process.nextTick(function () {
    console.log("nextTick callback!");
});

console.log("nextTick was set!");

process.on('exit', function () {
    console.log("I am waiting exit...")
});
```

输出:

```
nextTick was set!
nextTick callback!
I am waiting exit...
```

---
### 0x03 判断 javascript 执行环境
我们可以根据浏览器和 Node 环境提供的全局变量名称来判断 javascript 的执行环境：

```
if (typeof (window) === 'undefined'){
  console.log("node.js")
} else {
  console.log("browser")
}
```

