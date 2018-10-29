---
title: 从一个博客说起(2)Express中间件
date: 2016-12-30 20:30
tags: ['Node.js']
toc: true
categories: technology

---
### 0x00 中间件
Express 使用中间件(middleware) 来处理请求，当一个中间件处理完，可以通过调用 next() 传递给下一个中间件，如果没有调用 `next()`，则请求不会往下传递，如内置的 `res.render` 其实就是渲染完 `html`
直接返回给客户端，没有调用 `next()`，便不会有传递给下一个中间件。

> `express@4` 之前的版本基于 `connect` 这个模块实现的中间件的架构，`express@4` 及以上的版本则移除了对 `connect` 的依赖自己实现了。此外，中间件也是有加载顺序的。

---
### 0x01 错误处理

Express 内置了一个默认的错误处理器，我们可以手动控制返回的错误内容，加载一个自定义错误处理的中间件:

##### index.js

```
const express = require('express')
const app = express();

// 错误处理
app.use(function(err, req, res,next){
   // err 是自定义的错误处理中间件
   if (err) {
        console.log(err.stack);
   }
   res.status(500).send('Something worry')
}
app.listen(3000);
```






