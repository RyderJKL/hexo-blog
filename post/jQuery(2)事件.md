---
title: jQuery(2)事件  
date: 2016-11-28 11:12      
tags: ['jQuery']
toc: true
categories: technology

---
### 0x00 ready
不同于 JS `load()` 方法，jQuery 中的 `ready()` 在 DOM 准备就绪时就会触发，而不必等待整个页面都加载完成，这也是相比于 `load()` 更加高效的原因。

当 DOM 结构加载完成以后立即执行

```
$(document).ready(functinon(){
    //handler
});

// 以下是等价的
$(function() {
   // handler 
});
```

---
### 0x01 jQuery 事件绑定 on
因为给种遗留的历史问题，性能，效率，规范统一等各种原因，从 jQuery1.7 开始，jQuery 就只有一种事件绑定器 `.on()` (推荐只用这个)

至于其它，比如`.bind()`,`.live()`,`delegate()` 可以参考官方文档


---
#### on()
.on()方法事件处理程序到当前选定的jQuery对象中的元素。在jQuery 1.7中，.on()方法 提供绑定事件处理的所有功能。

```
.on( events [, selector ] [, data ], handler(eventObject) )
```

jQuery 使用 `on()` 绑定动态生成的元素时，不能直接用该对象操作，而是选择其非动态生成的父节点然后再找到本身才能达到效果(即事件委托)。

```
 // 写法
$("body").on("click","#newdiv",function(){
	alert("haha");
})

$("<div>").attr("id","newdiv").appendTo("body");
```

---
#### 直接事件 和 委托事件

在 jQuery 的事件处理程序器中(比如:`bind()`,`delegate()`,`on()`等等),如果省略`Selector` 或者参数为 `null`，那么事件处理程序被称为 `直接事件` 或者 `直接绑定事件` 。每次选中的元素触发事件时，就会执行处理程序，不管它直接绑定在元素上，还是从后代（内部）元素冒泡到该元素的。

当提供 `Selector` 参数时，事件处理程序是指为 `委托事件`（或者，代理事件,委派事件)。事件不会在直接绑定的元素上触发，只有当 `Selector` 参数选择器匹配到后代（内部元素）的时候，事件处理函数才会被触发。

> 事件冒泡简单的说就是，在冒泡路径上所有绑定了相同事件类型的元素上都会触发这些类型的事件.

事件委托是基于事件冒泡原理的实现的，它有2个好处，一是可以对后来加入的元素生效。二是大幅降低事件绑定的内存占用:

例如，在一个表格的 tbody 中含有 1,000 行，下面这个例子会为这 1,000 元素绑定事件：

```
$("#dataTable tbody tr").on("click", function(event){
  alert($(this).text());
});
```

委派事件的方法只有一个元素的事件处理程序，tbody，并且事件只会向上冒泡一层（从被点击的tr 到 tbody :

```
$("#dataTable tbody").on("click", "tr", function(event){
  alert($(this).text());
});
```

---
#### 阻止事件默认行为和事件冒泡
我们可以调用 `event.stopPropagation()` 和 `event.preventDefault()` 来阻止事件冒泡或事件的默认行为。此外也可以有更简洁的方法，给 `.on()` 传递一个 `false` 参数就可以。

```
$("a.disabled").on("click", false);
```

将会阻止所有含有 "disabled" 样式的链接的默认行为，并阻止该事件上的冒泡行为。


---
#### this

当jQuery的调用处理程序时，this关键字指向的是当前正在执行事件的元素。对于直接事件而言，this 代表绑定事件的元素。对于代理事件而言，this 则代表了与 selector 相匹配的元素。(注意，如果事件是从后代元素冒泡上来的话，那么 this 就有可能不等于 event.target。)我们要使用 jQuey 的相关方法，那么最好创建一个 jQuery 的对象，即使用 `$(this)`.


---
#### 将数据传递给事件处理程序
`data` 参数可以是任何类型，如果字符型，在必需提供 `Selector` 参数，或者明确的传递一 `null`。所以，做好将一个对象作为 `data` 参数。

```
function greet(event) { alert("Hello "+event.data.name); }
$("button").on("click", { name: "Karl" }, greet);
```
---
#### off()
删除的通过 `.on()` 添加的事件处理程序，当是从性能和效率的考量，你最好不要使用诸如 `off()`, `unbind()` 等方法。

---
#### one()
绑定一个事件，并且只运行一次，然后删除自己.

---
#### toggleClass()

---
### 0x02 event.target 和 event.currentTarget
通常情况下，我们可以认为 `event.currentTarget` 与 `$(this)` 是等价的，但是只是通常情况。



`event.currentTarget`: 事件绑定的元素

`event.target`:触发事件的元素


```
<body>
<div id="grandPapa">
i'am grandPapa
	<div id="papa">
	i'am papa
		<div id="son">	
		i'am son
		</div>
	</div>
</div>
</body>
<script type="text/javascript" src="JS/js/jquery-1.11.1.min.js" ></script>
<script type="text/javascript">
function handler(event){
	console.log($(event.target))
	console.log($(event.currentTarget))
}
$("#grandPapa").on('click',$('#son'),handler)
//[div#son, context: div#son]
//[div#grandPapa, context: div#grandPapa]
</script>
```


此外，在没有冒泡的情况下.`currentTarget` 和 `target` 是一样的值。





