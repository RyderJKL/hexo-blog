---
title: JS对象(5)对象属性  
date: 2016-12-13      
tags: ['JavaScript','JS对象']
toc: true
categories: technology

---
### 0x00 属性类型

ECMAScript 中有两种属性: **数据属性** 和 **访问器属性**，而在 ES5 中有对属性(property)的特性(attribute)提供了多种描述，比如是否可配置，是否可枚举等等。

---
### 0x01 数据属性
数据属性包含的是数据值的位置。数据属性的 4 特性如下:

1. [[Configurable]] 是否可配置，比如，是否可以使用 `delete`操作符删除，能否修改属性的特性，能否把属性修改为访问器属性。
   

2. [[enumerable]] 是否可枚举, 能否通过 `for in` 循环返回属性。

 
3. [[writable]] 是否可写，能否修改该属性的值。

4. [[value]] 包含该属性的值，默认该值为 `undefined`
    
##### Object.defineProperty()
ES5 新增了对对像属性特性进行配置的方法 `Object.defineProperty()`，该方法接收三个参数：属性所在的对象，属性的名字，属性的特性。


对于以上的属性特性值，若是在对象上直接添加的属性，对应的各个特性的值为`true`，而使用`defineProerty()`方法添加的属性为各个特性的值为 `false`.



```
var obj = {}
obj.name = 'tom'
obj.age = 21
Object.defineProperty(obj, 'age',{
    configurable:false,
    // 不可配置
    enumerable:false,
    // 不可枚举
})
// 如此，obj 对象中的 age 属性便不可以被 delete 删除了

for(var p in obj){
    console.log(obj)
    // undefined
}
```

---
### 0x02 访问器属性

与数据属性一样，访问器属性同样具备是否可配置和可枚举的特性，不同的是，访问器拥有两个方法，getter 和 setter 函数。

1. [[Get]]:读取属性时的函数
2. [[Set]]:写入属性时的函数

访问器属性不能直接定义，而必须通过 `Object.defineProperty()` 来定义。
 
```
var car = {
    model: 'X5',
    birthday: '2016/12/14'
}

// 值得注意的是，使用Object.defintProperty 方法来定义时会覆盖原始对象中的同名属性
// 所以，正确的做法是改写对象的属性名，给对应的属性名添加一个下划线 "_"

var car = {
    _model: 'X5',
    birthday: '2016/12/14'
}
Object.defineProperty(car, 'model', {
    get:function(){
        return this._model
    },
    
    set:function(val){
        this._model = val;
    }
})

console.log(car.model)
// 读取 model
car.model = 'X6'
// 写入 model
    
```


---
### 0x03 Object.defineProperties()

ES5 提供了一个一次性定义多个属性的方法 `Object.defineProperties()`,该方法接收两个对象参数:目标对象和包含与目标对象中要添加或修改的属性的对象。

```
var book = {}
Object.defineProperties(book,{
	_year:{
		writable:true,
		value:200,
	},

	edition:{
		writable:true,
		value:1,
	},

	year:{
		get:function(){
			return this._year;
		},
		set:function(newValue){
			if(newValue > 2004){
				this._year = newValue
				this.edition += newValue - 2004;
			}
		}
	}
	
})

alert(book.year)
// 2004
book.year = 2008
alert(book.year)
// 2008
alert(book.edition)
// 5
```


