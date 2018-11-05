---
title: 前端之坑(1)之原生JavaScript
date: 2017-01-05
tags: ['JavaScript','前端之坑']
toc: true
categories: technology

---
### 0x00 原生JavaScript

---
#### 0x00 undefined && null

JS 定义了两个特别的值，`undefined` 和 `null`。当试图读取没有赋值的变量或试图取不存在的对象属性时会返回 `undefined`。

而对于 `null`，好吧，这是个神奇的符号，它可以是基本的值 `null`,也可以是对象 `null`,它是 JS 原型链的顶层，所有的对象都是在它之下衍生出来的，它无处不在又变化多端，所以在此只记录其与 `undefined` 的区别。

由于 JS 的强制类型转换，下布尔环境中，`null` 与 `undefined` 都会被转换为 `fasle`。

所以，有时会遇到如下情况:

```
console.log( null == undefined);
// true
```

所以，并不是说 `null` 和 `undefinde` 是相等，只是它们都被转换为了布尔值.

```
console.log( null === undefined);
// false
```

但是多数情况下，我们并不关心一个值到底是 `null` 还是 `undefined` ，因为这两种情况我都需要排除掉，那么这时可以使用 **if** 语句和否定运算符 **(!)** :

```
if(!myData.name){
    //do something
};
```


### 0x01 DOM 操作

---
#### 0x00 element.style.height
对于 `element.style.height` 只能在 div 在行内样式设置了 `height` 才能读取,如果 `height` 值不写在行内样式（即是若没有在 `html` 和用 `js` 设置 `height` 时），`style.height`为 **undefind**，无法获取；

所以在需要获得元素的高度时,推荐使用 `ele.offsetHeight`。

> 同样 `ele.style.width` 存在同样的问题。

不定期更新。。。

