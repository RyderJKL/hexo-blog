---
title: Burpsuite
date: 2016-10-17 20:50
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### 0x00 Burpsuite 简介
Burpsuite 享有 Web 安全工具中的瑞士军刀的美誉。是由 PortSwigger 公司开发的统一的集成工具用以发现全部现代 Web 安全漏洞。不开源，但是有免费版。免费版不支持主动扫描。

---
### 0x01 Proxy

---
#### 导入证书

我们可以在 Burpsuite 应用程序能导出证书。
![CA certificate](http://upload-images.jianshu.io/upload_images/1571420-6c2270b076615c2b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

也可以在浏览器中设置 Burpsuite Proxy 后访问 http://brup 地址获得 证书。


![http://brup](http://upload-images.jianshu.io/upload_images/1571420-3a3a518b75ddfbca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

导入证书以后，便可以在使用 Proxy 代理的情况下访问使用 Https 的网站了。

![Intercept is on](http://upload-images.jianshu.io/upload_images/1571420-e8e3b9561c91985b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
#### Intercept 截断
Burpsuite 在默认情况下会截断所有从客户端发起的请求。

![Intercept](http://upload-images.jianshu.io/upload_images/1571420-8d9d28164876d4d9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

截断客服端请求/服务器端响应设置:


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-31e28066f7a82e93.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


修改响应信息:

![Rsponse Modification](http://upload-images.jianshu.io/upload_images/1571420-f3cc127519d2f7bc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

匹配和替换:
使用匹配和替换功能可以帮助我们去自动的修改请求或者响应的信息，以节省时间成本。


![Math and Replace](http://upload-images.jianshu.io/upload_images/1571420-d2ed29c4ba9aa865.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
#### Proxy 中 Invisible 功能
Invisible 功能可以使得不支持代理的客户端通过使用 DNS 污染使其转而支持 Burpsuite 代理。

![Proxy-Invisible](http://upload-images.jianshu.io/upload_images/1571420-51033915b24bf7aa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

未完待续


