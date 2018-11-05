---
title: 字符串操作API
date: 2016-10-13
tags: ['JavaScript基础进阶']
toc: true
categories: technology

---

`String` 原型上的方法有两种，与 `HTML` 有关的和与 `HTML` 无关的。

---
### 与 HTML 有关的字符串方法

##### charAt
`charAt` 方法返回字符串中指定索引的字符。

语法： _charAt(index)_

`index` 的值为 `0 ~ string.length`

##### charCodeAt
`charCodeAt` 返回字符串中指定索引位置处字符的 `Unicode` 编码。

语法： _charCodeAt(index)_


##### concat
`concat` 与数组中的 `concat` 方法类似，可以将一个或者多个字符连接在一起。但是其性能较差，比直接使用 `+` 作要差很多。

语法： _str.concat(str1,str2....)_


##### indexOf,lastIndexOf
`indexOf()` 方法用于查找子字符串在字符串中首次出现的位置，没有则返回 `-1`。该方法严格区分大小写，并且从左往右查找。而 `lastIndexOf` 则从右往左查找，其它与前者一致。

语法：_str.indexOf(searchValue [, fromIndex=0])，str.lastIndexOf(searchValue [, fromIndex=0])_


##### match
`match` 方法用于测试字符串是否支持指定正则表达式的规则，即使传入的是非正则表达式对象，它也会隐式地使用 `new RegExp(obj)` 将其转换为正则表达式对象。

语法: _ str.mathc(RegExp)_
该方法返回包含匹配结果的数组，如果没有匹配项，则返回 null。

注意:
* 若正则表达式没有 g 标志，则返回同 RegExp.exec(str) 相同的结果。而且返回的数组拥有一个额外的 input 属性，该属性包含原始字符串，另外该数组还拥有一个 index 属性，该属性表示匹配字符串在原字符串中索引（从0开始）。
* 若正则表达式包含 g 标志，则该方法返回一个包含所有匹配结果的数组，没有匹配到则返回 null。

```
let str = 'abcdefg!'
console.log(str.match(/[a-d]/i))
//["a", index: 0, input: "abcdefg!"]
```

** 相关的 RegExp 方法 **

* 若需测试字符串是否匹配正则，使用 `RegExp.test(str)`
* 若只需第一个匹配结果，使用 `RegExp.exec(str)`


##### replace


##### search
`search` 方法用于测试字符串对象是否包含某个正则匹配，相当于正则表达式的 `test` 方法，且该方法比 `match()` 方法更快。如果匹配成功，`search()` 返回正则表达式在字符串中首次匹配项的索引，否则返回-1。该方法不支持全局匹配。

语法: _str.search(regexp)_

```
let str = 'abcdefg'
console.log(str.search(/[a-g]/))
// 3, 匹配到子串"defg",而d在原字符串中的索引为3
```

##### slice
`slice` 方法提取字符串的一部分，并返回新的字符串。该方法类似于 `Array.prototype.slice()` 方法。

语法： _str.slice(start,end)_

同样取值的索引是 _[start,end)_。

##### split
`split()` 方法把原字符串分割成子字符串组成数组，并返回该数组。

语法： _str.split(separator,limit)_

两个参数均是可选的，其中 `separator` 表示分隔符，它可以是字符串也可以是正则表达式。如果忽略 `separator`，则返回的数组包含一个由原字符串组成的元素。如果 `separator` 是一个空串，则 `str` 将会被分割成一个由原字符串中字符组成的数组。`limit` 表示从返回的数组中截取前 `limit` 个元素，从而限定返回的数组长度。


使用正则分割字符串:

```
let str = 'today is a sunny day'
 console.log(str.split(/\s*is\s*/))
// ["today","a sunny day"]
```

若正则分隔符里包含捕获括号，则括号匹配的结果将会包含在返回的数组中。

```
console.log(str.split(/(\s*is\s*)/)); // ["today", " is ", "a sunny day"]
```

##### substr
`substr（）` 方法返回字符串指定索引位置开始的指定数量的字符。

语法： _str.substr(start[,length])_

`start` 表示开始截取字符的位置，可取正值或负值,`length` 表示截取的字符长度。

取正值时表示`start`位置的索引，取负值时表示 `length+start`位置的索引(此时的参与计算的 `length` 表示原始字符串的长度)。

##### substring
`substring()` 方法返回字符串两个索引之间的子串。

语法： _str.substring(indexA,[indexB])_

有效范围是 `[indexA,indexB)`。

##### toLocaleLowerCase、toLocaleUpperCase

`toLocaleLowerCase()` 方法返回调用该方法的字符串被转换成小写的值，转换规则根据本地化的大小写映射。而 `toLocaleUpperCase()` 方法则是转换成大写的值。


##### toLowerCase、toUpperCase
这两个方法分别表示将字符串转换为相应的小写，大写形式，并返回。

##### toString,ValueOf
这两个方法都是返回字符串本身。

语法： _str.toString(), str.valueOf()_

两者在对对象的处理上面存在一些差异：

```
var x = {
    toString: function () { return "test"; },
    valueOf: function () { return 123; }
};
console.log(x); // obj
console.log("x=" + x); // "x=123"
console.log(x + "=x"); // "123=x"
console.log(x + "1"); // 1231
console.log(x + 1); // 124
console.log(["x=", x].join("")); // "x=test"
```

当 “+” 操作符一边为数字时，对象x趋向于转换为数字，表达式会优先调用 `valueOf` 方法，如果调用数组的 `join` 方法，对象x趋向于转换为字符串，表达式会优先调用 `toString` 方法。

##### trim
`trim()` 方法清除字符串首尾的空白并返回。

使用 `replace` 实现 `trim` 方法

```
function trim(str){
  return str.replace(/(^\s*)|(\s*$)/g,"")
}
```

