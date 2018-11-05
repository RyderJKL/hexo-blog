---
title: JS事件(1)事件初见  
date: 2016-10-20      
tags: ['JavaScript','JS事件']
toc: true
categories: technology

---
### 0x01 事件处理程序
事件是用户或者浏览器自身执行的某种动作。而响应某个事件的函数叫做**事件处理程序**。

---
#### DOM0 级事件处理程序

> 在所有浏览器中，对于 DOM0 级事件，事件处理程序都只会也只能在事件冒泡阶段被处理。

DOM0 级事件处理是将一个函数赋值给一个事件处理程序属性来实现的。

每个元素(包括 window 和 document)都有自己的事件处理程序属性，这些属性通常小写，例如 onclick。


事件处理程序的名字以 `on` 开头。
```
var btn = document.getElementById("myBtn");
btn.onclick = function(){
    alert(this.id)// "myBtn"
}
```

使用 DOM0 级方法指定的事件处理程序被认为是元素的方法。因此，这时的事件处理程序是在元素的作用域中运行。程序中的 `this` 指代的是当前元素。

DOM0 级对每个事件只支持一个事件处理程序。

---
#### DOM2 级事件处理程序
DOM2 级中的两个方法: `addEventListener()` **添加事件处理程序** 和 `removeEventListener()` **移除事件处理程序**。

它们接收三个相同的参数:事件名，事件处理函数，一个布尔值。如果布尔值为 true，表示在捕获阶段调用事件处理程序，false 表示在冒泡阶段调用事件处理程序。所有浏览器默认都为 falase.

使用 DOM2 级事件处理程序的好处是可以添加多个事件处理程序。

```
<script type="text/javascript">
		var btn = document.querySelector("#myBtn");
		btn.addEventListener("click",function(){
			alert(this.id);
		},false);

		btn.addEventListener("click",function(){
			alert("word!");
		},false);
</script>
```

btn 中的两个事件处理程序会按照添加它们的顺序先后执行，首先弹出 ID，然后显示 word.

使用 addEventListener( 添加的事件只能使用 removeEventListener() 来移除，并且与 addEventListener() 传入的参数相同，这个意味着无法移除使用 addEventListener() 添加的匿名函数。

---
#### IE 事件处理程序
IE 中使用 **attachEvent()** 和 **detachEvent()** 来操作事件。两个方法接收两个相同的参数:事件处理程序名称与事件处理程序。因为 IE 只支持冒泡(IE8以下,所以没有第三个参数)

> 实际上，attachEvent 主要是为了兼容 IE8以下。从 IE9 开始，可以使用标准的 addEventLister 来使用 DOM2 级事件了。

```
vat btn = document.querySelector("#myBtn");
btn.attachEvent("onclick",function(){
    alert(this === window); //true
});
```

attachEvent() 与 DOM0 级方法的区别在于事件处理程序的作用域。DOM0 级中，事件处理程序会在所属元素的作用域内运行。而使用 attachEvent() 方法，事件处理程序会在全局作用域中运行，因此 this 等于 window。

同样，attachEvent() 也可为同一元素添加不同事件，但是不同于 DOM0 级方法，IE 中的这些事件是以相反的顺序被触发的。

detachEvent() 方法同样不能移除匿名函数。

attachEvent() 方法添加的事件只会在冒泡阶段被处理。

---
#### 夸浏览器的事件处理程序
考虑到不同浏览器之间操作事件处理程序的差异，我们可以使用专门的库或者编写自己的兼容程序来处理不同的浏览器中的情况。

我们将创建一个 **EventUtil 对象**，并为其添加**addHandler()** 方法和 **removeHandler()** 方法。它的作用是视情况分别使用 DOM0 级方法，DOM2 级方法或 IE 方法来添加事件。

```
var EventUtil = {
			addHandler:function (element, type, handler){
				if (element.addEventListener){
// 所有现代浏览器都可以使用的方法，IE9，firefox，chrome
					element.addEventListener(type, handler, false);
				} else if(element.attachEvent){
				// 主要是为了兼容 IE8，IE8 是最后一个使用专用事件系统的主流浏览器。	element.attachEvent("on"+type,handler)

				}else{
					element["on" + type] = handler;
				}
			},

			removeHandler:function (element,type,handler){
				if (element.removeEventListener){
					element.removeEventListener(type, handler,false)
			        } else if (element.detachEvent){
					element.detachEvent(type, handler)
				} else {
					element["on" + type] = null;
				}
			}
};
```

以上的两个方法首先会检测传入的元是否存在 DOM2 级方法，若存在就使用它。如果存在的是 IE 中的方法，则采取第二种方案。为了在 IE8 级更早的版本中运行，我们为事件类型添加了 **on** 前缀。

显然，我们没有考虑到所有的问题，比如在 IE 中的作用域问题，不过使用它们添加和删除事件处理程序还是足够了。

---
### 事件对象
触发 DOM 上的事件时，会产生一个事件对象 **event**,它包含着所有与事件有关的信息。比如导致事件的元素，事件的类型以及与其它特定事件相关的信息。


##### DOM 的事件对象
兼容 DOM 的浏览器会将一个 event 对象传入到事件处理程序中，而无论指定事件处理程序时使用的什么方法(DOM0 级或 DOM2 级),都会传入 event 对象。

event 对象包含与创建它的特定事件有关的属性和方法。触发的事件类型不一样，可用的属性和方法也不一样。DOM 中所有事件都具有以下成员:

属性/方法|类型|说明
---:|:---:|:---
bubbles|布尔|表明事件是否冒泡
cancelable|布尔|表明是否可以取消事件的默认行为|
preventDefault|函数|取消事件的默认行为(cancelable 为则可以使用该方法)|
stopPropagation|函数|取消事件的进一步捕获或冒泡(bubbles为true则可以使用该方法)|
target|元素|事件的目标|
type|字符串|被触发的事件的类型

在需要通过一个函数处理多个事件时，可以使用 type 属性。

```
var btn = document.querySelector("#myBtn");
var handler = function (event) {
	// body...
	switch(event.type){
		case "click":
			alert("Clicked");
			break;

		case "mouseover":
			event.target.style.backgroundColor = "red";
			break;

		case "mouseout":
			event.target.style.backgroundColor = "green";
			break;
	}
};

btn.onclick = handler;
btn.onmouseover = handler;
btn.onmouseout = handler;
```

此外，我们可以使用 preventDefault() 方法来阻止特定事件的默认行为。

最后，还可以使用 stopPropagation() 方法来立即停止事件在 DOM 层次中的传播，即取消进一步事件的捕获或冒泡。


---
#### IE  中的事件对象
不同于 DOM 中的 event 对象，要访问 IE 中的 event 对象，取决于事件处理程序的方法。在 IE 中使用 DOM0 级方法添加事件时， event 对象将会作为 window 对象的一个属性存在。若是使用 attachEvent() 方法添加事件，便会有一个 event 对象作为参数被传入事件处理程序函数中。如果是通过 HMTL 特性指定事件处理程序，那么还可以通过一个 event 的变量来访问 event 对象。

当然, IE 中的 event 也包含与创建它的事件相关的属性和方法，并且与 DOM 中的属性与方法类型。

属性/方法|类型|说明
:--:|:--:|--
cancelBubble|布尔|默认值为 false ，但将其设置为 true 便可取消事件冒泡(等价于 stopPropagation())|
returnValue|布尔|默认为 true，将其设置为 false| 可取消事件默认行为(等价于preventDefault())|
srcElement| 元素|事件的目标(等价于 target 属性)|
type|字符串|事件类型|


---
#### 夸浏览器的事件对象
显然，DOM 标准和 IE 中的 event 对象不同，但是基于它们之间的相似性，我们依旧可以写出夸浏览器的方案。因为 IE 中event 对象的全部信息和方法 DOM 对象中都有，只不过实现方式不一样。

我们通过对 EventUtil 对象的增强来到达不同浏览器之间的兼容性问题。

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
				event.stopPropagation()；
			} else{
				event.cancelBubble = true;
			}
		}
};
```

---
### 0x01 事件类型

DOM3 级规定了以下几个事件: UI 事件，焦点事件，鼠标事件，滑轮事件，文本事件，键盘事件，合成事件(当 Input Method Editor 输入字符时触发)，变动事件(DOM 底层结构发生变化时触发)

包括 IE9 在内的所有主流浏览器都支持 DOM2 事件和 DOM3 级事件。

---
#### UI 事件

##### load
在页面加载完成以后(所有图像，JavaScript文件，CSS文件等等)便会触发 window 上的 `onload 事件`。

显示是 load 事件的使用场景。

在 `docuement` 上定义 load 事件:

```
EventUtil.addHaneler(document, 'load', callback)
```

> DOM2 级规范规定，应该在 document 而非 window 上触发 load 事件，使用 window 仅仅是为了向后兼容。
图片预加载:

```
EventUtil.addHandler(window, 'load',function(){
// 确保页面加载完成，否则
操作 document.body 会报错
	var image = document.createElement('img');
	EventUtil.addHandler(image, 'load', function(event){
		event = EventUtil.getEvent(event);		
	})
	document.body.appendChild(image);
	image.src = "simle.gif"
})
```
动态加载 JavaScript:

```
EventUtil.addHandler(document,'load', function(){
var script = document.createElement('script')
	EventUtil.addHandler(script, 'load', function(){
	console.log('yes,JavaScript')
	})
	script.src = 'example.js'
	document.body.appendChild(script)
	})
```


不同于图片加载，只有在设置了 <script> 元素的 src 属性并将其添加到文档后，才会开始下载。


##### unload
从一个页面切换到另一页面时便会触发 unload 事件。利用这个事件最多的情况是清除引用，以次避免内存泄漏。

> 根据 DOM2 级事件，应该在 body 上触发 unload 事件，而不是 window 上，同样使用 window 只是为了兼容


#### resize
该事件在 window 上被触发.

```
EventUtil.addHandler(window,'resize',callback);
```
##### scroll
scroll 事件是在 window 对象上发生的，但是其实际表示的是页面中相应元素的变化。
混杂模式下通过 `body` 元素的 scrollLeft 和scrollTop 来监控；标准模式下，通过 <html> 元素跟踪页面变化。这里是个大坑。


---
#### 焦点事件
焦点是事件会在页面失去焦点或得到焦点时触发。这类事件最主要的两个方法是 `focus` 和 `blur`。


---
#### 鼠标事件
DOM3 级中定义了 9 个鼠标事件：
* click：单击主鼠标按钮时触发
* dblclick:双击主鼠标按钮时触犯
* mousedown:按下任意鼠标按钮时触发
* mouseup: 释放鼠标按钮时触发
* mouseout: 鼠标划出时触发
* mouseover: 鼠标滑过时触发
* mousewheel: 鼠标滚轮事件
* mouseenter: 仅IE9 ,FireFox9,, Opera支持
* mouseleave: 仅IE9 ,FireFox9,, Opera支持


##### 客户区的位置
鼠标的位置信息保存在事件对象的 `clientX`  和 `clientY` 属性中。它们的值表示在事件发生时，鼠标指针在可视区域中的水平和垂直位置。

```
var section = document.querySelector("section");
EventUtil.addHandler(section, "click",function(){
	event = EventUtil.getEvent(event);
	console.log(event.clientX + "," + event.clientY);
});
```

##### 页面坐标位置
我们可以通过 `pageX` 和 `pageY` 属性获得鼠标在页面中的位置。

```
var section = document.querySelector("section");
EventUtil.addHandler(section, "click",function(){
	event = EventUtil.getEvent(event);
	console.log(event.pageX + "," + event.pageY);
});
```

IE8 及其更早版本并不支持事件对象上的页面坐标。但是我们可以通过客户区坐标及其滚动坐标计算出来页面坐标。

```
var pageX = event.pageX,
    pageY = event.pageY;
if(pageX == undefined) { pageX = event.clientX + (document.body.scrolltop || document.documentElement.scrollTop); }

if(pageY == undefined) { pageY = event.clientY + (document.body.scrollLeft || document.documentElement.scrollLeft);}
```

##### 屏幕坐标位置
顾名思义，就是当事件发生时，鼠标相对于整个电脑屏幕的位置。我们可以通过 `screenX`  和 `screenY`  来获得它们的值。


##### onclick 鼠标点击事件

###### 点击按钮选中 checkbox checked属性值

```
<body>

	<button id = "selectAll">Select All</button>
	<button id = "cancelAll">Cancel</button>
	<ul>
		<li><input type="checkbox" name = "checkInput"></li>
		<li><input type="checkbox" name = "checkInput"></li>
		<li><input type="checkbox" name = "checkInput"></li>
		<li><input type="checkbox" name = "checkInput"></li>
		<li><input type="checkbox" name = "checkInput"></li>
	</ul>

</body>
<script type="text/javascript">
	var btnSelectAll = document.getElementById("selectAll");
	var btnCancelAll = document.getElementById("cancelAll");
	var checkArray = document.getElementsByName("checkInput");

	btnSelectAll.onclick = function (){
		for(var i = 0; i < checkArray.length; i++){
			checkArray[i].checked = true;
		}
	}

	btnCancelAll.onclick = function (){
		for(var i = 0; i < checkArray.length; i++){
			checkArray[i].checked = false;
		}
	}


</script>
```

---
#### 鼠标滑轮事件

任何元素都可以触发 mousewheel 事件，只需将其指定给页面中的元素或者 document 对象，即可处理鼠标滚轮的交互操作。

与 `mousewheel` 事件对应的 `evet` 对象除了包含鼠标事件的所有标准信息外，还包含一个特殊的 `wheelDelta` 属性。当鼠标滚轮向前滑动时，wheelDelta 是120的倍数；当滚轮向后滑动时，wheelDelta 是 -120 的倍数。

而 FireFox 支持的是一个 `DOMMouseScroll` 的类似事件，而有关鼠标滚轮有关的信息则保存在 `detail` 属性中，当向前滑动鼠标滚轮时，该属性的值是 -3 的倍数，当向后滑动鼠标滚轮时，该属性值是 3 的倍数。

此外，Oprea 9.5 之前的版本中， wheelDelta 值的正负号是相反的。


##### 取得鼠标滑轮增量(delta)兼容方法

```
var EventUtil = {
    getWheelDelta:function(){
        if(event.wheelDelta){
            return (client.engine.opera && client.engine.opera < 9.5 ? -event.wheelDelta : event.wheelDelta);
        } else {
            return -event.detail*40;
    },
};
```

如此，便可以将相同的事件处理程序指定给 `mousewheel` 和 `DOMMouseScroll` 事件了。


---
#### 键盘与文本事件
* keydown: 按下键盘上的**任意键**时触发
* keypress: 按下**字符键**时触发
* keyup: 释放键盘上的键时触发
* textInput: (DOM3 级事件)在文本插入文本框之前会触发 textInput 事件。

此外，另一个 `textInput`事件是对 `keypress` 事件的补充，旨在将文本显示给用户之前更容易拦截文本。其主要考虑的是字符，因此因此它的 event 对象中还包含一个 data 属性，该属性的值就是用户输入的值。

###### 键码

当发生 `keydown` 和 `keyup` 事件时，`event` 对象的 `keyCode` 属性会包含一个代码，与键盘上的一个特定的键对应。

DOM 和 IE 中的 event 对象都支持 keyCode 属性。

###### 字符码
当触发  `keypress` 事件时，绝大部分的浏览的 `event` 对象都会将该键对应的 ASCII 码保存在 `charCode` 属性中，而此时的 keyCode 属性的值可能为0或等于所按键的键码。

IE8 及之前版本和 Opera 则是在 keyCode 中保存字符的 ASCII 码。

> 在所有浏览器中按下能够插入和删除字符的键都会触发 keypress 事件。

###### 以跨浏览器的方法取得字符编码

```
var EventUtil = {
    getCharCode: function () {
        if (typeof event.charCode == "number"){
            return event.charCode;
        } else {
            return event.keyCode;
        }
    },

};
```


##### 文本框事件
input
change
focus
blur



---
#### HTML5 事件

##### contextmeun 事件
通过单击鼠标右键，便可以调出上下文菜单。 `contextmenu` 事件是冒泡的，所以可以为 document 指定一个事件处理程序，以处理页面总的所有类似事件。

---
### 0x02 内存和性能

---
#### 事件委托
**事件委托** 利用了事件冒泡，只指定一个事件处理程序就可以管理某一类型的事件。它的主要作用便解决"事件处理程序过多"的问题。

使用事件委托，只需在 DOM 树中尽量最高的层次上添加一个事件处理程序。

```
<ul id="myLinks">
	<li id="doSomething">Do something</li>
	<li id="goSomewhere">Go somewhere</li>
	<li id="sayHi">Say Hi</li>
</ul>

EventUtil.addHandler(myLinks,"click",function(event){
	var event = EventUtil.getEvent(event);
	var target = EventUtil.getTarget(event);
	switch(target.id){

		case "doSomething":
			console.log(target.id);
			document.title = "I changed the document's title";
			break;

		case "goSomewhere":
			console.log(target.id);
			location.href = "http://www.baidu.com";
			break;

		case "sayHi":
			alert("Say Hi");
			break;
	}
});
```

