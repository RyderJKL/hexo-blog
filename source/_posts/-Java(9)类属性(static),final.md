---
title: Java(9)类属性
date: 2016-07-21
tags: ['Java基础']
toc: true
categories: technology

---
### 0x00 关于static
static可以用来修饰类的成员方法和成员变量，此外，还可以用来编写static代码块来提高程序性能。static关键字定义的属性或者方法不属于对象，而是属于整个类的。 

---
#### static方法
static方法一般成为静态方法，它不依赖于任何对象就可以进行访问，因此对于静态方法来说是没有this的。由于这个特性，在静态方法中不能访问类的非静态变量和非静态方法，因为它们必须依赖于具体的对象才能被调用。但是在非静态方法中是可以访问静态成员方法/变量的。

至于为什么main函数必须是static的，现在就可以很清楚了。

此外，虽然没有显示的声明为static，类的构造器实际上也是静态的。

---
#### static变量
static变量就是静态变量，与非静态变脸的区别是:静态变量被所有的对象所共享，在内存中只有一个副本，当且仅当在类初次加载是会被初始化。而费静态变量是对象所拥有的，在创建对象的时候被初始化，存在多个副本，各个对象拥有的副本互不影响。

---
#### static代码块
同时也可以用于静态代码块，在类加载的时候默认执行一次，并且优先于构造方法。

---
#### 关于static的误区
1.stattic不能用于修饰局部变量。
2.static不会改变变量或者方法的作用域。Java中能够影响到访问权限的只有private，public，protected.

----
#### 对象方法修改类数据
有了static这个方法，便可以构建__类的属性__了，它们将会被所有成员对象/方法共享。

```
package com.jack.second;

public class Human {
	public Human(int h){
		this.height= this.height+h;
		Human.population=Human.population+1;
	}
	public int getHeight(){
		return this.height;
	}
	
	public void growHeight(int h){
		this.height=this.height+h;
	}
	
	public void breath(){
		System.out.println("huhuhuhu");
	}
	
	private int height;
	private static int population;
}
```

每创建一个对象时，都过通过该对象的构造方法修改类数据，为population类数据增加1。


---
### 0x01 final
final代表终极的意思。

final关键字的含义是：这个数据/方法/类不能被改变了

* final基本类型数据:定值(constant value)只能复制一次，不能再被修改
* final方法:该方法不能被覆盖
* final类:该类不能被继承。


