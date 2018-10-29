---
title: JS事件(3)EventUtil对象  
date: 2016-10-20      
tags: ['JavaScript','JS事件']
toc: true
categories: technology

---

```
var EventUtil = {
		addHandler: function(element, eventType, handler){
			if (element.addEventListener){
				// 所有现代浏览器都可以使用的方法，IE9，firefox，chrome
				element.addEventListener(eventType, handler, false)
			} else if (element.attachEvent){
				// 主要是为了兼容 IE8，IE8 是最后一个使用专用事件系统的主流浏览器。
				element.attachEvent( 'on' + eventType, handler)
			} else {
				element['on' + eventType] = handler;
			}
		},

		getEvent: function (event) {
			return event || window.event
			/*在 IE 中使用 DOM0 级方法添加事件时， event 对象将会作为 window
			对象的一个属性存在。若是使用 attachEvent() 方法添加事件，便会有一个 event 对象作为参数被传入事件处理程序函数中。如果是通过 HMTL 特性指定事件处理程序，那么还可以通过一个 event 的变量来访问 event 对象。*/
		},

		getTarget: function (event){
			return event.target || event.srcElement
			// target 现代浏览器
			// srcElement IE8 以下
		},

		preventDefault: function(event){
			if (event.preventDefault){
				event.preventDefault()
				// 阻止现代浏览器默认事件
			} else {
				event.returnValue = false
				// 阻止 IE8 默认事件
			}
		},

		stopPropagation: function(event){
			// IE8 不支持事件捕获，因此在夸浏览器的情况下，该方法只能用来阻止事件冒泡。
			if(event.stopPropagation){
				event.stopPropagation()
				// 阻止现代浏览器事件传播
			} else {
				event.cancelBubble = true;
				// 阻止 IE8 事件传播
			}
		},
		getWheelDelta:function(){
			// 总是返回 120 的倍数，为正表示鼠标滚轮向上滚动
			// 获取鼠标滑轮增量
			if(event.wheelDelta){
				// 主流浏览中 mousewhell 中的 wheelDelta
				/*当鼠标滚轮向前滑动时，wheelDelta 是120的倍数；当滚轮向后滑动时，wheelDelta 是 -120 的倍数。*/
				return (client.engine.opera && client.engine.opera < 9.5 ? -event.wheelDelta : event.wheelDelta);
			} else {
				/* FireFox 支持的是一个 DOMMouseScroll 的类似事件，而有关鼠标滚轮有关的信息则保存在 detail 属性中，当向前滑动鼠标滚轮时，该属性的值是 -3 的倍数，当向后滑动鼠标滚轮时，该属性值是 3 的倍数。*/
				return -event.detail*40;
			}
		},

		getPageCoordinates: function(event){
			// 获取鼠标在页面中的位置
			var pageX = event.pageX
			var pageY = event.pageY
			// IE8 不支持事件对象上的页面坐标，所以需要通过 client 偏移量 和 scroll 偏移量来计算
			if (pageX === undefined){
				pageX = event.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft)
			}

			if (pageY === undefined){
				pageY = event.clientY + (document.documentElement.scrollTop || document.body.scrollTop)
			}

			return {
				'pageX': pageX,
				'pageY': pageY
			}
		},

		removeHandler: function(element, eventType, handler){
			if(element.removeEventListener){
				element.removeEventListener(eventType, handler, false)
			} else if (element.detachEvent){
				element.detachEvent('on' + eventType, handler)
			} else {
				element['on' + eventType] = null;
			}
		}
	}
```

