---
title: JS引用类型(3)之Function      
date: 2016-10-06     
tags: ['JavaScript','JS引用类型']
toc: true
categories: technology

---

### 0x00 函数定义
JS 使用关键字 function  关键字来定义函数(也称为函数的声明):

```
funciton [function] {
    statements;
}
```

function 后面紧跟函数名 functionName 如果省去，便是一个匿名函数。

#### Function Experison
可以使用函数的标准语法定义一个函数，也可以使用函数表达式创建一个函数，这个函数可以是匿名函数

```
var square = funciton [ functionName] ( arguments) { ... };
```

---
### Calling Funciton

在页面加载完成以后调用函数:

```
<body onload = "functionName()"></body>

//or
window.onload(functionName());
```

函数一定要处于调用它们的域中，但是函数的声明可以在调用之后，但是这种方式只限于 `function funcName () {}` 的标准方式。而下面的代码是无效的:

```
console.log(square(5));  //square is not defined
square = funciton (n) {
    return n*n;
}
```


---
### About arguments
JS 中的参数在内部是用一个数组来表示的，在函数体内部可以通过 `arguments` 对象来访问这个数组，从而获取传递给函数的每一个参数。

其实，`arguments` 并非 `Array` 的实例，它只是与数组类似而已，但是我们依然可以使用方括号 [ ] 语法来访问它的每一个元素。


`arguments` 可以与参数名一起使用，并且它的值永远与对应的命名参数的值保持一致。

`arguments` 对象是函数的一个内部对象，存储的是 **传递给该函数的实参**


> JS 函数有一个重要特点: 命名的参数只提供便利，但不是必需的。

> JS 中的所有参数传递都是值传递，不可能通过引用传递参数。

#### arguments.callee
`arguments` 对象有一个叫 `callee` 的属性，该属性是一个指针，指向拥有这个 `arguments` 对象的函数。

```
function factorial (num){
		if (num <= 1 ){
			return 1;
		}else {
			return num * arguments.callee(num - 1);
		}
	}
```

`arguments.callee` 属性减少了函数名与函数内部调用的紧密耦合。这样，无论应用函数时使用的是什么名字，都可以保证正常完成**递归调用**。

---
### 函数声明与提升
函数声明与变量声明会被JavaScript引擎隐式地提升到当前作用域的顶部，但是对变量只提升名称不会提升赋值部分。

```
var foo = 1;
// 声明了一个全局的 foo 并赋值为 1
function fn(){
    /*所有的声明的变量被提升到顶部*/
    console.log(foo); // undefined
    var foo = 2;
    // 在函数内部声明了一个 foo 变量并赋值为 2
    console.log(foo); // 2
}
fn()
```

慎用 `name`。

上面的 fn 函数其实相当于:

```
function fn(){
    var foo;
    /*所有的声明的变量被提升到顶部*/
    console.log(foo); // undefined
    foo = 2;
    console.log(foo); // 2
}
```

而在全局作用域的 foo 变量在 fn 函数内部会被屏蔽。

此外，值得一提的是函数声明与函数表达式，浏览器会率先读取函数声明，并使其在执行任何代码之前可用；而对于函数表达式，则必须等到解析器执行到它所在的代码行，才会执行。

```
alert(sum(10,10)
// 正常运行，么有问题
function sum(a, b){
    return a+b
}

var sum = null;
alert(sum(10,10)
// 运行期间发生错误，原因在于函位于一个初始化语句中，而不是一个函数声明
var sum = function(a,b){
    return a + b
}
```



---
### apply(),call()

`apply()` 和 `call()` 都可以用于改变函数执行时的上下文，其实就是改变 `this` 的指向，其本质上是同一个方法，只是接收参数的形式有所不同而已。

```
function Human (name){
	this.name = name;
}

Human.prototype = {
	constructor: Human,
	sayName: function(){
		alert(this.name)
	}
}

var person = new Human("李小龙")
person.sayName()
// 李小龙

var cat = {
	name:"小咪"
}
person.sayName.call(cat)
//person.sayName.apply(cat)
// 小咪
```

如下，`cat` 首先并不具备 `sayName()` 方法，但是，我们使用了 `call`,动态改变了其执行的上下文，拿了 `person` 的 `sayName()` 来用。

很好的实现了代码复用。

> 使用 call() 或 apply() 来扩充作用域的最大好处，即是对象不需要与方法有任何的耦合关系

---
#### call 和 apply 的区别
`call` 和 `apply` 的第一个参数都是要改变上下文的对象，但是其后`call` 以参数列表的形式接收参数，而 `apply` 以数组的形式接收参数。

```
fn.call(obj,arg1,arg2...);
fn.apply(obj, [arg1,arg2,...]);
```


> call 和 apply 改变了函数执行中this的上下文以后便立即执行该函数，而 bind 则是返回改变了上下文后的一个函数

---
### 闭包

---
#### 没有块级作用域
在了解闭包以前，我们需要知道 JS 是没有块级作用域的，这意味着在块级语句中定义的变量，实际上是在包含函数而非语句中创建的。

```
for (var i = 0;i < 10; i ++) {
    console.log(i);
}
alert(i); // i = 10;
```

对 JS 而言，有 for 语句创建的变量 i 即使在 for 循环执行结束以后，也依旧会存在于循环外部的执行环境中。

---
#### 何为闭包？

**闭包** 是指有权访问另一个函数作用域中的变量的函数。创建闭包的常见方式，就是在一个函数内部创建另一个函数。

---
#### 闭包的常见形式

```
function f9(){
	var n = 999;
	add = function(){n++};
	// 定义一个内部函数(匿名函数)
	function f10(){
	// 定义一个内部函数 f10 函数
		alert(n)
	}
    return f10;
}
var fn = f9();
// 立即执行 f9 函数，并将执行结果赋值给 fn 变量
// fn -=> f10 此时 fn 变量指向 f10 函数
add();
// n == 1000
fn()
// 立即执行 f10 函数
// alert:1000
add();
// n == 10001
fn()
// 立即执行 f10 函数
// alert:1001
```



---
#### 使用匿名函数模仿块级作用域
JS 重来不会告诉你是否多次声明了同一个变量，遇到这种情况，它只会对后续的声明视而不见(不过，它会执行后续声明中的变量初始化)。

但是，我们是可以使用匿名函数来模仿块级作用域的。

```
( function () {
    // 这里是块级作用域
})();
```

上述，定义并立即调用了一个匿名函数。将函数声明包含在一对圆括号中，表示它是一个函数表达式。而紧跟的另一对圆括号会立即调用这个函数。

这种技术经常在全局作用域被用在函数外部，从而限制向全局作用域中添加过多的变量和函数。在一个由很多人开发的大型项目中，过多的全局变量和函数很容易导致命名冲突，而通过创建私有作用域，每个开发人员既可以使用自己的变量，又不必搞乱全局作用域。

```
( function () {
    var now = new Date();
    if (now.getMonth() == 0 && now.getDate() == 1){
        alert("Happy New Year!");
    }
})();
```


> 闭包的缺点：滥用闭包函数会造成内存泄露，因为闭包中引用到的包裹函数中定义的变量都永远不会被释放，所以我们应该在必要的时候，及时释放这个闭包函数。

---
### 私有变量
JS 没有私有成员的概念，所有对象属性都是公有的。

不过，倒是有个私有变量的概念。任何在函数中定义的变量，都可以认为是私有变量，因为不能在函数的外部访问这些变量。私有变量包括 **函数的参数**, **局部变量**， **在函数内部定义的其它函数**。

不在函数外部访问这个私有的变量和函数，但是可以定义 **特权方法( privileged method )** 使其有权访问私有变量和私有函数。

对此，有两种方法在在对象上创建特权方法。一是 **在构造函数中创建特权方法** ，但是使用构造函数的缺点也是显而易见的，它会针对每个实例都创建同样一组新方法，这对内存是种极大的浪费。其次我们可以使用 **静态私有变量**。

---
#### 静态私有变量
通过在私有作用域中定义私有变量和函数，同样也可以创建特权方法。

其基本模式如下:

```
( function () {
    //私有变量和私有函数
    var privateVariable = 10;
    function privateFunction () {
        return false;
    }


    // 构造函数
    MyObject = function () {

    };

    //公有|特权方法

    MyObject.prototype.publicMethod = function () {
        privateVariable ++;
        return privateFunction();
    }
})();
```

```
<ul>
	<li>1</li>
	<li>2</li>
	<li>3</li>
	<li>4</li>
	<li>5</li>
</ul>

<script type="text/javascript">
var lis = document.querySelectorAll("ul li")
for(let i=0; i< lis.length;i++){
	(function(index){
	lis[index].onclick = function(){
			lis[index].style.borderLeft = "2px solid deeppink"
			for(let j = 0; j < lis.length;j++){
				if(j!=index){
					lis[j].style.border = "none"
				}
			}
	}
	})(i)
}
</script>
```

如上，我们创建了一个私有作用域，并在其中封装了一个构造函数及其相应的方法。在私有作用域中，首先定义了私有变量和私有函数，然后又定义了构造函数和公有方法。而共有方法是在构造函数的原型上定义的。

但是，在这个模式中定义构造函数时并没有使用函数声明，而是使用了函数表达式，因为**函数声明只能创建局部函数**。出于同样的原因，我们也没有在声明 MyObject 时使用 var 关键字，**初始化未经声明的变量，总是会创建一个全局变量，因此，MyObject 就成了一个全局变量。


---
### 几个全局函数

#### eval()
`eval()` 是一个很强大的方法，它像一个完整的 ECMAScript 解析器，能够解释代码字符串。

```
// eval
var str ="19-2"
console.log(eval(str))
// 17
```

