---
title: (0)LinuxC-编程
date: 2016-05-21 11:52
tags: ['算法入门']
toc: true
categories: technology

---
### 0x00 GCC简介

GCC(GNU Compiler Collection)是目前Linux下最常用的C语言编译器，它是Linux平台编译器的事实标准。同时也能编译C，C++，Object C等语言编写的程序。它支持宿主开发也支持交叉编译。使用GCC编译程序时，编译的过程可以细分为四个阶段:

* 预处理(Pre-Processing)
* 编译(Compiling)
* 汇编(Assembling)
* 链接(Linking)

各个阶段所对应的目标文件扩展名分别为”.i“，".s"，".o"以及最终的可执行文件，它们的含义如下:

.c：最初的C源代码文件
.i：经过编译预处理的源代码
.s：汇编处理后的汇编代码
.o：编译后的目标文件，含有最终编译后的机器码，但是里面所引用的其它文件中函数的内存位置尚不知道。

下面以hello.c文件了解具体的编译过程：

```
#include<stdio.h>
int main(){
    printf("hello world!");
    return 0; 
}
```

* 1.预编译阶段
该阶段主要是讲.c文件中的头文件stdio.h的内容读进来，直接插入到程序文本中去，就得到了经过编译预处理的hello.i。

GCC命令:

```
$ :gcc -E hello.c -o hello.i
```

* 2.编译阶段

编译阶段的主要作用是检查语法错误，然后把代码翻译成汇编语言，生成汇编处理后的汇编代码hello.s。

GCC命令：

```
$: gcc -S hello.i -o hello.s
```

* 3.汇编阶段

将编译阶段生成的hello.s文件编译为目标文件hello.o文件

GCC命令:

```
$: gcc -c hello.s -o hello.o
```

* 4.链接阶段

将目标文件与所需的所有的附加的目标文件连接起来，生成最终的可执行文件。

GCC命令：
```
$: gcc hello.o -o hello
```

如果不想生成中间各类型的文件，也可以有源文件直接编译链接成为可执行文件:
```
$: gcc hello.c -o hello
```


