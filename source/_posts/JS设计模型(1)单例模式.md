# JS设计模式(1)单例模式

---
title: JS设计模式(1)单例模式
date: 2017-02-06
tags: ['JavaScript','JS设计模式']
toc: true
categories: technology

## 0x00 全局变量

首先需要明确的一点是，全局变量并不是单例模式。虽然，我们经常在 JavaScript 的开发中将全局变量当做单例来使用。

而对于全局变量，其最大的问题莫过于造成命名空间污染。

而为了最大程度的减少命名冲突，最常用的手段是使用闭包构建块级作用域以封装私有变量。

## 0x01 惰性单例

**惰性单例** 指的是在需要的时候才创建实例，并且只创建一个实例。

```js
let getSingle = function (fn) {
  let result;
  // result 变量存在于闭包中，永远不会被销毁，而在将来的请求在中，如果
  // result 已经被赋值，那么它将返回该值。
  return function () {
      return result || (result = fn.apply(this, arguments));
  }
}
```

单例模式将会非常有用，比如可以用来创建一个唯一的登录浮窗对象，但是，我们并不希望这个浮窗在页面加载完成的时候就已经创建完成，因为有时候用户可能并不会登录，而是希望当用户点击登录按钮时才创建浮窗。

```js
let createLoginLayer = function () {
  let div = document.createElement('div');
  div.innerHTML = "我是登录浮窗";
  div.id = "loginLayer";
  div.style.display = "none";
  document.body.appendChild(div);
  return div;
}

let createSingleLoginLayer = getSingle(createLoginLayer);

document.querySelector("#logBtn").onclick = function (e) {
    let loginLayer = createSingleLoginLayer();
    loginLayer.style.display = 'block';
}
```

单例模式最巧妙的地方在于，**创建对象和管理单例的职责** 被分布在两个不同的方法中，而只有当这两个方法组合起来才能发挥出单例模式的威力。

> 单例模式的核心是确保只有一个实例，并提供全局访问

