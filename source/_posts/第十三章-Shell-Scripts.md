---
title: 第十三章-Shell Scripts
date: 2016-04-21 15:12:52
tags: ['鸟哥的Linux读书笔记基础篇']
toc: true
categories: technology

---

### 0x01 What is Shell Script?

从字面意思可以理解为，shell script就是针对shell所写的剧本，哈哈，官方一点，shell script 是利用 shell 的功能所写的一个『程序 	(program)』，这个程序是使用纯文字档，将一些 shell 的语法与命令(含外部命令)写在里面，	搭配正规表示法、管线命令与数据流重导向等功能，以达到我们所想要的处理目的。简单点，shell script就像是早期DOS年代的批处理文件(.bat)。

---
#### Why shell script?

对于Linux的系统管理而言，shell script实在是一个很不错的工具，它可以汇整一些在command
 line下达的命令，将它写入sctipt文件中，来启动一连串的command  line命令输入，就是这么简单。但是shell script也有自身的不足，比如其在大数据的运算处理上，就不够好了，速度比较慢，这时候就是python的天下了！


---
#### 第一个shell script

基本了解了shell script后我们来看看编写它的一些

__注意事项:__
* 命令下达后:命令，选项与参数间的多个空白都会被忽略掉
* 空白行也将被忽略，并且[tab]键所占有的空白同样被视为空白键
* 读取到一个Enter符号(CR),就尝试运行该(串)命令。
* 如果一行的内容太多，可以使用{ \[Enter] }来延生至下一行
* \#作为注解符号

---
#### 关于shell script(.sh)文件的的运行
* 直接命令下达:shell.sh文件必须具备可读与可运行的权限(rx):
  * 绝度路径:比如/home/sys/shell.sh来下达运行命令
 * 相对路径:假设工作目录在/home/sys/下，则使用./shell.sh来运行
 * 变量[PATH]的功能:将shell.sh放在PATH指定的目录内，例如:～/bin

* 以bash程序来运行:通过bash shell.sh或者sh shell.sh来运行
   

---
### 0x01 hello world!
下面开始编写我们的第一个script:
```
#!/bin/bash
#program
#	this program shows "hello world,this is my first script!" in your scree
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin 
export PATH
echo "hello world!\a\n"
exit 0
```

对上面程序做出一些解释:
  * 第一行__#!/bin/bash__声明这个script所使用的shell
   __#!/bin/bash__来声明这个文件内的语法使用bash的语法，当程序被运行时，他会自动加载bash相关的环境配置，并且运行bash来使得文件内的命令能够运行，这很重要！
 
 *  程序内容的说明
  在书写内容以前，建议一定要养成这样一些说明习惯:1)内容与功能；2)版本咨询；3)作者与联络方式;4)建档日期;5)历史记录；等等，这有助于未来程序的改写与dubug！

* 主要的环境变量
 建议将一些重要的环境变量配置好，比如PATH和LANG,如此以来，则可以让我们在运行这个程序时，可以直接下达一些外部命令，而不必写决定路径！

* 退出程序
  我们可以利用exit这个命令来让程序中断，并且回传一个数值系统！

---
### 0x02  简单的shell script练习

编写scritp在工具最好是vim而不是vi，因为vim会有额外的语法检验！



---
#### 对谈是脚本:变量由使用者决定

比如，让使用者输入自己的名字，然后显示到屏幕上:
```
!/bin/bash
#program:
# user inputs his first name and last name then shows his full name
#History:
#2016/04/22
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

read -p "please input you first name:" firstname
read -p "please input you last name:" lastname
echo -e "\nYour full name is:$firstname $lastname"
```
如果想要制作一个每次运行都会依据不同的日期而变化结果的脚本呢？

  ---
#### 随日期变化:利用date进行文件创建

实例使用者只需要输入文件名，然后自动添加创建时间
```
#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH
#输入要创建的文件名
echo -e "i will use 'touch' command to creat 3 files."
read -p "please input your filename:" fileuser

filename=${fileuser:-"fileuser"}

#利用date命令创建文件
date1=$(date --date='2 days ago'+%Y%m%d) #前两天的日期
date2=$(date --date='1 days ago'+%Y%m%d) #前一天的日期
date3=$(date +%Y%m%d)                    #今天的日期
#配置文件名
file1=${filename}${date1}
file2=${filename}${date2}
file3=${filename}${date3}
#建立文件
touch "$file1"
touch "$file2"
touch "$file3
```

---
#### 运算
 我们除了declare来定义变量类型进行运算之外，还可以使用__{ $((计算式)) }__来进行数值运算，但是bash shell里面默认只能进行整数的计算。
```
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH
read -p "first number:" firstnu
read -p "sencond number:" secnu
total=$(($firstnu*$secnu))
echo -e "\nthe result of $firstnu*$secnu if ==>$total"
运行:
root@jack:~# sh sh04.sh 
first number:6
sencond number:9
the result of 6*9 if ==>54
```



---
### 0x03 script的运行方式差异

不同的script运行方式会造成不一样的结果:

#### 直接运行
 除了source之外的都是直接运行，当我们直接运行，其实是调用了一个子程序运行的script，当子程序完成后，在子程序内的各项变量或动作将会结束而不会传回到父程序中。

#### source:在父程序中运行
 当使用source运行脚本式脚本内陪的变量都会在原本的bash中生效，这和不注销系统而让某些写进~/.bashrc的配置生效时，使用__{ source ~/.bashrc }而不使用__{ bash ~/.bashrc }__一样的！


---
### 0x04 判断

我们提到过 $? 这个变量所代表的意义，	此外，也透过 && 及 || 来作为前一个命令运行回传值对於后一个命令是否要进行的依据

---
#### 利用test命令测试

比如判断一个文件是否存在
```
root@jack:~# test -e /fuckshit
#什么都不返回
```
配合&&与||来使用
```
root@jack:~# test -e /fuckshit && echo "exit" || echo "not exit"
not exit
```

---
#### test常用的判断标志:

##### 文件类型

测试标志|意义
:---:|:---
-e|该『档名』是否存在？(常用)
-f|该『档名』是否存在且为文件(file)？(常用)
-d|该『档名』是否存在且为目录(directory)？(常用)


##### 文件权限

测试标志|意义
:---:|:---
-r|侦测该档名是否存在且具有『可读』的权限？
-w|侦测该档名是否存在且具有『可写』的权限？
-x|侦测该档名是否存在且具有『可运行』的权限？
-u|侦测该档名是否存在且具有『SUID』的权限？
-g|侦测该档名是否存在且具有『SGID』的权限？
-s|侦测该档名是否存在且为『非空白文件』？


##### 两个文件之间的比较
如test file1 -nt file2

测试标志|意义
:---:|:---
-nt|(newer than)判断file1是否比file2新
-ot|(older than)判断file1是否比file2旧
-ef|判断 file1 与 file2 是否为同一文件，可用在判断 hard link 的判定上。 主要意义在判定，两个文件是否均指向同一个 inode 哩！

---
#### 利用判断符号[ ]

判读HOME是否为空
```
root@jack:~# [ -z "$HOME" ];echo $?
1
root@jack:~# echo $HOME
/root
```
__在 bash的语法当中使用中括号作为 shell 的判断式时，必须要注意中括号的两端需要有空格字节来分隔__
```
　[ "$HOME" == "$MAIL" ]
(我是空格)[(我是空格)"$HOME"(我是空格)==(我是空格)“$MAIL”(我是空格)]
```


---
#### shell script的默认变量($0,$1....)

其实系统已近为每个script默认配置好了一些，使得我们可以在运行script的同时直接添加参数以更好的使用脚本程序。

比如可以直接重新启动运行一个脚本
```
root@jack:~# /etc/init.d/syslog restart
```
script配置的默认变量格式如下:
```
/path/to/sciptname opt1 opt2 opt3 opt4
   $0   $1    $2   $3   $4
$0:这个脚本的文件名
$1:来自使用者的参数，善用 $1 的话，就可以很简单的立即下达某些命令功能
```
此外还有一些较为特殊的变量$#,$@我们通过下面的程序来了解
```
echo "the script name is ==> $0"
echo "total parameter number is ==>$#"
　[ "$#" -lt2 ]&& echo "the number of parameter is less than 2.Stop here."\
&& exit 0
echo "your whole parameter is ==>'$@'"
echo "the 1st parameter ==>$1"
echo "the 2nd parameter ==>$2"
```
运行结果如下：
```
root@jack:~/scripts# sh sh07.sh chen jack jhno
the script name is ==> sh07.sh #文件名
total parameter number is ==>3 #总的参数
your whole parameter is ==>'chen jack jhno' #参数的全部内容
the 1st parameter ==>chen #第一个参数
the 2nd parameter ==>jack #第二个参数
```

---
### 0x05 条件判断

---
#### if...then

##### 简单条件判断

 ```
if　[ 条件 ];then
执行语句
fi <==fi就代表if语句的结束
```

##### 多重条件判断
```
 if　[ 条件 ];then
    条件成立执行语句
else
    条件不成立执行语句
fi
```

##### 复杂条件判断

 ```
if　[ 条件一 ];then
条件一成立执行语句
elif　[ 条件二 ];then
条件二成立执行语句
else
条件一与二均不成立执行语句
fi
```
实例:检查主机的80端口是否开放
```
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH
echo "now,i will detect your linux server'services!"
echo -e "the www,ftp,ssh,and mail will be detect!\n"
testing=$(netstat -tuln | grep ":80")
if　[ "$testing" != "" ];then
	echo "www is running in youre system.";
fi
```


---
### 0x06 case....esac...(类似与c中which)

__语法如下__
```
case $变量 in
"第一个变量")
  程序
  ;;
"第二个变量")
  程序
  ;;
*)
  不满足一和二时执行
   程序
  ;;
esac
``` 

实例:
```
#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

echo "this program will print you selection!"

read -p "input your choice:" choice
case $choice in
#case $1 in #代替前两行，这样可以执行脚本时直接添加参数
"one")
  echo "your choice is ONE"
  ;;
"two")
  echo "your choice is TWO"
  ;;
"three")
  echo "your choice is THREE"
  ;;
*)
  echo "usage $0{one|two|three}"
  ;;
esac
```

---
### 0x08 函数

__语法:__
```
function 函数名(){
  程序
}
```

---
### 0x09 循环

---
#### while do done,until do done

##### while循环
当条件成立时，就执行循环体直到，while条件不成立，退出循环！
```
while [ 条件 ]
do      #循环开始
  程序段
done    #循环结束
```

##### until循环
与while相反，当条件成立时就终止循环，否则就进入循环！
```
until [ 条件 ]
do 
  程序段
done
```

实例:
```
#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH
while [ "$yn" != "yes" ]
do
        read -p "please input yes  to stop this program:" yn
done
echo "ok ,you input the correct answer."
```


---
#### for ...do...done

__语法:__
```
for var in con1 con2 con3
do
程序段
done
```

实例:
```
for  animal in dog pig cat
do
    echo "${animal}"
done
运行结果:
dog
pig
cat
```
for循环对数值运算的处理
```
#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH
read -p "input a number,i will count for total your input:" nu

s=0
for((i=1;i<=$nu;i=i+1))
do
        s=$(($s+$i))
done
echo "the result of '1+2+3+4+...+$nu is ==> $s"
```

---
### 0xA Shell Script的追踪与debug

```
root@jack:~#  sh [-nvx] script.sh
选项与参数:
-n:不要运行 script，仅查询语法的问题；
-v:再运行 sccript 前，先将 scripts 的内容输出到萤幕上；
-x:将使用到的 script 内容显示到萤幕上，这是很有用的参数！
```


