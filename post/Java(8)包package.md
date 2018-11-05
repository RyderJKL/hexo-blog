---
title: Java(8)包package
date: 2016-07-19
tags: ['Java基础']
toc: true
categories: technology

---
### 0x00 package
为了更好的组织代码，java引入包的概念。

包为Java程序提供了一个命名空间(name space)。一个Java类的完整路径由它的包和类名共同构成，比如com.vamei.society.Human。相应的Human.java程序要放在com/vamei/society/下。类是由完整的路径识别的，所以不同的包中可以有同名的类，Java不会混淆。 

包的建立非常简单。

```
package com.jack.society;

public class Human
{
  public Human()
   {
     this.height = 180;
    } 
}
```

__package com.jack.society__表示该程序在com.jack.society包中。com.jack表示包作者的域名。society表示包的本地路径。

包管理的是.class文件。Java号称"一次编译，处处运行" (Compile Once, run anywhere)。.class文件可以在任意装有Java虚拟机(JVM, Java Virtual Machine)的平台上运行，这帮助我们克服了系统差异造成的程序移植困难。

在JVM的基础设施下，加上包的管理辅助，Java程序实现了良好的可移植性 (portability)。


