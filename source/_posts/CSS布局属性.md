e---
title: CSS布局属性
date: 2016-09-14 22:55
tags: ['CSS','CSS布局']
toc: true
categories: technology

---
### 0x00 display 属性

display属性可以对元素的属性进行转换，使块级元素具有行级元素的特征，使行级元素具有块元素的特征。


属性值|描述
:---:|:---:|:---
none|隐藏元素
inline|转换行级元素
block|转换块级元素
inline-block|行内块级元素

> 关于 `inline` 常见的例子是：把 li 元素修改成 inline，制作成水平菜单。

> 去掉 `img` 标签产生的下边距的方法是将 `img` 设置: `display:block`.或者设置:



---
#### inline-block
简单的讲设置了 `inline-block` 属性的元素既拥有了 `block` 元素可以设置 `width` 和 `height` 的特性，又保持了inline元素不换行的特性。



##### inline-block 空白符
其实有 `inline-block` 空白符并不是怪 `inline-block` ，而是 `inline` ，因为默认情况下 `inline` 就是存在空白符的。

我们编写代码时写的空格，换行都会产生空白符。在浏览器中，空白符是不会被浏览器忽略的，多个连续的空白符浏览器会自动将其合并成一个。

```
<a href="">1</a>
<a href="">2</a>
<a href="">3</a>
<a href="">4</a><a href="">5</a><a href="">6</a>
```

如上:1,2,3,4之间在浏览器中显示时将存在空隙，4,5,6,之间将不存在空隙。

要去除空白符产生的间隙，可以通过设置 `font-size` 属性控制各个元素间产生的间隙的大小。

```
.advertisement {
		font-size: 0px;
	}
	.advertisement a{
		font-size: 14px;
		margin:0;
		padding: 0;
	}
```

---
#### inline-block 应用

##### 网页头部菜单
一个应用场景是，除了使用 `float` 对 `li` 进行横向导航布局外，还可以使用 `inline-block` 进行 `li` 导航设计。当然他们各有优劣，`float`属性会造成高度塌陷，需要清除浮动等问题。而 `inline-block` 则会带来 `空白符` 的问题。

##### 内联块元素
除了菜单之外，一切需要行内排列并且可设置大小的需求就可以用inline-block来实现。
例如使用a标签做按钮时，需要设置按钮的大小，我们就可以使用inline-block来实现。

##### inline-block 布局

一个简单的三栏布局:

```
.news, .showProduct , .contact{

		display: inline-block;
		width: 30%;
		height: 95%;
		margin: 1em;
	}

<div class="contentContainer">
		<div class="content">
		<div class="news">news</div>
		<div class="showProduct">showProduct</div>
		<div class="contact">contact</div>
		</div>
	</div>
```

> `vertical-align` 属性会影响到 `inline-block` 元素，你可能会把它的值设置为 top 。

---
### 0x01 margin-auto 与 max-width

位块级元素设置 `width` 可以阻止其从左到右撑满容器，然后使用 `margin-auto` 属性来使其水平居中。

```
#main{
    width:200px
    margin-auto;
}
```

唯一的问题是，当浏览器窗口比元素的宽度还要窄时，浏览器会显示一个水平滚动条来容纳页面。在这种情况下使用 `max-width` 替代 `width`可以使浏览器更好地处理小窗口的情况。这点在移动设备上显得尤为重要，

```
#main{
    max-width: 200px
    margin: auto;
}
```

---
### 0x02 box-sizing [CSS3]

为了解决布局中的烦人的数学问题，`box-sizing` 应运而生。

`box-sizing` 有两个属性值:`content-box` , `border-box`

##### content-box
`content-box` :表示元素的宽度与高度不包括填充padding与边框border的宽度与高度。对其宽度和高度的设定是对其内容的高度和宽的设定。当padding与border改变时将使其向外扩张。此时内容的高度和宽度不变。

##### border-box
`border-box` :表示元素的宽度与高度包括填充padding与边框border的宽度与高度。对其宽度和高度的设定是对其本身实际高度和宽的设定。当padding与border改变时将使其向内容空间塌陷。此时内容的高度和宽度将随之改变。

想要页面上所有的元素都有如此表现，那么可以：

```
* {
    -webkit-box-sizing:border-box;
    -moz-box-sizing:border-box;
    box-sizing:border-box;
}
```


---
### 0x3 position 属性

`position` 属性一共有四个值: `static` , `relative` , `absolute` , `fixed`

#### static
默认值，元素将按照正常文档流规则排列

#### relative
相对定位，元素元素仍然处于正常文档流当中，元素原来的位置将会保留，此后以此元素原来的静态位置作为参考点。

#### absolute
绝对定位,元素脱离正常文档流，不在占据原来的位置，参考已定位 的父元素位置进行偏移。（如果父元素没有设置定位属性值(这个值要是非 `static `)会一层层向上找寻定位参考元素，可以一直追溯到 `body` 然后根据它的位置偏移）


#### fixed
固定定位，元素脱离正常文档流，不再占用原来的位置，此后以浏览器的可视区域的四角作为参考点。

> 如果它一个元素是 `position: static`，那么它的绝对定位子元素会跳过它直接相对于 `body` 元素定位。



> !Note 何为文档流?
将窗体自上而下分成一行行，并在每一行中按从左到右的顺序排放元素，即为文档流。
  有三种情况将使得元素脱离文档流，分别是浮动(float left or right)、绝对定位(position:absolute)、固定定位(position:fixed)。

> 参考来源:
http://www.cnblogs.com/fsjohnhuang/p/3967350.html

> CSS 三种定位机制: 文档流，浮动(float),定位(position)
> 使用浮动和定位能够使元素脱离文档流


---
### 0x04 float 浮动属性

**float** 属性可以控制元素浮动的方式为： `left`, `right` , `none` ,`inherit` 。

> 在 CSS 中，任何元素都可以浮动。浮动元素会生成一个 `块级框`，而不论它本身是何种元素。

> 向右浮动，浮动元素将会逆序显示，向左，则相反。

> 假如在一行之上只有极少的空间可供浮动元素，那么这个元素会跳至下一行，这个过程会持续到某一行拥有足够的空间为止。

> 使用浮动(float)的一个比较疑惑的事情是他们怎么影响包含他们的父元素的。如果父元素只包含浮动元素，那么它的高度就会塌缩为零。

> 值得注意的是，在同一个父元素中，浮动元素对非浮动元素的影响是，浮动元素将会覆盖非浮动元素的空间，进而挤压非浮动元素的内容。


##### 图片溢出处理
使用 `float ` 一个最简单的场景就是文字对图片的环绕,但是这里也存在一个问题，就是当图片的大小超过了包含该图片的容器，而且图片本身是浮动的，那么此时，图片将会溢出到容器外面。

解决思路是:

1. 对容器使用 `overflow:auto` 属性，那么容器将会自动调整大小区包裹图片

```
.img { float:right;}
.containerImg{overflow:auto;}
```

2. 对图片本身进行控制。

```
.container img{
    float:right;
    width:50%;
}
```

甚至还能同时使用 min-width 和 max-width 来限制图片的最大或最小宽度。



#### 清除浮动




清除浮动:`clear:both`,`给父级添加高度`,`添加一个空的div`,`使用 display:inline-block`,终极大招 **给父级添加 overflow:hidden**

##### clear属性
为了让 `float` 元素不影响其他的元素，可以使用 `clear` 属性清除浮动属性，但是 `clear` 属性不是作用于 浮动 元素而是作用于下一元素的。


##### 将浮动元包裹在一起
另外一种是的浮动元素不影响其它元素的方法，就是不清楚浮动而是将所有浮动的元素放在一个父元素中。

##### 使用空 `div`

我们还可以在浮动元素与非浮动元素之间放置一个空的 `div`,并为其设置 `clear` 属性。

```
<style type="text/css">

.clear{clear:both}
</style>

<div>
    <div class="float1"></div>
    <div class="float2"></div>
    <div class="clear"></div>
    <p></p>
</div>
```


---
### 0x05 visibility 属性


属性值| 描述
---|---
visible | 显示元素
hidden | 隐藏元素
collapse| 当在表格元素中使用时，可以隐藏一行或者一列，但被行列占据的空间会留给其他内容使用，该值应用于其它元素，会被呈现为 hidden

##### visibility:hidden 和 display:none

使用CSS `display:none` 属性后，HTML元素（对象）的宽度、高度等各种属性值都将“丢失”,原有空间回收;而使用 `visibility:hidden` 属性后，HTML元素（对象）仅仅是在视觉上看不见（完全透明），而它所占据的空间位置仍然存在。

---
### 0x06 overflow 属性


属性值|描述
---|---
visible |溢出内容出现在元素框之外；(默认)
hidden| 隐藏溢出内容
auto|自适应索要显示的内容，需要时产生滚动条
scroll|溢出内容被修剪且始终显示滚动条

此外， 使用 `overflow-x` 可以横向显示样式， `overflow-y` 将纵向显示样式。


---
### 0x07 flexbox
新的 `flexbox` 布局模式被用来重新定义CSS中的布局方式。

---
### 0x08 所有浏览器下的CSS透明度


下面这种方式可以实现所有浏览器下的透明度设置：

```
.transparent {
    zoom:1;
    filter:alpha(opacity=50);
    opacity:0.5;
}
```

`Zoom` 属性是IE浏览器的专有属性，Firefox等浏览器不支持。

