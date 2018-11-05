---
title: 安装并配置oh-my-zsh
date: 2016-05-25 10:28:00
tags: ['kali系统配置']
toc: true
categories: technology

---
### 0x00 安装oh-my-zsh

手动安装:

```
$: git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
$: cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
$: chsh -s /bin/zsh#变更shell
$: 注销账号重新登陆
```

---
### 0x01 配置
zsh的配置主要集中在__.zhsrc__文件里，可以在此处定义自己的环境变量和别名。配置完成以后可以选择自己中意的主题。只需要在.zshrc中配置__ZSH_THEME="agnoster__(我的主题)"，系统默认主题为robbyrussell就可以了，相关文件在~/.oh-my-zsh/thems下。

---
### 0x02 插件
主要介绍auojump这个插件:
安装autojump:

```
$: git clone git://github.com/joelthelion/autojump.git
```

解压以后进入目录,执行:

```
./install.py
```

最后添加如下代码到.zshrc:

```
$: [[autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh
```

---
### 安装powerline电力线

---
#### 安装powerline

 ```
 pip install git+git://github.com/Lokaltog/powerline
 ```

---
#### 安装font

* __fontconfig:__

```
wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
$: mv PowerlineSymbols.otf /usr/share/fonts/
$: fc-cache -vf
$: mv 10-powerline-symbols.conf /etc/fonts/conf.d/
```


---
#### 作用于vim
则在.vimrc中添加如下代码:

```
set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256
```

---
#### 作用于zsh
则在.zshrc中添加如下代码:

```
if [[ -r /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/local/lib/python2.7/dist-packages/powerline/bindings/zsh/powerline.zsh
fi
```

----
#### 作用于tmux
则在.tmu.conf中添加:

```
source /usr/local/lib/python2.7/dist-packages/powerline/bindings/tmux/powerline.conf
set-option -g default-terminal "screen-256color"
```

---
#### 卸载

```
pip uninstall powerline
```


