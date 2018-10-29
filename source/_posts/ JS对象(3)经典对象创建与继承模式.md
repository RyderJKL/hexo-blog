---
title: JS对象(3)经典对象创建与继承模式  
date: 2016-09-28       
tags: ['JavaScript','JS对象']
toc: true
categories: technology

---
### 0x01 组合模式创建对象
JS 中创建一个对象的方式多种多样，每种方式都有自己缺点或者优点，具体的可以参考____

而组合使用构造函数模式和原型模式来创建自定义类型算是最常见的方式了。

在组合模式中，构造函数用于定义实例属性，而原型用于定义方法和共享的属性。

如此，每个实例都会有自己的一份实例属性的副本，又共享着对方法的引用。

```
function Person(name, age, job){
	this.name = name;
	this.age = age;
	this.job = job;
	this.friends = ["jack", "marli"]
}

Person.prototype = {
	// 使用字面量形式重写原型
	constructor : Person,
	sayName : function(){
		console.log(this.name);
	}
}

var person1 = new Person("刘德华",54,"歌手 演员")
person1.friends.push("成龙")
var person2 = new Person("特朗普",60,"企业家 花花公子 总统")

console.log(person1.sayName()+"的朋友: "+person1.friends)
//刘德华的朋友: jack,marli,成龙
console.log(person2.name+"的朋友: " +person2.friends)
//特朗普的朋友: jack,marli
```

当修改了 `person1.friends` 并不会影响到 `person2.friends`，因为它们分别引用了不同的数组。

现在，对 Person 的原型进行如下修改:

```
Person.prototype = {
	// 使用字面量形式重写原型
	constructor : Person,
	sex:'man',
	hobby:['woman','money','food'],
	sayName : function(){
		console.log(this.name);
	}
}
```

如上，我们新添加了 `sex` 和 `hobby` 两个共享属性。

```
person1.sex = "woman"
console.log(person1.sex)
// woman
console.log(person2.sex)
// man

person1.hobby.push("reputation")
// ["woman", "money", "food", "reputation"]
console.log(person2.hobby)
// ["woman", "money", "food", "reputation"]
```

我们尝试在 `person1` 中将 `Person` 原型里的 `sex` 修改为 `woman`,`person2` 并没有受到影响，即使 `sex` 属性是属于 `Person` 原型中的共享属性。这很容易理解，因为 `Person` 中的 `sex` 是字符串，即属于六种原始类型中的一种。

但是，当我门对 `person1` 中的 `hobby` 推入一个元素的时候，`person2` 中 `hobby` 同样被更改了。这也很容易理解，`hobby` 数数组，是引用类型的，且存在于 `Person` 的原型中，即它是共享属性，那么在任何实例中的操作都会影响到原型中的共享属性。



---
### 0x02 组合式继承
作为经典继承模式，组合式继承模式算是 JS 中使用最多的了。

其思想是使用原型链实现对原型属性和方法的继承，而通过借用构造函数来实现对实例属性的继承。

```
function SuperType(name){
	this.name = name;
	this.colors = ["red","blue","pink"];
}

SuperType.prototype = {
	// 重写原型
	constructor: SuperType,
	// 将原型的构造函数指向 SuperType
	job:["teacher","student"],
	sayName:function(){
		console.log(this.name)
	}
}


function SubType(name, age){
	
	SuperType.call(this, name); // **第二次调用 SuperType 构造函数**
	// 继承父类的实例属性，也因此而覆盖了原型继承中的同名属性
	this.age = age;
}

SubType.prototype = new SuperType(); // **第一次调用 Supertype 构造函数**
// 此时 SubType 的原型中将会包含 SuperType 的所有属性和方法(包括实例属性,共享属性,以及共享方法)

SubType.constructor = SubType;

SubType.prototype.sayAge = function(){
	// 继承而来的原型不能通过对象字面量的方式被重写，即是添加了 constructor 属性也没用
	console.log(this.age)
}

var aSubType = new  SubType("jack", 24)
aSubType.sayName()
// jack

var aSuperType = new SuperType("mack",35)
aSubType.job.push("softfore engineering")
console.log(aSuperType.job)
// ["teacher", "student", "softfore engineering"]
console.log(aSubType.job)
// ["teacher", "student", "softfore engineering"]
```

如下，我们大概了解了组合式继承，但，正如星号(**)所标记的那样，组合继承存在一个不足的地方，就是无论在何种情况下，都会调用两次超类型构函数。一次是在创建子类型原型的时候，一次是在子类型构造函数内部。

如何想解决这个问题，可以进一步的使用寄生组合式继承模式，它被认为是引用类型最理想的继承范式，也是实现基于类型继承的最有效方式。

---
### 0x03 寄生组合式继承
使用寄生组合式继承可以不必为了指定子类型的原型而调用超类型的构造函数，我们所需要的无非是超类型的一个副本而已。

如下是寄生组合式继承的基本模式：

```
function inheritPrototype(subType, superType){
	var prototype = Object(superType.prototype)             
	// 创建对象 
	prototype.constructor = subType;			
	// 增强对象
	subType.prototype = prototype;				
	// 指定对象
}
```

**inheritPrototype()** 函数接受两个参数:子类型构造函数和超类型构造函数。在函数中我们首先创建了一个超类型原型的一个副本，然后为创建的副本添加 `constructor` 属性，从而弥补因重写原型而失去的默认的 constructor 属性，最后我们将新创建的对象(原型副本)赋给子类型的原型。

如此，便可以使用 inheritPrototype() 函数替换组合式继承模式中为子类原型赋值的操作了

```
function SuperType(name){
	this.name = name;
	this.colors = ["red","blue","pink"];
}

SuperType.prototype = {
	// 重写原型
	constructor: SuperType,
	// 将原型的构造函数指向 SuperType
	job:["teacher","student"],
	sayName:function(){
		console.log(this.name)
	}
}

function SubType(name, age){
	
	SuperType.call(this, name); 
	this.age = age;
}

function inheritPrototype(subType, superType){
	var prototype = Object(superType.prototype) // 拷贝父级对象原型 
	prototype.constructor = subType;           //将子类原型构造属性指向其子类构造函数
	subType.prototype = prototype;	    	// 指定对象
}

inheritPrototype(SubType, SuperType);

var aSubType = new  SubType("jack", 24)
aSubType.sayName()
// jack
console.log(aSubType.colors)
//["red", "blue", "pink"]
```


