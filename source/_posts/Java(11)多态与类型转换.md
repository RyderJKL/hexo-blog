---
title: Java(11)多态与类型转换
date: 2016-07-19 
tags: ['Java基础']
toc: true
categories: technology

---
### 0x01 类型转换
Java属于强类型语言（Strongly typing），它的任意变量和引用均需要经过类型声明(type declaration)才能 使用。

----
#### 基本类型转换
不同的基本类型有不同的长度和存储范围。

当从高精度类型转换到低精度类型，如float到int，有可能损失信息，这样的转换叫做收缩变换(narrowing conversion)。这种情况下，需要显示的声明类型转换。

```
public class Test
{   
   public static void main(String [ ] args)
     {
        int a;
        a=int(1.23);//narrowing conversion
     }
}
```

如果是从低精度类型向高精度类型的转换，则不会有信息的损失。这样的变换叫做宽松变换(widening conversion)，此时，并不需要显示的要求类型转换，Java会自动进行。

---
### 0x01 upcast与多态


     
### 0x00 多态(polymorphism)


