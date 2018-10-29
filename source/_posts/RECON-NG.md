---
title: RECON-NG
date: 2016-04-08 18:21
tags: ['Kali第六章','被动信息收集']
toc: true
categories: technology

---


_如果你要expolit请使用Metasploit(Metasploit Framework)，如果你要社会工程请使用Social Engineer Toolkit，如果你要侦查使用Recon-ng吧！_

---
### 0x00

RECON-NG是一个超级重量级的全特性的WEB侦查(信息收集)框架，它使用Python编写，开源，功能强大，比如我们之前的DNS信息，联系人信息收集，邮件信息收集，以及web页面内容信息收集，几乎我们之前所介绍的被动信息收集RECON-NG都可以完成。但框架并不是全部，框架只是规范，所以它并不会包含太多的细节，所有的细节也都是调用模块来完成的！

RECON-NG也是一个命令行工具，其命令格式与msf一致，目前RECON-NG大概有几十个模块，其强大之处也是得益于这些多种多样的模块！

---
### 0x01 RECON-NG使用方式

启动RECON-NG,进入框架命令提示符:
```
root@jack:~# recon-ng
[71] Recon modules
[7]  Reporting modules
[2]  Import modules
[2]  Exploitation modules
[2]  Discovery modules
[recon-ng][default] > 
```

如果不知道框架下的命令怎么用的，请输入help查看帮助信息，即查看框架下可以使用的命令:

```
[recon-ng][default] > help
Commands (type [help|?] <topic>):
---------------------------------
add             Adds records to the database
 {REONG-NG下本身存在有数据库，
每次我们查询到的结果也都会保存到数据库中，
使用add向某一个数据库中插入数据}
back            Exits the current context 
{当我们进入RECON-NG时其提示符是:[recon-ng][default] >   ；
有时当我进入到一个模块中时，即是进入到了下一层级，
便可以使用back来返回了！}
delete          Deletes records from the database
{与add对应哈，能加必能减，能量守恒定律！}
exit            Exits the framework
help            Displays this menu
keys            Manages framework API keys
{recon-ng支持很多网站的API接口，比如SHODAN，google，baidu，
通过调用API使用搜索引擎来完成我们的信息搜索！}
load            Loads specified module
{加载新的模块}
pdb             Starts a Python Debugger session
{调用python的debugger对模块进行调试}
query           Queries the database
{查询数据库，后面可以跟标准的sql语句}
record          Records commands to a resource file
{将所有命令保存为resource文件，再在框架命令提示符下使用-r参数执行}
reload          Reloads all modules
resource        Executes commands from a resource file
search          Searches available modules
{快速搜索相关联的模块！}
set             Sets module options
shell           Executes shell commands
{通过shell在框架下调用一些复杂的系统命令}
show            Shows various framework items
{显示当前框架的各种信息}

snapshots       Manages workspace snapshots
{为recon-ng创建快照，相当于系统还原点}
spool           Spools output to a file
unset           Unsets module options
use             Loads specified module
{即是使用模块}
workspaces      Manages workspaces
```

查看帮助信息:

```
root@jack:~# recon-ng -h
usage: recon-ng [-h] [-v] [-w workspace] [-r filename] [--no-check]
                [--no-analytics]

recon-ng - Tim Tomes (@LaNMaSteR53) tjt1980[at]gmail.com

optional arguments:
  -h, --help      show this help message and exit
  -v, --version   show program's version number and exit
  -w workspace    load/create a workspace
{{为RECON-NG设置不同的工作区}}
  -r filename     load commands from a resource file
{将经常使用的命令保存在一个文件中，
使用-r就可以一次加载并执行了！}
  --no-check      disable version check
{默认情况下recon-ng每次启动都会检查升级，使用no-check则不是自检升级}
  --no-analytics  disable analytics reporting
{不进行报告分析}
```

---
#### 参数使用

Terminal提示符环境下rcon-ng的参数使用:

##### recon-ng -w

新建一个名为sina(新浪)的工作区
``` 
root@jack:~# recon-ng -w sina
 [recon-ng v4.6.3, Tim Tomes (@LaNMaSteR53)]                       
[71] Recon modules
[7]  Reporting modules
[2]  Import modules
[2]  Exploitation modules
[2]  Discovery modules
[recon-ng][sina] > 
```

RECON-NG框架命令提示符下参数使用:
 
##### workspace list

在工作区下查看有哪些工作区:

 ```
[recon-ng][sina] > workspaces list
 +------------+
  | Workspaces |
  +------------+
  | sina       |
  | default    |
  +------------+
```

##### keys查看recong-ng支持哪些网站的api
```
[recon-ng][sina] > keys list
 +---------------------------+
  |        Name       | Value |
  +---------------------------+
  | bing_api          |       |
  | builtwith_api     |       |
  | facebook_api      |       |
  | facebook_password |       |
  | facebook_secret   |       |
  | facebook_username |       |
  | flickr_api        |       |
  | fullcontact_api   |       |
  | google_api        |       |
  | google_cse        |       |
  | instagram_api     |       |
  | instagram_secret  |       |
  | ipinfodb_api      |       |
  | jigsaw_api        |       |
  | jigsaw_password   |       |
  | jigsaw_username   |       |
  | linkedin_api      |       |
  | linkedin_secret   |       |
  | pwnedlist_api     |       |
  | pwnedlist_iv      |       |
  | pwnedlist_secret  |       |
  | shodan_api        |       |
  | twitter_api       |       |
  | twitter_secret    |       |
  +---------------------------+
```

##### 为RECON-NG添加网站API:

{ _Usage: keys add <name> <value>_ }

```
[recon-ng][sina] > keys add twitter_api fdsaieljdfjjsfjsfdad....
```

---
#### 显示当前框架下的各种参数信息
```
[recon-ng][sina] > show options
 Name        Current Value  Required  Description
  DEBUG       False          yes       enable debugging output
  NAMESERVER  8.8.8.8        yes       nameserver for DNS interrogation
  PROXY                      no        proxy server (address:port)
  THREADS     10             yes       number of threads (where applicable)
  TIMEOUT     10             yes       socket timeout (seconds)
  USER-AGENT  Recon-ng/v4    yes       user-agent string
  VERBOSE     True           yes       enable verbose output
```

值得一提的是recon-ng是可以支持代理的，其本质上也是通过调用各种搜索引擎取收集信息的！

 ---
### 0x02 为recon-ng设置go-agent代理
```  
[recon-ng][sina] > set PROXY 127.0.0.1:8087
```
网络管理员通过查看访问日志，分析http请求中的UERS-AGENT字段便能知道扫描其网站的具体工具，我们可以通过设置recon-ng下的user-agent对工具发送的http请求的user-agent进行伪装，避免被过早封杀！
```
[recon-ng][sina] > set USER-AGENT "IE某一个版本的特有user-agent字段"
重置选项:
[recon-ng][sina] > unset USER-AGENT
USER-AGENT => None
```

 * __参数use:使用模块__
下面演示常用模块的使用方法:

 * __Quriey命令的使用:__

未完待续。。。


