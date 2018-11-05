---
title: FlexBox  
date: 2016-09-08 11:55    
tags: ['CSS3']
toc: true
categories: technology

---
### 0x00 FlexBox
flexbox 可以自动扩展其内部的 `items 项目(元素)` 的宽度或者高度以最大限度的去填充 flex 容器的可用空间，或者自动收缩其内部空间，以防止其内容溢出。

flexbox 的布局算法是与方向无关的，对于应用程序组件或者小规模的布局需求，flexbox 布局是很适合的，而针对大规模的布局，新兴的 Grid 布局或许是个不错的选择。

### 0x01 display:flex
对指定的元素使用 `display:flex` 属性，它便成为了一个 `FlexBox` 元素，它依旧是块级元素，只是拥了有一些 FlexBox 的特性。

当然，脱离了传统的 vertical 和 horizontal 形式，FlexBox 需要一些新的概念，比如，`主轴(main axis)`，`交叉轴(cross axis)` 等。如下图：

![flex_terms](http://upload-images.jianshu.io/upload_images/1571420-2cbcb3440aa21a77.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`main axis`: 是沿着 FlexBox 的布局方向，它并非就是水平或者垂直的，我们可以使用 `flex-direction` 这个属性去设置的我们布局方向，即是 `main axis`。

`cross axis`: 是与布局方向，即是与主轴垂直的轴。

先有这个两个概念。

> 当一个元素成为 flex 容器后，`float` ,`clear`,`vertical-align` 属性不再适用于 flexbox中的 item 了

### 0x02 flex-direction
`flex-direction` 决定哪个方向为主轴的方向。
`flex-diretion` 属性值如下:
`flex-direction:row`:主轴为横向的，即是沿着水平方向布局(从左向右)。
`flex-direction:row-reverse`:与 `row` 相反，沿着从右向左的方向布局
`flex-direction:colum`:主轴为垂直的，沿着从上到下的方向布局。
`flex-direction:colum-reverse`:与 `colum` 相反，沿着从下到上的方向布局。

实例代码:
```
//HTML
<div class="wrap">
    	<div class="flex_item">1</div>
    	<div class="flex_item">2</div>
    	<div class="flex_item">3</div>
</div>

//CSS
html{
	font-size: 100px;
	max-width: 640px;
	min-width: 640px;

}
.wrap{
	margin: 1.5rem auto;
	border:1px solid deeppink;
	font-size: 0.16rem;
	width: 3.2rem;	
}

.flex_item{
	width: 2rem;
	height: 2rem;
	text-align:center;
}

.wrap .flex_item:nth-child(1){
	background: #333;
}

.wrap .flex_item:nth-child(2){
	background: deeppink;
}

.wrap .flex_item:nth-child(3){
	background: green;
}
```

![初始样式](http://upload-images.jianshu.io/upload_images/1571420-5220dbdb6ef66d1b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

对 wrap 使用 `display:flex` 和 `flex-direction:row-reverse`

```
.wrap{
	display: flex;		
	flex-direction: row-reverse; 
	margin: 1.5rem auto;
	border:1px solid deeppink;
	font-size: 0.16rem;
	width: 3.2rem;	
}
```

![flex,row-reverse](http://upload-images.jianshu.io/upload_images/1571420-79741c6b92808160.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 0x03 flex-wrap
`flex-wrap` 是 FlexBox 的换行属性，默认值为 `flex-wrap:no-wrap` 即不换行，此时 `flex` 容器中的 `items` （子元素）会随着 `flex` 容器的大小自动缩放，即使 `items` 设置了固定的 width/height 并且超过了容器的大小，也不会溢出，而是平分 `flex` 容器的空间。

`flex-wrap` 的属性值如下:

`flex-wrap:nowrap（默认值）`:不换行
`flex-wrap:wrap:`换行，第一行在最上
`flex-wrap:wrap-reverse`:换行，第一行在最后
```
.wrap{
	width: 3.2rem;	
	/*flex 容器宽度为 3.2 rem*/
}

.flex_item{
	width: 3rem;
	/*items 的宽度和 6rem，没有 overflow ，而是平分 flex 容器的空间*/
}
```

![no-wrap](http://upload-images.jianshu.io/upload_images/1571420-189f1877f9328a36.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

为 `flex` 容器设置 `flex-wrap:wrap`:

```
.wrap{
        flex-wrap:wrap;
	width: 3.2rem;	
	/*flex 容器宽度为 3.2 rem*/
}

.flex_item{
	width: 3rem;
	/* items 宽度和 6rem，同样没有 overflow ，而是自动换行*/
}
```


![wrap](http://upload-images.jianshu.io/upload_images/1571420-b109ba7c044662e2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
### 0x04 flex-flow
`flex-flow` 是 `flex-direction` 和 `flex-wrap` 两个属性的简写属性，只是这两个属性。

```
.wrap{
    flex-flow:row-reverse wrap-reverse;
}
```

---
### 0x04 items 中的 flex
在 `items` 中使用 `flex` 可以设定每个 `items` 在 `flex` 容器中所占据的空间比例，而且还可以指定最小值。

`flex` 的书写格式是: _flex: flex-grow flex-shrink  flex-basis_

`flex-grow`:表示 item 扩展时在容器中所占据的空间比例
`flex-shrink`:表示 item 缩放时在容器中所占据的空间比例
`flex-basis`:表 item 的原始大小。


```
.wrap .flex_item:nth-child(1){
	background: #333;
	flex:1 1 1rem;
}

.wrap .flex_item:nth-child(2){
	background: deeppink;
	flex: 2 1 2rem;
}

.wrap .flex_item:nth-child(3){
	background: green;
	flex: 3 1 3rem;
}
```


![items](http://upload-images.jianshu.io/upload_images/1571420-727547682c8c0cf5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### justify-content 
`justify-content` 设置 `flex` 容器的 `main axis` 对齐方式。

`justify-content` 各属性值如下:
`justify-content:flex-start(默认值)`:在 main axis 的 flex-start 对齐


![flex-start](http://upload-images.jianshu.io/upload_images/1571420-67153ec24a7ecad3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


`justify-content:flex-end`:在 main axis 的 flex-end 对齐


![flex-end](http://upload-images.jianshu.io/upload_images/1571420-c3cd12bbcdb02595.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


`justify-content:center`:在 main axis 的 中心对齐


![center](http://upload-images.jianshu.io/upload_images/1571420-782ac590dd876552.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`justify-content:space-between`:在 main axis 的两端对齐。
  

![space-between](http://upload-images.jianshu.io/upload_images/1571420-72f3ee1ee34fa462.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


`justify-content:space-around`:


![space-around](http://upload-images.jianshu.io/upload_images/1571420-ec5dbc65e9572998.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



#### align-items
`align-items` 决定 cross axis 的对齐方式,`align-items` 于 `justify-content` 的作用是一致的，只是他们的方向不同而已，但是其与 `align-content` 区别在于，`align-items` 是作用于当前 flex 容器中的 items，而 `align-content` 则是用于 item 中内容的垂直对齐。

`aling-items` 其属性值有:
`align-items:center`: 在 cross axis 中心对齐


![center](http://upload-images.jianshu.io/upload_images/1571420-8075c74e5862ab42.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


`align-items:flex-start`: 在 cross axis 的 flex-sart 对齐


![flex-start](http://upload-images.jianshu.io/upload_images/1571420-21fabbcb23669e03.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`aling-items:flex-end`: 在 cross axis 的 flex-end 对齐


![flex-end](http://upload-images.jianshu.io/upload_images/1571420-0f07b56b7e674b0f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


`align-items:stretch默认值)`:当 `flex` 容器有高度，而 `items` 没有高度时，`items` 的高度将会充满 `flex` 容器的高度。

![默认值为stretch](http://upload-images.jianshu.io/upload_images/1571420-c579119ae1195a0e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`align-items:baseline`:在 items 中的 文字基线对齐



---
### 圣杯模型

使弹性盒子根据不同屏幕分辨率动态改变布局。

```
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<link rel="stylesheet" type="text/css" href="mystyle.css">
	<style type="text/css">
		body {
	font: 24px Helvetica;
	background:#999999;
	border:1px green solid;
}

#main {
	min-height: 800px;
	margin: 0px;
	padding: 0px;
	display: -webkit-flex;
	display: flex;
	-webkit-flex-flow: row;
	flex-flow: row;
}

#main > article {
	margin: 4px;
	padding: 5px;
	border: 1px solid #ccc333;
	border-radius: 7pt;
	background: #dddd88;
	-webkit-flex: 3 1 60%;
	flex: 3 1 60%;
	-webkit-order: 2;
	order: 2;

}

#main > nav {
	margin: 4px;
	padding: 5px;
	border: 1px solid #8888dd;
	border-radius: 7pt;
	background: #ccccff;
	-webkit-flex: 1 6 2 20%;
	flex: 1 6 20%;
	-webkit-order:1;
	order:1;
}

#main aside {
	margin: 4px;
	padding: 5px;
	border: 1px solid #8888bb;
	border-radius: 7pt;
	background: #ccccff;
	-webkit-flex: 1 6 20%;
	flex: 1 6 20%;
	-webkit-order:3;
	order:3;

}

header, 
footer {
	display: block;
	margin: 4px;
	pading 5px;
	min-height: 100px;
	border: 1px solid #eebb55;
	border-radius: 7pt;
	background:#ffeebb;
}

/*窄到不足以支撑三栏的时候*/

@media all and (max-width: 640px) {
	#main, 
	#page{
		-webkit-flex-flow:column;
		flex-direction: column;

	}

	#main > article, 
	#main > nav,
	#main > aside {
		/*恢复到文档内的自然顺序*/
		-webkit-order: 0;
		order:0;
	}

	#main > nav,
	#main > aside,header,footer {
		min-height: 50px;
		max-height: 50px;
	}
}
	</style>
</head>

<body>
	<header>header</header>
	<div id="main">
		<article>article</article>
		<nav>nav</nav>
		<aside>aside</aside>

	</div>
	<footer>footer</footer>

</body>

</html>
```

