---
title: JS极速入门                
date: 2016-9-25     
tags: ['JavaScript']
toc: true
categories: technology

---

### 0x00 认识JS
JS由三部分组成：核心(ECMAScript)，文档对象模型(DOM),浏览器对象模型(BOM).

---
### 0x01 声明 (Declatations)

JS 有三种声明:  
`var` : 声明变量  
`let` : 什么块范围局部变量( block scope local variable)   
`const` : 声明一个只读常量( ready only)



> 用 var 或 let 声明的未赋初值的变量，值会被设定为 undefined,试图访问一个未被初始化的变量会导致一 `ReferenceError` 异常抛出。

> undefined 值在 Bollean 环境中会被当做 false，在数值类型环境中会被转换为 NaN(Not a Number).

> 空值 null 在数值环境中会被当做 0 来对待；在 布尔环境中则会当做 false

---
### 0x02 JS的命名规则

JS 是大小写敏感的,可以包含字母，数字，下划线，$字符，但是第一个字符不能是数字。



---
### 0x03 JS的数据类型



JS中的数据类型分为7 中数据类型,六种`原型的数据类型`和`Object`(对象)

#### 基本数据类型

基本数据类型有: `String` , `Number` ,  `Boolean` , `Null` , `Undefined`,`Symbol`(一种新的数据类型).

> 对于 `float` 类型数据，当小数点后没有数或者只有零的时候，JS 会将浮点数自动转换成整数,以节省空间。


#### Object 对象

---
### 0x04 Operators

---
#### 一元(目) Unary operators

##### 自增(++) and 自减(--)
在没有进行赋值运算的时候，`++i` 和 `i++` 的作用是相同的。

若是存在赋值运算，当运算符(++)在前时，先自增后赋值，运算符在后时，先赋值再自增。

```
var a=10, b = 20 , c = 30;
++a;//11
a++;//12
var e = (++a) + (++b) + (c++) + (a++);// e = 77
```

##### ++ 的隐式转换

```
var box = '89';
box++;
//box = 90
//数字类型的字符串自动转换为数字 (隐式转换)

var box = `abc`;
box++;
//box 为NaN 尝试将字符串转换为数字，失败

var box = "123adf";
box ++;
//box 为NaN

var box = false;
var box1 = "false";
box1++;
box++;
//box1 = NaN
//box = 1
//false 默认值为 0，自增后为1 (隐式转换)

var box = 2.4;
box++;
//3.4 直接加1
```

##### delete


---
#### Arithmetic operators

常用的算术运算符有:`+`, `-`,  `*`,  `/(除)`, `%((求余))`

> `NaN` 和任何一个数运算得 `NaN`

> 数值和字符串相加，将自动转换为字符串的拼接

> 100/0 , 结果是 `Infinity` 无穷大

> 将一个数值类型的值转换为字符串类型

```
var a = 5;
a = a + " ";
```

 > 将一个字符串类型的数值转换为正在的数值

```
var a = "5";
a = a - 0;
// a = a / 1;
// a = a * 1;
```

##### /(除)

```
a % "" //Infinity
a % null //Infinity
a % "dfsd" //NaN
```

##### %(取余)

```
a % "" //NaN
a % null //NaN
a % "dfsd" //NaN
```

`JS` 中对两数进行求模运算，得到的`余数的符号`是由`被除数`决定的。


---
#### Comparision operators

`JS` 中的比较运算符: `>` , `<`,`<=`, `>=` , `==` , `!=` , `====` , `!==`

> 等于 (==) 只是在值相等的情况下便返回 ture

> 全等于 (===) 只是在值和类型都匹配时才返回 true

> 两个数值型字符串比较，那么比较的是第一个数字的大小

```
"555" > "69" // flase
```

> 两个数都是字符型，则比较其 第一字符的ASCII 码的大小。

```
"abc" > "abce" // false
"d" > "abce" // ture
//ASCII : a:97,b:98,c:99,d:100
```

> 两个运算数进行比较，如果有一个是数值，另一个是数值类型的字符串，则将另一个转换为数值，再比较(这里要和 `+` , 比如 123 + "789" 返回 "123789" 区分开)。

```
5 > "15" // false
```

> 关系运算符返回的是 `布尔值`


---
#### Logical operators

逻辑与 真真为真
逻辑或 一真为真

在所有的编程语言中，非 `0` 值都是真值。JS 中的 `false` 值的情况有: `false` , `null`, `NaN` , `undefined` , `0`, `空字符串`。

> 逻辑非运算符 (!) 可以用于任何值。无论这个值是什么数据类型，这个运算符都会返回一个布尔值。它的流程是：先将这个值转换成布尔值，然后取反。

---
#### Stirng operators
除了比较操作符，它可以在字符串值中使用，连接操作符（+）连接两个字符串值相连接，返回另一个字符串，它是两个操作数串的结合。


---
#### Conditional(ternary) operators
条件运算符( `conditional operator`) 是 JS  中唯一一个三目运算符。

```
conditiaon ? val1 : val2 ;
```

---
#### Comma operator
逗号操作符(,)对两个数进行求值并返回第二个操作数的值，通常用在 for 循环中。



---
#### Destructing
解构赋值 destructing assignment 可以从一个数组或者对象对应的数组解构或对象字面量里提取数据。

```
var foo = ["one", "two", "three"];

//不使用解构
var one = foo[0];
var two = foo[1];
var three = foo[2];

//使用解构
var [one, two, three] = foo;
```


---
#### typeof
`typeof` 操作符用来检测变量的数据类型。

```
typeof operand
typeof (operand)
```
以上两种都是有效的

对于字面量或者变量，使用 `typeof` 会返回如下字符串

字符串|描述|
---:|:---:|:---
undefined|未定义
boolean|布尔值
string|字符串
number|数字
object|对象或者null
function|函数



---
### 0x05 数据类型转换

#### 显示转换

##### Number( ) 函数

**Number()函数** 可以将任何的非数值( `string` , `null` , `boolean` ,`undefined`)转换为数值。

1.只包含数值的字符串，会直接转成成十进制数值，如果包含前导0，即自动去掉。


2.只包含浮点数值的字符串，会直接转成浮点数值，如果包含前导和后导0，即自动去掉。

3.如果字符串是空，那么直接转成成0。

4.如果不是以上三种字符串类型，则返回NaN。


```
Number(ture); //转换为 1
Number(null); //转换为 0
Number(undefined); //转换为 NaN
Number(false); //转换为 0
Number("false"); //NaN
Number("23"); // 23
Number("0.330"); //0.33
Number(""); //0

Number(0123); // 0 不会别忽略 自动识别为八进制 83
Number(0987); // 0 被忽略 自动识别为十进制 987
```

##### parseInt(String,radix) 函数
`parseInt` 将**字符串**转换为**整型**,从第一个数开始取，到最后一个连续数字结束，如果第一个不是数字，则返回 `NaN`.

`parseInt` 除了可以识别十进制还可以识别八进制和十六进制。


##### parseFloat(String) 函数
`parseFloat` 将 **字符串**转换成**浮点数**。
与 `parseInt` 从第一位解析到非浮点数。

##### 单目加法运算
将字符串转换为数字的另一种方法是使用单目加法运算

```
(+"1.1")+(+"1.1") = 2.2
```

##### String
将一个值转换为 `String` 类型。

##### Boolean

```
Boolean(123);
Boolean("123);
```

---
### 0x06 Control flow and error handling

---
#### Conditional Statements

JS 有两种条件判断语句: if...else 和 switch.


##### if...else

```
if (condition_1) {
    statement_1;
}
else if (condition_2) {
    statement_2;
}
...
else {
    statement_n;
    }
```

> 在 JS if 判断中，以下值将会被计算出 flase : `false`, `undefined`, `null`, `0`, `NaN`, `空字符串("")`。除此之外的所有内容都为 true

```
if("0") {console.log("ha");} // "ha"
```

##### switch...case

```
swicth (expression) {

    case labe_1:
        statements_1
        [break;]

    ...
    default:    
        statement_def
        [break;]
```

> !Note
> 表达式不能是浮点型，最后一条的 case 的break可以省略，default 的位置可以交换。

> 当多个值的执行语句，可以只写一组执行语句

```
swicth (expression) {

    case labe_1:
    case label_2:
    case label_3:

    ...
    case lable_n:
        statements
        [break;]

    ...
    default:    
        statement_def
        [break;]
```


---
#### Loop Statement

JS 中的循环控制语句有: `for`, `do...while`, `while`,`for...in`, `label`, `break`, `continue`.

`for...in` 主要是用来操作对象的。

##### for

```
for ([initialExpression]; [condition]; [incrementExpression])
    statement;
```

initialExpression: 初始化表达式
condition: 条件表达式
statement: 需要执行的语句
incrementExpression: 累计表达式


##### do...while

```
do
    statement
while (condition);
```

##### while

```
while (condition)
    statement
```

##### 标签语句 label statement

标签语句提供一种使我们可以在同一程序的另一处找到它的标识。
比如可以用一个标识来识别一个循环，并使用 break 或者 continue 来说明一个程序是否要中断这个循环或者继续执行。

```
lable:
    statement;
```

_label_ 可以是 JS 中任意的非保留的标识符。




---
#### Object Manipulation Statements
JS 中的对象操作语句有 `for...in`, `for...each`, `with`.

##### for...in
`for...in` 语句迭代一个指定的变量去遍历这个对象的属性，每个属性，JS 执行特定的语句。

```
for (variable in object) {
    statements
}
```

##### for each...in

`for each...in` 类似于 `for..in` 语句，但是它得到的是对象属性的值，而不名字。



---
### 0x09 Numbers and dates

JS 中，数字都是 `double float` 的，一个数字的表示范围只能是在(-(2^53-1)~2^53-1)之间的。没有特定的数字类型为整型。除了能够表示浮点数，数字类型有三个符号值: +Infinity、-Infinity和 NaN (not-a-number)。

---
#### 数字的常用方法



方法| 描述 |
:---|:---:|:---
Number.parsrFloat() |
Number.parseInet()|
Number.isFinite()| 判断传递的值是否为有限数字
Number.isInteger()|判断传递的是否为整数
Number.iNaN()|判断传递的值是否为NaN
Number.isSafeInteger()|判断传递的值是否为安全整数
Number.toExponential()|返回一个指数形式的字符串
Number.toFixed()|返回指定小数位数的形式
Number.toPrecision()|返回一个指定精度的数字。有可能损失精度


---
#### Math object
我们不可以创建一个自己的 Math 对象，而只能使用系统内建的 Math 对象。

方法 | 描述
---|---
abs |绝对值
sin(),cos(),tan() | 标准三角函数
pow(),exp(),log10()|指数与对数
min(),max()|返回逗号分隔的数组中的最大值、最小值
random()|返回0和1之间的随机数
round(),fround(),trunc()|四舍五入和截断函数
sqrt(),cbrt()|平凡根，立方根
sign()|数字的符号，说明数字是否为正，负，零

