---
title: AutoHotkey篇   
date:  2016-12-22     
tags: ['Windows工具篇','工具篇']
toc: true
categories: technology

---
### 0x00 前言
AutoHotKey 的强大之处不多赘述，它由最初旨在提供键盘快捷键的脚本语言驱动(称为：热键)，随着时间的推移演变成一个完整的脚本语言，有兴趣的看官打可谷歌一下。

### 0x01 安装

在浏览器中输入网址 http://www.autohotkey.com/ 进入AutoHotkey的官网，下载安装 AutoHotKey。


---
### 0x02 使用 AutoHotKey
安装完成以后可以在任意位置创建一 `AutoHotkey.ahk` 脚本。双击该脚本既可以运行 AutoHotKey。当在里面写入相应的映射代码然后右击选择 `reload this script` 执行它就可以开始使用AutoHotkey里面设置好的功能了。

我们还可以为该脚本设置开机自启动，只需要将该脚本生成一个“快捷方式”，然后将此快捷方式放置到程序自启动文件夹之下即可,一般都在这儿：

```
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\
```


---
### 0x03 配置
首先我们需要了解下脚本中常用的符号所代表的含义:

> \# 号代表 `Win` 键；  
! 号代表 `Alt` 键；  
^ 号代表 `Ctrl` 键；  
\+ 号代表 `shift` 键；  
:: 号(两个英文冒号)起分隔作用；  
run 非常常用 的 AHK 命令之一;  
; 号代表 注释后面一行内容；  

如果，需要使用快捷键 `Alt+q` 打开 `QQ` 可以在 `AutoHotkey.ahk` 脚本中添加如下内容:

```
;Alt+q QQ
!q::run E:\SoftWare\QQ\Bin\QQScLauncher.exe
```


---
### 0x04 我的配置文件

```
;Notes: #==win !==Alt 2015-05-20  ^==Ctr  +==shift

;Alt 组合打开常用软件
;Alt+s sublime
!s::run E:\Sublime Text 3\sublime_text.exe

;Alt+g google chrome
!g::run C:\Program Files (x86)\Google\Chrome\Application\chrome.exe

;Alt+x xiami
!x::run F:\Program Files (x86)\Xiami\XMusic\xmusic.exe

;Alt+c cmder
!c::run E:\Program Files\cmder\Cmder.exe

;Alt+q QQ
!q::run E:\SoftWare\QQ\Bin\QQScLauncher.exe

;Alt+w webStorm
!w::run E:\Program Files (x86)\JetBrains\WebStorm 2016.3.2\bin\webstorm.exe
;Alt+y youdaonote
!y::run F:\Youdao\YoudaoNote\YoudaoNote.exe

;Win 组合快速打开网页
#g::run https://www.google.com


;Ctrl+shift+c 快速拷贝文件路径
^+c::
; null= 
send ^c
sleep,200
clipboard=%clipboard% ;%null%
tooltip,%clipboard%
sleep,500
tooltip,
return

#c::
IfWinNotExist ahk_class Chrome_WidgetWin_1
{
    Run "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    WinActivate
}
Else IfWinNotActive ahk_class Chrome_WidgetWin_1
{
    WinActivate
}
Else
{
    WinMinimize
}
Return

;颜色神偷 Ctrl+Win+C
^#c::
MouseGetPos, mouseX, mouseY
; 获得鼠标所在坐标，把鼠标的 X 坐标赋值给变量 mouseX ，同理 mouseY
PixelGetColor, color, %mouseX%, %mouseY%, RGB
; 调用 PixelGetColor 函数，获得鼠标所在坐标的 RGB 值，并赋值给 color
StringRight color,color,6
; 截取 color（第二个 color）右边的6个字符，因为获得的值是这样的：#RRGGBB，一般我们只需要 RRGGBB 部分。把截取到的值再赋给 color（第一个 color）。
clipboard = %color%
; 把 color 的值发送到剪贴板
return
```


