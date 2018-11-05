---
title: Django博客(4)View,Urls
date:  2016-08-10
tags: ['Django','View,Urls']
toc: true
categories: technology

---
### 0x01 网页逻辑
* url设置相当于客户端向服务器发出request请求的入口, 并用来指明要调用的程序逻辑

* views用来处理程序逻辑, 然后呈现到template(一般为GET方法, POST方法略有不同)

* models用封装和处理数据库相关操作和数据

* template一般为html+CSS的形式, 主要是呈现给用户的表现形式


---
### 0x02 view 和 urls
先在 my_blog/article/view 中添加如下代码:

```


```

为了将上述 view 逻辑在 http 请求时被调用，便需要在 articel/urls 中进行配置。





