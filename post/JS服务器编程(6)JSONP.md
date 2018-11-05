---
title: JS服务器编程(6)JSONP  
date: 2017-1-2 15:32  
tags: ['JavaScript','JSONP']
toc: true
categories: technology

---
### 0X00 JSONP
JSOP 是 JSON with padding (填充式 json 或者 参数式 json 的缩写)，是应用 json 的一种新方法。 JSONP 只不过是被包含在函数调用中的 JSON。

JSONP 由两部分组成: 回调函数和数据。回调函数是当响应到来时应该在页面中调用的函数，而回调函数的名字一般是在请求中指定的。而数据就是传入的 JSON 数据。



