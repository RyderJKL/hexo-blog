---
title: 深入浅出Node.js(1)模块机制
date: 2016-12-15 16:45
tags: ['Node.js']
toc: true
categories: technology

---
### 0x00 CommonJS

> CommonJS 规范为 JavaScript 制定了一个美好的愿景，使 JavaScript 可以运行在任何地方。

目前 CommonJS 规范涵盖了模块，二进制，Buffer，字符集编码，I/O流，进程环境，文件系统，套接字，单元测试，Web 服务器网关接口，包管理等。

Node 与浏览器和 W3C 组织，CommJS 组织，ECMASript 共同构成了一个繁荣的 JavaScript 生态系统。

![JavaScript生态系统](http://upload-images.jianshu.io/upload_images/1571420-34096fd5ed067931.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
#### CommonJS 模块规范
CommonJS 对模块的定义分为模块定义，模块标识，模块引入。

在模块中存在一个 `module` 对象，它代表模块自身，而上下文中的 `exports` 对象属于 `module` 对象的一个属性，用于导出当前对象的变量或方法。

在 Node 中，一个文件就是一个模块，将方法挂载在 `exports` 对象上作为属性即可定义导出的方式:

```
//math.js
exports.add = function (a, b) {  return a + b;}
```

在另一个文件中，通过 `require()` 方法引入模块后，就能调用定义的属性和方法了:

```
// program.js
var math = require('math');
exports.increment = function (val1, val2) { return math.add(val1, val2);
}
```

而模块标识其实就是传递给 `require()` 方法的参数。

> 模块的意义在于将类聚的方法和变量等限定在私有的作用域中，同时支持引入和导出功能以顺畅的连接上下游依赖。

---
### 0x01 Node 的模块实现
在 Node 中，模块分为两类:一类是 Node 提供的模块，称为核心模块；另一类是用户编写的模块，称为文件模块。

一旦在 Node 中引入模块以后便会经历随后三个步骤: **路径分析**  ==> **文件定位** ==> **编译执行**。

但是，_Node 核心模块_ 源代码在编译过程中，直接被编译进了二进制执行文件。当 Node 进程启动时，部分核心源代码便直接被载入内存，连文件定位和编译执行都不需要。所以其加载速度是最快的。

而 _文件模块_ 则是在运行时动态加载，需要完整的路径分析，文件定位，编译执行过程，速度比核心模块慢。


---
### 0x01 包与NPM
包实际上是一个存档文件，即一个目录打包为 `.zip` 或 `.tar.gz` 格式的文件，安装以后解压还原为目录。

完全符合 CommonJS 规范的包的目录结构应该包含如下内容:

* package.json: 包描述文件
* bin: 可执行二进制文件目录
* lib: 存放 Javascript 代码的目录
* doc: 存放文档的目录
* test: 存放单元测试用例的代码

##### package.json
下面是 Node 中 `package.json` 文件中的主要字段；

* name: 包名
* description: 包简介
* version: 版本号
* author: 作者
* bin: 提供命令行使用
* main: 模块引入方法 `requier()` 在包引入时优先检查该字段，并将其作为包中其余模块的入口
* keywords: 关键词数组，使得 NPM 可以快速搜索到该包
* maintainers: 包维护着列表。
* contributors: 包贡献者列表
* bugs: 反馈 bug 的网页地址或邮箱
* licenses: 当前包所使用的许可证列表
* repositories: 托管源代码的位置列表
* dependencies: 使用当前包所需要依赖的包列表，而 NPM
 会通过这个属性自动加载依赖的包
* devDependecies: 一些模块只在开发时需要依赖。

---
#### NPM 常用功能
CommonJS 包规范是理论，NPM 是其中的一种实践。

对于 Node 而言， NPM 帮助完成了第三方模块的发布，安装和依赖。借助 NPM, 用户可以快速安装和管理依赖包。

下面是 node 的常用方法:

##### 查看帮助
运行 `npm -v` 可查看当前 NPM 版本。而直接运行 `npm` 则可以查看  NPM 帮助信息。

##### 安装依赖

* 执行 `npm install packe_name` 便可以安装一个包，并将其自动解压到 `node_modules` 目录下。

* 执行 `npm init` 会在当前目录下新建一个 `package.json` 文件

* 执行 `npm install pack_name --save` 将会安装一个包，并将其添加到 `package.json` 中 `dependencies` 字段中作为项目中的依赖。

* 执行 `npm install pack_name -g` 代表进行全局模式安装。但是全局模式并不意味着可以在计算的任何地方通过 `require()` 来引用它。 `-g` 实际上是将一个包安装为全局可用的可执行命令。它根据包描述文件中的 `bin` 字段配置。将实际脚本链接到与 Node 可执行文件相同的路劲下。

---
### 0x02 小结
CommonJS 提出的规范很简单，但却帮助 Node 形成了它的骨骼。

Node 通过模块规范组织了自身的原生模块，弥补了 Javascript 弱结构性的问题，形成了稳定的结构，并向外提供服务。

NPM 通过对包规范的支持，有效的组织了第三方模块，使得项目开发中的依赖问题得到了很好的解决，并有效提供了分享和传播的平台。


