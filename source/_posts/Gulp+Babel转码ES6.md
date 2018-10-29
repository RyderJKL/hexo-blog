---
title: ES6(16)Gulp+Babel转码ES6    
date: 2017-01-10  
tags: ['ES6']
toc: true
categories: technology

---
### 0x00 安装插件

```
安装全局 Gulp
npm install -g gulp

安装项目中使用的 Gulp
npm install --save-dev gulp

安装 Gulp 上 Babel 的插件
npm install --save-dev gulp-babel

安装 Babel 上将 ES6 转换成 ES5 的插件
npm install --save-dev babel-preset-es2015

安装 Gulp 上 uglify 压缩插件
npm install --save-dev gulp-uglify
```


---
### 0x01 Gulp 配置


```
在项目根目录新建 .babelrc ，内容为：
{
  "presets": ["es2015"]
}

在项目根目录新建 gulpfile.js，内容为：

var gulp = require("gulp");
var babel = require("gulp-babel");    // 用于ES6转化ES5
var uglify = require('gulp-uglify'); // 用于压缩 JS

// ES6转化为ES5
// 在命令行使用 gulp toes5 启动此任务
gulp.task("toes5", function () {
  return gulp.src("src/js/**/*.js")// ES6 源码存放的路径
    .pipe(babel()) 
    .pipe(gulp.dest("dist")); //转换成 ES5 存放的路径
});

// 压缩 js 文件
// 在命令行使用 gulp script 启动此任务
gulp.task('min', function() {
    // 1. 找到文件
    gulp.src('dist/*.js')
        // 2. 压缩文件
        .pipe(uglify())
        // 3. 另存压缩后的文件
        .pipe(gulp.dest('min/js'))
});

// 自动监控任务
// 在命令行使用 gulp auto 启动此任务
gulp.task('auto', function () {
    // 监听文件修改，当文件被修改则执行 script 任务
    gulp.watch('src/js/**/*.js', ['toes5']);
    gulp.watch('dist/*.js', ['min']);

});
```

