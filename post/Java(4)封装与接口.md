---
title: Java(4)封装与接口
date: 2016-07-19
tags: ['Java基础']
toc: true
categories: technology

---
### 0x00 封装(encapsulation)与接口(interface)

封装，继承和多态是面向对象的三大特征。

封装可以隐藏属性以及行为实现的细节，并对外提供访问的接口，以此提高对象的易用性和安全性。

---
#### 对象成员的封装

Java通过三个关键字来控制对象成员个的外部可见性(visibility):public,private,protected.

* public:该成员外部可见，既该成员是接口的一部分。
* private:该成员外部不可见，无法从外部访问。
* protected:涉及继承的概念。

但是内部方法并不受封装的影响，可以调用任意的成员，即使是被设置为private的成员。

在Java的通常规范中，表达状态的数据成员要设置为private，对数据成员的修改要通过接口提供的方法进行。

在一个.java文件中，有且只能有一个类带有public关键字。

```
public class Test{
  public static void main (String [] args){
    Human aPerson = new Human(160);
    System.out.println(aPerson.getHeight());
    aPerson.growHeight(170);
    System.out.println(aPerson.getHeight());
    aPerson.repeatBreath(10);
  }
}
  
  class Human{
    /**
     *member
     */
   private int height;
    /**
    *constructor
    */
    public Human(int h){
      this.height=h;
      System.out.println("i'am born");
    }

   public int getHeight()
     {
       return this.height;
     }

   public void growHeight(int h)
   {
     this.height=this.height+h;
   }

   private void breath()
   {
     System.out.println("huhuhuhu");

   }

   public void repeatBreath(int rep)
  {
    int i;
    for(i =0;i<rep;i++)
    {
      this.breath();
    }
   }
  }
```

---
#### 实施接口(implements interface)


Java提供了interface这一语法，可以将接口从类额具体定义中剥离出来，构成一个独立的主体。

接口是用来统一标准和规范的。


比如定义一个杯子的接口

```
interface Cup{
  abstract void addWater(int w);
  abstract void drinkWater(int w);
}
```

Cup接口中定义了两个方法的原型(stereotype):addWaer()和drinkWater()。在接口中我们不需要定义方法的主体，也不需要说明方法的可见性。因为这些都是默认为public的。

在类的定义中实施接口，比如在MusicCup类中实施Cup接口。

```
class MusciCup implements Cup
{
  public void addWater(int w)
  {
     this.water = this.water+w;
  }

  public void drinkWater(int w)
  {
     this.water =this.water-w;
  }
  
  private int water=0;
}
```

Java中使用__implements__关键字来实施接口(interface)。一旦在类中实施了某个接口，则必须在该类中定义接口的所有方法，类中的方法需要与interface中的方法原型相符合。

接口中所有的变量必须是常量且初始化，接口中所有的方法都是抽象的。

```
public interface Cup
{
  public static final String COLOR="red";
  public abstract void drinkWater();
}
```

接口实现的具体类中可以定义interface中没有提及的其它public方法，interface只是规定了一个必须要实施的最小接口。


---
### 0x01 接口继承
接口继承与类继承很类似，就是以被继承的interface为基础，添加新增接口方法原型。

比如，以cup作为原接口；

```
interface MetricCup extends Cup
{
  int WaterContent();
```

在Java的衍生类中，一个衍生类只能有一个基类，就是一个类不能同时继承于多个类，但是interface可以是多重继承的。

比如有一个Player接口

 ```
interface Player
{
  void Play();
}

新增一个MusiCup接口，它同时继承于Cup和Player接口

```
interface MusicCup extends Cup,Player
{
  void display();
}
```


