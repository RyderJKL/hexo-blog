---
title: Java(5)继承(inheritance)
date: 2016-07-19
tags: ['Java基础']
toc: true
categories: technology

---
### 0x01 继承
__继承(inheritance)__是除组合(composition)外，提高代码重复可以性的另一种方式。

先定义给一个Human类:

```
package com.jack.second;

public class Human {
	public Human(int h){
		this.height= this.height+h;
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
}
```

然后在Human类的基础上定义一个Woman类，使用关键字__extends__让Woman继承自Homan。

```
package com.jack.second;

public class Woman extends Human{
	public Woman(int h) {
		super(h);		
	}

	public void giveBirth(){
		System.out.println("Give Birth a woman");		
	}
}
```

如上，通过继承以此创建了一个新的类，叫做__衍生类(derived class)__。而被继承的类叫做__基类(base class)__。

衍生类以基类作为自己定义的基础，并补充基类中没有定义的giveBirth()方法。

下面使用TestWoman类测试

```
package com.jack.second;

public class TestHuman {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Woman p=new Woman(20);
		p.breath();
		p.growHeight(100);
		System.out.println(p.getHeight());
		p.giveBirth();
	}
}
```

整个过程可以分为三个层次:"基类定义","衍生类定义","外部使用"。

---
### 0x01 protected
现在可以看看__protected__的含义了。
被proteced定义的成员和方法在该类及其衍生类中可见。就是说，基类的protected成员可以被衍生层访问，但是不能被外部访问。

---
### 0x02 方法覆盖
_子类将会继承父类的所有属性和方法，并且在程序加载时，将会优先加载父类的所有特征。_

Java是同时通过方法名和参数列表来判断所要调用的函数方法的。但是若是方法名和参数列表相同呢？(当然这种情况只会出现在基类及其衍生类中)

在子类中，可以使用__super__和__this__来确定是哪个方法。

但是在外部，呈现只是统一接口，所以无法提供这两种方法，这时Java会__呈现子类方法__而不是父类的方法，这种机制叫做__方法覆盖(method overriding)__

方法覆盖可以很好的利用用于修改基类成员的方法。

````
package com.jack.second;

public class Woman extends Human{
	public Woman(int h) {
		super(h);
		
	}

	public void giveBirth(){
		System.out.println("Give Birth a woman");
		
	}
	
	public void breath(){
		
		System.out.println("hahaha");
	}
}
```

---
### 0x03 构造方法
子类会继承父类的所有属性和特征，在程序加载时将会优先加载父类的成员和方法。
所有基类的构造方法应该先被调用。这与方法覆盖并不冲突。


