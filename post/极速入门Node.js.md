---
title: 极速入门 Node.js  
date: 2016-12-23 09:45               
tags: ['Node.js']
toc: true
categories: technology

---
### 0x00 安装Node.js
安装完 `Node.js` 以后可以使用 `node -v` 命令查看当前版本

```
λ  node -v
v6.9.2
```

直接输入 `node` 指令则会进入到 `Node.js` 的命令行交互环境。

---
#### 安装 NPM
`npm` 是 `Node.js` 的包管理工具（package manager)。通过 `npm` 可以获得许多我们需要的模块和代码，以及模块间的依赖。

安装 `Node.js`  的时候，`npm` 便已经安装好了，通过 `npm -v` 指令可以查看 `npm` 的版本

```
λ  npm -v
3.10.9
```

---
### 0x01 第一个 Node 程序
从现在开始，我们编写的JavaScript代码将不能在浏览器环境中执行了，而是在Node环境中执行，因此，JavaScript代码将直接在你的计算机上以命令行的方式运行。

```
/*first_node.js*/
'use strict'
console.log("hello world")

//
λ  node first_node.js
hello world
```

第一行总是写上`'use strict'`,是因为我们总是以严格模式运行JavaScript代码，避免各种潜在陷阱。

---
#### 使用严格模式
如果有很多 JavaScript 文件，每个文件都写上 `'use strict'` 会很麻烦。我们可以给 Nodejs 传递一个参数，让 Node 直接为所有 js 文件开启严格模式：

```
λ  node --use_strict calc.js
```

当然，命令别名可以很方便的解决这个问题。

---
### 0x02 命令模式与 node 交互模式
在命令行模式下，可以执行 `node` 进入 Node 交互式环境，也可以执行 `node hello.js` 运行一个 `.js` 文件。在 Node 交互式环境下，输入的 JavaScript 代码会被立刻执行。


---
### 0x03 使用 WebStorm 搭建 Node 开发环境
WebStorm与IntelliJ IDEA同源，继承了IntelliJ IDEA强大的JavaScript部分的语法提示和运行调试功能。全平台，收费的商业软件，拥有30天的试用期。

下载安装完 WebStorm 后边可以新建工程，然后新建一个 `javascript` 文件开始编写代码了。



