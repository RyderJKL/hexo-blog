---
title: jQuery(5)动画   
date: 2016-11-30 10:12            
tags: ['jQuery']
toc: true
categories: technology

---
### 0x00 基本方法

> jQuery 中的所有特效方法都支持一个回调函数


#### hide(dura,easing,func)

#### show(dura,easing,func)

#### toggle(dura,easing,func)
显示或隐藏匹配元素

#### slideDown(dura,easing,func)

#### slideUp(dura,easing,func)
用滑动动画隐藏一个匹配元素

#### slideToggle(dura,easing,func)
用滑动动画显示或隐藏一个匹配元素。

#### fadeIn(dura,easing,func)
通过淡入的方式显示匹配元素。

#### fadeOut(dura,easing,func)
通过淡出的方式隐藏匹配元素。

#### fadeTo(dura,func)
调整匹配元素的透明度。

#### fadeToggle(dura,easing,func)
通过匹配的元素的不透明度动画，来显示或隐藏它们。

当被可见元素调用时，元素不透明度一旦达到0，display样式属性设置为none ，所以元素不再影响页面的布局。

#### animate()
`animate()` 允许在任意的数字属性的 CSS上创建动画，所有用于动画的必需是数字属性的，这些属性如果不是数字的将不能使用基本的jQuery功能，(如：`width`,`height`,`left` 等样式属性以及`scrollTop`,`scrollLeft`)  


一个简单的动画效果如下:

```
$("button").on("click",function(){
	$("#middle").animate({
		opacity:0.5,
		left:'+=50',
		height:'toggle',
	},1000,"linear",function(){
		$("#middle").css("left","-=50")
	})
})
```

除了定义数值，每个属性能使用 `show`, `hide`, 和 而 `toggle`. 而 `toggle` 关键字必须在动画开始前给定属性值。

`.animate()` 默认的缓动函数是 `swing`，可以设置 `linear`动画。再多的动画效果便只有使用 `jQuery Easing Plugin` 插件了。

#### delay()
设置一个延时来推迟执行队列中后续的项。

```
$('#foo').slideUp(300).delay(800).fadeIn(400);
```

#### stop(queue,clearQue,jumptoEnd)
停止匹配元素当前正在运行的动画。

参数 `queue` 表示要停止动画队列的名称  
参数 `clearQue` 是一个布尔值，当一个元素拥有多个动画时表示是否在停止动画时清除队列中的所有的动画。  
参数 `jumptoEnd` 也是一个布尔值，当为 `true` 时，表示在停止动画后，该元素上的 CSS 属性会被立刻修改成动画的目标值，并且执行回调函数。  

一个额外的方法 `slideToggle()`,会立刻从当前位置向反方向开始动画。

```
$("#clickme").on("click",function(){		
	$("#middle").stop().slideToggle(1000)
})
```


#### finish()
.finish()方法和.stop(true, true)很相似，.stop(true, true)将清除队列，并且目前的动画跳转到其最终值。但是，不同的是，.finish() 会导致所有排队的动画的CSS属性跳转到他们的最终值。


