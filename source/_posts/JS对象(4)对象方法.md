---
title: JS对象(4)对象方法  
date: 2016-09-28      
tags: ['JavaScript','JS对象']
toc: true
categories: technology

---
### 0x00 instanceof 属性
`instanceof` 可以判断当前实例是否属于某个对象。

```
console.log(aSubType instanceof SubType)
// true
console.log(aSubType instanceof SuperType)
// true
```

`aSubType` 是 `SubType` 的实例，而 `SubType` 对象有继承于 `SuperType` 对象，所以以上两个结果返回 `true`. 



###### Object.isPrototypeOf()
使用 `isPrototypeOf()` 方法可以判断原型是否拥有某个实例对象。


```
alert(Person.prototype.isPrototypeOf(person1);
// true
```


###### Object.getPrototypeOf() 
可以通过 `Object.getPrototypeOf()` 方法取得某个实例对象的原型。

```
alert(Object.getPrototypeOf(person1) == Person.prototype);
alert(object.getPrototypeOf(person1).name);
```

###### Object.hasOwnProperty()
使用 `Object.hasOwnProperty()` 方法可以检测一个属性是存在于实例中，还是存在于原型中,只有当给定方法存在对象实例中时，才会返回 true。

```
alert(person1.hasOwnProperty("name")); 
//true
```

###### in 操作符
有两种方式使用 `in` 操作符，单独使用和在 `for...in` 循环中使用。单独使用时，`in` 会在通过对象能访问的属性时返回 true ， 而不论该属性存在于实例中，还是原型中。

```
alert(person1.hasOwnProperty("name"));
// false
alert("name" in person1);
// true
```

> 同时使用 `hasOwnProperty()` 方法和 `in` 操作符就可以确定属性存在于对象实例中还是原型中。

###### for...in
`for...in` 方法返回所有能够通过对象访问的可枚举的属性，**包括实例和原型**的。

###### Object.keys()
使用 `Object.keys()` 方法获得对象中所有可枚举的 **实例属性**。

###### Object.getOwnPropertyNames()
如果想获得原型中的所有属性，无论属性本身是否可枚举，可以使用 `Object.getOwnPropertyNames()` 方法。


