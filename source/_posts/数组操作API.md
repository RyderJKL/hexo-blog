---
title: 数组操作API    
date: 2016-10-13    
tags: ['JavaScript基础进阶']
toc: true
categories: technology

---
### ES6 新增加的构造函数方法

---
#### Array.of
Array.of 用于将参数依次转换为数组中的一项，然后返回这个数组。而不论参数是数字还是其它。

```
Array.of(8.0);// [8]
Arry.of(8.);//[undefined*8]
```

Array.of 最常用的用途就是使用数组包括元素。

Array.of 的 polyfill 实现:

```
if(!Array.of){
  Array.of = function(){
    return Array.prototype.slice.call(arguments)
  }
}
```

---
#### Array.from
Arry.from 的主要用途是将类数组快捷的转换为数组，并返回一个新的数字实例。它可以接收三个参数，第一个为类似数组的对象，必选。第二个为加工函数，新生成的数组会经过该函数的加工再返回。第三个为this作用域，表示加工函数执行时this的值。后两个参数都是可选的。


```
var obj = {0: 'a', 1: 'b', 2:'c', length: 3};
Array.from(obj, function(value, index){
  console.log(value, index, this, arguments.length);
  return value.repeat(3); //必须指定返回值，否则返回undefined
}, obj);
```

除了 obj 对象之外，拥有迭代器的对象还包括，`String`,`Set`,`Map`,`arguments`.

Array.isArray

---
在 ES6 之前，我们有多种方法可以去判断一个值是否是数组：

```
var a = [];
// 基于 instanceof
a.instanceof Array;
// 基于 constructor
a.constructor === Array;
// 基于 Object.prototype.isPrototypeOf
Array.prototype.isPrototypeOf(a)
// 基于 getPrototypeOf
Object.getProtorypeOf(a) === Array.prototype
// 基于 Object.prototype.toString()
Array.prototype.toString(a) === '[object Array]'
```

以上，除了 `Object.prototype.toString` 以外，都不能正确的判断类型。


```
var a = {
  __proto__: Array.prototype
};
// 分别在控制台试运行以下代码
// 1.基于instanceof
a instanceof Array; // true
// 2.基于constructor
a.constructor === Array; // true
// 3.基于Object.prototype.isPrototypeOf
Array.prototype.isPrototypeOf(a); // true
// 4.基于getPrototypeOf
Object.getPrototypeOf(a) === Array.prototype; // true
```

如上，我们只是单纯的改变了对象 a 的 `__proto__` 属性，便导致该对象继承了 `Array` 类型。

所幸，ES6 提供了 Array.isArray 方法。

```
Array.isArray(a);// false;
```

Array.isArray 的 polyfill 如下:

```
if (Array.isArray){
  Array.isArray = function(args){
    return Array.prototype.toString(args) === '[object Array]'
  }
}
```

---
### 方法
数组所有方法都是继承自原型的。数组的方法非常之多，主要分为三种，一种是会改变自身的，一种是不会改变自身的，最后一种就是遍历了。


#### 改变自身值的方法(9个)
改变自身值的方法共有 9 个。分别是 `pop`,`push`,`sort`,`shift`,`unshift`,`reverse`,`splice`,以及 ES6 新增的方法 `copyWith` 和 `fill`。

##### pop
pop() 方法删除一个数组中的最后一个元素，并且返回该元素。

##### push
push() 方法在数组的最后推入一个或多个元素，并返回数组的新的长度。

##### reverse
reverse() 方法用于颠倒数组中元素的位置。该方法返回对数组的索引。

##### shift
shift() 方法删除数组中的第一个元素，并返回这个元素。

##### unshift
unshift() 方法用于在数组开开头插入一些元素，并返回新的数组长度。

##### sort
sort() 方法对数组进行排序，并返回这个数组。

语法: __arr.sort([compareFn])__

默认情况下，sort 方法将按照元素的 UniCode(万国码)进行排序。如果指定了 compareFn，那么将根据该函数返回的结果进行排序：

* 若 compareFn(a,b) > 0, a 将在 b之前
* 若 compareFn(a,b) = 0, a 和 b 相对位置不变
* 若 compareFn(a,b) < 0, a 将排在 b 之后

如果数组为非 ASCII 字符的字符串(é、è、a、ä 或中文字符等非英文字符的字符串)，则需要使用 `String.localeCompare`。

```
var array = ['好','好','学','习','天','天','向','上'];
var sortArr = array.sort(function (a,b) {return a.localeCompare(b)});
console.log(array)
//["好", "好", "上", "天", "天", "习", "向", "学"]
console.log(sortArr)
  //["好", "好", "上", "天", "天", "习", "向", "学"]
```

sort函数默认按照数组元素unicode字符串形式进行排序，然而实际上，我们期望的是按照拼音先后顺序进行排序，显然String.localeCompare 帮助我们达到了这个目的。

##### sort 在 chrome 的怪异行为
v8 引擎为了高效排序(采用了不稳定排序),即数组长度超过10条时，会调用另一种排序方法(快速排序)；而10条及以下采用的是插入排序。

那么这时就出现问题了：

```
var array = ['a','b','c','d','e','f','g','h','i','j','k','l','m'];
  array.sort(function (a, b) {
    return a - b
  });
  for (var i = 0,len = array.length; i < len; i++) {
    console.log(array[i]);
  }
```

##### splice
splice() 方法用新元素替换旧元素的方式来修改ia数组。

语法: arr.splice(start,deleceCount[,item1[,items]])

start 指定下标从那一位开始。如果超过了数组的长度，则从数组的末尾添加内容；若 start 为负数，则指定的索引位置等同于 length + start。

deleceCount 代表要删除元素的个数。

itemN 指定新增的元素，如果缺省，则该方法只删除数组元素。

返回值 由原数组中被删除元素组成的数组，如果没有删除，则返回一个空数组。


扩展，删除数组中指定位置的元素:

```
var array = ['a','b','c']
array.splice(array.indexOf('b'),1)
```

##### copyWith [ES6]


##### fill [ES6]


---
#### 纯函数

##### concat
concat() 方法将传入的数组或者元素与原来的数组合并，并返回一个新的数组。

__语法: arr.concat(value1,value2,...)__

若concat方法中不传入参数，那么将基于原数组浅复制生成一个一模一样的新数组（数组指向新的地址空间，但是数组内的引用类型依旧与原来的数组共用一块内存空间）。[关于深拷贝与浅拷贝]()

##### join

join() 方法将数组中的所有元素连接成一个字符串,并返回该字符串.

##### slice
slice() 方法将数组中一部分元素浅复制存入新的数组对象，并且返回这个数组对象。其返回的返回的范围是 __[start,end)__

__语法: arr.slice([start[,end]])__

参数 start 指定复制开始位置的索引，end如果有值则表示复制结束位置的索引（不包括此位置）。

如果 start 的值为负数，假如数组长度为 length，则表示从 length+start 的位置开始复制，此时参数 end 如果有值，只能是比 start 大的负数，否则将返回空数组。

```
var array = ['a','b','c','d','e','f','g','h','i','j','k','l','m'];
 var arr = array.slice(1,4)
 console.log(arr)
 // b,c,d
```

slice方法参数为空时，同concat方法一样，都是浅复制生成一个新数组。

```
var array = [
    {
      a:{
            b:2
      }
    }
  ]

  var arr = array.slice()
  arr[0].a.b = 3;
  console.log(array[0].a.b);// 3
```

由于slice是浅复制，复制到的对象只是一个引用，改变数组arr的值，array也随之改变。

##### toString
toString() 方法返回数组的字符串形式，该字符串由数组中的每个元素的 toString() 返回值经调用 join() 方法连接（由逗号隔开）组成。

__语法： arr.toString()__

当数组直接和字符串作连接操作时，将会自动调用其toString() 方法。

##### toLocalString
toLocaleString() 类似toString()的变型，该字符串由数组中的每个元素调用各自的 toLocaleString() 并返回值再调用 join() 方法连接（由逗号隔开）组成。

__语法：arr.toLocaleString()__


```
var array = [
    {'name':'jack'},
    123,
    new Date()
  ]
  console.log(array.toString())
  //[object Object],123,Mon Jun 05 2017 21:33:37 GMT+0800 (CST)
  console.log(array.toLocaleString())
  //[object Object],123,2017/6/5 下午9:33:37
```

##### indexOf

indexOf() 方法用于查找元素在数组中第一次出现时的索引，如果没有，则返回-1。

__语法：arr.indexOf(element, fromIndex=0)__

##### lastIndexOf

lastIndexOf() 方法用于查找元素在数组中最后一次出现时的索引，如果没有，则返回-1。并且它是indexOf的逆向查找，即从数组最后一个往前查找。

__语法：arr.lastIndexOf(element, fromIndex=length-1)__


##### includes (ES7)
includes() 方法基于ECMAScript 2016（ES7）规范，它用来判断当前数组是否包含某个指定的值，如果是，则返回 true，否则返回 false。与 indexOf 的区别是，includes 方法可以判断出 NaN。

```
var array = [NaN];
console.log(array.includes(NaN)); // true
console.log(arra.indexOf(NaN)>-1); // false
```

---
### 遍历方法

基于ES6，遍历的方法一共有12个，分别为forEach、every、some、filter、map、reduce、reduceRight 以及ES6新增的方法entries、find、findIndex、keys、values。

##### forEach

forEach() 方法指定数组的每项元素都执行一次传入的函数，返回值为undefined,并且会改变原数组。

语法：arr.forEach(fn, thisArg)
fn 表示在数组每一项上执行的函数，接受三个参数：
value 当前正在被处理的元素的值
index 当前元素的数组索引
array 数组本身
thisArg 可选，用来当做fn函数内的this对象。

```
var arr = ['1','2','3']
 var result = arr.forEach(function (value,index,self) {
    console.log(self[index] = value * value)
    //1,4,9
  })
  console.log(arr)
  // [1,4,9]
  console.log(result)
  // undefined
```

##### every
every() 方法使用传入的函数测试所有元素，只要其中有一个函数返回值为 false，那么该方法的结果为 false；如果全部返回 true，那么该方法的结果才为 true。

语法同 forEach。

##### some
some() 方法刚好同 every() 方法相反，some 测试数组元素时，只要有一个函数返回值为 true，则该方法返回 true，若全部返回 false，则该方法返回 false。


语法同 forEach。

some方法与includes方法有着异曲同工之妙，他们都是探测数组中是否拥有满足条件的元素，一旦找到，便返回true。

##### filter
filter() 方法使用传入的函数测试所有元素，并返回所有通过测试的元素组成的新数组。

语法同 forEach。


##### map
map() 方法遍历数组，使用传入函数处理每个元素，并返回函数的返回值组成的新数组。同样 map 方法默认不会改变原始数组的值。
语法同 forEach。

#### reduce

reduce() 方法接收一个方法作为累加器，数组中的每个值(从左至右) 开始合并，最终为一个值。

语法：arr.reduce(fn, initialValue)

fn 表示在数组每一项上执行的函数，接受四个参数：

* previousValue 上一次调用回调返回的值，或者是提供的初始值
* value 数组中当前被处理元素的值
* index 当前元素在数组中的索引
* array 数组自身

initialValue 指定第一次调用 fn 的第一个参数。

```
var arr = ['1','2','3']
 var result = arr.reduce(function (pre,value,index,arr) {
   return  parseInt(pre)+ parseInt(value)
 },1)
  console.log(arr)
  // ['1','2','3']
  console.log(result)
  // 7
```

#### reduceRight
reduceRight() 方法接收一个方法作为累加器，数组中的每个值（从右至左）开始合并，最终为一个值。除了与reduce执行方向相反外，其他完全与其一致，请参考上述 reduce 方法介绍。

[本文参考](http://louiszhai.github.io/2017/04/28/array/#Array-isArray)


---
### 自定义操作符

---
#### concatAll
concatlAll 和可以将二维数组或对象拆分为一维，并返回一个新的数组。

```
Array.prototype.concatAll = function () {
    let result = [];
    this.forEach(item => result.push(...item))
    return result;
  }
```



---
### 使用map，filter，concatAll 过滤数据

原始数据如下:

```
let courseLists = [
	{
		"name": "My Courses",
		"courses": [
			{
				"id": 511019,
				"title": "React for Beginners",
				"covers": [
					{ width: 150, height: 200, url: "http://placehold.it/150x200"},
					{ width: 200, height: 200, url: "http://placehold.it/200x200"},
					{ width: 300, height: 200, url: "http://placehold.it/300x200"}
				],
				"tags": [{ id: 1, name: "JavaScript" }],
				"rating": 5
			},
			{
				"id": 511020,
				"title": "Front-End automat workflow",
				"covers": [
					{ width: 150, height: 200, url: "http://placehold.it/150x200"},
					{ width: 200, height: 200, url: "http://placehold.it/200x200"},
					{ width: 300, height: 200, url: "http://placehold.it/300x200"}
				],
				"tags": [{ "id": 2, "name": "gulp" }, { "id": 3, "name": "webpack" }],
				"rating": 5
			}
		]
	},
	{
		"name": "New Release",
		"courses": [
			{
				"id": 511022,
				"title": "Vue2 for Beginners",
				"covers": [
					{ width: 150, height: 200, url: "http://placehold.it/150x200"},
					{ width: 200, height: 200, url: "http://placehold.it/200x200"},
					{ width: 300, height: 200, url: "http://placehold.it/300x200"}
				],
				"tags": [{ id: 1, name: "JavaScript" }],
				"rating": 5
			},
			{
				"id": 511023,
				"title": "Angular2 for Beginners",
				"covers": [
					{ width: 150, height: 200, url: "http://placehold.it/150x200"},
					{ width: 200, height: 200, url: "http://placehold.it/200x200"},
					{ width: 300, height: 200, url: "http://placehold.it/300x200"}
				],
				"tags": [{ id: 1, name: "JavaScript" }],
				"rating": 5
			}
		]
	}
];
```

要得到的目标数据:

```
[{
  cover: "http://placehold.it/150x200",
  id: 511019,
  title: "React for Beginners"
}, [object Object] {
  cover: "http://placehold.it/150x200",
  id: 511020,
  title: "Front-End automat workflow"
}, [object Object] {
  cover: "http://placehold.it/150x200",
  id: 511022,
  title: "Vue2 for Beginners"
}, [object Object] {
  cover: "http://placehold.it/150x200",
  id: 511023,
  title: "Angular2 for Beginners"
}]
```

答案:

```
Array.prototype.concatAll = function() {
  var result = []
  this.forEach(item => {
    result.push(...item);
  })
  return result;
}

var result = courseLists
				.map(list => list.courses
					.map(course => course.covers
                          .filter(cover => cover.width === 150)
                          .map(item => ({
                            id: course.id,
                            title: course.title,
                            cover: item.url
                          }))
          ).concatAll()
        ).concatAll()

console.log(result);
```

