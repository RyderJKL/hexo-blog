---
title: JS对象番外篇(2)继承的多种方式   
date: 2016-10-05      
tags: ['JavaScript','JS对象']
toc: true
categories: technology

---
### 0x01 基本继承模式

```
function SuperType(){
		this.property = true;
	}

	SuperType.prototype.getSuperValue = function (){
		return this.property;
	};

	function SubType(){
		this.subproperty = false;
	}

	SubType.prototype = new SuperType();

	SubType.prototype.getSubVaule = function(){
		return this.subproperty;
	}

	var instance = new SubType();
	console.log(instance.getSubVaule()); //false
	console.log(instance.getSuperValue()); //true
```

如上，我们通过将 超类的实例赋值给子类的原型实现了从超类到子类的继承。

然后，又通过将子类的实例赋值给 instance的原型 实现了从子类到 instance 的继承。

需要知道的是，此时 instance 的 constructor 指向的是 SuperType；因为子类的原型指向的是超类的原型对象，而这个原型的 constructor 属性指向的是 超类。

同样，在我们使用原型继承的时不能使用对象字面量创建原型方法，这样会重写原型。


当试图访问一个对象的属性时，它不仅仅在该对象上搜寻，还会搜寻该对象的原型，以及该对象的原型的原型，依此层层向上搜索，直到找到一个名字匹配的属性或到达原型链的末尾。


---
### 0x01 Combination Inheritance  
组合继承(Combination Inheritance) 有叫伪经典继承，其结合了原型链和构造函数两者之长。其思想是使用原型链实现对原型属性和方法的继承，而通过构造函数实现对实例属性继承。

如此，既通过在原型上定义方法实现了函数复用，又能够保证每个实例都有自己的属性。


```
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Document</title>
</head>
<body>
  
</body>
<script type="text/javascript">
  function SuperType (name){
    this.name = name;
    this.colors = ["red", "green", "blue"];
  }

  SuperType.prototype.sayName = function (){
    console.log(this.name);
  }

  function SubType (name, age){
    //继承属性
    SuperType.call(this, name);
    //定义 SubType 自己的属性
    this.age = age;
  }

  //继承方法
  SubType.prototype = new SuperType();
  //定义 SubType 自己的方法
  SubType.prototype.sayAge = function (){
    console.log(this.age);
  }

  //创建 instance1 实例，并继承自 SubType 
  var instance1  = new SubType("Jack", 89);
  instance1.colors.push("black");
  console.log(instance1.colors); //red,green,blue,black
  instance1.sayName();  //jack
  instance1.sayAge();   //89

  var instance2 = new SubType("Marge", 23);
  console.log(instance2.colors); //red,green,blue
  instance2.sayName();  //Marge
  instance2.sayAge();   //23
</script>
</html>
```

组合继承模式避免了原型链和借用构造函数的缺陷，融合了它们的优点，称为 JS 中最常用的继承模式。
 

---
### 0x02 寄生组合继承

所谓寄生组合继承，即通过借用构造函数来继承属性，通过原型链的混成形式来继承方法。其背后的基本思想是：不必为了指定子类型的原型而调用超类型的构造函数，我们所需要的无非就是超类型原型的一副本而已。本质上就是使用寄生继承来继承超类型的原型，然后再将结果指定给子类型的原型。

继承组合继承是引用类型最理想的继承方式。

```
function inheritPrototype (subType, superType){
    var prototype = object(superType.prototype); //创建对象
    prototype.constructor = subType;  //增强对象
    subType.prototype = prototype;    // 指定对象
 }
```

如上，inheritPrototype() 函数实现了继承组合继承最简单的形式。

这个函数接收两个参数: 子类型构造函数和超类型构造函数。首先在函数内部创建超类型原型的一个副本。然后为创建的副本添加 constructor 属性，从而弥补因重写原型而失去的默认的 consructor 属性。最后将新创建的对象赋值给子类型的原型。

```
 function inheritPrototype (SubType, SuperType){
    var prototype = Object(SuperType.prototype); //创建对象
    prototype.constructor = SubType;  //增强对象
    SubType.prototype = prototype;    // 指定对象
 }

 function SuperType(name){
  this.name = name;
  this.colors = ["red", "green", "blue"];

 }

SuperType.prototype.sayName = function (){
  console.log(this.name);
}

function SubType(name, age)
{
  SuperType.call(this, name);
  this.age = age;
}


inheritPrototype(SubType, SuperType);

SubType.prototype.sayAge = function (){
  console.log(this.age);
}

var instance = new SubType("jack");
instance.sayName();
```

