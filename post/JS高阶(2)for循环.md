---
title: JS高阶(2)for循环   
date: 2016-12-13       
tags: ['JavaScript','JS高阶']
toc: true
categories: technology

---
### 0x00 for

我们先从最经典的 `for` 循环开始:

```
for ( var i = 0;i < arr.length;i ++) {
    console.log(i);
}
```

---
### 0x01 forEach

而从 ES5 开始我们可以使用 `forEach` 方法来遍历数组:

```
var lis = document.querySelectorAll("ul li")

	lis.forEach(function(ele, index, arr){
		console.log(ele, index, arr)
	})
```

确实，使用 `forEach` 使得代码看起来更为简洁，但是在 `forEach` 中，我们不能使用 `break` 中断循环，也不能使用 `return` 语句返回到外层函数。

---
### 0x02 for...in

当然，也可以尝试使用 `for...in` 循环:

```
for (var i in arr ) {
    console.log(typeof i);
    // String
}
```

但是最好别这么做:

1. 首先 `i` 的值并不是数字，而是字符串类型。
2. `for..in` 循环除了遍历数组中的元素外，还会遍历自定义属性。

简而言之，`for...in` 是为普通对象设计的，更适合用来遍历对象属性，而并不适合于数组遍历。

---
### 0x03 for...of
ES6 提供了一种新的循环语法，即是强大的 `for...of` 循环:

```
for(var i of arr){
    console.log(i);
}
```

可以说，`for...of` 循环是最简洁，直接，有效遍历数据元素的语法。它不仅避开了 `for...in` 循环的所有缺陷，而且还可以正确的响应 `break`,`continue`,`return`语句。


但是，除此之外，`for...of` 同样可以用来遍历对象属性，甚至字符串。因为 `for...of` 循环可以遍历所有具备 **迭代器(Iterator)** 接口的集合。

