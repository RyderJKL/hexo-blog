---
title: 类数组与Arguments
date: 2016-06-14       
tags: ['JavaScript','JS高阶']
toc: true
categories: technology

---
### 类数组与鸭式辩型
所谓类数组对象:
> 拥有一个 length 属性和索引属性的对象。

```
var array = ['name', 'age', 'sex'];
var arrayLike = {
    0: 'name',
    1: 'age',
    2: 'sex',
    length: 3
}
```

`arrLike` 就是一个类数组对象，在某种程度我们可以将其当作一个数组来处理，比如读写操作`console.log(arrLike[0])`,`arrLike[1] = "email"`;获取长度`arrLike.length`;遍历`for(let item in arrLike)`等。但是类数组对象依然不具备数组所特有的属性或者方法。

像上面这中`arrLike` 虽然不是数组, 但我们把它当做数组处理, 这种现象叫做 **鸭式辩型**，同样`arguments` 也是一个鸭式辩型。

在javascript里面，很多函数都不做对象的类型检测，而是只关心这些对象能做什么，那么从这个角度理解，**原型的本质其实就是对行为的继承**,因此我们尽可利用鸭式辨型的便利,比如将 `arguments` 当作一个数组来处理:

```
function myConcat(seperator) {
    console.log(seperator)
  let args = Array.prototype.slice.call(arguments,1);
  console.log(args)
  return args.join(seperator)
}
console.log(myConcat(",","red","blue","orange"))
```

当然，我们也可以直接将 `arguments` 对象转换为数组:

```
argsArray = Array.prototype.slice.call(arguments);
argsArray = Array.prototype.splice.call(arguments,0)
argsArray = Array.prototype.concat([],arguments)
argsArray = ...arguments // ES6
argsArray = Array.from(arguments) // ES6
```

### Arguments
`Arguments` 对象具备的几个主要属性如下:

* `length`: 代表函数的是实际参数个数
* `calle`:  代表函数本身（严格模式(“use strict“)下, `arguments.callee` 不可用.
* `properties-indexes (字符串类型的整数)`： 该属性的值就是函数的参数值(按参数列表从左到右排列)。 `properties-indexes`内部元素的个数等于`arguments.length`。`properties-indexes` 的值和实际传递进来的参数之间是共享的（但是在严格模式下不共享）。

```
function fn(a,b,c){
  console.log(arguments.length)
}
console.log(fn.length);
fn(1);
// 实参: 1
// 形参: 3
```

[参考一:鸭式辩型](http://louiszhai.github.io/2015/12/15/arguments/#鸭式辩型)
[参考二:arguments](https://github.com/mqyqingfeng/Blog/issues/14)

