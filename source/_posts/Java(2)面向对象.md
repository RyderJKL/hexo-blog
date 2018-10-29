---
title: Java(2)面向对象
date: 2016-07-19
tags: ['Java基础']
toc: true
categories: technology

---
### 0x00 面向对象
__对象__是计算机抽象世界的一种方式。
世界上的每一个事物都可以称为一个__对象(object)__，对象有__状态(State)__和,\__行为(Behavior)__。

对象的状态由__数据成员(data member)__表示。数据成员又被称为__域(Field)__。

对象还有操作，用于改变对象的状态，操作就睡对象的__行为__，行为由成员__方法(member method)__表示。

对象可以归为__类(Class)__，或者归为__同一类型(Type)__。同类的对象有相同的方法，相同类型的数据成员。类的__实例(instance)__是对象。

类具有__属性__,它是对象状态的抽象。
类具有__操作__,它是对象的行为的抽象。

类实现了对像的数据(既状态)和行为的抽象。

概括的讲就是，对象中的数据成员表示对象的状态，对象可以执行方法以修改对象的状态表达动作。




#### 调用同一对象的数据成员:

```
public class Test
{
  public static void main(String [] args)
  {
    Huam aPerson = new Human();
    System.out.println(aPerson.getHeight());
  }
}

class Human
{
 /** 
  *
  */
  int getHeight()
  {
     return this.height;
  }

  int height;
}
```

this是隐性参数，它用来指代对象自身。当创建一个aPerson实例时，this就代表了aPerson这个对象。this.aPerson指aPerson的height。


#### 调用同一对象的其它方法

```
public class Test
{
  public static void main(String [] args)
    {
      Human aPerson = new Human;
      aPerson.repeatBreath(10);
    }
}

class Human
{
  void breath()
  {
    System.out.println("huhu");
  }

  /**
   *call breath()
   */
  void repeatBreath(int rep)
  {
    int i;
    for(i=0;i<rep;i++)
    {
      this.breath();
    }
  }
}
```

#### 数据成员的初始化
__显示初始化(explixcit initialization):__当在声明数据成员的同时，提供数据成员的初始值。显示初始化的值要硬性的写在程序中。


