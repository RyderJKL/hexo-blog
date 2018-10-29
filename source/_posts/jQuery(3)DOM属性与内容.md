---
title: jQuery(3)DOM属性与内容操作   
date: 2016-12-01 09:45        
tags: ['jQuery']
toc: true
categories: technology

---
### 0x00 尺寸

* width()/height()  
当使用 `.height()` 方法读取时，获得的是目标元素的 内容的高度。但是当使用 `.height('value')` 时，设置的是 `box-sizing`，将这个属性值改成border-box，将造成这个函数改变这个容器的outerHeight，而不是原来的内容高度。

> 不同于 `.css('height','200px')` 方法，`.height()` 方法不需要 `px` 值。



* innerWidth()/innerHeight()
返回/设置元素的高度，包括顶部和底部的padding，单位是像素。
该方法不适用于window and document对象，可以使用 `.height()` 代替。

* outerWidth()/outerHeight()
返回/设置元素的宽度，一直包括l左右 padding值，border值和可选择性的margin。单位为像素。

---
### 0x01 坐标

* offset().left()/offset().top()  
在匹配的元素集合中，获取的第一个元素的当前坐标，坐标相对于文档。当通过全局操作（特别是通过拖拽操作）将一个新的元素放置到另一个已经存在的元素的上面时，若要取得这个新的元素的位置，那么使用 .offset() 更合适。


* .position()
获取匹配元素中第一个元素的当前坐标，相对于offset parent的坐标。只获取不可设置。

* .scrollLeft()
获取或设置匹配元素水平滚动条的位置  
通常用于 `window` 对象
* .scrollTop()
获取或设置匹配元素垂直滚动条的位置  
 通常用于 `window` 对象

---
### 0x02 原生与 jQuery 对象转换

```
$("div").eq(0)[0].onclick = function () {
    //do something
}
```

---
### 0x03 CSS 属性操作



在 DOM 标记法中，属性名可以不使用引号包裹，但是在 CSS 标记法中，如果属性中含有连字符(-)的话，则必须用引号包裹.

---
#### 获取目标样式
jQery 能解析 `.css('background-color')` 和 `.css('backgroundColor')` 两种不同的格式并且返回正确的值。此外，从 jQuery1.9 开始，可以给 `.css()` 方法传递数组，其将返回 `属性-值` 配对的对象。

```
$("#clickme").on("click",function(){
	console.log($("#middle").css(['width','height','color'，'border']))
})
//Object {width: "1074px", height: "500px", color: "rgb(0, 0, 0)", border:"1px solid rgb(255, 0, 0)"}
```

---
#### 设置目标样式 
_.css(propertyName, function(index, value))_

可以直接传递一个 属性-值 的对象给 `.css()` 以快速设置多种不同的样式.

```
$("#box").one( "click", function () {
    $( this ).css( "width","+=200" );
  });
```

此外，还可以给每个属性添加函数返回函数的结果作为属性值。

```
$("div").click(function() {
    $(this).css({
      width: function(index, value) {
        return parseFloat(value) * 1.2;
      },
      height: function(index, value) {
        return parseFloat(value) * 1.2;
      }
 
    });
  });
```

---
#### addClass()/removeClass
 `addClass()` 为每个匹配的元素添加指定的样式类名。值得注意的是这个方法不会替换一个样式类名。它只是简单的添加一个样式类名到元素上。
 
通常和 `removeClass()` 一起使用，用来切换元素的样式.

```
$("p).addClass("firstClass secondClass").removeClass("thirdClass")
```

此外 `addClass()` 方法允许我们通过传递一个用来设置样式类名的函数。

```
$("ul li:last").addClass(function(index) {
  return "item-" + index;
});
```


---
#### toggleClass()
`toggleClass()` 最简单的用法是为目标指定一个或多个样式，如果指定的样式存在（不存在）就删除（添加）一个类。

```
$("p").click().toggleClass("myDiv"))
```

其它用法请参考官方文档。

---
### 0x04 DOM 内容

---
#### html()
`html()` 读的时候获得的是目标元素的 HTML 源码。此时不接受任何参数。

`html()` 写的时候对 XML 文档无效。与 JavaScript 的 `innerHTML()` 方法相同，使用 `html()` 来设置元素的内容时，这些元素中的任何内容会完全被新的内容取代。

此外，`html()` 方法允许我们通过函数来传递HTML内容

```
$("div").click(function(){
	$(this).html(function(){
		var countP = ""
		for(var i=0;i<10;i++){
			countP += "<p>hello,world</p>"
		}
		return countP
	})
})
```
---
#### val()
`val()` 主要用来获取表单元素的值,比如 `input`,`checkbox`,`radio`,`text`,`textarea`,`select`。

```
$('input:checkbox:checked').val();
$('input:radio[name=sex]:checked').val()
```

但是，当通过 `val()` 方法从 `textarea` 获得数据时，并不会包含回车符号(\r),只有通过 XHR 发送给服务器才会包含(\r)。

同样，当通过 `val()` 为某个表单元素设置值的时候允许使用一个函数来设置`val()`的值。

```
$('input:text.items').val(funciton({ return 'haha'}))
```

---
#### text()
和 `html()` 方法不同， `text()` 在XML 和 HTML 文档中都能使用。`text()` 方法返回一个字符串，包含所有匹配元素的合并文本。  


> `text()` 方法不能使用在 input 元素或scripts元素上。 

同样 `text()` 方法允许我们通过函数来传递文本内容。

---
#### attr()/removeAttr()
需要弄清楚的是 `Attributes` 和 `Property` 的区别。`prop()` 方法返回 property 的值,而 `attr()` 方法返回 attributes 的值。

要检索和更改DOM属性,比如元素的 `checked`, `selected`, 或 `disabled` 状态，请使用.prop()方法。


`removeAttr()` 方法使用原生的 JavaScript removeAttribute() 函数,但是它的优点是可以直接在一个 jQuery 对象上调用该方法，并且它解决了跨浏览器的属性名不同的问题。


