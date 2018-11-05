---
title: 数组去重与排序
date: 2016-12-13
tags: ['JavaScript','JS高阶']
toc: true
categories: technology

---
### 0x00

sort() 方法对数组的元素做原地的排序，并返回这个数组。它可以接受一个函数
( compareFunction )来进行某种特定顺序的排列。如果省略，则按照数组中元素的 Unicode 编码进行排序。

而sort()对于  compareFunction 的返回值将做如下处理:

* 如果 compareFunction(a, b) 小于 0 ，那么 a 会被排列到 b 之前；
* 如果 compareFunction(a, b) 等于 0 ， a 和 b 的相对位置不变。
* 如果 compareFunction(a, b) 大于 0 ， b 会被排列到 a 之前。


---
### 0x01 sort() 对数字排序
希望比较数字而非字符串，比较函数可以简单的以 a 减 b，如下的函数将会将数组升序排列。

```
var numbers = [4, 2, 5, 1, 3];
numbers.sort(function(a, b) {
  return a - b;
});
console.log(numbers);

// [1, 2, 3, 4, 5]
```

