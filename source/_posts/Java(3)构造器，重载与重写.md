---
title: Java(3)构造器，重载与重写
date: 2016-07-19
tags: ['Java基础']
toc: true
categories: technology

---

### 0x00 构造器与方法重载
#### 构造器
java中的对象在创建对象时我们可以对其进行显示会初始化(initialization)。如果我们没给数成员赋予初始值，数据成员会根据其类型采用默认的初始值。

比如:
整数型:0
布尔型:False
其它类型:null

显然显示初始化很不方便，这时我们便可以使用构造器(constructor)来初始化对象了，类似于C中的构造函数一样。

构造器的特征如下:
* 构造器的名字和类的名字相同
* 构造器没有返回值

定义Human类的构造器:

```
public class Test
{
  public static void main(String [] args)
  {
     Human aPerson = new Human(160);
     System.out.println(aPerson.getHeight());
  }
}

class Human
{
  /**
   *constructor
   */
   Human(int h)
   {
     this.height=h;
     System.out.println("i'm born")；
   }
  /**
   *accessor
   */
   int getHeight()
   {
     return this.height;
   }
   int height;
}
```

一旦我们定义了自己的构造方式，Java便不会再提供默认的构造方法，此时需要自己写上默认的构造方法。


#### 方法重载
一个类可以定义多个构造函数，每个构造器间的参数不同，Java会同时根据方法名和参数列表来决定所要调用的方法，这叫__方法重载(method overloading)__。构造方法可以进行重载，普通方法也可以重载。


---
### 0x1 重写


