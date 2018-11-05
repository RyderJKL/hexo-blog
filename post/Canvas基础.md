# Canvas

title: Canvas基础
date: 2016-11-09
tags: ['HTML5']
toc: true
categories: technology

---

## 0x00 Canvas

---

使用 Canvas 元素必须为其设置宽度和高度属性，指定可以绘制区域的大小。如果不添加任何样式或者不绘制任何图形，那么是看不到该元素的。

但是若是通过 CSS 样式来为其设置宽高属性的话，如果 CSS 的尺寸与 canvas 初始比例(canvas 默认初始宽度 300 px 高度 150 px)不一致，它会出现扭曲。

创建 Canvas 元素，并通过 `canvas.getContext()` 方法获取其 2D 上下文。

```js
// HTML
<canvas id="myCanvas" width="400" height="400">A drawing of something.</canvas>

// JS
var drawing = $("#myCanvas")

if (drawing.getContext){
  // 确定浏览器是否支持 <canvas>
  var context = canvas.getContext("2d")
}
```

如上，如果需要在画布上绘图，那么首先便需要获得绘图上下文。

然后，使用 `canvas.toDataURL()` 方法便可以获取在 `canvas` 元素上绘制的图像，它只接受一个参数，即是我们要指定图像的 MIME 类型。

```js
if(drawing.getContext()){
   var imgURL = drawing.toDataURL("image/png");
   // 获取图像的数据 URL
```

## 0x01 2D 上下文

---

使用 2D 上下文可以绘制简单的 2D 图形，比如矩形，弧线和路径。其两种基本绘图操作是**填充(fillStyle)**和**描边(strokeStyle)**

### 使用 strokeRect() 和 fillRect() 绘制矩形

可以使用 `fillStyle()` 属性来为通过 `fillRect()` 绘制的矩形填充颜色；使用 `strokeStyle()` 属性来为 `strokeRect()` 方绘制的矩形描边

```js
var drawing = $("#myCanvas")

if (drawing.getContext){
  // 检测浏览器是支持 canvas
  var context1 = drawing.getContext("2d");
  // 获得 2d 上下文

  context1.fillStyle = "red"
  context1.fillRect(40,20,50,50)
  // 绘制一个矩形并填充 红色

  context1.strokeStyle = "blue"
  context1.strokeRect(10,10,50,50)
  // 绘制一个矩形并描边为 蓝色
}
```

此外，可以使用 `clearRect()` 方法来清除指定区域。

## 0x02 绘制路径

---

一切形状的原始基础都是路径。在 Cavans 创建一个形状的首先需要的是创建新路径`beginPath`，再通过绘图命令，比如`moveTo`等在路径中绘制，然后关闭路径`clostPath`，最后填充颜色`fill`或描边`stroke`。

!> 调用`fill`函数时，所有没有闭合的形状都会自动闭合，所以你不需要调用`closePath`函数。但是调用`stroke`时不会自动闭合。

### moveTo()

设置笔触相对于画布左上角开始的起点位置，即是路径的起始点。

### lineTo()

直线路径。

## 0x03 描边三角形

---

```js
var drawing = $("#myCanvas")
if(drawing.getContext){
  // 检测浏览器是支持 canvas

  var context = drawing.getContext("2d");
  // 获得 2d 上下文

  context.beginPath()
  context.strokeStyle = "green"
  context.moveTo(50,200)
  context.lineTo(200,100)
  context.lineTo(100,50)
  context.closePath()
  context.stroke()
  // 描边三角形
}
```

![描边三角形](http://upload-images.jianshu.io/upload_images/1571420-56b87f33759a9711.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 0x03 填充三角形

```js
var drawing = document.querySelector("#drawing")

if(drawing.getContext){
  //是否支持 canvas
  context = drawing.getContext("2d")
  // 获得 2d 上下文
  context.beginPath()
  // 开始绘画
  context.fillStyle = "#333"
  // 填充色为 #333
  context.strokeStyle = "deeppink"
  // 描边颜色为 deeppink
  context.lineWidth = "20"
  // 线框为 20 px
  context.moveTo(150,150)
  // 起始触点 (150,150)
  context.lineTo(150,300)
  context.lineTo(300,225)
  // 绘制一个三角形
  context.closePath()
  // 闭合路径
  context.stroke()
  // 描边
  context.fill()
  // 填充
}
```

![ 描边填充三角形](http://upload-images.jianshu.io/upload_images/1571420-91cb003197633c76.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 0x04 圆

---

### arc() & arcTo()

`arc(x,y,radius,startAngle,endAngle,clockwise)`： 画一个以`(x,y)`为圆心，以`radius`为半径的圆弧（圆），从`startAngle`开始到`endAngle`结束，按照`anticlockwise`给定的方向（默认为顺时针）来生成。

!> arc() 函数中的角度单位是弧度，不是度数。角度与弧度的js表达式: `radians=(Math.PI/180)*degrees`。

## 0x05 描边圆形

---

```js
for(var i=0;i<6;i++){
  for(var j=0;j<6;j++){
     context.strokeStyle ='rgb(0,' + Math.floor(255-42.5*i) + ',' + Math.floor(255-42.5*j) + ')'
     context.beginPath()
     context.arc(50+60*i,50+60*j,30,0,Math.PI/180*360)
     context.stroke()
  }
}
```

![描边圆形](http://upload-images.jianshu.io/upload_images/1571420-1f909219b6dd44d0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
参考　MDN 官网。

## 0x06 填充圆形

---

描边填充圆形，并使用`globalAlpha`, 设置其透明度为`0.3`

```js
context.beginPath()
context.strokeStyle = "deeppink"
context.fillStyle ="#333"
context.globalAlpha = "0.3"
context.lineWidth = "20"
context.arc(450,300,100,0,Math.PI/180*300)
context.closePath()
context.stroke()
context.fill()
```

![描边填充圆形](http://upload-images.jianshu.io/upload_images/1571420-64f0efd96a3f767e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 0x07 渐变

---

Canvas 支持的渐变效果包括线性(`createLinearGradient()`)和径向(`createRadialGradient()`)渐变,并使用`addColorStop()` 为其指定渐变颜色。

> `strokeStyle` 和 `fillStyle` 属性都可以接 `canvasGradient` 对象。

### 渐变颜色 addColorStop()

`addColorStop(position,color)` 中第一参数 `position` 表示颜色出现在渐变中的相对位置。

### 线性渐变 createLinearGradient()

`createLinearGradient(x1,y1,x2,y2)`，其所接收的四个参数，分别代表渐变的起点和终点。

```js
context.beginPath()
var lineGradient1 = context.createLinearGradient(100,200,100,400)
lineGradient1.addColorStop(0.5,"green")
lineGradient1.addColorStop(1,"red")
context.strokeStyle = lineGradient1
context.lineWidth = "20"
context.moveTo(100,200)
context.lineTo(100,400)
context.closePath()
context.stroke()
```

![linearGradient](http://upload-images.jianshu.io/upload_images/1571420-05e1fff4fc4e66c7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 径向渐变 createRadialGradient()

`createRadialGradient(x1,y1,r1,x2,y2,r2)`  方法接受 6 个参数，前三个定义一个以 (x1,y1) 为原点，半径为 r1 的圆，后三个参数则定义另一个以 (x2,y2) 为原点，半径为 r2 的圆。

```js
// 径向渐变
var radGrad = context.createRadialGradient(0,150,40,0,140,90)
radGrad.addColorStop(0,'#00C9FF')
radGrad.addColorStop(0.8,'#00B5E2')
radGrad.addColorStop(1,'rgba(0,201,255,0)')

// 画图形
context.fillStyle = radGrad
context.fillRect(0,0,150,150)
```

![radialGradient](http://upload-images.jianshu.io/upload_images/1571420-c5d332c80e72d543.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 0x08 绘制文本

---

### 文本样式

* `font`:这个字符串使用和 CSS 属性相同的语法. 默认的字体是 `10px sans-serif`
* `textAlign`:文本对齐方式，可选值:`start`,`end`,`left`,`right`,`center`
* `textBaseline`: 基线对齐方式，可选值:`top`,`middle`,`bottom`

### fillText(text,x,y,[,maxWidth])

在指定的`(x,y)`位置填充指定的文本，绘制的最大宽度(可选).

### strokeText(text,x,y,[,maxWidth])

在指定的`(x,y)`位置绘制空心文本，绘制的最大宽度(可选).

```js
var linGrad = context.createLinearGradient(50,50,400,200)
linGrad.addColorStop(0.2,"red")
linGrad.addColorStop(0.7,"deeppink")
// 设置渐变

var str = "to be or not to be "
context.beginPath()

context.font = "60px 宋体"
// 设置文字格式 必需

context.textAlign = "left"
// 设置文字对齐方式 必需

context.textBaseline = "middle"
// 设置文字基线 必需

context.shadowColor = "#333"
context.shadowOffsetX = 10;
context.shadowOffsetY = 10;
context.shadowBlur = 10;

context.closePath()
// 闭合路径
context.fillStyle = linGrad
// 设置 fillStyle
context.strokeStyle = linGrad
// 设置 strokeStyle
context.fillText(str,50,50,400)
// 填充文字
context.strokeText(str,50,100,400)
// 描边文字
console.log(context.measureText(str))//width:570
```

`measureText()` 方法，将返回一个 [TextMetrics
]对象的宽度、所在像素，这些体现文本特性的属性。

![绘制文本](http://upload-images.jianshu.io/upload_images/1571420-a2aae4e08fcbc6d8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 0x09 Using Images

---

`canvas` 强大的特性还以使我们对图像进行操作处理。

当然，在对图像进行操作之间必然要引入图像资源，`canvas` 支持多种不同的图像资源引入方式，这里只了解常用的两种方式:使用 `Image` 对象或 `<img>` 标签 和 引用同一页面中的另一画布作为图像资源.

### drawImage(source,x,y)

 图像资源，以及在画布中的起始位置

### drawImage(source,x,y,width,height)

图像资源，在画布中的起始位置，并以指定的宽度和高度显示在画布中。以次实现图像的缩放效果。

```js
var isImage = new Image;
isImage.src = "Koala.jpg"
isImage.onload = function(){
  // do drawingImage statement
  context.drawImage(isImage,60,60,400,400)
  //五个参数时，代表图片在画布中显示的起始点和图片显示的宽高
}
```

![五个参数](http://upload-images.jianshu.io/upload_images/1571420-62612f58887fb1d4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### drawImage(source, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight)

当使用九个参数时，便是需要对图像进行**切片**处理了。其中sx,sy,sWidth,sHeight 规定要在图像源中取得的切片位置和切片大小；dx,dy,dWidht,dHeight 表示该切片在画布中显示的起始位置
和大小。

```js
var isImage = new Image;
isImage.src = "Koala.jpg"
isImage.onload = function(){
  context.drawImage(isImage,300,300,400,300,100,100,200,200)
}
```

![九个参数](http://upload-images.jianshu.io/upload_images/1571420-80a15d210cb60353.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### createPattern()

我们可使用 `createPattern()` 方法来规定图像显示的方式，`none`,`repeat`,`repeat-x`,`repeat-y`

```js
var isImage = new Image;
isImage.src = "Koala.jpg"
isImage.onload = function(){
  //图片是否平铺
  var imgs = context.createPattern(isImage,"repeat-x")
  context.fillStyle = imgs
  context.fillRect(0,0,700,500)
}
```

## 0xA 画布裁切 clip()

```js
var isImage = new Image;
isImage.src = "Koala.jpg"
isImage.onload = function(){
  context.drawImage(isImage,0,0,400,400)
}

//画布裁切 clip()
context.arc(230,230,170,0,Math.PI/180*360)
context.closePath()
context.clip()
```

![画布裁切](http://upload-images.jianshu.io/upload_images/1571420-99395eb635bd75fc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 0xB 画布方法

---

### save() 和 restore()

`save`和`restore`方法是用来保存和恢复`canvas`状态的，都没有参数。Canvas 的状态就是当前画面应用的所有样式和变形的一个快照。

```js
context.beginPath()
context.fillRect(50,50,150,150)
// 使用默认设置绘制一个矩形
context.save()
// 保存默认配置下的绘画状态
context.fillStyle = "deeppink"
// 设置一个新的绘画状态
context.fillRect(65,65,120,120)
// 使用新的绘制状态绘制一个矩形
context.restore()
// 恢复到默认绘制状态
context.fillRect(80,80,90,90)
// 同样，使用默认状态绘制一个矩形
```

![无](http://upload-images.jianshu.io/upload_images/1571420-c59ffb3396f2d479.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> `restore()` 恢复的是离它最近的 `save()` 之上 所保存的状态。

### translate()

`transltae(x,y)` 方法用 移动 canvas 原点。

```js
context.fillRect(50,50,100,100)
context.translate(100,100)
context.fillRect(50,50,100,100)
```

![translate](http://upload-images.jianshu.io/upload_images/1571420-a9c4b54f55df1361.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### scale(x，y)

`scale(x,y)` 缩放，其所接收的两个参数分别代表在 x 的缩放因子和在 y 轴的缩放因子。

```js
context.scale(1.5,1.5)
context.fillRect(50,50,100,100)
context.translate(150,150)
context.scale(0.5,0.5)
context.fillRect(50,50,100,100)
```

### rotate()

`rotate(angle)` 只接受一个参数，即旋转的角度，它是顺时针方向的，与 `arc()` 同样是以 **弧度** 为单位的值。

```js
context.rotate(Math.PI/180*deg)
```

> `scale` 也好，`translate`,`rotate()` 也好，所有的样式和变形命令都应该写在填充和描边命令之前。

## 0xC 画一个五角星

---

```js
var r = 200
context.translate(200,200)
context.beginPath()
context.moveTo(r,0)
for(var i=0;i<9;i++){
  context.rotate(Math.PI/180*36)
  if(i%2 == 0){
    context.lineTo(r/(Math.cos(Math.PI/180*36)*2)*0.7,0)
  }else{
    context.lineTo(r,0)
  }
}

context.closePath()
context.fill()
}
```

![五角星](http://upload-images.jianshu.io/upload_images/1571420-794492eef71ab485.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

