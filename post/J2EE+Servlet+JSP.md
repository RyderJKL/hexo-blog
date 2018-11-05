---
title: J2EEE+Servlet+JSP
date: 2016-07-25
tags: ['Java-J2EE']
toc: true
categories: technology

---
### 0x00 J2EE简介
目前，Java 2平台有3个版本，它们是适用于小型设备和智能卡的Java 2平台Micro版（Java 2 Platform Micro Edition，J2ME）、适用于桌面系统的Java 2平台标准版（Java 2 Platform Standard Edition，J2SE）、适用于创建服务器应用程序和服务的Java 2平台企业版（Java 2 Platform Enterprise Edition，J2EE）。

---
#### J2EE的四层架构
传统的二层架构(client/server)加重了客户端的处理负担，为此，J2EE使用了更加高效的四层架构:

* 运行在客户机上的客户层组件
* 运行在J2EE服务器上的Web层组件
* 运行在J2EE服务器上的业务逻辑层组件
* 运行在EIS服务器上的企业信息系统(Enterprise information system)层软件



---
### 0x02 JSP
在Servlet出现之后，随着使用范围的扩大，开始出现一个很大弊端，就是为了能够输出HTML内容，需要大量重复编写代码。所以，为了解决这个问题，基于Servlet技术产生了JSP技术。JSP全称Java Server Pages，即Java服务器页面，其目的是为了简化Servlet的设计.它实现了Html语法中的java扩展（以 <%, %>形式）。JSP同样是在服务器端执行的。

Servlet侧重于解决运算和业务逻辑问题，JSP侧重于解决展示问题，Servlet和JSP两者分工协作为Web引用带来了巨大贡献。

虽然JSP就是嵌入了java语句的HTML文件，但是它是不能直接通过浏览器运行的，而是必须翻译成一个Servlet程序，最后运行在容器上的，然后发送到客户端浏览器。

---
##### JSP中的指令元素
也可以称为指示元素，主要是用来提供整个JSP网页相关的信息，并且设定JSP页面的相关属性。

JSP中的指令元素包含三类:page,include,taglib。

###### page指令元素
page指令元素包含了与整个JSP页面相关的一些属性。

* import:用于导入java中的类，是page中唯一一个可以重复使用的属性。
```
<%@ page import="java.utli.Vector,java.io*"%>
<%@ page import="java.servlet.*"%>
```

* errorPage="error_url"
该属性用于指定当JSP页面发生异常时，将转向哪一个错误处理页面。


* isErrorPage="true|false"
该属性用于指定当前的JSP页面是否是另一个JSP页面的错误处理页面。默认值是false。

* contentTupe
属性指定用于响应的JSP页面的MIME类型和字符编码。
```
<%@ page contentType="text/html; chaeset=utf-8"%>
```

* pageEncoding="gb2312"
该属性指定JSP页面使用的字符编码。如果设置了这个属性，则JSP页面的字符编码使用该属性指定的字符集，如果没有设置这个属性，则JSP页面使用contentType属性指定的字符集，如果这两个属性都没有指定，则使用字符集“ISO-8859-1”。 

* session
该属性的值为“true|false”默认为true如果设置为false则该页面不能用session对象，要是使用的话会报错。


###### include指令元素
include指令元素用于在翻译阶段将指定的文件加入到当前的页面中来 
```
<%@ include file="relativeURLspec" %> 
```


###### taglib指令元素
声明用户使用的自定义标签。


