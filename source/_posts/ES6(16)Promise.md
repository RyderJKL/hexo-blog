---
title: ES6(16)Promise  
date: 2016-12-26    
tags: ['ES6']
toc: true
categories: technology

---
### 0x00 初见 Promise 


`Promise` 是异步编程的一种解决方案，比传统的解决方案——回调函数和事件——更合理和更强大。

在传统的 Node 异步编程中，比如按照一定顺序去读取多个文件进行异步操作时，很容易陷入 _回调地狱_。

```
var fs = require('fs');
fs.readFile("fileName1", function (err, data) {
	if (!err){
		fs.readFile("fileName1", function (err,data) {
			if (!err){
			//	......
			}
		})
	}
});
```


本节不会去深究 Promise 的底层实现，而是讨论如何使用 Promise 对象去进行异步操作。

Promise 的两个特点:
* 对象的状态不受外界影响。Promise对象代表一个异步操作，有三种状态：`Pending`（进行中）、`Resolved`（已完成，又称 `Fulfilled`）和`Rejected`（已失败）。只有异步操作的结果，可以决定当前是哪一种状态，任何其他操作都无法改变这个状态。
* 一旦状态改变，就不会在变，任何时候都可以得到这个结果。Promise对象的状态改变，只有两种可能：从`Pending`变为`Resolved`和从`Pending`变为`Rejected`。

有了 Promise 对象，便可以将异步操作以同步操作的流程表达出来，避免回调地狱。

当然，Promise 也是有缺点的，就是在于其状态的不可中断特性。因为在实际的开发过程中，是很有可能需要去中断这个状态的。

---
### 0x01 使用 Promise
ES6规定，Promise对象是一个构造函数，用来生成Promise实例。其接受两个`resolve` 和 `reject` 函数作为参数。

`resolve` 函数的在异步操作成功时调用，并将异步操作成功的结果作为参数传递出去。而 `reject` 函数在异步操作失败时调用，并将异步操作失败时返回的结果作为参数传递出去。这两个函数，由JavaScript引擎提供，不用自己部署。

以下代码创建 Promise 实例:

```
let promise = new Promise(function (resolve, reject){})
```

Promise实例生成以后，可以用`then`方法分别指定R`esolved`状态和`Reject`状态的回调函数。

```
promise.then(function (value) {
//	success
},function (err) {
//	error
});
```

`then` 接受两个回调函数作为参数。第一个回调函数是Promise对象的状态变为`Resolved`时调用，第二个回调函数是Promise对象的状态变为`Reject`时调用,而第二个参数是可选的。**这两个函数都接受Promise对象传出的值作为参数。**

Promise 一旦创建便会立即执行:

```
let promise = new Promise(function (resolve, reject){
	console.log('Promise');
	resolve();
});

promise.then(function (value) {
//	success
	console.log("Resolved");
},function (err) {
//	error
});

console.log("hi");
//Promise
//hi
//Resolved
```

---
#### 使用 Promise 发送 Ajax 请求

```
let getJSON = function (url) {
	return new Promise(function (resolve, reject) {
		let client = new XMLHttpRequest();
		client.open("GET", url, true);
		client.onreadystatechange = handler;
		client.responseType = "json";
		client.setRequestHeader("Accept", "application/json")
		client.send();

		function handler () {
			if (this.readyState!== 4){
				return;
			}

			if (this.status === 200){
				resolve(this.response);
			} else {
				reject(new Error(this.statusText));
			}
		}
	});
};

getJSON(url).then(function (json) {
	console.log("Contents: " + json);
}, function (err) {
	console.log("Error: " + err);
});
```

注意，在 `getJSON` 内部，在 `then` 方法中，调用函数 `resolve` 和函数 `reject` 时都带有参数，而在这些参数都将会被传递个回调函数。reject函数的参数通常是 `Error` 对象的实例，表示抛出的错误；`resolve` 函数的参数除了正常的值以外，还可能是另一个 Promise 实例。

[源代码](https://github.com/onejustone/JavaScript/tree/master/Promise_demo)

---
#### Promise.prototype.then()

`then()` 方法的作用是为 Promise 实例添加状态改变时的回调函数。在函数执行完成以后`then` 方法会返回一个新的 Promise 实例，以形成链式调用。

```
getJSON(url).then( value => value.commentURl)
.then(
	value => console.log(vlaue),
	err => console.log(err)
);
```

---
#### Promise.prototype.catch()

`catch()` 方法是 `then(null, rejection)` 方法的别名。通常来说，我们并不建议直接在 `then()` 方法中去处理异步操作可能产生的错误，即不要在 `then` 方法里面定义 `Reject` 状态的回调函数（即then的第二个参数）而是使用 `catch` 方法去捕获错误。

首先，Promise 对象中的错误具有冒泡性质，错误会一直向后传递。其次，Promise 对象中的错误也不会传递到外层代码中去，如果不使用 `catch` 方法，是不会捕获到错误的。这跟传统的 `try/catch` 代码块不同。


```
// bad
promise
  .then(function(data) {
    // success
  }, function(err) {
    // error
  });

// good
promise
  .then(function(data) { //cb
    // success
  })
  .catch(function(err) {
    // error
  });
 ```

 Node 中的 `unhandledRejection` 事件，专门用来监听为处理的 `reject` 错误:

 ```
process.on('unhandledRejection', function (err, p) {
  console.error(err.stack)
});
 ```

其接受两个参数,第一个是错误对象，第二个是报错的Promise实例。


---
### 0x02 不存在与 ES6 中的 Promise 方法

---
#### done() 

`done()` 方法用于捕获 Promise 回调链尾部可能抛出的任何错误:

```
Promise.prototype.done = function (resolve, reject) {
	this.then(resolve, reject)
	.catch(function (reason){
	// 抛出一个全局错误
		setTimeout( () => { throw reason;}, 0);
	});
};
```

---
#### finally()
`finally()` 方法用于指定不管Promise对象最后状态如何，都会执行的操作。其接受一个普遍的回调函数作为参数。

```
Promise.prototype.finally = function (callback){
	let P = this.constructor;
	return this.then({
		value => P.resolve(callback()).then( () => value),
		reason => P.resolve(callback()).then( () => {throw reason})
	});
};
```

---
### 0x03 应用

---
#### 加载图片
将图片的加载写成一个Promise，一旦加载完成，Promise的状态就发生变化。

```
const  preLoadImagePro = function (path) {
    return new Promise(function (resolve, reject) {
        let image = new Image();
        image.onload = resolve;
        image.onerror = reject;
        image.src = path;
    })
}
```

---
#### 构建顺序执行异步任务

```
var sequence = Promise.resolve();
array.forEach(function(item) {
	sequence = sequence.then(//deal item)
});
```



