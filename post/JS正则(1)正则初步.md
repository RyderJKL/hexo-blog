---
title: JS正则(1)正则初步
date: 2016-09-29
tags: ['JavaScript','JS正则']
toc: true
categories: technology

---

### 0x00 RegExp 类型
**JS** 通过 **RegExp** 类型来支持正则表达式，通过下面的语法便可以创建一正则表达式:

```
var experssion = / pattern / flags;
```

`pattern` 部分可以是任何简单或者复杂的正则表达式。

每个正则表达式带有一个或者多个标志 `flags` 以表明正则表达式的行为。

正则表达式的匹配模式支持一下三个标志:

* g : 全局 (global) 模式。
* i : 表示不区分大小写 (case-insensitive) 模式。
* m : 多行 (multiline) 模式。


---
### 0x01 构建正则表达式

与其它语言中的正则表达式类似，模式中的所有 **元字符** 都必需进行转义处理。

```
/*
* 匹配第一个 "bat" 或者 "cat" ,不区分大小写
*/

var pattern1 = /[bc]at/i;

/*
* 匹配第一个 "[bc]at",不区分大小写
*/

var pattern2 = /\[bc\]at/i;
```

正则表达中的
**元字符**包括： `(` `[` `{` `\` `^` `$` `|` `)` `?` `*` `+` `.` `]` `}`


以上例子都是通过 **字面量形式创建正则表达式**, 我们还可以通过 **RegExp 构造函数创建正则表达式**。

```
//字面量形式构建正则表达式
var pattern1 = /[bc]at/i;

// RegExp 构造函数构建正则表达式
vat pattern2 = new RegExp("[bc]at", "i");
```

值得注意的是，RegExp 构造函数接受的两个参数都是字符串(不能把正则表达式字面量传递给 RegExp构造函数)。当然也正因如此，所有存在于 RxgExp 构造函数中的 `元字符` 都必需进行双重转义，即使已经转义过的也是如此。

下面是使用 RegExp 构造函数定义形同模式时使用的字符串。

字面量 | 等价字符串
:---:|:---
/\\[bc\\]at/| "\\\\[bc\\\\]at"
/\.at/|"\\\\.at"
/\w\\\hello\\\123/|"\\\\w\\\\\\\\hello\\\\\\\\123"


> 使用正则表达式字面量和使用 RegExp 构造函数创建的正则表达式不一样，正则表达字面量始终会共享同一个 RegExp 实例，而使用构造函数的每一个新 RegExp 实例都是一个新实例。
?????
> 字面量使用正则的方式是最常用的


---
### 0x02 RegExp 实例方法

#### exec()
exec() 方法专门为捕获组而设计。exec() 接收一个要匹配的字符串作为参数，然后返回包含第一个匹配项信息的数组，虽然是是 `Array` 实例但是它包含有两额外的属性: `index` 和 `input`。index 表示匹配项在字符串中的位置， input 表示应用正则表达的字符串。

然后，在返回的 `Array` 数组实例中，第一项是与整个模式匹配的字符串，其他项是与模式中的捕获组匹配的字符串。

```
var text = "mom and dad and babay";
var pattern = /mom( and dad( and babay)?)?/gi;

var matches = pattern.exec(text);
console.log(matches.index);     //0
console.log(matches.input);     //整个字符串
console.log(matches[0]);        //整个字符串
console.log(matches[1]);        //and dad and baby
console.log(matches[2]);        // and baby
```

#### test()
test() 方法接收一个字符串作为参数，在模式与该参数匹配的情况下返回 true；否则返回 false。

test() 方法通常和 if 语句结合用于验证用户输入。

```
var text = "000-00-0000";
var pattern = /\d{3}-\d{2}-\d{4}/;

if(pattern.test(text)){
	alert("yes,this is true");
}
```


---
### 0x03 使用正则表达式匹配字符串


---
#### match()
**受到全局行为的影响**,全局搜索时，返回所有匹配值的数组。非全局时，返回第一个匹配到的值(返回的是一个类数组)

```
var str = "123jsdlf123jkdf123jd";
var regStr = /j/g;
console.log(str.match(regStr));
//返回数组:["j", "j", "j"]
```

---
#### search()
**不受全局行为的影响**，只返回第一个匹配字符串所在位置的**下标**。

```
var str = "123jsdlf123jkdf123jd";
var regStr = /j/g;
console.log(str.search(regStr));
//返回下标:3
```

---
#### replace
**受到全局行为的影响**,接收两个参数，第一是匹配项，第二个可以是字符串或者函数；全局搜索时替换全部，非全局时只会替换第一个。所有模式下返回的均是字符串。

```
var str = "123jsdlf123jkdf123jd";
var regStr = /j/g;
console.log(str.replace(regStr,"I Love You"));
//返回字符串:123I Love Yousdlf123I Love Youkdf123I Love Youd
```

---
### 0x02 特殊字符

* ^ :表示字符串的开始位置
* $ :表示字符串末尾危位置
* {} :表示匹配次数
* ? :匹配前一个表示式0次或1次
* \* :匹配前一个表达式0次或无穷次
* \+ :匹配前一个表达式一次或者无穷次，等同于 {1,}
* [] :表示有一系列字符可供选择，只要匹配其中一个边可以了
* \- :表示字符的连续范围


---
### 0x04 预定义匹配模式
* \d :匹配0-9之间的任意数字，[0-9]
* \D :匹配非数字，[^0-9]
* \w :匹配任意的字母，数字，下划线,[A-Za-z0-9]
* \W :匹配除所有的字母，数字，下划线,[^A-Za-z0-9]
* \s :匹配空格，制表符，断行符
* \S :匹配非空格等的字符
* \b :匹配单词边界
* \B :匹配非单词边界
* [\b]:匹配一个空格
---
### 0x05 高级匹配模式
* (X):捕获括号。匹配 'X' 并且记住匹配项。

```
var str = "foobarfoobar"
var pattern = /(foo)(bar)\1\2/
//'(foo)' 和 '(bar)' 匹配并记住字符串 "foo bar foo bar" 中前两个单词。
\1 和 \2 匹配字符串的后两个单词。
```

注意 \1、\2、\n 是用在正则表达式的匹配环节。在正则表达式的替换环节，则要使用像 $1、$2、$n 这样的语法，例如，'bar foo'.replace( /(...) (...)/, '$2 $1' )。

* (?:x):非捕获括号。
表达式是 /foo{1,2}/，{1,2}将只对 ‘foo’ 的最后一个字符 ’o‘ 生效。如果使用非捕获括号/(?:foo){1,2}/.，则{1,2}会匹配整个 ‘foo’ 单词。

* x(?=y):正向肯定查找。匹配'x'仅仅当'x'后面跟着'y'.

* x(?!y):正向否定查找。。匹配'x'仅仅当'x'后面不跟着'y'.

```
var pattern1 = /\d+(?!\.)/
var str1 = "3.123"
console.log(pattern1.exec(str1));
//123
```

/\d+(?!\.)/匹配一个数字仅仅当这个数字后面没有跟小数点的时候。

---
### 0x07 常用匹配算法

---
#### .* 贪心算法

---
#### *? 非贪心算法

---
#### (.*?) 内容提取


