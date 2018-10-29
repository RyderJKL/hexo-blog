---
title: 第一Android应用
date: 2016-06-03 18:47:52
tags: ['Android开发']
toc: true
categories: technology

---
### 0x00 安装Androi开发环境
在kali上安装Android Studio由于kali已经默认安装了javac，便不再需要额外配置java环境了。下一步是安装ADT，ADT中包含了Eclipse编辑器和Android SDK。Eclipse能很好的支持Java开发。

安装studio以前还需要
```
apt-get install lib32z1 lib32ncurses5  lib32stdc++6
```
linux版的Andro Studio下载链接:https://dl.google.com/dl/android/studio/ide-zips/2.1.1.0/android-studio-ide-143.2821654-linux.zip
使用迅雷下载边不需要翻墙了，顺便附上windows的下载链接:
win 64位 Android Studio:https://dl.google.com/dl/android/studio/install/2.1.1.0/android-studio-bundle-143.2821654-windows.exe

---
### 0x01第一个Androi程序
* 启动ADT，设置Work Space路径，即是Eclipse的工作路径。
* 进入Eclipse，点击New Android Application来创建新的App
* 填写App的名字，并安装Java包的命名规则，将给Package Name命名。


