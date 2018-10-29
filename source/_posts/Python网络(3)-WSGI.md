---
title: Python网络(3)-WSGI
date: 2016-08-17 10:21
tags: ['Python网络']
toc: true
categories: technology

---
### 0x00 前言
Python有着许多的 Web 框架，而同时又有着许多的 Web 服务器（Apache, Nginx, Gunicorn等）。那么，怎样确保可以在不修改Web服务器代码或网络框架代码的前提下，使用自己选择的服务器，并且匹配多个不同的网络框架呢？答案是接口，设计一套双方都遵守的接口就可以了。对python来说，就是`WSGI（Web Server Gateway Interface，Web服务器网关接口）`。其他编程语言也拥有类似的接口：例如Java的Servlet API和Ruby的Rack。

简单来说，WSGI是连接Web服务器和Web应用程序的桥梁，一方面从Web server 拿到原始 HTTP 数据，处理成统一格式后交给 Web 应用程序，另一方面从应用程序／框架这边进行业务逻辑处理，生成响应内容后交给服务器。

