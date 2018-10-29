---
title: jQuery(6)对象方法   
date: 2016-12-01 09:45         
tags: ['jQuery']
toc: true
categories: technology

---
### 0x00 $.each()
不同于 `$(selector).each()` 专门用来遍历一个 jQquery 对象, `$.each()` 函数要强大得多，它可以迭代任何集合，数组，类数组，jQuery对象，javascript 原生对象等。

迭代数组时，回调函数将会每次传递数组索引和对应的值作为参数

迭代对象时，回调函数将会每次传递一个键值对


```
var arr = ['one','two','three','four','five']
var obj = {
	'one':1,
	'two':2,
	'three':3,
	'four':4,
	'five':5
}

$.each(arr,function(i, val){
	$('#' + val ).text("Mine is "+ val +'.' )
	return (val !== 'three')
})

$.each(obj, function(i,val){
	$('#' + i).append( document.createTextNode('_' + val))
})

```
> $.each()返回false来终止迭代。返回非false相当于一个循环中的continue语句，这意味着，它会立即跳出当前的迭代，转到下一个迭代。

---
### 0x01 $.extend()
将两个或更多对象的内容合并到第一个对象。但是第一个给位置的对象(即是被合并的目标对象)将会被修改，并且通过 `$.extend()` 返回，我们可以像下面一言保留第一个目标对象.

```
var obj = $.extend({},object1,object2)
```

使用这种方式的情况是，如果第一个对象的属性本身是一个对象或数组，那么它将完全用第二个对象相同的key重写一个属性。这些值不会被合并。

```

```
此外，若设置了 deep 参数，即是 `$.extend(true,obj1,ob2...)` 的深层合并方法，那么在后续被嵌套的，对象和数组也会被合并进来，但是对象包裹的原始类型，比如String, Boolean, 和 Number是不会被合并进来的。


---
### 0x02 $.fn.extend()
`$.fn.extend()` 会将一个对象的内容合并到jQuery的原型，以提供新的jQuery实例方法。

```
 $.fn.extend({
 	check:function(){
 		alert("ahaa");
 	}
 })

 $(window).check()
 ```

