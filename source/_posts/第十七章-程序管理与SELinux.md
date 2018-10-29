---
title: 第十七章-程序管理与SELLinux
date: 2016-04-27 18:22:52
tags: ['鸟哥的Linux读书笔记基础篇']
toc: true
categories: technology

---
### 0x00 什么是程序管理

---
#### 进程与程序(process && program)

当我们运行一个命令或者程序的时候，系统就会产生一个进程，并分配给这个进程一个id，即PID，每个进程对应一个PID，每个PID也只对应一个进程！

__Linux的fork机制__
在linux里面基本上每一个子程序的产生都是由父程序以复制(fork)的方式，而这个程序与父程序唯一的差别就是PPID不同。

__服务__
服务(daemon)，其实就是常驻在内存当中的程序，通常负责一些系统所提供的功能以服务使用者各项任务。

---
### 0x01 工作管理(job control)
job control的意思是:当我们登陆系统取得 bash shell之后，在单一终端机介面下同时进行多个工作的行为管理,比如一边复制文件一边打包，一边进行vi编辑。

---
#### 工作管理?

我们把可以出现提示字节让你操作的环境就称为前景(foreground)，至于其他工作就可以让你放入背景 (background) 去暂停或运行。

##### job control:&,[ctrl-z],jobs,fg,bg,kill

* __直接将命令丢到背景中运行:&__

 假如我们将整个/etc备份成为/tmp/etc.tar.gz，且不想等待，则可以这样做：
```
root@jack:~# tar -zpcvf /tmp/etc.tar.gz /etc > /tmp/log.txt 2>&1 &
[1] 2130
```
输入一条命令后，在命令后加上&就代表将该命令丢到背景中，此时bash给予该命令一个工作号码，其实就是该命令的pid了。然后我们使用数据流重定向，将该命令可能产生的错误输出到/tmp/log.txt文件中，当命令完成时会在终端中出现如下信息:
```
[1]+  已完成  tar -zpcvf /tmp/etc.tar.gz /etc > /tmp/log.txt 2>&1
```

* __ctrl-z__
 
 有时我们会正在使用vi对一个文件进行编辑，但是突然要查找某个文件，这时你会按下__ctrl-z__退出vi(其实按下__ctrl-z__并没有真正的退出vi编辑，系统只是将这个任务__暂停__了)
 ```
root@jack:~# vim /tmp/log.txt 
(ctrl-z)
[1]+  已停止               vim /tmp/log.txt
root@jack:~# find / -print 
...
(ctrl-z)
```

* __观察目前背景中作状态:jobs__

 __{ Usage $: jobs -[lrs] }__

 __选项与参数:__
 * -l:除了列出 job number 与命令串之外，同时列出 PID 的号码；
 * -r:仅列出正在背景 run 的工作
 * -s:仅列出正在背景当中暂停 (stop) 的工作
```
root@jack:~# jobs -l
[1]-  2156 停止                  vim /tmp/log.txt
[2]+  2168 停止                  find / -print
```
\+ 代表最近被放到背景的工作号码， - 代表最近最后第二个被放置到背景中的工作号码

* __fg从背景中取出工作__

 fg(foreground)的意思就是将背景中的过工作拿到前景中来了

 __{ Usage $: fg %jobnumber }是工作号码，不是PID哈__
```
root@jack:~# jobs -l
[1]-  2156 停止                  vim /tmp/log.txt
[2]+  2168 停止                  find / -print
root@jack:~# fg %1
vim /tmp/log.txt
```

* __让工作在背景下运行bg__
```
root@jack:~# jobs;bg 2;jobs
[1]-  已停止               vim /tmp/log.txt
[2]+  已停止               find / - print > /tmp/find.txt
[2]+ find / - print > /tmp/find.txt &
[1]+  已停止               vim /tmp/log.txt
[2]-  运行中               find / - print > /tmp/find.txt &
```

* __kill进程终结者__

 __{ Usage $: kill [-1 9 15] }__

 __选项与参数:__
 * -1:重新读取一次参数的配置档 (类似 reload)
 * -9:立刻强制删除一个工作
 * -15:以正常的程序方式终止一项工作。与 -9 是不一样的

 ```
root@jack:~# jobs -l
[1]+  2270 停止                  vim /tmp/log.txt
root@jack:~# kill -9 2270
root@jack:~# jobs
[1]+  已杀死               vim /tmp/log.txt
 ```
此外，需要注意的是 kill 后面接的数字默认会是 PID ，如果想要管理 bash 的工作控制，就得要加上 %数字 
```
root@jack:~# jobs
[1]+  已停止               vim /tmp/log.txt
root@jack:~# kill -9 %1
```

* __离线管理:nohup__

 想要让在背景的工作在你注销后还能够继续的运行，那么使用 nohup 搭配 & 是不错的运行情境:
 ```
 root@jack:~# nohup ./sleepsh02.sh &
 ```

---
### 0x02 程序管理

下面我们将了解如何观察程序与程序的状态，然后再加以程序控制！

---
#### 观察程序:ps,top,pstree

##### ps静态观察
 
 __选项与参数__
  * ps aux:观察系统所有的程序数据
  * ps -l:仅观察自己的相关程序
  * ps axjf:连同部分程序树

  仅观察自己的相关程序:ps -l
 ```
root@jack:~# ps -l
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
0 S     0  2253  2247  0  80   0 -  6308 -      pts/1    00:00:00 bash
0 R     0  2482  2253  0  80   0 -  2708 -      pts/1    00:00:00 ps
#-----#
F:代表程序旗标，常见的０表示此程序的权限为root
S:代表程序状态(stat),D(runing),S(sleep),D(不可唤醒的睡眠状态),Ｔ(stoop),Z(Zombie)僵尸态
UID/PID/PPID:
C:CPU使用率
PRI/NI:Priority/Nice缩写，此程序被cpu所运行的优先顺序，数字越小越优先
ADDR/SZ/WCHAN:与内存有关
TTY:登录者的终端机，远程为(pst/n)
TIME:占用cpu的时间
CMD:command的缩写
```
 ps -l 则仅列出与你的操作环境 (bash) 有关的程序而已， 亦即最上一级的父程序会是你自己的 bash 而没有延伸到 init 这支程序,他的内容如下:

 _bash 的程序属於 UID 为 0 的使用者，状态为睡眠 (sleep)， 之所以为睡眠因为他触发了 ps (状态为 run) 之故。此程序的 PID 为 2253，优先运行顺序为 80 ， 下达 bash 所取得的终端介面为 pts/1 ，运行状态为等待 (wait) _


##### ps aux观察系统所有程序
```
root@jack:~# ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0 176724  5028 ?        Ss   08:37   0:01 /lib/systemd/s
#-----#
%CPU:该程序使用的cpu百分比
%MEN:该程序使用的实体内存百分比
STAT:程序状态(R/S/D/T/Z)
START:该程序启动时间
TIME:已实际使用cpu运行的时间
COMMAND:该程序实际命令
```
找出与 cron 与 syslog 这两个服务有关的 PID 号码
```
root@jack:~# ps aux | egrep '(cron|syslog)'
root       671  0.0  0.0  27644  2780 ?        Ss   08:37   0:00 /usr/sbin/cron -f
root       723  0.0  0.0 258672  3420 ?        Ssl  08:37   0:00 /usr/sbin/rsyslogd -n
Debian-+   852  0.0  0.1 361492  9408 ?        S<l  08:37   0:00 /usr/bin/pulseaudio --start --log-target=syslog
root      2514  0.0  0.0  12892  1556 pts/1    S+   11:03   0:00 grep -E (cron|syslog)
```

* __zombie__
发现在某个程序的 CMD 后面还接上 <defunct> 时，就代表该程序是僵尸程序啦,这时我们就需要一步一步跟踪它直到找出它的父程序然后杀掉它！


##### top
不同于ps，top可以将目前系统程序运行状态动态的显示出来:
```
　root@jack:~# top
　top - 11:13:32 up  2:36,  2 users,  load average: 0.15, 0.18, 0.17
Tasks: 175 total,   2 running, 172 sleeping,   1 stopped,   0 zombie
%Cpu(s):  3.0 us,  0.7 sy,  0.0 ni, 96.3 id,  0.1 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem:   5792464 total,  2549740 used,  3242724 free,   231280 buffers
KiB Swap:  7908348 total,        0 used,  7908348 free.   833968 cached Mem
PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                               
 1168 root      20   0 2011860 231160  59236 S   5.4  4.0   3:35.12 gnome-shell    
```
top默认使用能cpu占用率进行排序！


##### pstree
 要找到进程之间的相关性，pstress是必不可少的命令，它会使用线段将相关性进程连接起来。
```
root@jack:~# pstree -up
#列出每个进程的PID以及所属的账号名称
```

---
#### 进程管理:signal,kill,killall

进程之间是可以相互控制的，但是又是如何相互控制的呢？其实就是信号了，我们通过给某个进程传递一个讯号从而告知该进程想要它做什么，因此这个信号就很重要了！

下面是主要的一些信号内容:

数字|名称|内容
:---:|:---:|:---
1|SIGHUP|启动被终止的进程，可让该 PID 重新读取自己的配置档，类似重新启动
2|SIGINT|相当于用键盘输入 [ctrl]-c 来中断一个进程的进行
9|SIGKILL|代表强制中断一个进程的进行，如果该进程进行到一半， 那么尚未完成的部分可能会有『半产品』产生，类似 vim会有 .filename.swp 保留下来。
15|SIGTERM|以正常的结束进程来终止该进程，不是使用于当该进程已近发生错误
17|SIGSTOP|	相当於用键盘输入 [ctrl]-z 来暂停一个进程的进行


那么如何将信号传递给进程呢？就是kill，killall命令了

* __kill -singal PID 管理单个进程__
```
root@jack:~# kill -9 %1
```

* __killall -singal 进程名称 管理整个服务__
强制杀掉所有以httpd启动的服务
```
root@jack:~# killall -9 httpd
```
需要强调的是， kill 后面直接加数字（代表进程PID）与加上 %number(jobs查询到的工作号码) 的情况是不同的！


> ###### 关于进程的运行顺序

Liunx中进程运行的优先顺序与PRI(priority)值有关，PRI的值越低代表越优先的意思，但是这个PRI的值是由系统核心动态调整的，使用者无法直接调整PRI的值，如果想要改变进程的优先顺序，就得通过Nice值，它们的关系是: __PRI(new)=PRI(old)+nice

对root而言nice的可调整范围为:-20-19,一般使用者为0-19,然后我们有两种方式给予某给进程nice值

* __nice:在进程开始运行时给予nice值__

 __{ Usage $: nice [-n 数字] command }__
```
root@jack:~# nice -n -5 vi &
```

* __renice:调整已经运行进程的nice值__

 __{ Usage $: renice [number] PID }__

 ```
root@jack:~# ps -l
F S   UID   PID  PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
4 T     0  2384  1606  0  75  -5 - 43557 -      pts/0    00:00:00 vi
0 R     0  2390  1606  0  80   0 -  2708 -      pts/0    00:00:00 ps
root@jack:~# renice 6 2384
2384 (process ID) old priority -5, new priority 6
```
> ###### 系统资源观察

* __free__观察内存使用情况
```
root@jack:~# free 
             total       used       free     shared    buffers     cached
Mem:       5792464    1537280    4255184     148380      50304     576536
-/+ buffers/cache:     910440    4882024
Swap:      7908348          0    7908348
```
* __uname__查看系统核心信息
```
root@jack:~# uname -a
Linux jack 4.0.0-kali1-amd64 #1 SMP Debian 4.0.4-1+kali2 (2015-06-03) x86_64 GNU/Linux
```

* __uptime__系统启动时间与工作负载
```
root@jack:~# uptime
 13:35:42 up 10 min,  2 users,  load average: 0.29, 0.26, 0.21
```
* __netstat__追踪网络和系统插槽

 找出目前系统上已经在监听的网络及其PID

 ```
root@jack:~# netstat -tlnp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
```

* __dmesg__:分析核心信息
例如，查看启动时硬盘的信息
```
root@jack:~# dmesg | grep -i hd
[    0.082322] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    7.737685] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
```
或者查看系统网卡相关信息
```
root@jack:~# dmesg | grep -i eth
[    0.881331] e1000e 0000:00:19.0 eth0: registered PHC clock
[    0.881352] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 
```
* __vmstat__检测系统资源变化
```
root@jack:~# vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0      0 4290044  51168 581576    0    0    96    11   79  420  3  1 93  2  0
```

> #### 0x03 特殊文件与程序

----
> ###### 具有SUID/SGID权限的命令运行状态

如何查找具有SUID/SGID权限的文件和目录？
```
root@jack:/tmp# find / -perm +6000
```

> ###### /proc/* 的意义

程序都是存放在内存中的，而内存中的数据又都写到来/proc这个目录中，基本上，目前主机上面的各个程序的 PID 都是以目录的型态存在於 /proc 当中。
> ###### 运行文查询:fuser,lsof,pidof

* __fuser借文件找出正在使用该文件的程序__

 找出所有使用到/proc这个文件系统的程序
```
root@jack:~# fuser -mvu /proc
                     用户     进程号 权限   命令
/proc:               root     kernel mount (root)/proc
                     root          1 f.... (root)systemd
                     root        241 f.... (root)systemd-journal
```
找出使用到单个文件系统的程序
```
root@jack:~# fuser -uv /run/systemd//sessions/1.ref 
                     用户     进程号 权限   命令
/run/systemd/sessions/1.ref:
                     root        677 f.... (root)systemd-logind
                     root        906 F.... (root)gdm-session-wor
```
杀死该进程
```
root@jack:~# fuser -ki /run/systemd//sessions/1.ref 
/run/systemd/sessions/1.ref:   677   906
杀死进程 677 ? (y/N) n
杀死进程 906 ? (y/N) n
```

* __lsof找出进程所开启的文件__

 找出该目录下正在被使用的文件
```
root@jack:~# lsof +d /dev
```
找出属于root的bash正在使用的文件
```
root@jack:~# lsof -u root | grep bash
bash      1606 root  cwd       DIR               8,13     4096     524289 /root
```
  


* __pidof找出某个正在运行进程的PID__
 找出init进程的pid
```
root@jack:~# pidof init
1
```


> #### 0x04 SELinux

----


