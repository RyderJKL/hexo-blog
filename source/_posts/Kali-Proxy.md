---
title: Kali Proxy

date: 2016-07-31 21:24

tags: ['Kali渗透测试','Kali安装与环境优化']
toc: true
categories: technology

---
### 0x00 XXNET

详细配置可以参考官方文档: https://github.com/XX-net/XX-Net

#### Google APPID

```
goagent5-143111|goagent4-143111|goagent3-143111|goagent2-143111|goagent1-143111|goagent-143111
```

Firefox 需手动导入证书 data/gae_proxy/CA.crt 启动后生成。


---
### 0x01 ShadowSocks

删除ShadowSocks本地缓存:

```
$: cd /root/.config/shadowsocks-gui/Local\ Storage/ 

```

---
### 0x02 Tor

#### Kali tor安装

> http://www.blackmoreops.com/2013/12/16/installing-tor-kali-linux/

#### Tor官网
> https://www.torproject.org/download/download-easy.html.en

#### 暗网wiki
> http://zqktlwi4fecvo6ri.onion/wiki/index.php/Main.Page

#### kali 下 Tor 启动问题

##### should not be run as root

解决:
在 `tor-browser_zh-CN` 目录下打开 `browser文件夹`，选择 `start-tor-browser` 文件，使用 `gedit` 打开，（ctrl+f查找root，将{“id -u”-eq 0}中的“0”改为 "1“）。

##### 再次运行出现错误2：“Tor意外退出”：
权限问题导致，需将Tor目录的权限改为root账号，chown -R root:root tor-browser_zh_CN

> !Note \
最大化tor browser窗口之后，网站可以获取显示器尺寸信息，从而跟踪用户！

---
### 0x03 命令行Proxy

#### 对 `apt-get` 添加代理设置
如果使用的是 `XX-NET` 代理，可在 `/etc/apt/apt.conf` 文件中添加如下内容:

```
Acquire::http::Proxy "http://127.0.0.1:8087";
```

此外，同样但不限于以下方法:

```
#Acquire::ftp::Proxy"ftp://127.0.0.1:8087";
#Acquire::https::Proxy"https://127.0.0.1:8087";
#Acquire::socks::Proxy"https://127.0.0.1:8087";
```
#### 添加 `export` 对不支持Proxy的程序使用代理

编辑 `/etc/bash.bashrc` 文件，在末尾添加如下内容:

```
export http_proxy="http://127.0.0.1:8087"
```

使用 `curl` 命令进行验证

```
 root ~ 1 curl -v http://www.sina.com
```

#### 终极武器 `proxychains`
以上所有的方法都决定了一次只能使用一个代理，即只会进行一次跳转，使用 `proxychains` 可以一次实现多次跳转。

```
 root ~ 1 vim /etc/proxychains.conf 
```

`proxychains` 有三种类型的代理， `static` , `dynamic` , `random`:
默认使用 `static`。
```
static: 使用静态代理的方式，按添加代理服务器的地址顺序进行 `串联` 代理，若是其中一个无法连接，则整个代理链无法使用。

dynamic: 类似static代理，不过使用 `并联` 的方式，当添加的代理链中的某一个代理服务器无法使用时，  将自动跳过该代理服务器。

random :  随机选择代理链中的所有服务器进行代理。
```

此外，当选择使用 `random` 代理时，可以指定代理链的长度。不使用默认 DNS 代理设置，以及设置代理连接和超时时间长度等。

设置完毕，当在命令行中使用 `proxychains` 前缀，便可以对任意程序使用代理链代理了。

```
 root ~ 1 proxychains nmap -p80 211.144.145.0/24
```
