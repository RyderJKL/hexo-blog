---
title: JS事件(2)mousewheel和scrollTop
date: 2016-10-20
tags: ['JavaScript','JS事件']
toc: true
categories: technology

---
### 0x00 浏览器的渲染兼容模式
全球的浏览器市场可谓三分天下，Chrome，FireFox，IE，而在各自的背后都追随着自己的若干小弟，它们各自都遵循这个共同渲染标准，同时也有用这属于自身的规范和特性。

我们可以通过
`document.compatMode` 这个属性来检测浏览器的渲染模式，它 返回两个值，`BackCompat(混杂模式，怪异模式)` 和 `CSS1Compat(标准模式)`。

在`BackCompat` 模式下通过`document.body` 来获得页面的变化，而在`CSS1Compat`模式下`document.docuementElement`来获得页面变化。


```
EventUtil.addHandler(window, "scroll", function(event){
	if(document.compatMode == "CSS1Compat"){
		// 如果是在标准模式下,那么通过 <html> 元素来获得页面变化
		console.log(document.documentElement.scrollTop);
	} else{
		// 如果是在混杂模式下，那么通过 <body> 元素来获得页面变化
		console.log(document.body.scrollTop);
	}

});
```

比较有意思的是，如果我们想获得可视区域的高度，那么对于 FireFox，通过 `document.body.clientHeight` 和 `document.documentElement.clientHeight` 都是可行的，但是对于 Chrome 则只能通过 `document.documentElement.clientHeight` 才行得通。


---
### 0x01 Chrome 添加全局 mousewhell

方法一,通过给 `document.documentElement` 添加
```
document.documentElement.onmousewheel = function(event){
	event.preventDefault()
	if(event.wheelDelta <0){
		document.body.scrollTop = 5400;
		console.log(document.body,scrollTop);
	}else{
		document.body.scrollTop = -5400;
	}
}
```

方法二，通过给 `window` 添加

```
window.onmousewheel = function(){
	event.preventDefault()
	if(event.wheelDelta <0){
		document.body.scrollTop = 5400;
		console.log(document.body.scrollTop);
	}else{
		document.body.scrollTop = -5400;
	}
}
```


---
### 0x03 兼容FireFox和Chrome的 mousewheelScrollTop

```
var EventUtil = {
		addHandler: function(element,type,handler){
                        if(element.addEventListener){
				element.addEventListener(type, handler);
			} else if (element.attachEvent){
				element.attachEvent(type, handler);
			} else {
				element["on" + type] = handler;
			}
		},

		getEvent: function(event){
			return event ? event : window.event;
		},

		getTarget: function(event){
			return event.target || event.srcElement;
		},
		preventDefault: function(event){
			if(event.preventDefault){
				event.preventDefault();
			} else {
				event.returnValue = false;
			}
		},
		removeHandler: function(){
			if (element.removeElementListener){
				element.removeElementListener(type,handler);
			} else if (element.detachEvent){
				element.detachEvent;
			} else {
				element["on" + type] = null;
			}
		},
		stopPropagation: function(){
			if(event.stopPropagation){
				event.stopPropagation();
			} else{
				event.cancelBubble = true;
			}
		},

		getWheelDelta:function(event){
			if(event.wheelDelta){
            	return event.wheelDelta;
        	} else {
            	return -event.detail*40;
			}
		},

};

	function mousewheelScrollTop (event){
		var event = EventUtil.getEvent(event)
		EventUtil.preventDefault(event);
		var wheelDelta = EventUtil.getWheelDelta(event);
		console.log(wheelDelta);
		if(wheelDelta<0){

			if(document.compatMode=="CSS1Compat"){
			// FireFox
				document.documentElement.scrollTop = 5000;
			}else{
			// Chrome
				document.body.scrollTop = 5000;
			}

		}else{
			if(document.compatMode=="CSS1Compat"){
				document.documentElement.scrollTop = -5000;
			}else{
				document.body.scrollTop = -5000;
			}
		}
	}

	EventUtil.addHandler(window,"DOMMouseScroll",mousewheelScrollTop);
	EventUtil.addHandler(window,"mousewheel",mousewheelScrollTop);
```

## scrollTop 注意事项

当页面有DTD文档说明时:使用document.body.scrollTop的值总是0.此时需要使用document.documentElement.scrollTop.

页面具有 DTD（或者说指定了 DOCTYPE）时，使用 document.documentElement。
页面不具有 DTD（或者说没有指定了 DOCTYPE）时，使用 document.body。
在 IE 和 Firefox 中均是如此。
为了兼容，可以使用如下代码：

```js
let scrollTop = window.pageYOffset
|| document.documentElement.scrollTop
|| document.body.scrollTop
|| 0
```

