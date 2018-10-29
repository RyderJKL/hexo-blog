---
title: CSSDOMView
date: 2017-05-05
tags: ['CSS']
toc: true
categories: technology

---
### 文档视图(documentView)和元素视图(ElementView)

---
#### 文档视图四个方法

##### elementFromPoint()
返回给定坐标处所在的元素。

##### getBoundingClientRect()
得到矩形元素的界线，返回的是一个对象，包含 top, left, right, 和 bottom四个属性值，大小都是相对于文档视图左上角计算而来。

##### getClientRects()
返回元素的数个矩形区域，返回的结果是个对象列表，具有数组特性。这里的矩形选区只针对inline box，因此，只针对a, span, em这类标签元素。

##### scrollIntoView()
让元素滚动到可视区域。实现锚点的另一中种发方法。

```
element.scrollIntoView
```

---
#### 元素视图

##### clientLeft 和 clientTop
这两个返回的是元素周围边框的厚度,如果不指定一个边框或者不定位该元素,它的值就是0.

#### style.left 与 offsetLeft
相同点:首先他们获取的都是元素的左外边框至包含元素的左内边框之间的像素距离。
不同点: 1. style.left返回的是字符串，带有 px;offsetLeft返回的是数值。
       2. style.left 是可读写的；offsetLeft只能读取不能配置。

> 注意: style.left 只有在配置(而且只能使用js配置或者是html行内样式，在CSS定义的left值通过js是获取不到的)以后才能读取到。


##### offsetParent
返回最近的非 `static` 的祖先定位元素。

##### offsetHeight 和 offsetWidth
整个元素的尺寸（包括边框）。

##### clientHeight 和 clientWith
表示内容区域的高度和宽度，包括padding大小，但是不包括边框和滚动条。

##### scrollLeft 和 scrollTop
Element.scrollTop属性获取或设置元素内容垂直滚动的像素数。可读可写。

##### scrollHeigth 和 scrollWidth
Element.scrollHeight只读属性是对元素内容的高度的度量，包括由于溢出而在屏幕上不可见的内容。

判断一个元素是否已经滚动到底部:

```
element.scrollHeight - element.scrollTop === element.clientHeight
```

当容器不滚动但有溢出的孩子时，一下方法可以检查确定容器是否可以滚动：

```
window.getComputedStyle(element).overflowY !== 'visible'
window.getComputedStyle(element).overflowY !== 'hidden'
```

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollHeight)


---
### 鼠标位置(Mouse position)

##### clientX,clientY
鼠标向对于客户端可视区左上角的偏移量。浮点数。无论页面是否水平滚动，单击客户区域的左上角将始终导致clientX值为0的鼠标事件。

##### offsetX, offsetY
表示鼠标相对于当前被点击元素 `padding box` 的左上偏移值。

##### pageX, pageY
pageX只读属性返回事件相对于整个文档的X（水平）坐标（以像素为单位）。
此属性考虑到页面的任何水平滚动。


##### screenX, screenY
鼠标相对于显示器屏幕的偏移坐标。在iphone中，这个属性基本上就等同于pageX/pageY


##### x, y

[CSSView Module](https://msdn.microsoft.com/en-us/library/hh781509(v=vs.85).aspx)

