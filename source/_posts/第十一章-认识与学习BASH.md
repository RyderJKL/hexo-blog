---
title: 第十一章-BASH
date: 2016-04-10 22:22:52
tags: ['鸟哥的Linux读书笔记基础篇']
toc: true
categories: technology

---
### 0x00 关于BASH
管理整个计算机硬件的其实是操作系统的核心 (kernel)，这个核心是需要被保护的！ 所以我们一般使用者就只能透过 shell 来跟核心沟通，以让核心达到我们所想要达到的工作。

Shell其实就是能够操作应用程序的接口的壳程序！

但是shell的版本是很多的，比如Bourne SHell(sh),C SHell,商业上常用的K SHell，以及Bourn Again SHell(bash)这个是Bourne SHell的增强版！

而bash 是 GNU 计划中重要的工具软件之一，目前也是 Linux distributions 的标准 shell 。 bash 主要兼容于 sh ，并且依据一些使用者需求，而加强的 shell 版本。不论你使用的是那个 distribution ，你都难逃需要学习 bash 的宿命啦！

查看/etc/shells文件看看我们的电脑可以使用哪些shell:
```
root@jack:~# cat /etc/shells 
# /etc/shells: valid login shells
/bin/sh
/bin/dash
/bin/bash
/bin/rbash
/usr/bin/screen
/usr/bin/tmux
```

---
#### Bash shell的功能:
__命令记忆功能:__
bash最棒的一个功能就是能记住你过去使用过的命令，默认可以记住1000条，它会将所有记住的命令存放在你的加目录.bash_history中。
```
root@jack:~# cat .bash_history 
```
但需要知道的是，~/.bash_history 记录的是前一次登陆以前所运行过的命令，而至于这一次登陆所运行的命令都被缓存在内存中，当你成功的注销系统后，该命令记忆才会记录到 .bash_history 当中！

__命令别名配置功能:(alias)__
我们可以个一些常用的同时又很复杂的命令设置别名，比如:
```
root@jack:~# alias lm='ls -al'
```

__通配符:__
bash还支持许多的通配符来帮助用户查询与命令下达:
例如:__{ $ ls -l /usr/bin/X* }__查询/usr/bin下以X开头的文件.

__小插曲:__命令的下达

使用\(反斜杠)来跳脱:当我们下达的命令太长需要两行时:
```
root@jack:~# cp /var/spool/mail/root/etc/crontab\
> /etc/bin /root
```
将三个文件复制到/root下。

---
### 0x01 shell的变量功能   

---
#### 变量的取用与配置
首先我们来取出变量的内容出来看看，这样我们便要用到echo命令了，当然echo的可不止这一个哈，后面我们会慢慢道来，变量在被取用时，前面必须要加上美元符号"$",或者用"${PATH}"来读取！
```
root@jack:~# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
root@jack:~# echo ${PATH}
```

#### 在shell中配置一个变量

```
root@jack:~# echo $myname
root@jack:~# myname=jack
root@jack:~# echo $myname
jack
```
若你有一个常去的工作目录名称为：『/cluster/server/work/taiwan_2005/003/』，如何进行该目录的简化
```
root@jack:~#  work="/cluster/server/work/taiwan_2005/003/"
root@jack:~# cd $work
```


#### 变量的配置规则: 

* 变量内容若有空格符号可以使用双引号(")或单引号(')将变量内容结合起来，但:
 * 双引号内的特殊字符如 $ 等，可以保有原本的特性，如下所示：『var="lang is $LANG"』则『echo $var』可得『lang is en_US』
 * 单引号内的特殊字符则仅为一般字符 (纯文本)，如下所示：『var='lang is $LANG'』则『echo $var』可得『lang is $LANG』

*  可用跳脱字符『 \ 』将特殊符号(如 [Enter], $, \, 空格符, '等)变成一般字符；

* 在一串命令中，还需要藉由其他的命令提供的信息，可以使用反单引号『\`命令\`』或『$(命令)』。特别注意，那个 ` 是键盘上方的数字键 1 左边那个按键，而不是单引号！例如想要取得核心版本的配置：
```
root@jack:~# uname -r
4.0.0-kali1-amd64
root@jack:~# versoin=$(uname -r)
root@jack:~# echo $versoin 
4.0.0-kali1-amd64
```
已知locate命令可以列出所有的相关文件来，但是如果我想知道所有文件的权限呢?
```
root@jack:~# ls -l `locate sina`
```

* 若该变量为扩增变量内容时，则可用 "$变量名称" 或 ${变量} 累加内容，如下所示：
```
root@jack:~# version=${version}yes
root@jack:~# echo $version
4.0.0-kali1-amd64yes
```

* 若该变量需要在其他子程序运行，则需要以 export 来使变量变成环境变量：
『export PATH』

* 取消变量的方法为使用 unset 『unset变量名称』例如取消 myname 的配置:unset myname

---
### 0x02 环境变量的功能

我们可以使用env和export两个命令来查看目前我的shell环境中有多少默认的环境变量!

---
#### env观察环境变量与常用环境变量:

```
root@jack:~# env
XDG_VTNR=7
GPG_AGENT_INFO=/run/user/0/keyring/gpg:0:1
SHELL=/bin/bash { 代表目前使用的shell}
TERM=xterm
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;
.........(省略)
USERNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin { 这个就是运行文件搜索的路径啦，目录与目录之间用冒号隔开}
DESKTOP_SESSION=default
QT_IM_MODULE=fcitx
PWD=/root
HOME=/root { 代表用户的家目录，很多程序都可能会取用到这个变量的值!}
```
env是(enviroment)的缩写，上面的意思是列出所有的环境变量来，当然export其中的一个功能也是可以这样的！

---
#### set观察所有变量(包括环境变量与自定义变量)
set 除了环境变量之外， 还会将其他在 bash 内的变量通通显示出来，下面仅列出几个重要的内容：

```
root@jack:~# set
GTK_IM_MODULE=fcitx
HISTCONTROL=ignoreboth
HISTFILE=/root/.bash_history
HISTFILESIZE=2000
HISTSIZE=1000
HOME=/root
HOSTNAME=jack
HOSTTYPE=x86_64
IFS=$' \t\n'
LANG=zh_CN.UTF-8
LINES=24
LOGNAME=root
```
基本上，在 Linux默认的情况中，使用{大写的字母}来配置的变量一般为系统内定需要的变量，比较重要的有以下几个:

##### PS1:提示字符的配置
这是 PS1 (数字的 1 不是英文字母)，这个东西就是我们的『命令提示字符』喔！当我们每次按下 [Enter] 按键去运行某个命令后，最后要再次出现提示字符时，	就会主动去读取这个变量值了
 
    * \d ：可显示出『星期 月 日』的日期格式，如："Mon Feb 2"
    * \H ：完整的主机名。举例来说，鸟哥的练习机为『www.vbird.tsai』
    * \h ：仅取主机名在第一个小数点之前的名字，如鸟哥主机则为『www』后面省略 
    *  \t ：显示时间，为 24 小时格式的『HH:MM:SS』
    *  \T ：显示时间，为 12 小时格式的『HH:MM:SS』
    * \A ：显示时间，为 24 小时格式的『HH:MM』
    * \@ ：显示时间，为 12 小时格式的『am/pm』样式
    * \u ：目前使用者的账号名称，如『root』；
    * \v ：BASH 的版本信息，如鸟哥的测试主板本为 3.2.25(1)，仅取『3.2』显示
    * \w ：完整的工作目录名称，由根目录写起的目录名称。但家目录会以 ~ 取代；
    * \W ：利用 basename 函数取得工作目录名称，所以仅会列出最后一个目录名。
    * \# ：下达的第几个命令。
    * \$ ：提示字符，如果是 root 时，提示字符为 # ，否则就是 $ 啰～

配置我的字符提示变量:
```
root@jack:~# PS1='[\u@\h \w \A #\#]\$ '
[root@jack ~ 15:27 #2]# ls
```

##### export 自定义变量转换成环境变量
其实所谓的环境变量(也可以理解为全局变量)与自定义变量(也可以理解为局部变量)的区别便是，__该变量是否会被子程序所继续引用__。当我们登录Linux并取得一个bash后，我们得到的bash就是一个独立的程序，接下来在这个bash底下所下达的任何命令都是由这个bash衍生出来的，那些被下达的命令就被成为子程序了，在shell中，__子程序仅会继承父程序的环境变量，而不会继承父程序的自定义变量__,所以这时export命令就很有用了！export主要用在__分享自己的变量配置给后来呼叫的文件或其他程序__。
```
[root@jack ~ 15:46 #4]# export 变量名
```
这里关于如何就爱那个环境变量转换成自定义变量将在后续的declare里介绍！

---
### 0x03 变量键盘读取，数组，声明:read,array,declare

---
#### read

 用来读取来自键盘的输入的变量，用法如下:
```
选与参数:{ USE $: read [-pt] variable }
-p:后面可以接提示字符
-t:后面接等待的"秒数"
```
从键盘输入一内容，并将该内容赋值给test变量
```
root@jack:~# read test
this is test   "{此时光标会等待你输入，此处我输入的是"this is test"}"
root@jack:~# echo $test
this is test
```
提示用户在30秒内输入自己的名字，并将该内容赋值给变量named
```
root@jack:~# read -p "please input your name:" -t 30 named
please input your name:jack "{ 看，此时会有提示字符哟！}"
root@jack:~# echo $named
jack
```
---
#### declare/typeset
declare或typeset是一样的功能，就是__声明变量的类型__
```
选项与参数:{USE $: declare [-aixr] variable }
-a:将变量定义为数组类型(array)
-i:将变量定义为整数类型(integer)
-x:用法与export一样，就是将变量变成环境变量
-r:将变量配置为readonly类型，该变量不可被更改，也不能unset
```
需要知道的是，在默认情况下，bash对于变量有几个基本的定义:
* 变量类型默认为__字符串__，所以若是不指定变量类型，则1+2为一个字符而不是数学表达式
* bash环境中的数值运算，默认只能达到整数形态，所以1/3结果是0

让变量sum进行100+300+50的计算
```
root@jack:~# declare -i sum=100+300+50
root@jack:~# echo $sum
450
```
将sum变成环境变量
```
root@jack:~# declare -x sum
root@jack:~# export | grep sum
declare -ix sum="450"
```
让sum变成只读属性，不可更改
```
root@jack:~# declare -r sum
root@jack:~# sum=dkfd
bash: sum: 只读变量
```
让sum变回去，变成自定义变量
```
root@jack:~# declare +x sum   "{ 将-变成+就可以进行取消了 }"
root@jack:~# declare +p sum   "{ -p可以单独列出变量类型 }"
declare -ir sum="450"         "{ 看，现在只剩下i，r属性了，不在具备x了 }"
```
declare结合数组的在一起是很有用的，但有趣的是，一旦将变量的配置为__只读__通常得要注销再重新登陆才能该变量的类型！

---
#### 数组(array)变量类型
在bash里数组的声明方式是:__var[number]=content__
```
root@jack:~# var[1]="small min"
root@jack:~# var[2]="big min"
root@jack:~# var[3]="nice min"
root@jack:~# echo "${var[1]},${var[2]},${var[3]}"
small min,big min,nice min
```
对于数组的读取，一般建议使用__${数组}的方式来读取__

---
### 0x04 文件系统与程序的限制关系:ulimit

通过ulimit命令，bash可以__限制某些用户的某些系统资源，包括可以开启的文件数量，可以使用的cpu时间，可以使用的内存总量等__

__ulimit__

```
选项与参数:{ use $: ulimit [-SHacdfltu] 配额 }
-a ：后面不接任何选项与参数，可列出所有的限制额度；
-f ：此 shell 可以创建的最大文件容量(一般可能配置为 2GB)单位为 Kbytes
-u ：单一用户可以使用的最大程序(process)数量。
```

---
### 0x05 变量的删除取代与替换

---
#### 变量内容的删除

变量配置方式|说明|
:---:|:---:
${变量#关键字}|若变量内容从头开始的数据符合[关键字]，则将符合的最短数据删除
${变量##关键字}|若变量内容从头开始的数据符合[关键字]，则将符合的最长数据删除
${变量%关键字}|若变量内容从尾向前的数据符合[关键字]，则将符合的最短数据删除
${变量%%关键字}|若变量内容从尾向前的数据符合[关键字]，则将符合的最长数据删除
${变量/旧字符串/新字符串}|若变量内容符合[旧字符串]，则[第一个字符串将会被新字符串所取代]
${变量//旧字符串//新字符串}|若变量内容符合[旧字符串]，则[全部字符串将会被新字符串所取代]

实例:
根据需要删除path路径
```
root@jack:~# path=${PATH}
#先让小写path获得PATH变量内容
root@jack:~# echo path
path
root@jack:~# echo $path
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#删除前四个目录
root@jack:~# echo ${path#/*usr/bin:}
/sbin:/bin
```
删除前面的所有目录，只保留最后一个目录
```
root@jack:~# echo ${path##/*:}
/bin
```

---
#### 变量的测试与内容替换
有时候我们需要判断某个变量是否存在，Bash Shell可以进行变量的条件替换,既只有某种条件发生时才进行替换：
  * (1) ${value:-word} 当变量未定义或者值为空时,返回值为word的内容,否则返回变量的值.
 * (2) ${value:=word}与前者类似,只是若变量未定义或者值为空时,在返回word的值的同时将word赋值给value　
 * (3) ${value:?message}若变量以赋值的话,正常替换.否则将消息message送到标准错误输出(若此替换出现在Shell程序中,那么该程序将终止运行)　　
 * (4) ${value:+word}若变量以赋值的话,其值才用word替换,否则不进行任
何替换
 * (5) ${value:offset}　${value:offset:length}从变量中提取子串,这里offset和length可以是算术表达式.
以上变量测试也是可以通过shell script内的if...then...来处理的，既然bash有提供这么简单的方法我们也可以吸收一下下！

---
### 0x06 命令别名与历史命令

---
#### 命令别名配置:alias,unalias

使用alias我们可以为一个很长的命令配置一简短的命令别名来取代既有的命令！
 
__使用方法:{ use $: alis 别名='命令 选项...' }__

例如:
```
root@jack:~# alias vi='vim'
root@jack:~# alias lm='ls -al | more'
root@jack:~# alias rm='rm -i'
```

然后使用alias查看目前有哪些命令别名
```
root@jack:~# alias
alias lm='ls -al | more'
alias ls='ls --color=auto'
alias rm='rm -i'
alias vi='vim'
```
至于如果想要缺消别名的话，就使用unalias:
```
root@jack:~# unalias lm
```

但是我们添加的alias会在没开机以后就没有了，如果想要永久生效，那么需要在.bashrc文件最后添加alias命令
```
root@jack:~# vim .bashrc

alias ffx='firefox > /tmp/firefox.txt 2>&1 &'
alias fuck-gwf='bash /software/shadowsocks-gui-0.6.4-linux-x64/start.sh > /tmp/gwf.txt 2>&1 &'
```
或者新建立一个文件名为.bash_aliases的文件用来专门存放我们的alias命令
```
root@jack:~# vim .bash_aliases
alias ffx='firefox > /tmp/firefox.txt 2>&1 &'
alias fuck-gwf='bash /software/shadowsocks-gui-0.6.4-linux-x64/start.sh > /tmp/gwf.txt 2>&1 &'
```
然后，更新下:source .bashrc文件！{ 对了上面两个命令，懂的自然懂，哈哈！！}

---
#### 历史命令 history

```
选项与参数:{ use $: history [n][-c]/[-raw] histfiles }__
n:数字，列出最近的n笔命令
-c:将目前shell中的所有的history内容全部消除
-a:将目前新增的histoty命令新曾到histfiles中，如没有加histfiles则默认写入～/.bash_histoty
-r:将histfiles的内容读到目前这个shell的history中
-w:将目前的history记录写入到histfiles
```
history除了能记录历史命令外，还能帮助我们利用相关功能运行命令:
```
root@jack:~# !n
root@jack:~# !command
root@jack:~# !!
选项与参数:
n:运行history中第几个命令
command:运行命令开头为command的命令
!!:运行上一个命令
```
其实history的用途是很多的，尤其是root的历史记录文件，是黑客的最爱，一旦解析该文件，便极有可能在～/.bash_history中获得重要数据！

---
### 0x07 Bash shell的操作环境

---
#### 路径与命令搜索顺序
1.以相对/绝对路径运行命令，例如『 /bin/ls 』或『 ./ls 』；
2.由 alias 找到该命令来运行；
3.由 bash 内建的 (builtin) 命令来运行；
4.透过 $PATH 这个变量的顺序搜寻到的第一个命令来运行。

---
#### 环境配置文件
bash的环境配置文件有全局配置文件和个人配置文件之分，需要注意的是我们前面谈到的命令的别名，自定义的变量啊，在注销bash以后就会失效，如果想要保留配置，就得将这些配置写入配置文件！

##### login shell
login shell会读取两个配置文件:
* etc/profile:这个是系统的整体配置文件
  每个使用者登录取得bash时一定会读取的配置文件
* ～/.bash_profile or ~/.bash_login or ~/.profile:个人配置文件

bash在读完了整体环境配置/etc/profile并由此呼叫其它配置文件后，才会读取使用者的个人配置文件,依序是:
* ~/.bash_profile
* ~/.bash_login
* ~/.profile

其实bash的login shell配置只会读取以上三个文中的一个，而读取的顺序是依照上面的顺序!

 ##### source 更新环境配置文件的命令
 由于 /etc/profile 与 ~/.bash_profile 都是在取得 login shell 的时候才会读取的配置文件，所以， 如果你将自己的偏好配置写入上述的文件后，通常都是得注销再登陆后，该配置才会生效。但是我们可以使用source或者小数点(.)命令都可以将配置文件的内容读进来目前的shell环境中。
```
root@jack:~# source ~/.bashrc
root@jack:~# .  ~/.bashrc
```

##### non-login shell
non-login shell这种非登录的取得的配置文件就是~/.bashrc

* 其它相关配置文件
 * /etc/man.config
规范了使用 man 的时候， man page 的路径到哪里去寻找！』所以说的简单一点，这个文件规定了下达man 的时候，该去哪里查看数据的路径配置！当以 tarball 的方式来安装你的数据，那么你的 man page 可能会放置在 /usr/local/softpackage/man 里头，那个 softpackage 是你的软件名称， 这个时候你就得以手动的方式将该路径加到 /etc/man.config 里头，否则使用 man 的时候就会找不到相关的说明档啰。
 * ~/.bash_history
记录历史命令的文件，每次登录shell后，bash会先读取这个文件，将所有的历史命令读入内存！
 * ~/.bash_logout
该文件则记录了当我注销bash后，系统再帮我做完什么动作以后才离开!
  

#### 终端机的环境配置:stty,set

 一般来讲，linux都帮我们做好了最好的使用者环境了，所以我们不用担心操作环境的问题，倒是了解了解总是可以的，比如如何在终端机中查询快捷键使用，或者更改终端机中的快捷键！

 我们可以使用__stty -a__来列出目前环境中所有的按键，^表示Ctrl的意思:
```
root@jack:~# stty -a
speed 38400 baud; rows 18; columns 80; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = M-^?; eol2 = M-^?;
swtch = M-^?; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R; werase = ^W;
lnext = ^V; flush = ^O; min = 1; time = 0;
```
几个重要的代表意义是:
 * eof: end of file,输入结束，例如邮件结束是，{ ^D }
 * erase:向后删除字符,{ ^? }
 * intr:送出一个interrupt(中断)的讯号给目前正run的程序，终止目前命令,{ ^C }
 * kill:删除在目前命令上的所有文字，在提示符下，将整列命令删除，{ ^U }
 * quit:送出一个quit讯号给目前正在run的程序,{ ^\ }
 * start:在某个程序停止后，重新启动其他的output,，恢复屏幕输出，{ ^Q }
 * stop:暂停目前屏幕的输出,{ ^S }
 * susp:送出一个terminal stop的讯号给正在run的程序,暂停目前的命令，{ ^Z }
  
##### 通配符与特殊符号
bash下通配符(wildcard)可以帮我更加方便的处理数据，下面是一些常用的通配符:

符号|意义
:---:|:---
*|代表__0到无穷多个__任意字符
?|代表__一定有一个__任意字符
[ ]|代表__一定有一个在括号内__的字符(非任意)，例如 [abcd]代表一定有一个字符，可能是a，b，c，d中的任一个
[ - ]|若有减号在中括号内时，代表__在编码顺序内的所有字符__.例如 [0-9] 代表 0 到 9 之间的所有数字，因为数字的语系编码是连续的！
[ ^ ]|若中括号内的第一个字符为指数符号 (^) ，那表示__反向选择__,例如 [^abc] 代表 一定有一个字符，只要是非 a, b, c 的其他字符就接受的意思。

下面是几个使用通配符查看文件的用例:
```
root@jack:~# ls -d /etc/gro* 
#查找/etc下以gro开头的目录
root@jack:~# ls -d /etc/?????
#查找刚好是五个字母的目录
root@jack:~# ls  /etc/*[0-9]*
#查找文件名含有数字的文件
```
当然，linux下除了通配符外还有一些特殊的符号，整理如下:

符号|意义
:---:|:----:
\|跳脱符号：将『特殊字符或通配符』还原成一般字符
;|连续命令下达分隔符：连续性命令的界定 (注意！与管线命令并不相同)
~|用户的家目录
$|取用变量前导符：亦即是变量之前需要加的变量取代值
>,>>|数据流重导向：输出导向，分别是__取代__\与__累加__
<,<<|数据流重导向：输入导向
' '|单引号，不具有变量置换的功能
" "|具有变量置换的功能！
\` `|两个__ ` __中间为可以先运行的命令，亦可使用 $( )

文件名尽量不要使用到上述的字符！

---
### 0x08 数据流重定向

数据流重定向(redirect)就是将某个命令运行以后应该要出现在屏幕上的数据，给传输到其他地方去，在我们想要将某些数据存储下来时，超级有用！！！

---
#### standard output and standard error output
 在学习数据流重定向之前我们先来了解下何为标准输出以及标准错误输出:
标准输出(standard output)指的是:命令行所回传的错误信息，而标准错误输出(standard error output)是:命令运行后，所回传的错误信息

 通过重定向我们可以将standard output(简称stdout)与standard error output(简称stderr)分别传送到其它的文件或者装置中，而不是打印到屏幕上，而分别传送所用的特殊字符如下所示:
1.标准输入(stdin):代码为0，使用<或<<;
2.标准输出(stdout):代码为1，使用>或>>;
3.标准错误输出(stderr):代码为2，使用2>或2>>;
(数字与重定向符号之间没有空空)

 其中:
 * 1>:以覆盖的方法将__正确的数据__输出到指定的文件或装置上
 * 1>>:以覆盖的方法将__正确的数据__输出到指定的文件或装置上
 * 2>:以覆盖的方法将__错误的数据__输出到指定的文件或装置上
 * 2>>:以累加的方法将__错误的数据__输出到指定的文件或装置上

 实例:将一个命令的执行返回结果产生的stdout与stderr分别存到不同的文件中去:
```
root@jack:~# find /home -name .bashrc >list_right 2>list_error
root@jack:~# 
```
注意，此时__屏幕上不会出现任何信息__，所有的信息都被放进了那两个文件中！

 进一步如果我知道错误信息是会发生，倒是要将其忽略掉而不显示或者存储呢？这时就可以使用黑洞装置了/dev/null,这个/dev/null可以吃掉任何导向这个装置的信息:
```
root@jack:~# find /home -name .bashrc 2>/dev/null 
/home/.Trash-0/files/chrome/.bashrc
```
如此，stdout会显示到屏幕上，而stderr被丢弃了！
 
 那要将所有的正确和错误的信息写入到同一个文件中呢？使用__&>filename__就ok
```
root@jack:~# find /home -name .bashrc &>list
```

---
#### standard input : < and <<

 standard input <就是原本需要__由键盘输入的数据，改由文件内容来取代__，而__<<__代表的是__结束的输入字符关键字__

 利用cat来创建一个文件
```
root@jack:~# cat > catfile
one man's dream 
to be or not to be
root@jack:~# cat catfile 
one man's dream 
to be or not to be
```
用stdin代替键盘输入以创建文件
```
root@jack:~# cat > catfile <~/.bashrc
```
使用重定向创建文件，并且输入关键字"eof"代表结束
```
root@jack:~# cat > catfile <<"eof"
> this is a test
> ok now stop
> eof
root@jack:~# 
```

---
#### 命令输出导向的意义
* 屏幕输出的信息很重要，而且我们需要将他存下来的时候；
* 背景运行中的程序，不希望他干扰屏幕正常的输出结果时；
* 一些系统的例行命令 (例如写在 /etc/crontab 中的文件) 的运行结果，希望他可以存下来时；
* 一些运行命令的可能已知错误信息时，想以『 2> /dev/null 』将他丢掉时；
*  错误信息与正确信息需要分别输出时。

---
#### 命令运行的判断依据: ;,&&,||

 使用__;__来分隔命令从而达到一次执行多个命令的目的
```
root@jack:~# sync;sync;shutdown -h now
#先运行两次 sync 同步化写入磁盘后才 shutdown 计算机
```
换个角度，若我想实现两个命令之间的相关性呢？就是前一个命令执行的成功与否决定后一个命令是否执行，这时就要用到&&或||了
 * __$?(命令回传值)与&&或||__
  在linux中__若前一个命令的运行结果为正确，会回传一个$?=0的值__,然后我便可以借助__&&或||__来判断后续命令是否要执行了！

命令下达情况|说明
:---:|:---:
cmd1&&cmd2|1. 若 cmd1 运行完毕且正确运行($?=0)，则开始运行 cmd2。 2.若 cmd1 运行完毕且为错误 ($?≠0)，则 cmd2 不运行。
cmd1or(只能有英文代替了双竖线死活显示不了) cmd2|1.若 cmd1 运行完毕且正确运行($?=0)，则 cmd2 不运行。 2.若 cmd1 运行完毕且为错误 ($?≠0)，则开始运行 cmd2。

   
 实例:
  先判断一个目录是否存在，若不存在则建立该目录,若存在不做任何事情
```
root@jack:~# ls /tmp/abc || mkdir /tmp/abc
ls: 无法访问/tmp/abc: 没有那个文件或目录
root@jack:~# ls /tmp
abc
```
如果我不确定abc目录是否存在，但是我必须想要创建/tmp/abc/hehe文件怎么办?
```
root@jack:~# ls /tmp/abd || mkdir /tmp/abc && touch /tmp/abd/hehe
ls: 无法访问/tmp/abd: 没有那个文件或目录
mkdir: 无法创建目录"/tmp/abc": 文件已存在
```

解释如下:
 * (1)若 /tmp/abc 不存在故回传 $?≠0，则 (2)因为 || 遇到非为 0 的 $? 故开始 mkdir /tmp/abc，由于 mkdir /tmp/abc 会成功进行，所以回传 $?=0 (3)因为 && 遇到 $?=0 故会运行 touch /tmp/abc/hehe，最终 hehe 就被创建了

* (2)若 /tmp/abc 存在故回传 $?=0，则 (2)因为 || 遇到 0 的 $? 不会进行，此时 $?=0 继续向后传，故 (3)因为 && 遇到 $?=0 就开始创建 /tmp/abc/hehe 了！最终 /tmp/abc/hehe 被创建起来。

比如:
以 ls 测试 /tmp/vbirding 是否存在，若存在则显示 "exist" ，若不存在，则显示 "not exist"！ 
```
root@jack:~# ls /tmp/vbirding && echo "exist" || echo "not exist"
ls: 无法访问/tmp/vbirding: 没有那个文件或目录
not exist
```
但如果反过来:
```
root@jack:~# ls /tmp/vbirding || echo "not exist" && echo "exist"
ls: 无法访问/tmp/vbirding: 没有那个文件或目录
not exist
exist
```
not exist与exist同时出现了!why?__原因在于,命令是从左向右顺序执行的，如果前一命令被执行者回传$?=0,若是前一个命令没有被执行，则会将前前一个的$?值继续传递给下一命令，所以&&或者||的顺序是不能颠倒的，这里存在一逻辑判断与回传值的问题__

---
### 0x09 管道命令

管道命令使用的是"|"这个界定符号，另外管线命令与连续下达命令不一样的哈！

管道命令仅可以处理由前面一个命令传来的正确信息，也就是standard output的信息，对于standard error并没有直接处理的能力，例如less，more，head，tail等都是可以接受standard input的管道命令，至于ls，cp，mv等就不是管道命令了，因为ls，cp，mv不会接受来自stdin的数据。

---
#### 截取命令:cut,grep
截取其实就是将一段数据经过分析后，取出我们想要的，或者是经由关键字取得我们所想要的那一行，并且一般情况下，截取信息都是针对__一行一行__来分析的，并不是整篇信息分析的，不过cut在处理多空格相连数据时，会有点吃力。


##### cut
将一段信息的某一段给它__切__出来，处理的是__以行为单位__的信息 

__选项与参数: { usage $: cut -d'分割符号' -f num  }__
* -d:后接分割符，与-f一起使用
* -f:取出第几段的意思
* -c:以字符为单位取出固定区间字符
  
将PATH变量取出，找出第五个路径来:
```
root@jack:~# echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
root@jack:~# echo $PATH | cut -d ':' -f4
/usr/bin
#如同上面的数字显示，我们是以【: 】作为分隔，因 此会出现
/usr/local/bin 
```

##### grep
grep是分析一行信息，若当中有我们所有需要的信息，就将改行拿出来

__选项与参数:{ useage $: grep [-acinv] [--color=quto] '关键字' filename__
 * -a: 将 binary 文件以 text 文件的方式搜寻数据
 * -c:计算找到'关键字'的次数
 * -n:显示行号
 * -i:忽略大小写
 * -v:反向选择，显示出没有'关键字'的那一行
 * --color=auto:将找到的关键字部分加上颜色 

将last(可查询本月里登录者的信息)中，有出现root的那一行就显示出来
```
root@jack:~# last | grep 'root' -n --color=auto
1:root     pts/0        :0               Mon Apr 18 18:47   still logged in   
2:root     :0           :0               Mon Apr 18 18:22   still logged in   
5:root     pts/0        :0               Sun Apr 17 14:24 - 16:29  (02:05)  
```
   
结合cut命令，只显示last行中含有root的第一列
```
root@jack:~# last | grep 'root' -n | cut -d ' ' -f 1
1:root
2:root
 ```

---
#### 排序命令:sort,uniq,wc
##### sort
__选项与参数:{ usage $: sort [-fbMnrtuk] [file or stdin]__
* -f:忽略大小写
* -b:忽略最前面空格部分
* -M:一月份排序
* -n:以数字排序
* -r:反向排序
* -u:重复信息过滤，只显示一次
* -t:分隔符
* -k:以哪个区间来进行排序
  
/etc/password内容是以“：”来分隔的，现在以第三列来进行排序       
```
root@jack:~# cat /etc/passwd | sort -t ':' -k 3 
```

##### wc
wc的作用是显示文件有多少字，多少行，多少字符

__选项与参数:{ usage $: wc [-lwm] }__

* -l:显示有多少行
* -w:显示有多少字(英文单词)
* -m:多少字符

```
root@jack:/etc# cat /etc/hosts | wc
    7      22     184
```

---
#### 双向重导向:tee
tee 可以让 standard output 保存一份到文件内的同时并将同样的数据继续送到屏幕去处理！ 这样除了可以让我们同时分析一份数据并记录下来之外，还可以作为处理一份数据的中间缓存记录之用！
  
__选项与参数:{ usage $: tee [-a] file }__
参数-a，以累加(append)的方式将数据加入到file中
```
root@jack:~# last | tee last.list | cut -d " " -f1
```

---
#### 字符转换命令:tr,col,join,paste,expand
##### tr
tr可以用来删除一段信息当中的文字，或者是进行文字信息的替换

__选项与参数:{ usage $:  tr [-ds] set1 ...}__
* -d:删除信息当中的set1这个字符串
* -s:取代掉重复的字符!

将 last 输出的信息中，所有的小写变成大写字符：
```
root@jack:~# last | tr [a-z] [A-Z]
```
将 last输出的信息中，将冒号 (:) 删除
```
root@jack:~# last | tr -d ':'
```

##### col

__选项与参数:{ usage $:  col [-xb] }__
* -x:将 tab 键转换成对等的空格键
* -b:在文字内有反斜杠 (/) 时，仅保留反斜杠最后接的那个字符

##### join
他是在处理两个文件之间的数据，而且，主要是在处理『两个文件当中，有 "相同数据"的那一行，才将他加在一起』的意思

 ##### past 
paste 就直接『将两行贴在一起，且中间以 [tab] 键隔开』而已！

##### expand
 就是在将 [tab] 按键转成空格键啦


##### 分割命令:split
split可以将一个大文件，依据文件的大小或行数来分割成为小文件

__选线与参数：{　usage $: split [-bl] file PREFIX }__
* -b:接分割成的文件大小，单位为b,k,m
* -l:以行数来进行分割
* PREFIX:代表前导符，可作为分割文件的前导字

我的test.txt文件共有729行，现在我以200行分割为一个文件
 ```
root@jack:/tmp# split -l 200 test.txt test
root@jack:/tmp# ls -al test*
-rw-r--r-- 1 root root  8721 4月  19 14:50 testaa
-rw-r--r-- 1 root root  8663 4月  19 14:50 testab
-rw-r--r-- 1 root root  9821 4月  19 14:50 testac
-rw-r--r-- 1 root root  3958 4月  19 14:50 testad
-rw-r--r-- 1 root root 31163 4月  19 14:43 test.txt
```
将以上４个文件合成为一个文件，命名为newtest
```
root@jack:/tmp# cat test* >> newtest
#使用cat然后数据流重定向，ｏｋ！
```

----
#### 参数代换:xargs
xargs就是在产生某个命令的参数的意思！ xargs 可以读入 stdin 的数据，并且以空格符或断行字符作为分辨(因为是以空格为分隔符，当文件名或者其它名词内有空格时可能产生误判)，将 stdin 的数据分隔成为 arguments 。

__选项与参数:{ usage $: xargs [-0pen] command__

* -0:如果输入的 stdin 含有特殊字符，例如 `, \, 空格键等等字符时，这个 -0 参数 可以将他还原成一般字符
* -e: EOF (end of file) 的意思
* -p:在运行每个命令的 argument 时，都会询问使用者的意思
* -n:后面接次数，每次 command 命令运行时，要使用几个参数的意思

将 /etc/passwd 内的第一栏取出，仅取三行，使用 finger 这个命令将每个 账号内容秀出来
```
root@jack:~# cut -d':' -f1 /etc/passwd | head -n 3|xargs finger 
Login: root           			Name: root
Directory: /root                    	Shell: /bin/bash
On since Tue Apr 19 14:30 (CST) on :0 from :0 (messages off)
On since Tue Apr 19 14:40 (CST) on pts/0 from :0
   7 seconds idle
No mail.
No Plan.
```
同上，将所有的 /etc/passwd 内的账号都以 finger 查阅，但一次仅查阅五个账号，并且每次查询请求确认
```
root@jack:~# cut -d":" -f1 /etc/passwd | xargs -p -n 5 finger
finger root daemon bin sys sync ?...y
```
其实使用xargs的一个重要原因是:很多命令并不支持管道命令，但我们去可以通过xargs来提供该命令引用standard input之用.

找出/sbin目录下具有特殊权限的文件名，并使用ls -l列出详细属性
```
root@jack:~# find /bin -perm +7000 | xargs ls -l
-rwsr-xr-x 1 root root  30800 1月  22 01:38 /bin/fusermoun
```


