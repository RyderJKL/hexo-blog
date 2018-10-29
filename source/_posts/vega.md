---
title: vega
date: 2016-07-31 11:16
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### 0x00 vega简介
vega是JAVA编写的开源的图形化Web应用检测平台，可以帮助你发现和确认SQL注入、XSS、信息泄漏和其他漏洞，能在Linux, OS X, and Windows上运行。它有两种工作模式，扫描模式(Scanner)和代理模式(Proxy)，可以进行爬站，处理表单和注入测试。

大多数的Web扫描器几乎都是支持主动扫描和代理扫描模式的。

启用代理模式，可以使用代理服务器对提交的数据进行任意修改，这将可以使得我们更方便的了解到整个提交响应的流程。

同时vega也是支持SSL扫描的。


----
### 0x01 配置扫描模块功能

![2016-09-02 23-30-47 的屏幕截图.png](http://upload-images.jianshu.io/upload_images/1571420-63f5a83639f8edf3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* Injection Modules:
该模块下包含一些常用的，比如，sql盲注，XSS跨站脚本，XML注入检查，Http头注入啦等等

* Response Processing Modules:
响应进程模块。

#### Edit Target Scope
将要扫描的目标划分为一个集合，就是将多个站点作为一个租进行统一的扫描；同时也可以设置不扫描的url页面。


![Edit Target Scope.png](http://upload-images.jianshu.io/upload_images/1571420-52d5e4c47131ed39.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x02 Proxy模式
首先打开vega，打开vega的Proxy模式，并选择windows菜单下的Preferences选项对其进行基本配置。

![Proxy-Windows-Preferences.png](http://upload-images.jianshu.io/upload_images/1571420-2d06d90b76eb1e60.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

打开页面可以看到左边可以进行三项不同和的配置:

#### General
在General下可以设置vega的两种外部代理模式，SOCKS proxy（Tor 代理）和External HTPP proxy(Agent 代理)，以此所有vega发起的请求便都会经过这个两个中的一个进行转发了。

然后`Appearence`选择界面显示style，`Updates`可以选项vega自动更新。

#### Proxy
该`Proxy`表示的是vega的内部代理，可以将vega伪造成为某个特定类型的浏览器。


![Proxy-Windows-Preferences-Proxy.png](http://upload-images.jianshu.io/upload_images/1571420-18cf623bd5079a9b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* Override client User-Agent
代表使用上面的Defaul User-Agent的字符去覆盖客户端的浏览器代理。

* Prevent browser caching
阻止浏览器缓存。以此可以每次都发起一个全新的请求，建议勾选。

* Prevent intermediate caching
阻止中间代理服务器缓存。作用同上。

##### Listener
选择vega的Proxy模式，以为着vega本身便是一个代理软件了，这时可以在Proxy下的Litener下设置要监听的IP地址和端口好了。



#### Scanner
* total path descendants: 最大扫描路径
* child paths for a single node: 单个节点下的最大扫描子路劲
* path depth:扫描的超链接数量
* duplicate path elements:多个路径的枚举数
* display in alert reports:在报警报告里显示的最大字符串长度
* requests per second to send:每秒发送的最大请求数
* response size to process in kilobytes:

##### Debug
* 记录所有的Scanner请求
* 将调试信息输出到控制台


> proxy模式下，Listerner是必须要设置的。

```
root@kali:~# netstat -pantu | grep 1080
tcp6       0      0 127.0.0.1:1080          :::*                    LISTEN      2962/java      
```

---
#### Proxy模式实战

##### 设置Vega监听

当配置好Vega代理模式以后，便可以通过浏览器去访问目标网站了，当然还需要对浏览器进行代理设置并保证浏览器中代理设置与vega->Perference->Proxy->Listener下的代理设置保持一致。

首先设置vega代理:
其实，这里主要设置vega要监听的代理主机的IP和port，可以是局域网下的host，也可以外网的host，这样可以让vega成为一个Proxy服务器，这与vega->Perference->General下的Proxy是完全不同的。

![vega->Perference->Proxy->Listener.png](http://upload-images.jianshu.io/upload_images/1571420-177ca58936fe4dec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 设置firefox代理

然后打开firefox，设置AutoProxy中的代理参数:

![设置fireproxy使用vega代理.png](http://upload-images.jianshu.io/upload_images/1571420-dbafc2fdc516fd34.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

模式代理服务器使用vega，并开启全局代理，这样所有的流量都将会经过代理服务器。

所有参数设置完毕，在vega中选择`start HTTP Proxy`，然后通过浏览器访问目标完整，那么所有的数据都将会被vega记录下来：

![使用vega代理爬取sina.png](http://upload-images.jianshu.io/upload_images/1571420-a0ce580317a28a01.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 遨游目标网站 
浏览网站，发现目标服务器所有可能的数据交互的地方，比如表单，登陆，注册页面等。

##### 漏洞检测


目标网站手动浏览完成以后，便可以被动的对爬取下来的网站经行漏洞检测了，只需点击Scanner选项就可以了:

![Proxy下Scanner结果.png](http://upload-images.jianshu.io/upload_images/1571420-eeee187611023f6b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

从上可以得到：针对192.168.234.129/dvwa/，一共发现了三个高危，一共中级，一个低级漏洞。

当然，这只是下vega的Proxy模式下，在被动扫描得到的结果，下面来看看vega强大的`Scanner`模式。


---
### 0x03 Scanner模式
Vega的Scanner模式，又代表了vega下的主动扫描，
首先选择vega下的Scanner模式:

![Scanner模式.png](http://upload-images.jianshu.io/upload_images/1571420-0fdd7f264748082f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击导航栏上的`scan`选项，选择`start new scan`(开始个新的扫描)或者`Edit Target Scope`(编辑一个扫描组合)

---
#### Edit Target Scope && Start new scan
我们先`Edit Target Scope`，在该配置下可设定目标的扫描根路径，并且排除不需要扫描的网站页面。

![Edit Target Scope.png](http://upload-images.jianshu.io/upload_images/1571420-db39dbdb0f9a0926.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

设置完成，开始`Start new scan`，并且`Choose a target scope for scan`，就是刚刚配置的scope了。

![Start new scam.png](http://upload-images.jianshu.io/upload_images/1571420-70dd7837e77130c2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### 配置cookie或者登陆验证
当一个网站需要登陆凭证才可以访问的时候，通常会使用cookies进行填充，而cookie可以从浏览器获得或者使用抓包工具去抓取。当然也可以直接设置验证参数。

在vega里面可以直接设置验证参数:

![Identity.png](http://upload-images.jianshu.io/upload_images/1571420-a684ef5d23f90864.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

前三种，basic http authentication,digest http authentication,NTLM,都是基于web server来进行的登陆验证模式，而Macro(宏)则是针对web application表单提交式的登陆验证模式，这也是当前比较主流的方式:

输入Identity:name:name
选择验证类型:Macro

![SetIdentity.png](http://upload-images.jianshu.io/upload_images/1571420-185d5c265690ed58.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

create macro:

![Create Macro.png](http://upload-images.jianshu.io/upload_images/1571420-844e4950e86e6bfc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

add item:


![add Item.png](http://upload-images.jianshu.io/upload_images/1571420-3c8fc82500068d54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


选择拥有登录cookie信息的requset页面，即是login.php页面作为验证参数页面:


![Selecte Login.php.png ]
](http://upload-images.jianshu.io/upload_images/1571420-51cc0fb0f374d3f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

注意选择完毕要双击该`url`，出现如下页面，勾选Configuration下的两个选项:


![Configuration.png](http://upload-images.jianshu.io/upload_images/1571420-11a6b185f03742cb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


---
#### Start New Scope
ok,身份信息设置完毕。直接开始`Scanner`->`Start New Scan`，选择之前设置好的Dvwa Scope :


![Scanner->Satrt New Scope->Choose Scope.png](http://upload-images.jianshu.io/upload_images/1571420-b4fa61c16c259189.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

next,Select Modules:


![Select Modules.png](http://upload-images.jianshu.io/upload_images/1571420-b429838c18ed6e6c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在Authentication Options中选择之前设置好的admin验证信息:

![Authentication.png](http://upload-images.jianshu.io/upload_images/1571420-1b3beb2016b01f54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

vega自动扫描开始:


![Scanning.png](http://upload-images.jianshu.io/upload_images/1571420-09c151709008a962.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


等待扫描完成，得到扫描报告：



![Get Scanner Report.png](http://upload-images.jianshu.io/upload_images/1571420-b0be52c232a9b9cc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

从最后的扫报告可以看到，vega的scanner(主动扫描)比Proxy下的被动扫描发现的漏洞要多得多。

对于漏洞的具体利用，将在以后讲到。

---
### 0x04 vega后续使用优化

##### Filter by scope
在`Website View`界面下，选择`Filter By Scope`可以过滤掉目标网站里嵌套的超链，从而排除其它不必要的感染。

---
### 0x05 手动Debug
可以在Proxy模式下，选择某一个url页面，然后右键`Replay Request`进行重放。



![Replay Request.png](http://upload-images.jianshu.io/upload_images/1571420-ace088cde801933f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x06 Vega的(Intercept)截断功能

截断的意思，就是当client通过proxy向server发起request的时候，proxy会截断request，在修改该request后在向server发送,当然proxy也可以intercept server 给client的response，进行修改和篡改。

实验过程中，vega对数据的重放和截断还有所欠缺。

---
### 0x07 Vega 访问 Hppts网站
Https网站是通过证书加密了的，国内比如百度，据说已经采用了https全站加密。

所有，当使用了vega代理模式，并且访问https网站时，可以访问HTTP://vega/ca.crt，只用vega的字签名证书，添加该网站为可信任站点。


问题:关于https的传输和加密过程？
















---
title: vega
date: 2016-07-31 11:16
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### 0x00 vega简介
vega是一个基于Java编写的开源可视化Web扫描器。


----
### 0x01 配置扫描模块功能

![2016-09-02 23-30-47 的屏幕截图.png](http://upload-images.jianshu.io/upload_images/1571420-63f5a83639f8edf3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* Injection Modules:
该模块下包含一些常用的，比如，sql盲注，XSS跨站脚本，XML注入检查，Http头注入啦等等

* Response Processing Modules:
响应进程模块。

#### Edit Target Scope
将要扫描的目标划分为一个集合，就是将多个站点作为一个租进行统一的扫描；同时也可以设置不扫描的url页面。


![Edit Target Scope.png](http://upload-images.jianshu.io/upload_images/1571420-52d5e4c47131ed39.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x02 Proxy模式
首先打开vega，打开vega的Proxy模式，并选择windows菜单下的Preferences选项对其进行基本配置。

![Proxy-Windows-Preferences.png](http://upload-images.jianshu.io/upload_images/1571420-2d06d90b76eb1e60.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

打开页面可以看到左边可以进行三项不同和的配置:

#### General
在General下可以设置vega的两种外部代理模式，SOCKS proxy（Tor 代理）和External HTPP proxy(Agent 代理)，以此所有vega发起的请求便都会经过这个两个中的一个进行转发了。

然后`Appearence`选择界面显示style，`Updates`可以选项vega自动更新。

#### Proxy
该`Proxy`表示的是vega的内部代理，可以将vega伪造成为某个特定类型的浏览器。


![Proxy-Windows-Preferences-Proxy.png](http://upload-images.jianshu.io/upload_images/1571420-18cf623bd5079a9b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* Override client User-Agent
代表使用上面的Defaul User-Agent的字符去覆盖客户端的浏览器代理。

* Prevent browser caching
阻止浏览器缓存。以此可以每次都发起一个全新的请求，建议勾选。

* Prevent intermediate caching
阻止中间代理服务器缓存。作用同上。

##### Listener
选择vega的Proxy模式，以为着vega本身便是一个代理软件了，这时可以在Proxy下的Litener下设置要监听的IP地址和端口好了。



#### Scanner
* total path descendants: 最大扫描路径
* child paths for a single node: 单个节点下的最大扫描子路劲
* path depth:扫描的超链接数量
* duplicate path elements:多个路径的枚举数
* display in alert reports:在报警报告里显示的最大字符串长度
* requests per second to send:每秒发送的最大请求数
* response size to process in kilobytes:

##### Debug
* 记录所有的Scanner请求
* 将调试信息输出到控制台


> proxy模式下，Listerner是必须要设置的。

```
root@kali:~# netstat -pantu | grep 1080
tcp6       0      0 127.0.0.1:1080          :::*                    LISTEN      2962/java      
```

---
#### Proxy模式实战

##### 设置Vega监听

当配置好Vega代理模式以后，便可以通过浏览器去访问目标网站了，当然还需要对浏览器进行代理设置并保证浏览器中代理设置与vega->Perference->Proxy->Listener下的代理设置保持一致。

首先设置vega代理:
其实，这里主要设置vega要监听的代理主机的IP和port，可以是局域网下的host，也可以外网的host，这样可以让vega成为一个Proxy服务器，这与vega->Perference->General下的Proxy是完全不同的。

![vega->Perference->Proxy->Listener.png](http://upload-images.jianshu.io/upload_images/1571420-177ca58936fe4dec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 设置firefox代理

然后打开firefox，设置AutoProxy中的代理参数:

![设置fireproxy使用vega代理.png](http://upload-images.jianshu.io/upload_images/1571420-dbafc2fdc516fd34.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

模式代理服务器使用vega，并开启全局代理，这样所有的流量都将会经过代理服务器。

所有参数设置完毕，在vega中选择`start HTTP Proxy`，然后通过浏览器访问目标完整，那么所有的数据都将会被vega记录下来：

![使用vega代理爬取sina.png](http://upload-images.jianshu.io/upload_images/1571420-a0ce580317a28a01.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 遨游目标网站 
浏览网站，发现目标服务器所有可能的数据交互的地方，比如表单，登陆，注册页面等。

##### 漏洞检测


目标网站手动浏览完成以后，便可以被动的对爬取下来的网站经行漏洞检测了，只需点击Scanner选项就可以了:

![Proxy下Scanner结果.png](http://upload-images.jianshu.io/upload_images/1571420-eeee187611023f6b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

从上可以得到：针对192.168.234.129/dvwa/，一共发现了三个高危，一共中级，一个低级漏洞。

当然，这只是下vega的Proxy模式下，在被动扫描得到的结果，下面来看看vega强大的`Scanner`模式。


---
### 0x03 Scanner模式
Vega的Scanner模式，又代表了vega下的主动扫描，
首先选择vega下的Scanner模式:

![Scanner模式.png](http://upload-images.jianshu.io/upload_images/1571420-0fdd7f264748082f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击导航栏上的`scan`选项，选择`start new scan`(开始个新的扫描)或者`Edit Target Scope`(编辑一个扫描组合)

---
#### Edit Target Scope && Start new scan
我们先`Edit Target Scope`，在该配置下可设定目标的扫描根路径，并且排除不需要扫描的网站页面。

![Edit Target Scope.png](http://upload-images.jianshu.io/upload_images/1571420-db39dbdb0f9a0926.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

设置完成，开始`Start new scan`，并且`Choose a target scope for scan`，就是刚刚配置的scope了。

![Start new scam.png](http://upload-images.jianshu.io/upload_images/1571420-70dd7837e77130c2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### 配置cookie或者登陆验证
当一个网站需要登陆凭证才可以访问的时候，通常会使用cookies进行填充，而cookie可以从浏览器获得或者使用抓包工具去抓取。当然也可以直接设置验证参数。

在vega里面可以直接设置验证参数:

![Identity.png](http://upload-images.jianshu.io/upload_images/1571420-a684ef5d23f90864.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

前三种，basic http authentication,digest http authentication,NTLM,都是基于web server来进行的登陆验证模式，而Macro(宏)则是针对web application表单提交式的登陆验证模式，这也是当前比较主流的方式:

输入Identity:name:name
选择验证类型:Macro

![SetIdentity.png](http://upload-images.jianshu.io/upload_images/1571420-185d5c265690ed58.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

create macro:

![Create Macro.png](http://upload-images.jianshu.io/upload_images/1571420-844e4950e86e6bfc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

add item:


![add Item.png](http://upload-images.jianshu.io/upload_images/1571420-3c8fc82500068d54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


选择拥有登录cookie信息的requset页面，即是login.php页面作为验证参数页面:


![Selecte Login.php.png ]
](http://upload-images.jianshu.io/upload_images/1571420-51cc0fb0f374d3f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

注意选择完毕要双击该`url`，出现如下页面，勾选Configuration下的两个选项:


![Configuration.png](http://upload-images.jianshu.io/upload_images/1571420-11a6b185f03742cb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


---
#### Start New Scope
ok,身份信息设置完毕。直接开始`Scanner`->`Start New Scan`，选择之前设置好的Dvwa Scope :


![Scanner->Satrt New Scope->Choose Scope.png](http://upload-images.jianshu.io/upload_images/1571420-b4fa61c16c259189.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

next,Select Modules:


![Select Modules.png](http://upload-images.jianshu.io/upload_images/1571420-b429838c18ed6e6c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在Authentication Options中选择之前设置好的admin验证信息:

![Authentication.png](http://upload-images.jianshu.io/upload_images/1571420-1b3beb2016b01f54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

vega自动扫描开始:


![Scanning.png](http://upload-images.jianshu.io/upload_images/1571420-09c151709008a962.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


等待扫描完成，得到扫描报告：



![Get Scanner Report.png](http://upload-images.jianshu.io/upload_images/1571420-b0be52c232a9b9cc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

从最后的扫报告可以看到，vega的scanner(主动扫描)比Proxy下的被动扫描发现的漏洞要多得多。

对于漏洞的具体利用，将在以后讲到。

---
### 0x04 vega后续使用优化

##### Filter by scope
在`Website View`界面下，选择`Filter By Scope`可以过滤掉目标网站里嵌套的超链，从而排除其它不必要的感染。

---
### 0x05 手动Debug
可以在Proxy模式下，选择某一个url页面，然后右键`Replay Request`进行重放。



![Replay Request.png](http://upload-images.jianshu.io/upload_images/1571420-ace088cde801933f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x06 Vega的(Intercept)截断功能

截断的意思，就是当client通过proxy向server发起request的时候，proxy会截断request，在修改该request后在向server发送,当然proxy也可以intercept server 给client的response，进行修改和篡改。

实验过程中，vega对数据的重放和截断还有所欠缺。

---
### 0x07 Vega 访问 Hppts网站
Https网站是通过证书加密了的，国内比如百度，据说已经采用了https全站加密。

所有，当使用了vega代理模式，并且访问https网站时，可以访问HTTP://vega/ca.crt，只用vega的字签名证书，添加该网站为可信任站点。


问题:关于https的传输和加密过程？
































































---
title: vega
date: 2016-07-31 11:16
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### 0x00 vega简介
vega是一个基于Java编写的开源可视化Web扫描器。


----
### 0x01 配置扫描模块功能

![2016-09-02 23-30-47 的屏幕截图.png](http://upload-images.jianshu.io/upload_images/1571420-63f5a83639f8edf3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* Injection Modules:
该模块下包含一些常用的，比如，sql盲注，XSS跨站脚本，XML注入检查，Http头注入啦等等

* Response Processing Modules:
响应进程模块。

#### Edit Target Scope
将要扫描的目标划分为一个集合，就是将多个站点作为一个租进行统一的扫描；同时也可以设置不扫描的url页面。


![Edit Target Scope.png](http://upload-images.jianshu.io/upload_images/1571420-52d5e4c47131ed39.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x02 Proxy模式
首先打开vega，打开vega的Proxy模式，并选择windows菜单下的Preferences选项对其进行基本配置。

![Proxy-Windows-Preferences.png](http://upload-images.jianshu.io/upload_images/1571420-2d06d90b76eb1e60.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

打开页面可以看到左边可以进行三项不同和的配置:

#### General
在General下可以设置vega的两种外部代理模式，SOCKS proxy（Tor 代理）和External HTPP proxy(Agent 代理)，以此所有vega发起的请求便都会经过这个两个中的一个进行转发了。

然后`Appearence`选择界面显示style，`Updates`可以选项vega自动更新。

#### Proxy
该`Proxy`表示的是vega的内部代理，可以将vega伪造成为某个特定类型的浏览器。


![Proxy-Windows-Preferences-Proxy.png](http://upload-images.jianshu.io/upload_images/1571420-18cf623bd5079a9b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* Override client User-Agent
代表使用上面的Defaul User-Agent的字符去覆盖客户端的浏览器代理。

* Prevent browser caching
阻止浏览器缓存。以此可以每次都发起一个全新的请求，建议勾选。

* Prevent intermediate caching
阻止中间代理服务器缓存。作用同上。

##### Listener
选择vega的Proxy模式，以为着vega本身便是一个代理软件了，这时可以在Proxy下的Litener下设置要监听的IP地址和端口好了。



#### Scanner
* total path descendants: 最大扫描路径
* child paths for a single node: 单个节点下的最大扫描子路劲
* path depth:扫描的超链接数量
* duplicate path elements:多个路径的枚举数
* display in alert reports:在报警报告里显示的最大字符串长度
* requests per second to send:每秒发送的最大请求数
* response size to process in kilobytes:

##### Debug
* 记录所有的Scanner请求
* 将调试信息输出到控制台


> proxy模式下，Listerner是必须要设置的。

```
root@kali:~# netstat -pantu | grep 1080
tcp6       0      0 127.0.0.1:1080          :::*                    LISTEN      2962/java      
```

---
#### Proxy模式实战

##### 设置Vega监听

当配置好Vega代理模式以后，便可以通过浏览器去访问目标网站了，当然还需要对浏览器进行代理设置并保证浏览器中代理设置与vega->Perference->Proxy->Listener下的代理设置保持一致。

首先设置vega代理:
其实，这里主要设置vega要监听的代理主机的IP和port，可以是局域网下的host，也可以外网的host，这样可以让vega成为一个Proxy服务器，这与vega->Perference->General下的Proxy是完全不同的。

![vega->Perference->Proxy->Listener.png](http://upload-images.jianshu.io/upload_images/1571420-177ca58936fe4dec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 设置firefox代理

然后打开firefox，设置AutoProxy中的代理参数:

![设置fireproxy使用vega代理.png](http://upload-images.jianshu.io/upload_images/1571420-dbafc2fdc516fd34.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

模式代理服务器使用vega，并开启全局代理，这样所有的流量都将会经过代理服务器。

所有参数设置完毕，在vega中选择`start HTTP Proxy`，然后通过浏览器访问目标完整，那么所有的数据都将会被vega记录下来：

![使用vega代理爬取sina.png](http://upload-images.jianshu.io/upload_images/1571420-a0ce580317a28a01.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 遨游目标网站 
浏览网站，发现目标服务器所有可能的数据交互的地方，比如表单，登陆，注册页面等。

##### 漏洞检测


目标网站手动浏览完成以后，便可以被动的对爬取下来的网站经行漏洞检测了，只需点击Scanner选项就可以了:

![Proxy下Scanner结果.png](http://upload-images.jianshu.io/upload_images/1571420-eeee187611023f6b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

从上可以得到：针对192.168.234.129/dvwa/，一共发现了三个高危，一共中级，一个低级漏洞。

当然，这只是下vega的Proxy模式下，在被动扫描得到的结果，下面来看看vega强大的`Scanner`模式。


---
### 0x03 Scanner模式
Vega的Scanner模式，又代表了vega下的主动扫描，
首先选择vega下的Scanner模式:

![Scanner模式.png](http://upload-images.jianshu.io/upload_images/1571420-0fdd7f264748082f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击导航栏上的`scan`选项，选择`start new scan`(开始个新的扫描)或者`Edit Target Scope`(编辑一个扫描组合)

---
#### Edit Target Scope && Start new scan
我们先`Edit Target Scope`，在该配置下可设定目标的扫描根路径，并且排除不需要扫描的网站页面。

![Edit Target Scope.png](http://upload-images.jianshu.io/upload_images/1571420-db39dbdb0f9a0926.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

设置完成，开始`Start new scan`，并且`Choose a target scope for scan`，就是刚刚配置的scope了。

![Start new scam.png](http://upload-images.jianshu.io/upload_images/1571420-70dd7837e77130c2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### 配置cookie或者登陆验证
当一个网站需要登陆凭证才可以访问的时候，通常会使用cookies进行填充，而cookie可以从浏览器获得或者使用抓包工具去抓取。当然也可以直接设置验证参数。

在vega里面可以直接设置验证参数:

![Identity.png](http://upload-images.jianshu.io/upload_images/1571420-a684ef5d23f90864.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

前三种，basic http authentication,digest http authentication,NTLM,都是基于web server来进行的登陆验证模式，而Macro(宏)则是针对web application表单提交式的登陆验证模式，这也是当前比较主流的方式:

输入Identity:name:name
选择验证类型:Macro

![SetIdentity.png](http://upload-images.jianshu.io/upload_images/1571420-185d5c265690ed58.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

create macro:

![Create Macro.png](http://upload-images.jianshu.io/upload_images/1571420-844e4950e86e6bfc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

add item:


![add Item.png](http://upload-images.jianshu.io/upload_images/1571420-3c8fc82500068d54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


选择拥有登录cookie信息的requset页面，即是login.php页面作为验证参数页面:


![Selecte Login.php.png ]
](http://upload-images.jianshu.io/upload_images/1571420-51cc0fb0f374d3f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

注意选择完毕要双击该`url`，出现如下页面，勾选Configuration下的两个选项:


![Configuration.png](http://upload-images.jianshu.io/upload_images/1571420-11a6b185f03742cb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


---
#### Start New Scope
ok,身份信息设置完毕。直接开始`Scanner`->`Start New Scan`，选择之前设置好的Dvwa Scope :


![Scanner->Satrt New Scope->Choose Scope.png](http://upload-images.jianshu.io/upload_images/1571420-b4fa61c16c259189.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

next,Select Modules:


![Select Modules.png](http://upload-images.jianshu.io/upload_images/1571420-b429838c18ed6e6c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在Authentication Options中选择之前设置好的admin验证信息:

![Authentication.png](http://upload-images.jianshu.io/upload_images/1571420-1b3beb2016b01f54.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

vega自动扫描开始:


![Scanning.png](http://upload-images.jianshu.io/upload_images/1571420-09c151709008a962.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


等待扫描完成，得到扫描报告：



![Get Scanner Report.png](http://upload-images.jianshu.io/upload_images/1571420-b0be52c232a9b9cc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

从最后的扫报告可以看到，vega的scanner(主动扫描)比Proxy下的被动扫描发现的漏洞要多得多。

对于漏洞的具体利用，将在以后讲到。

---
### 0x04 vega后续使用优化

##### Filter by scope
在`Website View`界面下，选择`Filter By Scope`可以过滤掉目标网站里嵌套的超链，从而排除其它不必要的感染。

---
### 0x05 手动Debug
可以在Proxy模式下，选择某一个url页面，然后右键`Replay Request`进行重放。



![Replay Request.png](http://upload-images.jianshu.io/upload_images/1571420-ace088cde801933f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x06 Vega的(Intercept)截断功能

截断的意思，就是当client通过proxy向server发起request的时候，proxy会截断request，在修改该request后在向server发送,当然proxy也可以intercept server 给client的response，进行修改和篡改。

实验过程中，vega对数据的重放和截断还有所欠缺。

---
### 0x07 Vega 访问 Hppts网站
Https网站是通过证书加密了的，国内比如百度，据说已经采用了https全站加密。

所有，当使用了vega代理模式，并且访问https网站时，可以访问HTTP://vega/ca.crt，使用vega的字签名证书，添加该网站为可信任站点。


问题:关于https的传输和加密过程？


