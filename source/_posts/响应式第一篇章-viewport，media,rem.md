---
title: viewport ,media, rem
date: 2016-11-22
tags: ['响应式布局']
toc: true
categories: technology

---
### 0x00 viewport
通俗的讲，移动设备上的`viewport`就是设备的屏幕上能用来显示我们的网页的那一块区域，但实际情况下并不总是这样。

移动设备的屏幕尺寸比 PC 端的屏幕尺寸要小得多，所以，移动端的浏览器为了能让那些在 PC 端开发的网站被正常的显示，决定默认情况下把 `viewport` 设为一个较宽的值，我们暂且把这个浏览器默认的 `viewport` 叫做 **layout viewport**,这个 `layout viewport` 的宽度可以通过 `document.documentElement.clientWidth` 来获取(iphone6的 `layout viewport` 值为 `980 px`)。

此外，还需要一个 `viewport` 来代表浏览器可视区域的大小，我们这个 `viewport` 称为 **visual viewport` ,可以通过 `window.innerWidth` 来获取它的宽度值.

最后，还有一个能够完美适配移动端设备的 `viewport` 。所谓的完美适配指的是，首先不需要用户缩放和横向滚动条就能正常的查看网站的所有内容；第二，显示的文字的大小是合适，比如一段14px大小的文字，不会因为在一个高密度像素的屏幕里显示得太小而无法看清，理想的情况是这段14px的文字无论是在何种密度屏幕，何种分辨率下，显示出来的大小都是差不多的。我们把这个 `viewport` 叫做 **ideal viewport**，即是 **理想 viewport**，`ideal viewport` 的宽度等于移动设备的屏幕宽度。

 `ideal viewport` 并没有一个固定的尺寸，不同的设备拥有有不同的 `ideal viewport`,目前，iphone6的 `ideal viewport` 宽度值是 `375px`。

---
### 0x01 meta 媒体查询
我们可以通过 `meta` 标签对移动设备的 `viewport` (移动设备默认的是 `layout viewport`)，进行控制。

```
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=2.0,minimum-scale=0.5,user-scalable=yes"/>
```

对 meta viewport content 中的属性解释如下:
* `width` : 设置 **layout viewport** 的宽度，该值为一个正整数，当设置为字符串 **width-device** 时，意味着将浏览器的 viewport 设置为 **ideal viewport**。
* `initial-scale` :设置页面的初始缩放值
* `minimum-scale` :用户所能进行的最小缩放值
* `maximum-scale` :用户所能进行的最大缩放值
* `user-scalable` :是否允许用户进行缩放，值为 **yes** 或 **no**

> 这些属性可以同时使用，也可以单独使用或混合使用，多个属性同时使用时用逗号隔开。

此外，缩放是相对于 ideal viewport 来缩放的，缩放值越大，当前viewport 的宽度就会越小，反之亦然。

CSS3 加入的媒体查询使得无需修改内容便可以使样式应用于某些特定的设备范围。

在 `link` 元素中应用媒体查询:

```
<link href="example.css" rel="stylesheet" media="(max-width:800px) and (min-width:375px) ">
```
* `max-width` :当媒体可视区域的宽不大于该值时应用 example.css 样式 

* `min-width`: 当媒体可视区域的宽不小于该值时应用 example.css 样式 

在 CSS 样式中使用媒体查询:

```
<style type="text/css">
	@media screen and (max-width: 800px) and (min-width: 375px){
		/*style*/
		*{
			background: red;
		}
	}
</style>
```

这个查询适用于宽度在 375px 和 800px之间的屏幕 `screen` 。与此类似的媒体类型 `tv` 代表电视, `handheld` 代表手持设备,`print` 代表打印机。

其中，  `and` 属于逻辑操作符合，此外，还有 `not`, `only`, `or` 等逻辑操作符， 并且 `or` 操作符和 `逗号(,)` 操作符的作用一样。

比如，想在最小宽度为700像素或是横屏的手持设备上应用一组样式:

```
@media (min-width: 700px), handheld and (orientation: landscape) { ... }
// (orientation: portrait) 表示竖屏设备
```

> 媒体查询要写在 所有的 CSS 样式的最后

---
### 0x02 rem
当在进行移动设备的布局时，我们将会经常使用的一个单位是 **rem**,而不再是 **px**

#### rem, em
`rem` 与 `em` 的参考对象都是 `font-size` 这个属性的值，不过 em 的参考对象是父级的 font-size 值，而 rem 的参考对象是根元素 `<html>` 元素的 font-size 值。

> 1em = 父级 font-size 大小，1rem = 根元素 font-size 大小

如果html5要适应各种分辨率的移动设备，应该使用rem这样的尺寸单位,下面是各个分辨率范围在 `html上` 设置 `font-size` 的代码：

```
html{font-size:10px}
		@media screen and (min-width:321px) and (max-width:375px){html{font-size:11px}}
		@media screen and (min-width:376px) and (max-width:414px){html{font-size:12px}}
		@media screen and (min-width:415px) and (max-width:639px){html{font-size:15px}}
		@media screen and (min-width:640px) and (max-width:719px){html{font-size:20px}}
		@media screen and (min-width:720px) and (max-width:749px){html{font-size:22.5px}}
		@media screen and (min-width:750px) and (max-width:799px){html{font-size:23.5px}}
		@media screen and (min-width:800px){html{font-size:25px}}
```


