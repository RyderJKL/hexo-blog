---
title: OPENVAS
date: 2016-06-30 19:29
tags: ['Kali渗透测试','漏洞扫描']
toc: true
categories: technology

---

### 0x00 OPENVAS 一切皆策略

Openvas是开源的，是Nessus项目分支，用于管理目标系统的漏洞的同时也可以进行攻击渗透。Kali默认安装，但未配置和启动。

Openvas的更新很快，并且配置比较复杂，基于此，也许Openvas并不为大多数人所知。


---
### 0X01 Openvas配置

不幸的是，好像Kali Rolling版本已经没有默认安装Openvas了，需要重新下载:

#### 安装openvas

```
➜  ~ apt-get install openvas
```

##### 然后开始配置Openvas

```
➜  ~ openvas-setup
```

##### 检查安装结果

```
➜  ~ openvas-check-setup
```

##### 查看当前账号

```
➜  ~ openvasmd --list-users
```

##### 修改账号密码

记住更新完openvas以后一定要记得记住那个密码！！！

```
➜  ~ openvas --user=admin --new-password=Password
```

##### 升级Openvas

```
➜  ~ openvas-feed-update
```

##### openvas开放的端口

```
➜  ~ netstat -pantu | grep 939

```

其中9390是openvas的manager端口号，9391是openvas第一个默认安装的第一个扫描器的端口号，9392是openvas的web登录界面。

但是有时openvas会加载失败，导致family与NVT加载失败，使用openvas-setup才可以从新打开。


---
### 0x02 openvas的web页面

登录openvas web界面:https://127.0.0.1:9392
值得注意的是，openvas不会随着kali自动启动，所以我们需要每次自行启动openvas服务:

```
$: /usr/bin/openvas-start
```

---
#### Extras->MySetting
这里可以对我们的openvas进行设置。

![MySetting.png](http://upload-images.jianshu.io/upload_images/1571420-92c25a92cc251ff1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


---
### 0x03  OPENVAS 初体验

使用openvas进行扫描操作之前需要配置扫描策略(Configuration)。

登录openvas界面后选择Configuration菜单下的Scan configs可以看到openvas已经默认集成了多种扫描策略:


![Scan configs的默认策略.png](http://upload-images.jianshu.io/upload_images/1571420-756f4b34bb0cfe24.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


* __Discover__: 只对目标系统进行发现扫描。
* __empty__: 空策略，不进行任何操作。
* __Full and fast:__全面的快速的扫描
* __Full and fast ulitimate:__全面的快速的极限扫描
* __Full and very deep:__全面的深度扫描
* __Full and very deep ultimate:__全面的极限深度扫描
* __Host Discovery:__主机发现
* __System Discovery:__系统识别

通常情况下我们会选择Full and Fast策略，它的families类型会达到56，NTV数量可以达到40000多个。

当然也可以自定义扫描策略.

---
### 0x04 Openvas 自定义扫描策略

---
#### 创建一个只针对windows的扫描策略
选择菜单栏的星号，可以进行自定义的扫描策略。

进入Confiuration选项点击Scan configs后再点击菜单栏中的星号图标可进行__New Scan Configuration__操作。

然后设置好策略的名称，在__Edit Network Vulnerability Test Families__中\选择需要的__family__\类型，每一个__family__代表一种漏洞类型，该类型下会集成多个__NVTS__。

然后勾选__Selext all NVTs__选项为策略添加该families。

还注意到_Family__旁有斜着(DYNAMIC)和横(STATIC)着的两个箭头，选择DYNAMIC意味着当openvas官方发布该__Family__下新的__NVTS__时，策略会自动添加新的__NVTS__。

由于只是针对windows系统的扫描，所以我们会选择如下的__Families__:

* Brute force attacks:暴力破解漏洞，该family不仅仅对windows有效，linux同样适用。
* Buffer overflow:缓存区溢出漏洞
* Compiance
* Databse:数据库
* Default Accpunts:默认账号
* Default Service:默认服务
* FTP:
* FInger abuses:
* Firewall:
* Gain a shell rmotely
* General
* Malware恶意软件
* Nmap NSE：NAMP的恶意扫描脚本
* Nmap NET NSE
* Peer-To-Peer
* Policy
* Port scanners
* Privilege escalation
* Production detetion
* RPC
* SMTP problems
* SNMP
* Service detection
* Settings
* Useless services
* Web Servers
* Web application abuses
* Windows
* Widows:Microsoft Bulletins

选择完毕以后__Save Config__,\回到主界面，可以发现多了一个__window_Server_scanconfig__的配置文件。

![zhujiemian.png](http://upload-images.jianshu.io/upload_images/1571420-199de9ce4e878a94.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以后可以通过__扳手__图标对其进行编辑。


##### 确定要扫描的Targets策略
选择菜单栏__Configuration__\下的__Targets__\选项，然后点击__星号按钮__进行扫描目标策略配置。


![Targets策略.png](http://upload-images.jianshu.io/upload_images/1571420-ca20371739175fd0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

配置好以后选择__Creat Target__进行保存。


##### 配置端口扫描策略

同样选择__Configuration__\-->__Port List__\-->__星号(New Port List)__添加需要扫描的端口号。


##### Schedule策略
调度策略可以使用__Task__按Schedule中的规则去执行任务。
比如在特定的时间点执行策略，或者每周执行一处策略。

![Schedule.png](http://upload-images.jianshu.io/upload_images/1571420-0c147ffa2801d6da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### Task策略
建立Task策略可以自定义执行之前的所有策略。
这次讲使用到菜单栏的__Scan Management__\选项下的__Task__。

![Targets策略.png](http://upload-images.jianshu.io/upload_images/1571420-42c3ec570ffa9653.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

最后回到Task Manager页面，点击执行按钮开始执行任务。

利用扫描器去扫描也许会得到很多的结果，但是我们该如何去验证这些结果的正确性？这个便是MSF所能做的了。

##### 生成报告
当扫描完成以后可以讲扫描结果进行特定格式的导出，以方便进行阅读和分析。


