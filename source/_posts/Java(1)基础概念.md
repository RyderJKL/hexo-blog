---
title: Java(1)基础概念
date: 2016-07-19 
tags: ['Java基础']
toc: true
categories: technology

---
### 0x00 HelloWorld
首先我们来创建第一个java程序

```
public class HelloWord
{
    public static void main(String [] args)
    {
       system.out.println("HelloWold!");
    }
}
```

首先Java__第一个类的名称必须与java程序的名称对应__，同时，java是强类型的语言，既它是大小写敏感的。最后语句的结束要使用__;__来结束。

同样java程序要经过编译器的编译才能运行，而java的夸平台性是因为java的程序的执行依赖于java虚拟机。

命令行下使用__javac__来编译java程序

```
$: javac HelloWorld.java
```

当前路径下将生成一个名为HelloWorld.class的文件。

让后使用__java__运行程序

```
$: java HelloWorld
```

---
### 0x01 java中的变量
java和c都是静态类型的语言，在使用变量之前，要声明变量的类型。

同时java中的数据类型分类可分为基本数据类型和引用数据类型。

java中变量类型如下

数据类型|存储大小|
:---:|:---:|:---
byte 字节|8 bits
int 整数|4 byte
short 短整型|2 byte
long 长整型|8 byte
float 浮点型|4 byte
doubel 双精度型|8 byte
char 字符|2 byte
boolean|1 bit

对于Java中的基本数据类型，一旦声明就会被分配内存空间，而普通类型需要使用__new关键字__来分配空间。
#### 关于变量的命名
推荐采用驼峰命名法。原则，见名知意。
类：首字母大写,以后每个单词首字母大写
包：包名全部小写
方法：以小写字母开头，以后每个单词首字母大写
变量：以小写字母开头，以后每个单词首字母大写
常量：全部使用大写，并以"_"隔开。


switch语句中的表达式只能识别byte，int，short，char四种类型的数据类型。

---
### 0x02 java数组
数组包含相同类型的多个数据。

java使用如下方式声明一个数组

```
int[] a;
```

但是数组真正所需的空间并没有真正分配给数组，所以可以在声明的同时使用__new__来开辟数组所需的空间

```
int [] a= new int[100]
```

在声明的同时给数组赋值并确定数组的大小

```
int[] a = new int[]{1, 4, 5, 5};
```


