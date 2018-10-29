---
title: JavaScript模块化(2)之requireJS  
date: 2017-02-14      
tags: ['JavaScript','前端模块化']
toc: true
categories: technology

---
### 0x00 requireJS
requierJS 采用异步加载模块的式，它的出现不仅解决了页面在加载很多 JS 模块时的浏览器阻塞问题，还接管了模块间的依赖关系。

首先下载最新版本的 require.js 文件，然后在页面中使用 requireJS:

首先加载 require.js 文件:

```
<script src="js/require.js" defer async="true" ></script>
```

`async` 属性表明这个文件需要异步加载，避免网页失去响应。IE不支持这个属性，只支持 `defer`。

然后加载我们自己的主模块:

```
<script src="js/require.js" data-main="js/main" defer async="true"></script>
```

`main` 是整个网页应用的入口，即主模块，data-main属性的作用是，指定网页程序的主模块，其作用类似于 C 语言中 `main` 函数。`main.js` 中的后缀名 `.js` 在 require.js 中可以省略。

主模块依赖于其它的模块，而加载其它模块，需使用AMD规范定义 `require()` 函数。


``` 
// main.js
require(['moduleA', 'moduleB', 'moduleC'], function (moduleA, moduleB, moduleC){
    
});
```

`require()` 函数接受两个参数。第一个参数是一个数组，表示所依赖的模块，上例就是 `['moduleA', 'moduleB', 'moduleC']`，即主模块依赖这三个模块；第二个参数是一个回调函数，当前面指定的模块都加载成功后，它将被调用。加载的模块会以参数形式传入该函数，从而在回调函数内部就可以使用这些模块。


---
### 0x01 AMD 规范
使用 require.js 加载的模块都必须使用 AMD 规范，即模块必须采用 `define()` 函数来定义，该函数接受的第一个参数是一个数组，代表该模块对其它模块的依赖。

下面是使用 AMD 规范进行模块化的简单 demo:

```
 // 使用 require.js 加载模块
 
  // index.html
 <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="require.js" data-main="main.js" async defer="true"></script>
<body>

</body>
</html>

 // app.js
 /**
 * Created by onejustone on 2017/3/10.
 */
define(function () {

		function foo() {
			return "it's app.js";
		}
		
		return {
			foo: foo,
		}

});

 //index.js
 /**
 * Created by onejustone on 2017/3/10.
 */
define(['app'],function (app) {
	function bar () {
		let appContent = app.foo();

		console.log(appContent)
		console.log("it's index.js")
	}

	return {
		bar: bar
	}
});

// main.js
/**
 * Created by onejustone on 2017/3/10.
 */
require(['index'], function (index) {
	index.bar()
});
 
```

以上所由模块均在同一目录下。


---
### 0x02 模块加载
我们首先需要使用 `require.config()` 方法对需要加载的模块进行配置。该方法的参数是一个对象，而在该对象中,`paths` 属性代表模块的加载路径。`shim` 用于定义非 AMD 模块规范的一些模块的特征，因为有的第三方库并没有使用 AMD 规范编写,比如 Angular.js，所以
 `shim` 属性，是专门用来配置不兼容的模块的。具体来说，每个模块要定义:
 
 * (1) `exports值（输出的变量名）`: 表明这个模块外部调用时的名称；   
 * (2) `deps数组`: 表明该模块的依赖性。

#### 使用 require.js 加载 angular.js

```
/**
 * Created by onejustone on 2017/3/10.
 */

require.config({
	// 所有脚本的根目录，相对于 index.html
	baseUrl: "scripts",
	paths: {
		// Angular 脚本路径，相对于 baseUrl
		"angular": "angular",
		"angular-ui-router":"angular-ui-router.min"
	},
	shim: {
		"angular": {
			exports:"angular"},
		// 需要导出一个名称为 angular 的全局变量， 否则无法使用
		"angular-ui-router": {
			// 设置 angular 的其它模块依赖 angular 核心模块
			deps: ["angular"]
		}
	}
});


require(['angular','angular-ui-router'], function (angular) {
	console.info(angular.version)
});
```



