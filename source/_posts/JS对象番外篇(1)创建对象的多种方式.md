---
title: JS对象番外篇(1)创建对象的多种方式   
date: 2016-09-28      
tags: ['JavaScript','JS对象']
toc: true
categories: technology

---
### 0x00 JS 对象
对象在 JS 中被称为引用类型的值((在其它语言中，对象是类的实例))。
JS 没有类的概念，至于对象，我们可以想象为散列表，一些键值对的组合，其值可以是数据或者函数。


所以，在物理世界中对象是指在内存中可以被标识符引用的一块区域。

我们创建一个对象的时候实际上是在内存中开辟了一块空间，而对于这个对象(这块空间)，可以使用任何的标识符去**引用(reference)**[也可以是指向]它。

```
var o = { 
  a: {
    b:2
  }
}; 
// 两个对象被创建，一个作为另一个的属性被引用，另一个被分配给变量o

var o2 = o; // o2变量是第二个对“这个对象”的引用

o = 1;      // 现在，“这个对象”的原始引用o被o2替换了

var oa = o2.a; // 引用“这个对象”的a属性
// 现在，“这个对象”有两个引用了，一个是o2，一个是oa
```


---
### 0x01 使用 Object 创建对象
创建自定义对象最简单的方法就是创建一个 Object 实例,然后为其添加属性和方法。

```
var person = new Object();
person.name = "Jack";
person.age = "29";

person.sayName = function () {
    alert(this.name);
}
```

---
### 0x2 字面量创建对象
除了使用 Object 实例化一个对象外，还可以使用对象字面量语法创建一个对象

```
var person = {
    name: "Jack",
    age: "29",
    sayName: function () {
        alert(this.name);   
    }
};
```

---
### 0x03 工厂模式
工厂模式抽象了创建具体对象的过程，从而使用函数来封装以特定接口创建对象的细节。

```
function createPerson (name, age, job){
	var o = new Object();
	o.name = name;
	o.age = age;
	o.job = job;
	o.sayName =function (){
		alert(this.name);
	};
	return o;
}

var person1 = createPerson("jack", 27, "Student");
```
函数 createPerson() 能够根据接收的参数来创建一个包含必要信息的对象。
我们可以无数次的调用这个函数去创建一个对象。

---
#### 工厂模式的问题
虽然工厂模式解决了创建多个相似对象的问题，也在很大程度上较少了代码量，但是工厂模式却没有解决对象识别问题。

---
### 0x03 构造函数模式
Object 构造函数或者字面量可以创建单个的对象，但是使用同一接口创建很多对象时，会产生大量重复代码，即使使用 **工厂模式** 可以解决创建多个相似对象的问题，但没法解决对象识别问题(即是如何知道一个对象的类型)。因此一种基于工厂模式的变种出现了，**构造函数模式**。


```
function Person (name, age, job){
		this.name = name;
		this.age = age;
		this.job = job;
		this.sayName = function (){
			alert(this.name);
		};
	}
var person1 = new Person("Jack", 29, "teacher");
var person2 = new Person("Macl", 28, "studnet");
```

如上，首先我们并没有显示的去创建对象，而是 `new` 了一个 `Person()` 构造函数( 为了与普通函数区分开来，构造函数首字母大写，构造函数没有 `return` 语句)，创建了一个 `Person` 实例。

> 任何函数，只要通过 `new` 操作符来调用，它就可以作为构造函数；而任何函数，如果不使用 `new` 调用，那它与普通函数并没有什么不同。

---
#### 构造函数模型的问题
使用构造函数的问题即是，每个方法都要在每个实例上重新创建一遍。比如，person1 和 person2 都用到了同一个函数，sayName()。但是那两个函数不是同一个 Funciton 实例。

当然，我们可以将构造函数内部定义的函数提取处理，在其外部从新定义，从而让其成为一个全局函数，这样 person1 和 person2 就可以共享在全局作用域中定义的同一个函数 sayName()。

但是新的问题有出现了，在全局作用域中定义的函数实际上只能被某个对象调用，更重要的是，当对象需要定义很多方法时，那么就要定义很多个全局函数，这样我们自定义的引用类型变丝毫没有封装性可言。


---
### 0x04 原型模式
在JS中每个对象有拥有一个原型对象，所以在每个对象内部都有一个指向其原型对象的指针(或者属性，这个属性叫原型属性(prototype)，比如我们所创建的所有自定义对象的原型属性都会指向 Object 对象，而object 对象的原型对象是null。





```
function Person () {
  
}

Person.prototype.name = "jack";
Person.prototype.age = 29;
Person.prototype.job = "teacher";
Person.prototype.sayName = function (){
	alert(this.name);
}

person1 = new Person();
person2 = new Person();

alert(person1.sayName == person2.sayName); // true
```

如上，将 sayName() 方法和所有属性直接添加到了 Person 的 prototype 属性中，构造函数变成了一个空函数。虽然我并没有在Person 构造函数中定义sayName() 方法，但是由构造函数创建出来的新对象实例却拥有了 sayName() 方法。而这正是因为 person 对原型对象的特殊引用。

**原型对象中有一个constructor属性指向包含prototype属性的函数**

当为对象实例添加一个与对象属性同名的属性时，实例中的这个属性就会屏蔽原型对象的同名属性。但是，也可以使用 `delete` 操作符完全删除实例属性，从而能够重新访问原型中的属性。



---
#### 封装的原型
我们可以使用一个包含所有属性和方法的对象字面量来重写整个原型对象，这样不但可以减少代码量，也更好的从视觉上进行了封装。但是一旦重写原型对象，那么 `constructor` 属性不再会指向 `Person` 而是指向 `Object`，这意味着，重写原型对象便切断了现有原型与任何之前已经存在的对象实例之间的联系。

所以我们需要将其设置回正确的值

```
function Person(){

	}

Person.prototype = {
    constructor: Person,
	name: "jack",
	age: 29,
	job: "teacher",
	sayName: function(){
		alert(this.name);
	}
};
```

---
#### 原型的动态性
在调用某个属性时， JS 引擎会首先在对象实例中搜索该属性，在没有找到的情况下会继续搜索原型，即使对象实例是在为原型修改属性之前创建也不会有问题。

```
function Person(){

}

var friend = new Person();

Person.prototype.sayHi = function (){
    alert("hi");
};

friend.sayHi() //没有问题
```

但是若是重写整个原型对象，情况便不一样了

```
function Person(){

}

var friend = new Person();
	
Person.prototype = {
	name: "jack",
	age: 29,
	job: "teacher",
	sayName: function(){
		alert(this.name);
	}
};

friend.sayName();
// error
```

因为重写原型对象，切断了现有原型与之前已经存在的对象实例之间的联系；它们引用的仍然是最初的原型。


---
#### 原型模式的问题
原型模式省略了为构造函数传递初始化参数这环节，这会使得所有实例在默认情况下获得相同的属性值；而不止于此，其最大的问题在于其共享的本质所导致的，特别是对于包含引用类型值的属性，当我们修改某一个实例对象一个特定属性时必将影响原型对象的，从而使得所有实例属性发生改变。


---
### 0x06 组合模式

创建自定义对象最常见的方式就是**组合使用构造函数模式和原型模式。** 构造函数用于定义实例属性，而原型模式用于定义方法和共享的属性。

```
function Person (name, age, job) {
		this.name = name;
		this.age = age;
		this.job = job;
		this.friends = ["jack","mac"];
	}

Person.prototype = {
	constructior: Person,
	sayName: function(){
		alert(this.name);
	}
}

var person1 = new Person("Nich", 20, "Enginner");
var person2 = new  Person("Greg", 19, "Student");

person1.friends.push("van");
console.log(person1.friends); //["jack", "mac", "van"]
console.log(person2.friends); //["jack", "mac"]
```

如上，实例属性都是在构造函数中定义的，而由所有实例共享的属性 constructor 和方法 sayName() 则是在原型定义的。

当修改了 person1.friends, 并不会影响到 person2.friens, 因为它们分别引用了不同的数组。

---
### 0x07 动态原型模式
进一步，我们可以将所有信息都封装在构造函数之中，并通过构造函数初始化原型(当然，在必要的条件下)。

```
function Person(name, age, job){
		//属性
		this.name = name;
		this.age =age;
		this.job = job;

		//方法
		if (typeof this.sayName != "function"){
			Person.prototype.sayName = function (){
				alert(this.name);
			}
		}
	}

var friend = new Person("jack",18,"The walking Dead");
friend.sayName();
```

注意构造函数中，只有在 sayName() 不存在的情况下，才会将其添加到原型中。



---
### 0x08 寄生构造模式
**寄生(parasitic)构造模式**的基本思想是创建一个函数，该函数的作用仅仅是封装创建对象的代码，然后返回新创建的对象。

```
function Person (name, age, job){
		var o = new Object();
		o.name = name;
		o.age = age;
		o.job = job;
		o.sayName = function (){
			alert(this.name);
		};
		retuen o;
	}

	var friend = new Person("jack", 28, "Enginner");
```

如上，除了使用 new 操作符并把使用包装的函数叫做构造函数之外，这个模式跟工厂模式一模一样。构造函数在不返回值的情况下，默认会返回新对象实例。通过在构造函数中的 return 语句可以重写调用构造函数时返回的值。

寄生构造模式可以在特殊情况下为对象创建构造函数。

> 值得注意的是，寄生模式下返回的对象与构造函数或者与构造函数的原型属性之间没有任何关系。构造函数返回的对象与构造函数在外边创建的对象没有什么不同。

---
### 0x09 稳妥构造函数模式
所谓**稳妥对象(durable object)**指的是没有公共属性，而且其方法也不引用 `this` 的对象。此外稳妥构造模式也不会使用 `new` 操作符调用构造函数。

```
function Person (name, age, job){
	var o = new Object();
	o.name = name;
	o.age = age;
	o.job = job;
	o.sayName = function (){
		alert(this.name);
	};
	return o;
}
var friend = Person("jack",28,"Nojob");
friend.sayName();
```

如此，变量 friend 中保存的是一个稳妥对象，而除了调用 sayName() 方法以外，没有别的方法可以访问其数据成员。

稳妥构造函数模式非常适合某些安全执行环境。

> 与寄生构造函数一样，稳妥构造函数创建的对象与构造函数之间没有什么关系。

