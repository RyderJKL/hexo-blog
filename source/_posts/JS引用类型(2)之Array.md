---
title: JS引用类型(2)之Array          
date: 2017-01-21     
tags: ['JavaScript','JS引用类型']
toc: true
categories: technology

---
### 0x00 Array object

JS 数组的每一项可以保存任何类型的数据，并且 JS 的数组大小是可以动态调整的，即可以随着数据的添加自动增长以容纳新的数据。

JavaScript 中没有明确的数组数据类型。但是，我们可以通过使用内置 **Array** 对象和它的方法对数组进行操作。


---
#### creating an array

##### 使用 Array 构造函数创建数组

```
var arr = new Array(a, b, c,...N);
var arr = Array(a, b, c,..N);
```

##### 使用数组字面量创建数组

```
var arr = [a, b, c, ..N];
```


> var arr = [4] 和 var arr = new Array(4) 是不等效的，后者指的是数组长度。

##### 创建指定长度的空数组

```
var arr = new Array(arraylength);
var arr = Array(arraylength);

//以下等效
var arr = [];
arr.length = arrrayLength;
```

---
### 0x01  数组与对象
数组可以作为一个属性(property)分配给一个新的或者已经存在的对象(object).

```
var obj = {};
obj.prop = [element0, element1, ..., elementN];

//or
var obj = { prop:[element0, element1, ..., elementN]};

```

---
### 0x02 填充数组 (populating an array)

#### 给元素赋值以填充数组

```
var emp = [];
emp[0] = "haha";
emp[1] = "heihei";
```

#### 创建数组时填充

```
var myArray = new Array("hello", myVar, 3.1244);

//or
var myArray = ["mna", "apple", "orange"];
```

---
### 0x03 数组的 length 属性
有趣的是， length 属性不是只读的，可以通过 lenght 属性从数组的末尾移除或添加元素。

指定 length 长度以删除最后一个元素

```
var colors = ["red", "blure", "green"];
colors.length = 2;
```

使用 length 向末尾添加元素

```
colors[colors.length] = "black";
```


---
### 0x04 检测数组
可以使用 `instanceof` 操作符来检测数组

```
if (value instanceof Array){
    do something;
}
```

但是当网页包含多个框架是使用 instanceof 就可能存在问题。所以使用 **Array.isArray()** 也许更好。

```
if ( Array.isArray(value)) {
    do something;
}
``` 


---
### 0x05 数组方法 array methods

---
#### toString(),valueOf(),toLocalString()

当然，所有对象都具有 `toString()`,`valueOf()`,`toLocalString()` 这三种方法。

调用数据的 `toString()` 会返回一个
由数组元素拼接而成的用逗号隔开的字符串:

```
var colors = ["red", "blue", "green"];
console.log(colors.toString())
// 字符串: red,blue,green
```

而调用数组的 `valueOf()` 方法返回的还是数组。


---
#### join() 
join() 方法只接受一个参数，就是用作分隔符的字符串，然后返回所有数组项的字符串。

```
var colors = ["red", "green", "white"];
colors.join("||"); // red||green||white
```

---
#### 重排序 sort(), reverse()
`sort()` 方法会调用每个数组项的 `toString()` 方法，再按数组项的 ASCAII 码进行排序，并且会改变原来数组的顺序。所以 `sort()` 方法并不适合对全数字的数组进行排序。

##### 使用 sort() 方法对数组元素进行随机排列

```
var arr = ["红","橙","黄","绿","黑"]
arr.sort(function(a,b){ var num = Math.random()-0.5
    return num;
})
```

`reverse()` 方法可以反转数组项的顺序,同样的 `reverse()` 函数也会改变原始数组的顺序。


---
#### unshift(), shift()
`shift()` 能够移除数组的第一项并返回该项，同时将数组的长度减 1
。

```
var colors = new Array();
var count = colors.push("red", "green");
alet(count); //2

colors.push("black");

var item = colors.shift(); // red;
```

`unshift()` 作用与 `shift()` 相反，它在数组前端添加 n 个任一项并返回新的数组长度。

---
#### 栈的方法 push(), pop()
栈是一种 LIFO( Last In First Out 后进先出)的数据结构，也就是最新添加的项最后被移除，而栈中项的插入叫 **推入** 和 删除叫 **弹出**。JS 提供了 push() 和 pop() 方法，以类似栈的行为。 

push() 方法可以接受任意数量的参数，把它们逐个添加到数组末尾，并返回修改以后的数组长度。

```
var colors = ["red", "blue", "green"];
console.log(colors.push('balck'));
// 4
```

pop() 方法则是从数组末尾移除一项，减少 length 的值，然后返回移除的项。


```
var colors = ["red", "blue", "green"];
console.log(colors.push('balck'));
// 4
console.log(colors.pop());
// black
```

---
#### 队列的方法 
栈数据结构的访问规则是 LIFO(后进先出的)，而队列的访问规则是 FIFO(First In First Out)，先进先出的。由于 `push()` 是向数组末端添加项的方法。那么，结合 `push()` 和 `shitft()` 便可以像使用队列那样使用数组了。

`unshift()` 结合 `pop()` 可以从相反的方向来模拟队列。

---
#### concat() 
`contact()` 方法会先创建一个当前数组的一副本，然后将接收到的参数添加到这个副本的末尾，最后返回新构建的数组。

`concat()` 方法不会影响到原始数组。

---
#### slice()
slice() 方法同样会先创建一个当前数组的副本，然后在只有一个参数的情况下返回从该参数指定位置到当前数组末端的所有的项；在有两个参数的情况下，则返回从该参数开始的位置到结束位置之间的项---但是不包括结束位置。

```
arr = [1,3,4,56]
arr2 = arr.slice(0);
```

`slice()` 方法不会影响到原始数组。

在函数式编程的术语中，我们说它是一个 **纯函数**。

```
var colors = ["red", "blue", "green", "balck"];
console.log(colors.slice(1));
// ["blue", "green", "balck"]
console.log(colors);
// ["red", "blue", "green", "balck"]
console.log(colors.slice(1));
// ["blue", "green", "balck"]
console.log(colors);
// ["red", "blue", "green", "balck"]
```


---
#### splice() 
`splice()` 要用途主要是在数组的中部插入项。它有以下3种用法:

删除: 可以删除任意数量的项，并且只需要两个参数，要删除的第一项的位置和要删除的项数。

```
splice(2); //从下标为 2 的位置开始删除以后的所有
```

```
splice(0, 2); //将会删除数组中的前两项
```

插入: 可向指定位置插入任意数量的项，只需三个参数: 起始位置，0（要删除的数），要插入的项。

```
splice(2,0,"red","green","white"); //从下标为 2 的位置开始插入
```

替换: 只需指定三个数： 起始位置，要删掉的项数，要插入的任意数量的项。

```
splice(2,1,"red","green");
```

`splice()` 方法始终都会返回一数组，该数组包含从原始数组中删除的项（没有删除的项则会返回一个空数组）。

但是 `splice()` 方法会影响到原始数组。

在函数式编程的术语中，我们说它是一个 **非纯函数**。

```
var colors = ["red", "blue", "green", "balck"];
console.log(colors.splice(0, 1));
// ["red"]
console.log(colors);
// ["blue", "green", "balck"]
console.log(colors.splice(0, 1));
// ["blue"]
console.log(colors);
// ["green", "balck"]
console.log(colors.splice(0, 1));
// ["green"]
console.log(colors);
// ["balck"]
```

---
#### indexOf(), lastIndexOf()
`indexOf()` 和 `lastIndexOf()` 都返回要查找的项在数组中的位置。它们都接收两参数:要查找的项 和表示查找起点位置的索引。

其中 `indexOf()`从数组的的开头开始向后找，`lastIndexOf()`从数组的末尾开始向前找。

```
var colors = new Array("red","green","black","dfjsl");
alert(colors.indexOf("black")); // 2
alert(colors.indexOf("dfjsl",2)); //3
```

---
### 0x06 迭代方法

##### for 循环遍历数组

```
for (var i = 0;i < arr.lenght; i++) {
    statement
}
```

##### forEach() 方法遍历数组

```
var colors = ['red', 'green', 'blue'];
    colors.forEach(function (color){
        document.write(color);
    });
```

forEach() 函数将数组元素作为参数依次迭代传递给 function.

> 一旦 JS 元素被保存为标准的对象属性，再使用 `for..in` 循环来迭代将变得非常不适用，因为正常元素和所有可枚举的属性都会被列出。

当然，ES6 提供了一种新的遍历的方法，`for...of`， 它比以上任何方法都强大易用。
JS 为数组定义了5个迭代方法，这些方法都接收三个参数： 数组项的值，该项在数组中的位置，数组对象本身。

##### erery()，some()

对 every() 来说，传入的参数必需对每一项都返回 true，这个方法才返回 true；否则，返回false。而 some() 方法则只要传入的函数对数组中的某一项返回 true，就会返回 true。

```
var numbers = [1,2,4,5];
 var everyResult = numbers.every(function(item,index,array){
    return (item > 2);
});

alert(everyResult); // false

var somerResult = numbers.some(function(item,index,array){
    return (item > 2);
});

alert(someResult); // true;
```

##### filter()
filter() 方法对查询某些符合条件的所有数组项非常有用。

```
var numbers = [1,2,6,4,78,12,34];
    var filterResult = numbers.filter(function(item,index,array){
        return (item > 2);
    });

    alert(filterResult);  // 6,4,78,12,34
```

##### map()
map() 同样返回数组，而这个数组时在原始数组的基础上经过函数运行以后的数组项集合。

```
var numbers = [1,2,6,4,78,12,34];
    var mapResult = numbers.map(function(item,index,array){
        return (item*2)
    });
    alert(mapResult);
```

> 本文更新日志: 
2016-9-25;
2016-10-11;
2016-12-25;
2017-01-21;

