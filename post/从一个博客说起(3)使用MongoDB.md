---
title: 从一个博客说起(3)使用MongoDB  
date: 2016-12-30 20:30  
tags: ['Node.js']
toc: true
categories: technology

---
### 0x00 关于 MongoDB
MongoDB 是一个基于分布式文件存储的数据库。由 C++ 语言编写。旨在为 WEB 应用提供可扩展的高性能数据存储解决方案。
MongoDB 是一个介于关系数据库和非关系数据库之间的产品，是非关系数据库当中功能最丰富，最像关系数据库的。


---
### 0x01 安装 MongoDB



#### 创建数据目录

创建数据目录( `\data\db` )用于存放 MongoDB 数据：

```
Path
----
D:\Git-Repository\NEMBlog\data\db
```

#### 命令下运行 MongoDB 数据库服务

为了从命令提示符下运行MongoDB服务器，你必须从MongoDB目录的 `bin` 目录中执行 `mongod.exe` 文件。

```
C:\Program Files\MongoDB\Server\3.4\bin\mongod.exe --dbpath D:\Git-Repository\NEMBlog\data\db
```

当然，每次都这么运行的话，我会疯掉的，懒人 Tips : 在 `PowerShell` 中添加命令别名，以快速获得启动的路径:

```
function run-Mongod {"'C:\Program Files\MongoDB\Server\3.4\bin\mongod.exe' --dbpath D:\Git-Repository\NEMBlog\data\db"}
Set-Alias mongod run-Mongod
```

如果执行成功，会输出如下信息：

```
C:\Users\onejustone
λ  & 'C:\Program Files\MongoDB\Server\3.4\bin\mongod.exe' --dbpath D:\Git-Repository\NEMBlog\data\db
2017-01-20T11:39:55.542+0800 I CONTROL  [initandlisten] MongoDB starting : pid=1420 port=27017 dbpath=D:\Git-Repository\NEMBlog\data\db 64-bit host=onejustone404
2017-01-20T11:39:55.545+0800 I CONTROL  [initandlisten] targetMinOS: Windows 7/Windows Server 2008 R2
2017-01-20T11:39:55.546+0800 I CONTROL  [initandlisten] db version v3.4.0
2017-01-20T11:39:55.546+0800 I CONTROL  [initandlisten] git version: f4240c60f005be757399042dc12f6addbc3170c1
2017-01-20T11:39:55.546+0800 I CONTROL  [initandlisten] OpenSSL version: OpenSSL 1.0.1t-fips  3 May 2016
```

---
#### MongoDB后台管理 Shell

如果你需要进入MongoDB后台管理，你需要先打开 `mongodb` 装目录的下的 `bin` 目录，然后执行 `mongo.exe` 文件，MongoDB Shell是MongoDB自带的交互式 Javascript shell,用来对MongoDB进行操作和管理的交互式环境。

默认连接 `test` 数据库:

```
λ  mongo
MongoDB shell version v3.4.0
connecting to: mongodb://127.0.0.1:27017

> db
test
```

---
#### 0x02 使用 Node.js 连接 MongonDB 数据库

首先需要官方提供的 `node-mongodb-native` 驱动模块，在 `package.json` 文件的 `dependencies` 自动添加依赖:

```
 "dependencies": {
    "mongodb": "*",
}
```

运行 `npm install` 等待模块下载完成。

然后在工程根目录中创建 `settings.js` 文件，用于保存工程的配置信息，比如，数据库连接信息:

```
moduel.export = {
	db: 'db',
	// db ：代表数据库名称
	host: 'localhost'
	// host: 数据库地址
}
```

接着在工程根目录下创建 `models` 文件夹，并在该文件夹中新建 `db.js` 文件:

```
/**
 * Created by onejustone on 2017/1/18.
 */

var settings = rquire('../settings'),
	Db = require('mongodb').Db,
	Connection = rquire('mongodb').Connection,
	Server = rquire('mongodb').Server;

module.exports = new Db(settings.db,
	new Server(settings.host,
	Connection.DEFAULT_PORT,
	{}),{safe: true}
	// 创建一数据库连接实例，并通过 module.exports 导出该实例
	// 设置数据库名，数据库地址，数据库端口
	);
```

如上，我们创建了一个数据库连接实例，以后便可以通过 `require` 来对该数据库进行读写操作了。

---
### 0x03 添加 Session 会话支持


运行 `npm install express-session` 安装 `session` ， 等待依赖模块安装完成。然后在 `app.js` 的 _var path = require('path')_ 后添加如下代码:

```
var session = require('express-session');
var  MongoStore = require('connect-mongo')(session);
var settings = require('./settings');
```

在 `app.use(cookieParser());` 后添加如下代码:

```
app.use(cookieParser());
app.use(session({
  secret: settings.cookieSecret,
    key: settings.db, // cookie name
    cookie: {maxAge: 1000*60*60*24*30}, // 30days
    store: new MongoStore({
	    url: 'mongodb://localhost/' + settings.db,
    })
}));
```

如上，`cookieParse()` 是用来解析 Cookie 的中间件。而 `express.session` 则用来提供会话支持，`secret` 用于防止篡改 Cookie，`key` 是 Cookie 的名字,`maxAgae` 设置 Cookie 的生命周期为 30 天。设置其 `store` 参数为 `MongoStroe` 实例，把会话信息存储到数据库中。

> 好吧，Express 升级到 4.x 后全是坑，我也会醉了。。。

最后，推荐使用, `supervisor` , 安装命令: `npm install supervisor` ，以此便于调试，以后每次修改代码，直接刷新浏览器就行，无需再次重启服务。

```
D:\Git-Repository\NEMBlogPS>supervisor app

Running node-supervisor with
  program 'app'
  --watch '.'
  --extensions 'node,js'
  --exec 'node'

Starting child process with 'node app'
```

