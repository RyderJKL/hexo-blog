---
title: Cmder篇   
date:  2016-12-22     
tags: ['Windows工具篇','工具篇','Cmder']
toc: true
categories: technology

---
### 0x00 安装 Cmder
Cmder官网 `http://cmder.net/` Cmder 官方提供的安装包作为一个压缩档的存在, 可即压即用，你甚至可以放到USB就可以虽时带着走，连调整过的设定都会放在这个目录下，不会用到系统机码(Registry)，所以也很适合放在Dropbox / Google Drive / OneDrive共享于多台电脑。

---
### 0x01 配置 Cmder

###### 添加 cmder 到 AutoHotKey

```
;Alt+c cmder
!c::run E:\Program Files\cmder\Cmder.exe
```

---
#### 默认开启设置
输入win + alt + p或者 在底部右击点击 settings, 进入设置页面；可以根据自己的所需进行各种配置(字体，皮肤等等等等)。

如下图所示，可以设置PowerShell作为默认开启的选项；也可以更改默认开启是所在目录。


###### 命令别名
修改 `Cmder` 目录下 `vendor\profile.ps1` 文件，比如：

```
Set-Alias st "C:\Program Files\Sublime Text 3\sublime_text.exe"
 
function Git-Status { git status } 
Set-Alias gs Git-Status

function go-Work {cd E:\work\web\cdn\}
Set-Alias gw go-Work
```

