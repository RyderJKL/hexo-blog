---
title: CSS基础归纳(一)  
date: 2016-09-08 11:55  
tags: ['CSS']
toc: true
categories: technology

---
### 0x00 WEB 3层标准
前端页面三层:
结构: HTML(内容)
表现: CSS(Cascading Style Sheet)
行为: JS

CSS由三部分组成，对象，属性，和值。对象便是选择器。

 ---
 ### 0x02 HTML中使用CSS
 
 * 行内样式(内联样式)  
   位于html标记内，使用 `style` 属性定义:

   ```
   <p style="color:red;width=400px"></p>
   ```
   
* 内部样式  
  位于 `<head></head>` 之间，使用 `<style></style>` 标记声明：
  ```
  <head>
    <title></title>
    <style type="text/css">
        p { };
    </style>
  </head>
  ```
  
* 链接样式  
  从外部定义css样式表，通过 `<link/>` 链接到页面:
  ```
  <link href="style.css" rel="stylesheet" type="type/css" />
  ```
  
* 导入样式  
  在 `<style></style>` 标记之间导入一个外部样式表,导入时使用 `@import` :

  ```
  <head>
    <meta charset="utf-8"/>
    <title></title>
    <style type="text/css">
        @import url("style.css");
        @import url(style.css);
        @import "style.css";
    </style>
  </head>
  ```
  
以上三种方式均有效.
  
######  link 和 @import 的区别:
 
> 1)link属于XHTML标签，而@import是CSS提供的;  
> 2)页面被加载的时，link会同时被加载，而@import引用的CSS会等到页面被加载完再加载;  
> 3）@import只在IE5以上才能识别，而link是XHTML标签，无兼容问题;  
> 4）link方式的样式的权重 高于@import的权重.
  

---
### 0x03 文字属性
  
属性|描述|属性值
:----|:---:|:----
font-weight | 字体加粗 | bold , normal (正常);
font-style | 字体风格 | normal (正常)，italic (斜体)
font-variant | 
font-size | 字号 | 数值 px ;数值 em ;
line-height | 行高（行距）| `px`, `em` 
font-family | 字体 | 可带多个属性值，用逗号隔开，依次执行。中文字体需使用双引号。

##### font的简写属性:

```
font: bold italic small-caps 1em/1.5em "宋体" sans-serif;
```

值得注意的是：`css` 速记版本只会在你同时指定  `font-size` 和 `font-family` 属性时才会生效。如果你没有指定 `font-weight`,  `font-style` ,或者 `font-variant`，那么这些值将会自动默认为 `normal`


---
### 0x04 text 文本属性

属性|描述|属性值
:---:|---|:---
color|文本颜色
direction|文本方向
line-height|行高| 数值 px ;
text-align|文本对齐方式| `left` , `center` , `right` ,
text-decoration|文本修饰| `underline` , `overline` , `line-through `, `none` , `blink`
text-indent|文本首行缩进| 数值 px ; 数值 em; 百分比 
text-tranform|元素中的字母(规范文本大小写)| `none` , `uppercase` ,`lowercase` , `capitalize`
white-space|设置空白的处理方式| `normal` , `pre-line` (合并空白序列，但是保留换行符) , `nowrap`(防止元素中的文本换行)， `pre`(空白符不会被忽略), `pre-wrap`(保留空白符序列)
word-spacing|单词间距(汉字不适用)
letter-spacing|字母间距(汉字使用)
text-shadow|文本阴影|四个参数{ px px px #f0000}
text-wrap|规定文本换行规则|


> !Note  
> 1.网页中常用的字体大小为12 px/14 px;  
> 2.行高(行距)的大小不能小于段落中字体的大小，一般行距为14 px;  
> 3.em 单位,1 em 相当于当前字体的属性，2 em 相当于当前字体尺寸的两倍， em 是非常有用的单位，它可以自动使用用户所使用的字体.  
> 4.使文本垂直居中的小技巧就是为元素设置行高 `line-height`，使其水平居中设置 `text-align:center`
  
---
### 0x05 背景

属性|描述|属性值
:---:|:---:|:---
background-color|设置元素的背景颜色|`rgba(0,0,0,0.5)设置背景透明`
background-image|设置元素的背景图片
background-position|设置背景图片的起始位置| `left` ,`right` , `center`, `top` , `bottom`  也可以使用数值: `px` , `百分比`
background-repeat|设置背景图片是否及如何重复| repeat (重复); no-repaet (不重复); repeat-x (横向平铺); repeat-y (纵向平铺)；默认为 `repeat`
background-attachment|背景图案是否固定或者随着页面滚动| `fixed` , `scroll` ;默认值 `scroll`
background-size|控制背景图片的尺寸|`50%`,`100px,50px`,`cover`(拉大，覆盖；保持宽高比),`contain`(缩小，使其恰好适合背景区；保持宽高比)
background-clip|控制元素背景显示区域|`border-box` , `padding-box` ,`context-box`


```
body {
  background-color:rebeccapurple;
  background-image:url("03ec10.jpg");  #注意url的格式
  background-repeat:no-repeat;#设置背景图片是否重复显示以及如何显示
  background-attachment:fixed;#设置图片随着内容一起滚动(相对浏览器固定)
  background-position:right center;
  background-size:100px 100px;#设置背景图片的大小
}

!<--background 的简写属性-->
body{
    background: red url("123.jpj") no-repeat center;
}
```


> !Note \
1.background-postion 属性值要先写水平方向的属性，再写垂直方向的属性。\
2.background-attachment 属性只适用于 `body`





---
### 0x06 列表项目的符号样式 list-style

属性|描述|属性值
:---:|:--:|:---
list-style-type|列表项目符号样式| `none` , `dashed` , `circle` 
list-style-image|设置图片作为项目符号|
list-style-position|项目符号定位| `inside`(符号在列表项内) , `outside` (符号在列表项外))

##### list-style-type
对于无序列表的 `list-style-type` 属性值有三种: `disc`, `circle`, `square`

有序列表的 `list-style-type` 属性值有: `decimal`, `lower-roman`, `upper-roman`, `lower-latin`, `upper-latin`


##### list-style 简写

```
ul li {
 list-style: url("listtypeiamge.png") inset;
```






---
### 0x07 行元素,块元素和空元素

#### 行内元素

> 1)和其它元素都在一行上; \
2)元素的高度，宽度，行高及顶部和底部的边距不可设置; \
3)元素的宽度就是它包含文字或者图片的宽度，不可改变；

但是在行元素中有两个例外的标签 `input` , `img`。

所以，行内元素在设置 水平方向的 `padding-left`、`padding-right`、`margin-left`、`margin-right` 都产生边距效果，但竖直方向的 `padding-top` 、`padding-bottom`、`margin-top`、`margin-bottom` 却不会产生边距效果。


#### 块级元素

> 1)每个块级元素都从新的一行开始，并且其后的元素也另起一行。（真霸道，一个块级元素独占一行）;\
2)元素的高度、宽度、行高以及顶和底边距都可设置; \
3)元素宽度在不设置的情况下，是它本身父容器的100%（和父元素的宽度一致），除非设定一个宽度。

##### 块元素和行元素列表



![label.png](http://upload-images.jianshu.io/upload_images/1571420-e2d43ca21c61a213.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### 空元素
知名的空元素: `<br> <hr> <img> <input> <meta> <link>`


---
### 0x08 单位

#### 长度单位

##### em

`em` 为相对长度单位，相对于当前对象内文本的字体尺寸`(font-size)`。比如：Web页面中`body`的文字大小在用户浏览器下默认渲染是`16 px`，所以，此时的 `1em = 16px`;

##### in (英寸:inches), pt(点:points) 
`in` 和 `pt` 都是绝对长度单位，它们的关系如下:

```
1 in = 2.54 cm = 25.4 mm = 72 pt = 6 pc =96 px
```

#### 角度单位

##### deg
度(Degress)。 一个圆共360度

##### grag
梯度(Gradians)。一个圆共400梯度

##### turn 
转，圈(turn)。一个圆共1圈

##### rad
弧度(Radians)。一个圆共2pi弧度

###### 各个角度之间的关系

```
90 deg = 100 grad = 0.25 turn
```




---
### 0x09 盒子模型


![cssbox.png](http://upload-images.jianshu.io/upload_images/1571420-f51788b857aa2c7d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




盒模型中主要是使用div来进行布局的，其构成元素为: margin 外边距， border 边框， padding 内填充， content 内容。

其width和height的设置是针对content的宽度和高度的设置。

整个div所占的宽度和高的=内容+内边距+边框+外边距

#### WEB标准中padding的使用规范

当**padding**为四个值的时候按照顺时针： `padding-top` -> `padding-right` -> `padding-bottom` -> `padding-left` 的顺序。


属性|对应值|
:---:|:--:|:---
padding四个值| `top` , `right` , `bottom` , `left`
padding三个值|`top` , `left right` , `bottom`
paddin二个值| `top bottom` , `left right`


与 **padding** 属性相似的属性还有 **margin** 。

> !Note 关于 `margin`  
margin-left 使当前元素向右移动，margin-right 使得下一个元素向右移动。

#### 边框样式 border
##### border-color
##### border-width
##### border-style
属性值有： `dashed (虚线)` , `dotted (点)` , `double (双线)` , `solid (实线)`, `inset`, `outset`, `ridge`, `groove`

此外还可以使用 `none` 或者 `hidden` 来明确的移除边框，或者设置边框颜色为 `transparent` 来让边框不可见，后者不会影响布局。



##### border-radius [ CSS3 ]

`border-radius` 用于绘制圆角边框。其值可使用 `px` 或者 `百分比`。

```
border-radius:20px; 指定四个相同半径
border-radius: 20px 40px; 左上，右上，剩下的对角匹配。
border-radius: 5px 10px 40px;上左，上右，下右，下左。剩下的对角匹配。
border-radius: 5px 10px 20p 40px;上左，上右，下右，下左。
```

###### 单独绘制某一角圆角边框:

```
border-top-right-radius:右上角
border-bottom-left:左下角
```

所以是对 `border-radius` 的描述方向是**先垂直后水平** 。





---
### 0x0B text-overflow 
`text-overflow` 只有两个属性值。

```
clip : 不显示省略标记，而是简单的剪裁
ellipsis : 当对象内文本溢出时显示省略标记
```

> 注释:  
`text-overflow` 属性仅是注解，当文本溢出时是否显示省略标记。要实现溢出时产生省略号的效果还须定义：强制文本在一行内显示（`white-space:nowrap`）及溢出内容为隐藏（`overflow:hidden`），只有这样才能实现溢出文本显示省略号的效果。

> 显然该属性只对块元素有效，如果是 <a> 标签，呵呵~

```
.content {overflow:hidden; white-space:nowrap;text-overflow:ellipsis;}
```

---
### 0x0C gradient 渐变
渐变分为 `radial-gradient` (径向渐变) 和 `linear-gradient` (线性渐变)。

##### linear-gradient

```
#mybox{background:linear-gradient(to left,red, gold, black);}
```

第一个参数可指定的参数值:

```
to bottom : 从上往下
to right : 从左往右
to top : 从下往上
to left : 从右往左
```

其后的颜色值代表起点色，过渡色，终点色。


##### radial-gradient 

```
background:radial-gradient(circle at left bottom,#0084d6,#016dcc)
```

所以对 `radial-gradient` 来讲，描述其方向的规则是 **先水平后垂直**.



