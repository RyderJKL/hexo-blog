---
title: CSS Position 与 Float 进阶
date: 2017-01-21     
tags: ['CSS','position','float']
toc: true
categories: technology

---
### position
**position** 一共有四个属性值: `static`,`relative`,
`absolute`,`fixed`。

而所有元素在默认情况下 **position** 的值为 `static`。而 `fixed` 
是相对于浏览器的窗口进行定位的。我们主要来看看 `relative` 和 `absolute`。

#### relative

**relative** 定位相对于自身原来在文档流中的位置进行定位。**但普通流中依然保持着原有的默认位置，并没有脱离普通流，只是视觉上发生的偏移。**

此外, **relative** 并不会改变元素的 **display** 属性值

> 文档流: 元素按照自上到下, 自左到右的顺序依次排放, 即文档流.

#### absolute
**absolute** 相对有具有非 `static` 定位属性的父级元素来进行定位，直到 
**body** 元素。

此外,**absolute** 会将元素的 **display**设置为 `block`。

#### position 小结

1. 在应用了 `position:relative/absplute` 
以后，**margin** 
属性依然适用，但是此时并不建议使用 **margin** 属性，因为很难精确的去对元素进行定位。

2. 应用了 `position: absolute / relative` 之后，会覆盖其他非定位元素（即 position 为 static 的元素），如果你不想覆盖到其他元素，也可以将 z-index 设置成 -1。

### float 详解

我们知道，一旦某个元素被设置 `float` 属性以后,该浮动元素便会脱离正常的文档流, 使其浮动到父元素的行的一端(元素向左或向右移动, 直到碰到浮动元素, 或者达到父元素内容的边界, 不包括padding), 并且其他元素将忽略该浮动元素并填补其原先的空间.

#### 对父级元素的影响

元素浮动以后，回脱离正常文档流，导致父元素塌陷。

#### 对兄弟元素（非浮动）的影响

1. 若兄弟元素是 **块级元素**,那么对于 __浮动元素之前的兄弟元素__ 没有影响。而对于 __浮动元素之后的兄弟元素__ 现代浏览器及IE8+下, 该兄弟元素会忽视浮动元素而 **填充** 它的位置, 并且该兄弟元素会处于浮动元素的下层(并且无法通过z-index属性改变他们的层叠关系),然而它的内容文字和其他行内元将会环绕浮动元素.对此, IE6,7分别有不同的表现. IE6,7中, 该兄弟元素会紧跟在浮动元素的右侧, 并且IE6中会保留3px的空隙; IE7中则没有空隙。

2. 若兄弟元素是 **内联元素**,则内联元素将环绕浮动元素排列.

#### 对兄弟元素 (浮动) 的影响

浮动的兄弟元素将相对该浮动元素按照从左到右(float:left)或者从右到左
(float:right)的顺序依次排列.

#### 清除浮动的两种方法:

##### overflow: hidden | auto
父元素使用 `overflow:auto|hidden`, 
切记不可使用 `overflow:visible`.

``` 
.outer{
	overflow:auto|hidden;
}    
```

##### 伪类 after 

同样为父元素添加一个 **clearfix** 类,利用 `after` 伪类 和
`clear:both` 属性, 
清除浮动的同时还可避免加入 dom 元素:

``` 
.clearfix::after{
	content:'';
	display:block;
	clear:both;
}
```

