---
title: Java(7)抽象类组合内部类
date: 2016-07-19
tags: ['Java基础']
toc: true
categories: technology

---

### 0x00 abstract 抽象类
我们可以从多个具体的类中提取相同的属性和方法来构建一个总类，既是抽象类，这个类不能被实例化，以此作为子类的模板，以防止子类的。。。。可以使用abstract定义抽象类，此时抽象类中的方法将在子类中去实现，在父类中实现是无意义的。

```
public class abstract Animal()
{
   private String name;
   public abstract void sound();
}


public class cat extends Animal()
{
   public void sound(){
     Sytem.out.println("miao....");
  }
}
```

---
### 0x01 组合


---
### 0x02 内部类


