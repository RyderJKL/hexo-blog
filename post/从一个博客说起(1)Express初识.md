---
title: 从一个博客说起(1)Expresss初识  
date: 2016-12-30 20:30  
tags: ['Node.js']
toc: true
categories: technology


---
### 0x00 安装 Express
使用 Express 的前提是，已经安装了 `Node.js` :

```
npm install -g express --save
// 全局安装 Express 并将其保存到依赖列表中：
```

---
### 0x01 使用 Express 生成器
通过应用生成器工具 express 可以快速创建一个应用的骨架。
 

```
npm install express-generator -g
// 全局安装生成器
express -e NEMBlog
//当前工作目录下创建一个命名为 blog 的应用,并制定模板引擎为 ejs
```

生成如下目录和文件:

```
λ  express -e NEMBlog

  D:\Git-Repository\NEMBlogPS>express -e .

  warning: option `--ejs' has been renamed to `--view=ejs'

destination is not empty, continue? [y/N] y

   create : .
   create : ./package.json
   create : ./app.js
   create : ./public
   create : ./public/images
   create : ./public/stylesheets
   create : ./public/stylesheets/style.css
   create : ./public/javascripts
   create : ./routes
   create : ./routes/index.js
   create : ./routes/users.js
   create : ./views
   create : ./views/index.ejs
   create : ./views/error.ejs
   create : ./bin
   create : ./bin/www

   install dependencies:
     > cd . && npm install

   run the app:
     > SET DEBUG=nemblog:* & npm start
```

```
cd blog 
// 进入应用目录
npm install
// 安装相关依赖
set DEBUG=blog
// 设置测试模式
npm start
// 启动应用
// DEBUG=blog npm start(Mac or Linux)
//启动这个应用
```

当看到如下信息，代表启动成功:

```
D:\blog
λ  set BEBUG=blog
D:\blog
λ  npm start

> blog@0.0.0 start D:\blog
> node ./bin/www

GET / 200 1442.953 ms - 170
GET /stylesheets/style.css 200 41.876 ms - 111
```

访问 `localhost:300` 可看到 Express 的欢迎页面。

---
### 0x02 工程结构
如此，我们使用 Express 初始化了一个工程项目。该工程项目的内部结构如下:

```
D:\blog
λ  ls


    目录: D:\blog


Mode                LastWriteTime     Length Name
----                -------------     ------ ----
d----        2016/12/30     16:16            bin
d----        2016/12/30     16:34            node_modules
d----        2016/12/30     16:16            public
d----        2016/12/30     16:16            routes
d----        2016/12/30     16:16            views
-a---        2016/12/30     16:16       1257 app.js
-a---        2016/12/30     16:16        324 package.json
```

* app.js: 启动文件。
* packages.json: 存储与工程相关的信息及模块依赖。当在 `dependecies` 中添加依赖的模块时，运行 `npm install`,npm 会检查当前目录下的 `package.json`，并自动安装所有指定的模块。
* node_modules: 存放 `package.json` 中安装的模块。
* public: 存放 image,css,js等文件。
* routes：存放路由文件。
* views: 存放视图文件，或者说模块文件。
* bin: 存放启动项目的脚本文件。比如，当我们运行 `npm start` 的时候实际上运行的是 `node ./bin/www` 命令。

---
#### app.js

我们来看一下 `app.js` 文件中的内容:

```
D:\blog
λ  cat .\app.js
// 加载依赖库
var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

// 加载路由控制
var index = require('./routes/index');
var users = require('./routes/users');

// 创建项目实例
var app = express();

//  定义EJS模板引擎和模板文件位置，也可以使用ejs或其他模型引擎
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
// 定义 icon 图标
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
// 定义日志和输出级别
app.use(logger('dev'));
// 定义数据解析器
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
// 定义cookie解析器
app.use(cookieParser());
// 定义静态文件目录
app.use(express.static(path.join(__dirname, 'public')));

// 匹配路径和路由
app.use('/', index);
app.use('/users', users);

// catch 404 and forward to error handler
// 404 错误处理
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
// 生产环境，500 错误处理和错误堆栈跟踪
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

// 输出模型
module.exports = app;
```

---
#### www
`bin/www` 是一个 node 脚本文件，用于分离配置和启动程序:

```
D:\blog\bin
λ  cat www
#!/usr/bin/env node

/**
 * Module dependencies.(依赖加载)
 */

var app = require('../app');
var debug = require('debug')('blog:server');
var http = require('http');

/**
 * Get port from environment and store in Express.(自定义启动端口)
 */

var port = normalizePort(process.env.PORT || '3000');
app.set('port', port);

/**
 * Create HTTP server.(创建 HTTP 服务器实例)
 */

var server = http.createServer(app);

/**
 * Listen on provided port, on all network interfaces.(启动网络服务监听端口)
 */

server.listen(port);
server.on('error', onError);
server.on('listening', onListening);

/**
 * Normalize a port into a number, string, or false.(标准化函数)
 */

function normalizePort(val) {
  var port = parseInt(val, 10);

  if (isNaN(port)) {
    // named pipe
    return val;
  }

  if (port >= 0) {
    // port number
    return port;
  }

  return false;
}

/**
 * Event listener for HTTP server "error" event.（http 异常事件处理程序）
 */

function onError(error) {
  if (error.syscall !== 'listen') {
    throw error;
  }

  var bind = typeof port === 'string'
    ? 'Pipe ' + port
    : 'Port ' + port;

  // handle specific listen errors with friendly messages
  switch (error.code) {
    case 'EACCES':
      console.error(bind + ' requires elevated privileges');
      process.exit(1);
      break;
    case 'EADDRINUSE':
      console.error(bind + ' is already in use');
      process.exit(1);
      break;
    default:
      throw error;
  }
}

/**
 * Event listener for HTTP server "listening" event.(事件绑定函数)
 */

function onListening() {
  var addr = server.address();
  var bind = typeof addr === 'string'
    ? 'pipe ' + addr
    : 'port ' + addr.port;
  debug('Listening on ' + bind);
}
```

---
### 0x03 关于静态目录

可以通过 Express 中的 `express.static` 内置中间件函数设置静态目录。将包含静态资源的目录的名称传递给 `express.static` 中间件函数便可以直接访问图像、CSS 文件和 JavaScript 文件之类的静态文件。
 
##### 几个路径问题 __dirname,__filename, process.cwd() , ./, ../
假如 `app.js` 文件位于 `` 下,我们在 `app.js` 中运行如下代码:

```  
server.listen(7880, function(){
	console.log('Web Server Start');
	console.log('__dirname:'+ __dirname)
	console.log('__filename:' + __filename)
	console.log('process.cwd:' + process.cwd())
	console.log('./'+ path.resolve('./'));
	console.log('../:'+ path.resolve('../'))
});

// path.resolve('./') 可以将(./)等转换为绝对路径。

输出结果如下:

__dirname:D:\Git-Repository\GoChat
__filename:D:\Git-Repository\GoChat\app.js
process.cwd:D:\Git-Repository\GoChat
./D:\Git-Repository\GoChat
../:D:\Git-Repository
```

如此得出如下结果:

* `__dirname`:  当前文件所在文件夹的绝对路径
* `__filename`: 当前文件的绝对路径
* `process.cwd()`:总是返回运行 node 命令时所在的文件夹的绝对路径
* `./`: 当前文件所在路径
* `../`: 当前文件的上一级路径
 
 ---
### 0x04 使用 supervisor


supervisor 相当于 node 的热修复，它会监听当前目录下 node 和 js 后缀的文件，当这些文件发生改动时，supervisor 会自动重启程序,而我们不用手动重新启动整个程序。


全局安装

```
npm i -g supervisor
```


