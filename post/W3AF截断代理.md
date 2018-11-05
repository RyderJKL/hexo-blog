---
title: W3AF截断代理
date: 2016-010-07 11:55
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### 0x00 截断代理
通过w3af 的截断代理功能，可以查看到完成的客户端与服务器的请求数据。当然也可以使用 firebug 取获得请求的数据，但是没有 w3af 那般直观。


首先配置 w3af 的截断代理选项，如下，将监听本地8080端口:


![w3af http modification options.png](http://upload-images.jianshu.io/upload_images/1571420-8e6dc309bbe7386c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后在浏览器中添加代理 w3af 代理，将w3af获得的 http 响应头中所保持不变的数据保存为文本文件。

![http header cookie.png](http://upload-images.jianshu.io/upload_images/1571420-c498056c2ba8e8ce.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

退出w3af 截断代理，选择 Configuration http setting ,在 `General`  --> `header_files` 中配置保存的 http  header 文件路径，要扫描的目录网站的 url 信息等，如下:


![Configure http setting.png](http://upload-images.jianshu.io/upload_images/1571420-738d170fc091dfc9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如此，我们同样配置好了对要扫描的目标网站的认证信息，这与之前的 cookies 认证，auth 的 detailed 认证，或者 http base等的本质是一样的，在服务器看来，都是一个合法的客户端发起的请求。


通过 w3af 截断代理获得的 http 请求信息，使得我们可以在后续过程中进行手动爬网，fuzzing等，重放攻击等等。

---
### 0x01 w3af spider_man 插件
w3af 不支持基于客户端的技术（比如 javascript ，flash， java applet）。
为了解决这个问题，w3af 提供了一个基于插件的截断代理**crawl** 功能下的**spider_man**插件 ，而这种截断代理不同于上一种截断代理，上一种更倾向于后续的手动爬网，重定向等操作。而基于插件的截断代理，主要是为了发现客户端的漏洞。


![spider_main.png](http://upload-images.jianshu.io/upload_images/1571420-d85dbe257462c882.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### oxo2 W3af Exploit
W3af 最大的特点就是，它不当可以发现漏洞，同时还可以利用发现的漏洞。

我们先找一个可以拿到 shell 的漏洞。

首先启动 w3af 的截断代理:



![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-1441eb1563be31b3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

进入到 dvwa 的页面，在 SQLinjection 页面随便输入点什么:

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-783f1a504ee827c6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

从 w3af 中获得该页面的 [http://192.168.56.101/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit]  http 请求数据：


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-0a194dbb63728996.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


将 `Histoty` --> ` Request` --> `Raw`中的固定信息部分提取出来另存为 headfile 文本文件以作为网站认证的http认证信息,退出代理，然后在`Configuration` 中设置 `General` 信息。


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-6ccd0a7641fe2793.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

设置完毕，在 `audit` 中选择 `sqli` 插件，添加 `Target` 目标地址 [
http://192.168.56.101/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit] 然后 `Start` 开始扫描。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-707f4325a9e1f8ad.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

此后，W3af 将会自动的去扫描发现 sql 漏洞:


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-cf9ea1a9bda7aa53.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

从`Result` 中可以知道这是一个关于 MySQL 的注入漏洞，并且是在第 39 次请求中发现的。

更进一步，我们可以在 `Result` --> `Request/Response navigator`  实施过滤规则，以查看第39次请求/响应的参数信息，以此得知该漏洞到底是如何发现的。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-a3c2d7d60d4c5771.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

上图所示的 id 参数部分便是 w3af 对该页面发起的参数，我们可以通过其解码工具得知具体的明文信息。


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-5f5c7811045011e5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

此外，还可以通过服务器端的响应消息查看端倪:


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-34989e2daa829c05.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




---
#### Exploit 

在扫描成功获得漏洞后，进入 ` Exploit` 漏洞利用模块。


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-92b3314d970a3ddc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


双击 shell ，可以查看该shell 下可以利用的信息:

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-e4a14f959ca12c0f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
















