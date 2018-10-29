---
title: ES6(2)let和const    
date:  2016-12-17   
tags: ['ES6']
toc: true
categories: technology

---
### 0x00 let
`let` 命令所声明的变量只在 `let` 命令所在的代码块内有效。

对于 `for` 循环，`let` 命令就很好了。

```
for(let i = 0; i < 10; i++){}
console.log(i)
// ReferenceError
```

计数器 `i` 只在 `for` 循环体内有效，在循环体外引用就会报错。

此外，`let` 不像 `var` 那样会发生“变量提升”现象。所以，变量一定要在声明后使用，否则报错。

```
console.log(foo) // 输出undefined
console.log(bar) // 报错ReferenceError

var foo = 2;
let bar = 2;
```

> `var` 命令允许重复声明，后面的声明会覆盖前面的。但是 `let` 和 `const` 命令不允许重复

---
#### 暂时性死区
ES6明确规定，如果区块中存在let和const命令，这个区块对这些命令声明的变量，从一开始就形成了封闭作用域。凡是在声明之前就使用这些变量，就会报错。这在语法上，称为“暂时性死区”（temporal dead zone，简称TDZ）。

这样的设计是为了让大家养成良好的编程习惯，变量一定要在声明之后使用，否则就报错。

```
if (true) {
  // TDZ开始
  tmp = 'abc'; // ReferenceError
  console.log(tmp); // ReferenceError

  let tmp; // TDZ结束
  console.log(tmp); // undefined

  tmp = 123;
  console.log(tmp); // 123
}
```

---
#### 块级作用域

`let` 实际上是提供了一个块级作用域，ES5 时没有块级作用域的，只有全局作用域和函数作用域，而在 ES5 很可能造成两种后果:1)内层变量可能会覆盖外层变量。 2)用来计数的循环变量泄露为全局变量。

```
function f1(){
    let n = 5
    if (true) {
        let n = 10
    }
    console.log(n) // 5
}
```

ES6允许块级作用域的任意嵌套。外层作用域无法读取内层作用域的变量,内层作用域可以定义外层作用域的同名变量。

块级作用域的出现，实际上使得获得广泛应用的立即执行函数表达式（IIFE）不再必要了。

```
// IIFE
(function (){
    var tmp = ...;
}())

// 块级作用域
{
    let tmp = ...;
}
```

---
### 0x01 const
`const` 声明一个只读常量。一旦声明，常量的值就不能改变，即必须立即初始化，不能留到以后赋值。其作用域与 `let` 命令相同，只在块级作用域有效。

```
if(true){
  const MAX = 5
}

console.log(MAX)
// ReferenceError: MAX is not defined(…)
```

值得注意的是当使用 `const` 声明一个变量指向一个引用类型时，`const` 能保证只是变量名指向的地址不变，和该地址中数据没有关系。

```
const a = []
a.push("hello") // 可执行
a.length = 0;	//  可执行
// a = ['dfdf'] //  尝试改变 a 的指向，报错
```


---
### 0x02 对象冻结
可以使用 `Object.freeze` 方法来冻结一个对象。

```
const foo = Object.freeze({})
foo.prop = 123; // 不起作用
```

除了冻结对象本身，对象的属性也可以被冻结。使用下面的函数可以将一个对象彻底冻结。

```
var constFreeze = (obj) => {
	Object.freeze(obj)
	Object.keys(obj).forEach((key, value) => {
		if( typeof obj[key] == 'object') {
			constFreeze(obj[key])
		}
	})
}
```

ES6除了添加 `let` 和 `const` 命令，还要 `import` 和 `class` 方法可以声明变量，加上 ES5 中的两种声明变量的方式,`var` 和 `function`，ES6 一共有 6 种声明变量的方法。


---
### 0x03 顶层对象
顶层对象，在浏览器环境指的是 `window` 对象，在Node指的是 `global` 对象。ES5之中，顶层对象的属性与全局变量是等价的。

顶层对象的属性与全局变量挂钩，被认为是JavaScript语言最大的设计败笔之一。

ES6 为了改变这一点，依旧规定 `var` 命令和 `function` 命令声明的全局变量，依旧是顶层对象的属性。而 `let` 命令、`const` 命令、`class` 命令声明的全局变量，不属于顶层对象的属性。

```
var c = 123

window.alert(window.c) // 1

let b = 456
window.alert(window.b) // undefined
```

> 从ES6开始，全局变量将逐步与顶层对象的属性脱钩。

