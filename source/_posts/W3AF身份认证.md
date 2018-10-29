---
title: W3AF身份认证
date: 2016-09-05 11:16
tags: ['Kali渗透测试','Web渗透测试']
toc: true
categories: technology

---
### 0x00 W3AF简介
无论是Httrack，Nikto，Vega还是skipfish都是比较轻量级的tools。Web Application Attack and Audit Framework，基于Python编写的Web渗透测试框架，此框架的目标是用来`发现`和`利用`所有WEB应用程序bug。

不同于，nikto，vega，这些都是个别的大牛一时兴起而写出来的，毕竟个人的能力是有限的，所以很有可能这些工具也只是停留在一个版本就绝迹了，而w3af是基于开源的，所以它的生命周期会更长。


现在w3af一共覆盖了9个大类近150个plugin：
* audit:审计，在该组件下，集成了大量的web扫描工具。

* infrastructure:基础架构，主要用来扫描服务器的banner等基本信息。

* grep:被动扫描类型。

* evasion:逃避，主要是用来逃避目标的IDS，IBS的检测。

* mangle:主要是基于正则表达式的信息替换，比如注入，代码修改。

* auth:基于表单的身份认证。

* brutefoece:暴力破解。

* output:对扫描出来的结果输出为特定的文件。

* crawl:爬网，比如web spider，爬网爬得越全，那么发现漏洞的可能行越大。

---
#### attack
其实attack算是w3af中的第十类，但是不同与前九个，attck模块不能人为的进行配置的，所有的攻击的方法都是固定的，使用者无法修改。


---
### 0x01 原生安装 w3af

#### 测试Kali自带w3af

在Kali Rolling上测试自带w3af失败。

杀死所有有关w3af的进程:

```
root@kali:~# ps -aux | grep -n w3af
root@kali:~# kill -9 8362 8437 9943 9945 9946 9949 10086
```

#### 安装步骤

在主目录里实现源码下载和安装等相关步骤:

```
$ cd ~
```

更新update源:
```
apt-get update
```

安装pip以及w3af
```
apt-get install -y python-pip w3af
```

升级pip:

```
pip install --upgrade pip
```

通过 github clone w3af 源代码 :

```
git clone https://github.com/andresriancho/w3af.git
```

等待w3af源代码下载完成，然后进入w3af目录:
```
$ cd w3af
```

```
./w3af_console (./w3af.gui)
```

提示，需要安装相关依赖:

```
$ apt-get install python-dev libxml2-dev libxslt1-dev zlib1g-dev

$ apt-get build-dep python-lxml
```

然后，可以使用pip或者运行替换脚本安装w3af的相关依赖:

```
$ ./tmp/w3af_dependency_install.sh
#$ pip install pyClamd==0.3.15 PyGithub==1.21.0 GitPython==0.3.2.RC1 nltk==3.0.1 chardet==2.1.1 tblib==0.2.0 futures==2.1.5 ndg-httpsclient==0.3.3 pyasn1==0.1.8 lxml==3.4.4 scapy-real==2.2.0-dev guess-language==0.2 msgpack-python==0.4.4 python-ntlm==1.0.1 Jinja2==2.7.3 markdown==2.6.1 psutil==2.2.1 mitmproxy==0.13 ruamel.ordereddict==0.4.8
```

#### 升级w3af

```
 root  ~  cd w3af 
 root  ~  w3af  git pull     
 ```


#### 创建w3af快捷方式
Linux下的快捷方式文件都是已 `.desktop` 结尾的。

首先将 Kali 自带的 w3af 的快捷方式 copy 到桌面 

```
$: cp /usr/share/applications/w3af.desktop /root/Desktop 
```

然后打开 w3af.desktop 文件 

```
 root  ~  cd Desktop          
 root  ~  Desktop  vim w3af.desktop 
[Desktop Entry]
Name=w3af
Encoding=UTF-8
Exec=sh -c "/root/w3af/w3af_gui"  <---修改为最新安装的 w3af_gui 启动路径
Icon=kali-w3af.png
StartupNotify=false
Terminal=false
Type=Application
Categories=03-webapp-analysis;
X-Kali-Package=w3af
```

保存退出 vim，回到 desktop 为w3af.desktop 添加运行权限

```
 root  ~  Desktop  chmod u+x w3af.desktop 
```
w3af有两种启动方式，console和GUI启动.

---
### 0x02 w3af_console 使用简介

---
#### help命令
`help` 可以查看w3af当前模块下可用的命令

```
 root  ~  w3af  ./w3af_console 
w3af>>> help
|----------------------------------------------------------------------------|
| start         | Start the scan.                                            |
| plugins       | Enable and configure plugins.                              |
| exploit       | Exploit the vulnerability.                                 |
| profiles      | List and use scan profiles.                                |
| cleanup       | Cleanup before starting a new scan.                        |
|----------------------------------------------------------------------------|
| help          | Display help. Issuing: help [command] , prints more        |
|               | specific help about "command"                              |
| version       | Show w3af version information.                             |
| keys          | Display key shortcuts.                                     |
|----------------------------------------------------------------------------|
| http-settings | Configure the HTTP settings of the framework.              |
| misc-settings | Configure w3af misc settings.                              |
| target        | Configure the target URL.                                  |
|----------------------------------------------------------------------------|
| back          | Go to the previous menu.                                   |
| exit          | Exit w3af.                                                 |
|----------------------------------------------------------------------------|
| kb            | Browse the vulnerabilities stored in the Knowledge Base    |
|----------------------------------------------------------------------------|
```

---
#### plugins模块
`plugins` 功能下共有九个可供选择的扫描模块。

比如:
```
w3af/plugins>>> audit xss sqli lfi 
```
代表选择同时 `audit` 下的 `xss` ，`sqli` 和 `lfi` 扫描功能。

当然也可以指定 `audit` 下的所有功能

```
w3af/plugins>>> audit all
```
确定选择以后，各个 功能 对应的 status 将会启动。

```
w3af/plugins>>> crawl spider_man 
w3af/plugins>>> back
```

选择完成以后使用 `back` 返回上一级目录。

#### profile
我们可以就将所选的 `plugins` 下的配置通过 `profile` 保存，方便下次直接调用。

```
w3af>>> profiles save_as myScanProfile
Profile saved.
```

使用 `profile`
```
w3af/profiles>>> use fast_scan 
```

---
#### w3af 的全局设置

##### http-settings

```
w3af>>> http-settings 
w3af/config:http-settings>>> view
|----------------------------------------------------------------------------|
| Setting                 | Value | Modified | Description                        |
|----------------------------------------------------------------------------|
| url_parameter           |      |      | URL parameter                      |
|                         |      |      | (http://host.tld/path;<parameter>) |
| timeout                 | 0    |      | HTTP connection timeout            |
| headers_file            |      |      | HTTP headers filename which        |
|                         |      |      | contains additional headers to be  |
|                         |      |      | added in each request              |
|----------------------------------------------------------------------------|
| cookie_jar_file         |      |      | Cookie Jar file holding HTTP       |
|                         |      |      | cookies-指定一个包含cookies信息的文件                            |
| ignore_session_cookies  | False |      | Ignore session cookies             |
|----------------------------------------------------------------------------|
| ntlm_auth_url           |      |      | NTLM authentication domain (target |
|                         |      |      | domain name)                       |
| ntlm_auth_user          |      |      | NTLM authentication username       |
| ntlm_auth_passwd        |      |      | NTLM authentication password       |
| ntlm_auth_domain        |      |      | NTLM authentication domain         |
|                         |      |      | (windows domain name)              |
|----------------------------------------------------------------------------|
| rand_user_agent         | False |      | Use random User-Agent header 使用能够随机的user-agent       |
| max_file_size           | 400000 |      | Maximum file size                  |
| max_http_retries        | 2    |      | Maximum number of HTTP request     |
|                         |      |      | retries                            |
| user_agent  (默认agent为w3f，不建议使用默认值)            | w3af.org |      | User Agent header                  |
| max_requests_per_second | 0    |      | Maximum HTTP requests per second   |
|----------------------------------------------------------------------------|
| string_match_404        |      |      | Tag HTTP response as 404 if the    |
|                         |      |      | string is found in it's body       |
| always_404              |      |      | Comma separated list of URLs which |
|                         |      |      | will always be detected as 404     |
|                         |      |      | pages                              |
| never_404               |      |      | Comma separated list of URLs which |
|                         |      |      | will never be detected as 404      |
|                         |      |      | pages                              |
|----------------------------------------------------------------------------|
| proxy_port (支持外部代理)             | 8080 |      | Proxy TCP port                     |
| proxy_address           |      |      | Proxy IP address                   |
|----------------------------------------------------------------------------|
| basic_auth_user    (w3af的基本认证信息)     |      |      | Basic authentication username      |
| basic_auth_passwd       |      |      | Basic authentication password      |
| basic_auth_domain       |      |      | Basic authentication domain        |
|----------------------------------------------------------------------------|
```

##### 不使用默认的 user-agent 使用随机user-agent

```
w3af/config:http-settings>>> set rand_user_agent True 
```

设置完毕后 `save` ，并 `back` 上一级目录

```
w3af/config:http-settings>>> save 
The configuration has been saved.
w3af/config:http-settings>>> back
The configuration has been saved.
w3af>>> 
```

##### misc-settings

```
w3af>>> misc-settings 
w3af/config:misc-settings>>> help
```

```
w3af/config:misc-settings>>> view
|----------------------------------------------------------------------------|
| Setting                 | Value                 | Modified | Description   |
|----------------------------------------------------------------------------|
| msf_location            | /opt/metasploit3/bin/ |          | Full path of  |
|                         |                       |          | Metasploit    |
|                         |                       |          | framework     |
|                         |                       |          | binary        |
|                         |                       |          | directory     |
|                         |                       |          | (/opt/metasploit3/bin/ |
|                         |                       |          | in most linux |
|                         |                       |          | installs)     |
|----------------------------------------------------------------------------|
| interface               | wlan0                 |          | Local         |
|                         |                       |          | interface     |
|                         |                       |          | name to use   |
|                         |                       |          | when          |
|                         |                       |          | sniffing,     |
|                         |                       |          | doing reverse |
|                         |                       |          | connections,  |
|                         |                       |          | etc.          |
| local_ip_address        | 192.168.1.6           |          | Local IP      |
|                         |                       |          | address to    |
|                         |                       |          | use when      |
|                         |                       |          | doing reverse |
|                         |                       |          | connections   |
|----------------------------------------------------------------------------|
| max_discovery_time      | 120                   |          | Maximum crawl |
|                         |                       |          | time          |
|                         |                       |          | (minutes)     |
| stop_on_first_exception | False                 |          | Stop scan     |
|                         |                       |          | after first   |
|                         |                       |          | unhandled     |
|                         |                       |          | exception     |
|----------------------------------------------------------------------------|
| non_targets             |                       |          | A comma       |
|                         |                       |          | separated     |
|                         |                       |          | list of URLs  |
|                         |                       |          | that w3af     |
|                         |                       |          | should        |
|                         |                       |          | completely    |
|                         |                       |          | ignore        |
|----------------------------------------------------------------------------|
| fuzz_url_filenames      | False                 |          | Indicates if  |
|                         |                       |          | w3af plugins  |
|                         |                       |          | will send     |
|                         |                       |          | fuzzed file   |
|                         |                       |          | names in      |
|                         |                       |          | order to find |
|                         |                       |          | vulnerabilities |
| fuzz_url_parts          | False                 |          | Indicates if  |
|                         |                       |          | w3af plugins  |
|                         |                       |          | will send     |
|                         |                       |          | fuzzed URL    |
|                         |                       |          | parts in      |
|                         |                       |          | order to find |
|                         |                       |          | vulnerabilities |
| fuzzable_headers        |                       |          | A list with   |
|                         |                       |          | all fuzzable  |
|                         |                       |          | header names  |
| fuzzed_files_extension  | gif                   |          | Indicates the |
|                         |                       |          | extension to  |
|                         |                       |          | use when      |
|                         |                       |          | fuzzing file  |
|                         |                       |          | content       |
| form_fuzzing_mode       | tmb                   |          | Indicates     |
|                         |                       |          | what HTML     |
|                         |                       |          | form combo    |
|                         |                       |          | values w3af   |
|                         |                       |          | plugins will  |
|                         |                       |          | use: all, tb, |
|                         |                       |          | tmb, t, b     |
| fuzz_form_files         | True                  |          | Indicates if  |
|                         |                       |          | w3af plugins  |
|                         |                       |          | will send     |
|                         |                       |          | payloads in   |
|                         |                       |          | the content   |
|                         |                       |          | of            |
|                         |                       |          | multipart/post |
|                         |                       |          | form files.   |
| fuzz_cookies            | False                 |          | Indicates if  |
|                         |                       |          | w3af plugins  |
|                         |                       |          | will use      |
|                         |                       |          | cookies as a  |
|                         |                       |          | fuzzable      |
|                         |                       |          | parameter     |
|----------------------------------------------------------------------------|
```

---
#### target 模块
`target` 用于设置需要被扫描的目标地址。

```
w3af>>> target 
w3af/config:target>>> view 
|---------------------------------------------------------------------------|
| Setting   | Value | Modified | Description                                     |
|---------------------------------------------------------------------------|
| target_framework | unknown |      | Target programming framework                    |
|           |      |      | (unknown/php/asp/asp.net/java/jsp/cfm/ruby/perl) |
| target   (设置要扫描的网站url) |      |      | A comma separated list of URLs                  |
| target_os (设置要扫描的操作体统的主机ip)| unknown |      | Target operating system (unknown/unix/windows)  |
|---------------------------------------------------------------------------|
```

##### 使用 `target` 指定目标地址

```
w3af/config:target>>> set target http://www.sina.com
w3af/config:target>>> view
|---------------------------------------------------------------------------|
| Setting  | Value      | Modified | Description                                |
|---------------------------------------------------------------------------|
| target_framework | unknown    |      | Target programming framework               |
|          |            |      | (unknown/php/asp/asp.net/java/jsp/cfm/ruby/perl) |
| target   | http://www.sina.com | Yes  | A comma separated list of URLs             |
| target_os | unknown    |      | Target operating system                    |
|          |            |      | (unknown/unix/windows)                     |
|---------------------------------------------------------------------------|
```

##### 使用`self-contained` 将上述设置另存为

```
w3af>>> profiles 
w3af/profiles>>> save_as test2 self-contained
Profile saved.
```

由此，我们可以将 `test1` 设置与他人共享。


---
#### `start` 启动扫描

```
w3af>>> start 
```

---
#### w3af下 script
w3af 也自带了许多的扫描脚本

```
 root  ~  w3af  1  cd scripts                                         
 root  ~  w3af  scripts  1  ls                                      
allowed_methods.w3af             login_brute_password_only.w3af
```
 
##### 以sqli.w3af 脚本为例
我们只需要修改脚本中的 target 地址便可以很方便的调用这些脚本了

```
 root  ~  w3af  scripts  1  cat sqli.w3af                              master 
# This is a demo of the attack plugin sql_shell

plugins
output console,text_file
output config text_file
set output_file output-w3af.txt
set verbose True
back
output config console
set verbose False
back

audit sqli

crawl web_spider
crawl config web_spider
set only_forward True
back

grep path_disclosure

back
target
set target http://www.sina.com <---更改为目标ip
back

start

bug-report

details 0

back

exit
```

##### ./w3af_console -s scripts/scriptname.weaf 

```
 root  ~  w3af  1  ./w3af_console -s scripts/sqli.w3af   
```

脚本执行完成，并会在w3af根目录下生成 扫描报告 :
```
 root  ~  w3af  1  ls                                                   master 
circle.yml  extras           profiles  tools  w3af_api      w3af_gui
doc         output-w3af.txt  scripts   w3af   w3af_console
 ```

---
### 0x03 w3af 身份认证

`w3af` 支持四种身份认证: `HTTP Basic` , `NTLM` , `Form` , `Cookie` 。不同的认证方式对应不同的目标扫描类型。

---
#### HTTP Basic 
`HTTP Basic` 并没有严格意义上的加密，只不过是经过了简单的编码而已，基于这种认证，使用很简单的破解工具便可以破解了。

我们以 win7 为例，首先安装win7 IIS 服务器，选择默认网站属性，关闭默认网站的匿名身份认证，从而选择基本身份认证，并设置登录的用户名和密码。

然后通过Kali去访问该网站，使用 wireshark 进行抓包，通过 `Floow TCP Stream` 分析，我们可以得到一个 经过 base64 进行编码的  `Authorization` 信息，其中包含了登录使用的用户名和密码，使用  `W3af --> tools  --> Encode/Uncode`  功能对所得到编码字符进行反向解码便可以得到用户名和密码。

---
##### 对使用 HTTP basic 认证的网站进行扫描
在 `Configuration` --> `HTTP Config` --> `Basic HTTP Authentication` 添加基本认证信息:


![HTTP settings.png](http://upload-images.jianshu.io/upload_images/1571420-fba9c47cb195e069.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

等待一切配置完毕可以勾选需要扫描的模块进行扫描，在 Target 中指定要扫描的目标 url。


---
#### NTML 
NTML 身份认证是微软一家才有的身份认证方式。

开启 NTML 的认证功能需要使用到 IIS 的集成身份认证摸块。NTML 也是windows 下的默认身份认证方式。

然后，回到 Kali 下的 W3af中配置 NTML 认证信息。
 
![NTML Atuentication.png](http://upload-images.jianshu.io/upload_images/1571420-3ada3ea2d7fe5502.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

同样的，等待一切配置完毕可以勾选需要扫描的模块进行扫描，在 Target 中指定要扫描的目标 url。

---
#### 基于From的身份认证
基于From的身份认证便不能使用 W3af的HTTP Configuration了，而是使用 W3af中的 auth 插件，目前 w3af 提供两种方式的 From 表单提交认证,即是 detailed 和 generic方法，detailed 相比于 generic的信息更加详细。

##### detailed
选择 W3f 下的 auth 插件在的 detailed 选择，配置要提交的From信息，


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-4b9e198be4893ece.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


__username_field__ 和 __password_field__分别表示在表单中要提交的用户名和密码控件的 username，如下所示:

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-e15b70eb54bbe963.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

auth_url 表示表单所在的url地址。

check_url 表示一旦表单验证成功以后进入的页面，主要是为了验证表单提交是否成功。同样，`check_string` 具有同样的作用，它表示的是表单登录成功以后可以看到的特征字符串。

ok,配置完成以后，选择保存，继续进行 crawl 爬网插件的配置。

在 `crawl` 下首先需要要选择 `web_Spider` 一项勾选 `only_forward`指定在该 target url 下要扫描的特定的子目录。同时还可以配置`follow_regex` (需要扫描的特定类型的页面)和 `ignore_regex`  (需要忽略的页面)  以此进行交叉组合筛选。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-9af7df836dcb0609.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
#### Cookie 双因素身份认证
W3af Cookie认证方法比较严格的，直接copy cookies 信息是没法认证的。所以首先需要导出 cookies 的信息。

比如，使用 firebug 导出 dvwa 站点的 cookies 信息，格式如下

```
192.168.56.101	FALSE	/	FALSE	PHPSESSID	c04db28f36bf5cd9a7e4ebfed22045bd
192.168.56.101	FALSE	/dvwa/	FALSE	security	high
```

将其改成 w3af 的专用格式:
```
# Netscape HTTP Cookie File
192.168.56.101	FALSE	/	FALSE	173151000100	PHPSESSID	c04db28f36bf5cd9a7e4ebfed22045bd
192.168.56.101	FALSE	/dvwa/	FALSE	173151000100	security	high
//domain		flag	path	secure_flag	时间信息，表示cookie有没有过期	name	name value
```

根据 W3af 官方的解释，使用cookie 信息时，每一行之上必需使用特定的数据格式，其各个数据字段之间必需使用 TAB 制表符来进行分隔，而不是空格。

更改完 cookies 格式以后，将其保存为本地文件，回到 `w3af` --> ` HTTP Configuration` 下选择 `Cookies`,导入保存的本地 cookie 文件。

![cooki.jre.png](http://upload-images.jianshu.io/upload_images/1571420-b7628f679c183d2a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
 
ok,cookies 信息配置完成，接下来可以在 `audit` 选择相应的扫描插件然后填写 target 开始扫描了。


