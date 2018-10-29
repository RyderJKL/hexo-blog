---
title: CSS 3D
date: 2016-11-14 13:50    
tags: ['CSS3','CSS3D']
toc: true
categories: technology

---
### 0x00 transform 2D
我们先来看看在二维坐标系中的 `transform` 的作用效果。

`transform` 可以让元素进行移动`translate`,旋转`rotate`,缩放`scale`,变形`skew`。

> 2D 中的旋转角为正时,将会沿顺时针旋转。

##### 旋转

```
transform:rotate(50deg)
```

##### 缩放

```
transform:scale(xNum,yNum)
```

##### 倾斜

```
transform:skewX(angle)
transform:skewY(angel)
trasnform:skew(xangle,yangle)
```

##### 平移

```
transform:tanslate(x,y)
```



---
### 0x01 CSS 3D


---
#### 关于坐标系

传说从初中到高中到大学的课堂上，教材中所涉及的立体几何基本都是右手系。
关于左手系与右手系的关系，见下图。

![坐标系](http://upload-images.jianshu.io/upload_images/1571420-08e3ebedd4e32d00.png?imageMogr2/auto-orient/strip)

规定在右手坐标系中，物体旋转的正方向是右手螺旋方向，即**从该轴正半轴向原点看是顺时针方向(记住这点很重要，不然在之后的 CSS 3D 旋转属性中，你的世界会有种眩晕感，然后你的坐标系开始紊乱，然后你的宇宙就崩溃了。。。)

OK,我们借坐标系短暂回忆了下我们的青春，现在我们来看看值移动设备或PC中的坐标系是如何建立的，同样见下图，一目了然。


![3D坐标系](http://upload-images.jianshu.io/upload_images/1571420-a5756362f624def7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 在移动设备和电脑中 Y 轴是向下的。


---
### 0x02 transform 3D 属性

#### transform-origin
`transform-origin` 可以改变元素是旋转中心的位置。默认情况下，元素即绕三维物体会绕着自身的中心点旋转。`rotate()` 默认的旋转中心是(50%,50%)。

CSS3变形属性中旋转、缩放、倾斜都可以通过 `transform-origin` 属性重置元素的原点，但其中的位移 `translate()` 始终以元素中心点进行位移。


####  persective
需要知道的是，在设计 3D 效果时:

* 只能选择透视方式，也就是近大远小的显示方式。
* 镜头方向只能是平行Z轴向屏幕内，也就是从屏幕正前方向里看。
* 初始状态下，所有元素都是放置在z=0的平面上。

`perspective` 属性让元素拥有了视野和视角的效果，而不是像以往的贴在屏幕上的平面，模拟了眼睛与物体之前的距离带来的远近视差效果。

通过 `perspective(透视)` 属性， 可以设置镜头到元素所在平面的距离，它会让东西看起来近处的大，远处的小。以此，从视觉上产生不同程度的3D效果。其默认值是设备的屏幕分辨率。所以不同设备的 `perspective` 默认值是不一样的。

设置 `perserspective` 有两种方式，

```
transform: perspective( 400px );
/**或者**/
perspective: 400px;
```

这两种写法，都触发了元素的3D行为，函数型的写法`transform:perspective(400px)` 适用于单个元素，会对每一个元素做3D视图的变换，而`perspective:400px` 的写法，需写在父元素上。

所以，`perspective` 并不影响当前元素的渲染，而是影响它的所有子元素。这也是它跟*transform:perspective()*方法的主要区别。

> 在 WebKit 浏览器里，使用 `perspective` 只要是它的祖先元素都行，但在火狐或IE里只能是直接父元素。


![perspective 1000px](http://upload-images.jianshu.io/upload_images/1571420-4e630ef425dfa715.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![perspective 300px](http://upload-images.jianshu.io/upload_images/1571420-dc9f239a7c94c84e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



 此外,`perspective-origin` 属性规定了镜头在平面上的位置。镜头的默认位置是 **对着** 元素的中心点的。

#### backface-visibility
backface-visibility 属性可用于隐藏内容的背面。

#### transform-style

`transform-style` 属性是3D空间一个非常重要的属性，指定嵌套元素如何在3D空间中呈现。他主要有两个属性值：`flat` 和 `preserve-3d`。

其中 `flat` 值为默认值，表示所有子元素都在2D平面呈现。而 `preserve-3d` 表示所有子元素在3D空间中呈现。

当对 **舞台元素** (变形元素们的共同直接父元素)使用 `transform-style:perserve-3d` 时，便是为其中的所有的子元素声明了一个 3D 渲染空间，这样处于其中的子元素便会以 3D 的形态展现出来。

> `transform-style`  属性是非继承的，即只对其直接子元素提供 3D 渲染空间，对于中间节点需要显式设定。

**如果需要使用 3D 模式，必须先为其直接父元素指定 `transform-style:perserve-3d`，并在任意祖先元素(包括直接父级元素)上增加 `perspective ` 属性，有必要的好最好一并添加 `perspective-origin` 来指定透视点。

---
### 0x03 绘制 3D 图像

---
#### 正方体
```
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>Cubes</title>
<meta name="description" content="">
<meta name="keywords" content="">
<link href="" rel="stylesheet">
<style type="text/css">
	html,body{
		perspective-origin: 50% 50%;
		perspective:1000px;
		height: 100%;
		width: 100%;
		background: #444;
	}

	.cube {
		position: fixed;
		top:25%;
		left: 50%;
		width: 200px;
		height: 200px;
		margin-left: -100px;

	}

	.container-3D{
		transform: rotateX(0deg) rotateY(0deg) rotateZ(0deg);
		transform-style: preserve-3d;
		animation: rotation 10s linear infinite;
	}

	@-webkit-keyframes rotation {
		from{
				transform: rotateY(0deg) rotateX(-180deg) rotateZ(-140deg);
		}50%{
				transform: rotateY(360deg) rotateX(-360deg) rotateZ(0deg);
		}to{
				transform: rotateY(360deg) rotateX(180deg) rotateZ(220deg);
		}
	}

	@-webkit-keyframes plus{
		from{	width: 200px; height: 200px;background-color: #B00;border-width: 1px;border-color: #000;border-radius: 0px;	}
		20%{	width: 200px; height: 200px;background-color: deeppink;border-width: 10px;border-color:#333;border-radius: 15px;	}
		40%{	width: 100px; height: 100px;background-color: yellowgreen;border-width: 12px;border-color: #444;border-radius: 20px;	}
		60%{	width: 100px; height: 100px; background-color: #B00; border-width: 30px;border-color: #fff;border-radius: 50px}
		80%{	 width: 180px; height: 180px; background-color: #0B0; border-width: 10px;border-color: #000; border-radius: 0px	}
		to{		width: 200px; height: 200px;background-color: #333;border-width: 1px;border-color: #123;border-radius: 10px;	}
	}


	.face{
		background: rgba(200,200,200,1);
		width: 200px;
		height: 200px;
		position: absolute;
		border:1px solid black;
		transform-style: preserve-3d;
		animation: plus 5s ease-in-out infinite alternate;
	}

	.face--front{
		transform: translateZ(100px);
	}

	.face--back{
		transform: translateZ(-100px);
	}

	.face--left{
		transform: rotateY(-90deg) translateZ(-100px);
	}

	.face--right{
		transform: rotateY(90deg) translateZ(-100px);
	}

	.face--top{
		transform: rotateX(-90deg) translateZ(100px);
	}

	.face--bottom{
		transform: rotateX(90deg) translateZ(100px);
	}
</style>
</head>
<body>
    <div class="cube container-3D">
    	<div class="face face--front">face--front</div>
    	<div class="face face--back">face--back</div>
    	<div class="face face--left">face--left</div>
    	<div class="face face--right">face--right</div>
    	<div class="face face--top">face--top</div>
    	<div class="face face--bottom">face--bottom</div>
    </div>
</body>
<script type="text/javascript" src=" " ></script>
</html>
```

如上，我们为 `html/body` 设置 `perspective` 属性，使其成为舞台元素，而为 `.container-3D` 添加了 `transform-style:preserve-3d` 使其成为渲染 3D 空间的容器，为其直接子元素开启 3D 渲染环境。

---
#### 3D container 元素的常用旋转动画

```
.container-3D{
		transform: rotateX(0deg) rotateY(0deg) rotateZ(0deg);
		transform-style: preserve-3d;
		animation: rotation 10s linear infinite;
	}

	@-webkit-keyframes rotation {
		from{
				transform: rotateY(0deg) rotateX(-180deg) rotateZ(-140deg);
		}50%{
				transform: rotateY(360deg) rotateX(-360deg) rotateZ(0deg);
		}to{
				transform: rotateY(360deg) rotateX(180deg) rotateZ(220deg);
		}
	}
```

