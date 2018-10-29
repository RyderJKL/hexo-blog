---
title: kali软件安装和更新源
date: 2016-02-23 21:24
tags: ['Kali渗透测试','Kali安装与环境优化']
toc: true
categories: technology
---

# 0x00 安装 Firefox

首先卸载iceweasel:

```bash
apt-get remove iceweasel
```

然后打开更新源文件文件:

```bash
gedit  /etc/apt/source.list
```

添加如下更新源:

deb http://downloads.sourceforge.net/project/ubuntuzilla/mozilla/apt all main

最后运行如下命令:

```
$ apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C1289A29
$ apt-get update
$ apt-get install firefox-mozilla-build
```

---
### 0x01 安装Google-Chrome

首先下载deb chrome包:https://www.google.com/chrome/browser/thankyou.html?platform=linux

然后运行如下命令:

```
$ apt-get install alacarte
$ apt-get -f install
$ dpkg -i gooel-chrome-stabel-current-amd64.deb
$ apt-get install libappindicator1
$ apt-get -f install
```

然后添加一个chrome的普通用户:

```
$ useradd -m chrome
$ su chrome
```

进入到主菜单`main menu` 选择 `internet` 然后找到`chrome` 在 `command`中添加:

```
gksu -u chrome google-chrome
```

并且点击左边的chrome图标更换chrome图片：computer->opt>googel->chrome:product_logo_48.png ok！

然后使用 leafpad命令:

```
$ leafpad /opt/google/chrome/google-chrome 
```

在`exex -a "$0" "$HERE/chrome" "$0" `后添加:--user -data-dir

```
$ apt-get update && apt-get upgrade
$ reboot
```

然后使用su chrome用户运行google-chrome。

如果想要使用`root`身份运行Chrome，那么需要使得Chrome以非沙箱的形式运行:

```
$ cd /usr/share/applications/
```

打开`google-chrome`在`command`里添加%U --no-sandbox并将`permission`勾选Allow

> kali中chrome的proxy

将shadwosocks放在创建的chrome/home目录下，然后以root身份运行就好了，正确的姿势是:

```
$ alias fuck-gwf="bash /home/chrome/Downloads/shadowsocks-gui-0.6.4-linux-x64
/start.sh > /tmp/shadow.txt 2>>&1 &"
$ fuck-gwf
```

记住一点，就是讲shadowsocks文件放为chrome创建的那用户的目录下就好。


---
### 0x03 Kali下的常用软件及运行环境

播放器smplayer，flashplugin-nonfree，gdebi(图形化软件包安装界面)，amule(电驴)，qbittorrent(bt),geany(开发程序)，stardict(翻译软件)，freemind，netspeed(流量监控),mtr（路由追踪）filezilla(FTP工具)

---
### 0x04 install flashplayer
1.首先到ado官网下载最新Linux版本的tar.gz文件。

2.打开终端，并切换到下载文件所在目录，执行命令: 

```
$: tar xzvf install_flash_player_11_linux.x86_64.tar.gz
```

3.进入解压出来的文件夹,找到 `libflashplayer.so` 拷贝到 `/usr/lib/mozilla/plugins/` 下,命令如下：

```
$: cp libflashplayer.so /usr/lib/mozilla/plugins/
```

---
### 0x05 安装搜狗拼音

#### 首先需要安装fcitx框架

添加软件源：

```bash
leafpad /etc/source.list
// 请自行添加软件源，比如国内的阿里源
```

```bash
apt-get install fcitx
```

然后，下载对应的搜狗拼音 `.deb` 包，直接双击安装就是了。

> http://pinyin.sogou.com/linux/help.php

 最后添加搜狗拼音：应用程序 --> 常用程序 --> 首选项 -->  fcitx设置 --> 添加sougou拼音

然后请重启电脑。

卸载fcitx

``` bash
$: apt-get remove --auto-remove fcitx
```

### 0x05 Kali apt resources

查看 Kali 内核版本信息:

```bash
uname -a 
```

查看 Kali 发行版本信息:

``` bash
lsb_release -a
```

[Kali official source] (http://docs.kali.org/general-use/kali-linux-sources-list-repositories)

```bash
$: leafpd /etc/apt/sources.list

deb http://http.kali.org/kali kali-rolling main non-free contrib
```

if you changed the `sources.list` file,remember use `apt-get update` command. or you can:

```bash
$: apt-get update--fix-missing & apt-get dist-upgrade
$: apt-get clean
```
