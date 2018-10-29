---
title: OWASP_ZAP
date: 2016-10-13 20:50
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### 0x00 OWASP_ZAP
Zend attack proxy 是一款 web application 集成渗透测试和漏洞工具，同样是免费开源跨平台的。

OWASP_ZPA 支持截断代理，主动、被动扫描，Fuzzy，暴力破解并且提供 API。

OWASP_ZPA 是Kali Web Top 10 之一。

---
### 0x01 截断代理
首次启动 OWASP_ZAP　会提示是否将 session 进行保存，以及如何保存。

![首次启动页面.png](http://upload-images.jianshu.io/upload_images/1571420-12b42bd8af7fa6e0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

OWASP_ZAP 默认监听的是 8080 端口，并且在启动 ZAP 的时候便会自动开始监听。

如此，只需设置浏览器代理，ZAP 便会自动爬取所有数据。
![Proxy.png](http://upload-images.jianshu.io/upload_images/1571420-b3c465e305dceb25.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


---
### 0x02 主动扫描
ZAP 最简单的使用方式便是在首页直接输入目标 Target 然后点击 **攻击** 便会开始主动扫描了。
![scan.png](http://upload-images.jianshu.io/upload_images/1571420-2df8796ef181b6ee.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


---
### 0x03 Fuzzer
通过右键选择某个特定页面进行 Fuzzer。

![Fuzzer.png](http://upload-images.jianshu.io/upload_images/1571420-afad45d0a1a41e0d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

此外，也可以选择工具菜单中的 **Fuzz** 进行 Fuzzing 。
![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-b41477bd15b10371.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![Fuzzer.png](http://upload-images.jianshu.io/upload_images/1571420-a294236753c872e7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


---
#### 数据库注入 Fuzzing
选择可能存在 SQL 注入的可疑字符串，为其添加 PayLoads 记性 SQL Injection Fuzzing。

![ SQL Injection Fuzzing.png](http://upload-images.jianshu.io/upload_images/1571420-0a08fcde805fb48d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

fuzzing 完整以后，可以通过 `Code` ,`Size Resp.Header` 等字段属性对 fuzzing 的结果进行筛选。


![Fuzzing结果筛选.png](http://upload-images.jianshu.io/upload_images/1571420-4aeb397e48e28cc1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


---
#### 页面目录Fuzzing
首先选中需要替换的字符串，然后点击 `Fuzz Locations` 中的 `Add` 选中以选择 fuzzing 的方式。

![fileFuzzing.png](http://upload-images.jianshu.io/upload_images/1571420-0f8428e66cb4b065.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们可以使用 字符串，脚本，正则表达式，文本文件或 ZAP 自带的 **File Fuzzer** 去搜索网站目录。


![网站目录页面Fuzzing.png](http://upload-images.jianshu.io/upload_images/1571420-cb7e122e24478897.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x04 暴力破解

![暴力破解.png](http://upload-images.jianshu.io/upload_images/1571420-c7f176b0aa8fda50.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但是，当我们使用一个字典文件去尝试暴力破解的时候，如何去识别出破解成功与不成功的不同差异，便只有依靠上帝了。

---
### 0x05 ZAP 的 API
API 是一程序开发的接口。ZAP 提供API 一便让开发者使用ZAP 以定制自己的扫描程序。

ZAP 的 API  使用文档:[ http://zap]


---
### 0x06 Mode(扫描模式)
ZAP 有四种扫描模式 **Safe**, **Protected**, **Standard**, **Attack（攻击似的扫描）**。 扫描所得的漏洞数量以次递增。


![Mode](http://upload-images.jianshu.io/upload_images/1571420-e6ea9e1d9783e5bb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x07 Scan Policy (扫描策略)

选择特定页面进行 `Active Scan` :

![Active Scan](http://upload-images.jianshu.io/upload_images/1571420-bd062a946eba0885.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

ZAP 继承了一个默认的扫描策略 **Default Policy**:

![Default Policy](http://upload-images.jianshu.io/upload_images/1571420-0fdf13bb29f320c1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当然，我们可以定制自己的扫描策略，在 顶部导航 分析 中的扫描策略(或者Ctrl+P) 打开 `Scan Policy Manager` 添加或修改自己的扫描策略。


![Scan Policy Manager](http://upload-images.jianshu.io/upload_images/1571420-2f88c09ac0516a92.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如此，我们便可以在以后的网站扫描配置中选择自定义的扫描策略了。

---
### 0x08 Anti CSRF Tokens
某些应用程序为了防止 CSR 攻击，在每次访问时都会随机生成一个新的 Token。这些由伪随机算法生成的随机数也许大部分的扫描器都不支持。所以我们可以通过 ZAP 的 `Anti CSRF Tokens` 功能添加该网站的特定的 **Tokens**(如果该网站有 Token 的话)。


![Anti CSRF Tokens](http://upload-images.jianshu.io/upload_images/1571420-02a6921e9a3121cf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


> what's token?
在OAuth协议中，token是在输入了用户名和密码之后获取的，只不过是服务器或者说网站帮你生成的临时密码。利用这个token你可以拥有查看或者操作相应的资源的权限。你有这些权限，是因为服务器知道你是谁（authentication）以后赋予你的，所以token这个东西，其实就是你的一个“代表”，或者说完全能代表你的“通行证”。从这个概念来说，“令牌”这个翻译，真的是非常的“信雅达”啊

---
### 0x09 HTTP -CA
首先生成并保存 ZAP 的http 证书。


![ HTTP -CA](http://upload-images.jianshu.io/upload_images/1571420-e57113da6d764ae0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后在浏览器中导入 ZAP 的根证书。


---
### 0x0A  ZAP 身份认证
在 ZAP 中最常用的 身份认证是使用 HTTP Session 的认证方式。当然 ZAP 也是支持其它认证方式的，并且我们可以在 **Session Properities** 中进行配置。


![Authentication](http://upload-images.jianshu.io/upload_images/1571420-7d8627ec8c08a324.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

由上图可知，目前 ZAP 支持四种身份认证方法: `Form`,`HTTP/NTLM`, `Manual`,`Script-based`。

默认情况下，一个 Muaual 认证方式就足够了，也是最简单易用的方式。

---
#### HTTP Session
ZAP 在默认情况下只会将其内置的几个 session 名称识别为 HTTP Session。但是，某些情况下，有的网站也许会自定义自己的 session 名称，这时我们有必要手动为其添加自定义的 session 标识。

![HTTP Session](http://upload-images.jianshu.io/upload_images/1571420-cbdfcbf890069559.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![添加自定义的 Security](http://upload-images.jianshu.io/upload_images/1571420-dbdb60ffb9d8efae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x0B 截断
ZAP 可以实时截断从客户端发起的请求或者从服务器端回传的响应。


![Set Break](http://upload-images.jianshu.io/upload_images/1571420-1b2bce83c4a68d0c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


---
### 0x0C 隐藏域
以微软搜索引擎 必应为例，未开启隐藏域时访问的眼如下:


![BiYing](http://upload-images.jianshu.io/upload_images/1571420-d02c59871442d8ca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

开启 ZAP 的隐藏域显示功能:

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-e2e13f29c55b8bfa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x0D 总结
标准扫描工作流程: 设置代理 --> 手动爬网 --> 自动爬网 --> 主动扫描.


