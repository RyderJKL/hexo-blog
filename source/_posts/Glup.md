---
title: Glup(1)  
date: 2016-12-31 9:45              
tags: ['JavaScript','前端自动化']
toc: true
categories: technology

---
### 0x00 What's Gulp
Gulp 是**基于流的自动化构建工具**。

> 开发者可以使用它在项目开发过程中自动执行常见任务。Gulp.js 是基于 Node.js 构建的，利用 Node.js 流的威力，你可以快速构建项目并减少频繁的 IO 操作。Gulp.js 源文件和你用来定义任务的 Gulp 文件都是通过 JavaScript（或者 CoffeeScript ）源码来实现的。

Gulp 是基于流的，Gulp 对文件的操作就像水管之于水流，水流流经水管，水管将水水流改变成不同的形状。


---
### 0x01 基于流的 Gulp
何为 **流**,请参考:

安装 glup: http://www.gulpjs.com.cn/docs/getting-started/

我们来看看 Gulp 是如何控制和操作流的:

```
'use strict'

var gulp = require('gulp')

gulp.task('sync1', function () {
	console.log("I am a sync task")
})

gulp.task('async', function (done) {
	setTimeout(function () {
		console.log("I am a async task")
		done()
    }, 2000)
})

```

我们可以看到，GUlp 是以任务开始的，`gulp.task` 可以定义一个任务，然后在命令行下使用 `gulp 任务名` 就可以执行对应的任务了:

```
D:\blog
λ  gulp sync1
[10:30:07] Using gulpfile D:\blog\gulpfile.js
[10:30:07] Starting 'sync1'...
I am a sync task
[10:30:07] Finished 'sync1' after 724 μs
D:\blog
λ  gulp async
[10:30:14] Using gulpfile D:\blog\gulpfile.js
[10:30:14] Starting 'async'...
I am a async task
[10:30:16] Finished 'async' after 2 s
```
Gulp 的任务可以是同步和异步，在异步任务中确定任务完成，可以通过调用函数参数 `done()` 来实现。

此外，`gulp.task` 可以有依赖，只要第二个参数传入一个数组，中间加上依赖的任务就行了，而数组里面的这些任务是并行处理的，不会一个执行完才执行另一个（同步任务的输出比异步任务的结束早）。

```
'use strict'

var gulp = require('gulp')

var through = require('through2')

gulp.task('sync1', function () {
	console.log('i am a sync')
})

gulp.task('sync2', function () {
	console.log('i am a second sync')
})

gulp.task('sync3', function () {
	console.log('i am a third sync')
})

gulp.task('async', function (done) {
	console.log('ready...')
	setTimeout(function () {
		console.log('Fire!')
		done()
    }, 2000)
})

gulp.task('asyncs', ['async', 'sync1', 'sync2', 'sync3'], function (done) {
	console.log('ok, task all done')
	done()
})

```

如上，我们组合了多个任务,以通过 gulp 依赖进行了并行处理:

```
D:\blog
λ  gulp asyncs
[11:04:40] Using gulpfile D:\blog\gulpfile.js
[11:04:40] Starting 'async'...
ready...
[11:04:40] Starting 'sync1'...
i am a sync
[11:04:40] Finished 'sync1' after 545 μs
[11:04:40] Starting 'sync2'...
i am a second sync
[11:04:40] Finished 'sync2' after 291 μs
[11:04:40] Starting 'sync3'...
i am a third sync
[11:04:40] Finished 'sync3' after 207 μs
Fire!
[11:04:42] Finished 'async' after 2 s
[11:04:42] Starting 'asyncs'...
ok, task all done
[11:04:42] Finished 'asyncs' after 240 μs
```

---
### 0x02 I/O 处理

除了以上的基本任务模式。对于每个 task, Gulp 通常通常用来操作文件输入和输出流，因此 Gulp 封装了批量操作文件流的 API：

```
'use strict'

let gulp = require('gulp')

gulp.task('src-dist', function () {
	gulp.src("./*.js")
		.pipe(gulp.dest('./public'))
})
```

上面的命令表示将当前目录下所有的 `.js` 文件匹配出来，依次输出到目标文件夹 `./public` 中去。

更高级一点，还可以将当前目录及其所有子目录中的文件提取出来:

```
'use strict'

let gulp = require('gulp')

gulp.task('src-dist', function () {
	gulp.src("./**/*.js")
		.pipe(gulp.dest('./public'))
})
```


---
### 0x03 Gulp 技巧
下面一个在开发环境中能够用到的 gulpfile.js 配置:

```
var gulp=require("gulp"),
	webserver=require("gulp-webserver"),
	livereload=require("gulp-livereload"),
	sass=require("gulp-ruby-sass"),
	uglify=require("gulp-uglify");

// 注册任务：
gulp.task("webserver",function(){
	gulp.src('./dist').pipe(webserver({
		livereload:true,
		open:true
	}))
});
// html任务：
gulp.task("html",function(){
	return gulp.src("src/**/*.html")
	.pipe(gulp.dest("dist"));
	//指明源文件路径并输出到发布环境
});

// sass任务：
gulp.task("sass",function(){
	return sass("src/sass/*.scss",{style:"compact"})
	.on("error",function(err){
		console.log("编译出错",err.message);
	})
	.pipe(gulp.dest("dist/css"))
})

// script压缩任务：
gulp.task("script",function(){
	return gulp.src("src/js/*.js")
			.pipe(uglify({preserveComment:"some"})) //压缩并保留注释
			.pipe(gulp.dest("dist/js"))
})

// 监听任务：
gulp.task("watch",function(){
	gulp.watch("*.html",["html"]);
});

//默认执行任务：
gulp.task("default",["sass","webserver","html","script","watch"]);
```


更多的高级用法请参看官方文档。



