---
title: HTML5新增元素
date: 2016-09-13
tags: ['HTML5']
toc: true
categories: technology

---
### 0X01 HTML5新增主体元素

header,nav,aside,section,article,footer

---
### 0x02 HTML5新增非主体元素

##### datalist

`datalist` 要结合 `input` 元素使用，并且通过的 `input` 的 `list` 属于与其关联。

```
<input type="text" id="list" list="showData">
<datalist id="showData">
	<option value="boy"></option>
	<option value="girl"></option>
	<option value="woman"></option>
	<option value="man"></option>
</datalist>
```



##### progress
表示一个任务的完成进度，而且通常这些任务都在表单中启动和处理。

```
<progress value="10" max="50">
```

vaule:表示处理进度的程度
max:表示任务完成以后达到的值

##### meter
与 `<progress>` 类似，用于显示刻度或精度而非进度。

```
<meter max="100" min="25" low="40" hight="100" optimum="50" value="15"></meter>
```

##### output
用于显示表单元素处理的结果值。`for` 将 `output` 元素与参与计算的元素相关联起来。


---
### 0x03 HTML5新增文本框元素

##### email

```
<input type="email" />
```

当在 form 表单中，当输入邮箱地址提交请求时，将会自动验证输入邮箱格式是否正确

##### tel

```
<input type="tel" />
```

tel 在主要功能作用是针对不同的设备自动跳出响应的数字键盘，这个主要是针对移动端的。它不会去验证输入的电话号码的格式。


##### number

```
<input type="number" step="10" min="100" max="1000"/>
```

number 只能接受数字类型的值。其中:

min:表示能输入的最小值
max:表示能输入的最大值
step:表示每次调整的增量

##### range

```
<input type="range" min="1000" max="15000" step="1000" value="5000" />
```

range 允许用户选择一范围的数值。

##### date

##### time

##### color




---
### 0x03 HTML5新增音视频元素

---
#### vedio
`vedio` 元素提供了 播放、暂停和音量控件来控制视频，也提供了 width 和 height 属性控制视频的尺寸.如果设置的高度和宽度等

`vedio` 元素有如下属性值：

* `width/height`: 设置 `vedio` 元素的宽度和高度
* `src/source`: 设置视频流的存储路劲
* `autoplay`:视频自动播放
* `controls`:显示 `video` 元素自带的控制组件 `controls`
* `poster`:指定一个图片路径，在视频等待播放时显示一幅图片。
* `preload`:有三个值:`none`,`metadata`,`auto`。值为`none` 不缓存视频；`metadata` 播放前只加载视频的宽高等信息;`auto` 默认值，要求浏览器尽快下载视频。
* `loop`:反复播放视频



```
<video src="臭屁虫2.mp4" width="400" height="400" controls="controls" autoplay="autoplay" loop="loop" ></video>
```


---
#### 视频事件


视频处理事件:

* `play()`:播放媒体文件
* `load()`:加载媒体文件，动态应用程序可以使用该方法提前加载
* `canPlayType(type)`:查看浏览器是否支持某种类型的媒体格式
* `progress()`: 用于更新资源的下载进度，会周期性的触发。
* `canplaythrough()`:当整个媒体可以顺序播放时，触发该事件。
* `canplay()`:不考虑整体状态，只有下载了一定可放的帧变化触发该事件


针对视频处理的常用属性如下：

* `ended`:媒体播发完成时该属性返回 `true`
* `paused`:暂停播放时，该属性返回 `true`
* `duration`:返回播放时长，以秒为单位
* `currentTime`:获得或设置媒体播放位置
* `error`:播发错误时触发

---
#### 一个简单的视频处理控件

```
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>video</title>
	<meta name="description" content="">
	<meta name="keywords" content="">
	<link href="" rel="stylesheet">
	<style type="text/css">

		#videoBox{
			width:600px;
			height: 500px;
			position: relative;
		}
		#contronlBtn{
			border:1px solid red;
			width: 40px;
			height: 40px;
		}

		#progressVedio{
			width: 400px;
		}

		#showTime{
			width: 40px;
			height: 20px;
			border:1px solid red;
			display: block;
			position: absolute;
			top:400px;
		}

	</style>
</head>
<body>

	<div id="videoBox">
		<video id="videoSource" src="臭屁虫4.mp4" width="400" height="400" controls="controls" autoplay="autoplay" loop="loop" ></video>
		<span id="showTime"></span>
		<button id="contronlBtn">播放</button>
		<progress id="progressVedio" value="0" max=""></progress>
		<span id="progressTime"></span>
		<span id="totalTime"></span>
		</div>
	</body>
	<script type="text/javascript">
		var contronlBtn = document.querySelector("#contronlBtn")
		var videoSource = document.querySelector("#videoSource")
		var progressVedio = document.querySelector("#progressVedio")
		var totalTime = document.querySelector("#totalTime")
		var progressTime = document.querySelector("#progressTime")
		var showTime = document.querySelector("#showTime")

		var timer = null;

		window.onload = function(){
			var countTime = parseInt(videoSource.duration)
			progressVedio.max = countTime
			totalTime.innerHTML = "时间:"+ parseInt(countTime/60)+":"+(countTime%60);
			contronlBtn.onclick = function (){
				if(videoSource.paused){
					videoSource.play()
					contronlBtn.innerHTML = "Pause"
				}else if(videoSource.play){
					videoSource.pause()
			contronlBtn.innerHTML = "Play"
		}
	}

	timer = setInterval(function(){
		var nowTime =  parseInt(videoSource.currentTime)
		progressVedio.value = nowTime
		progressTime.innerHTML = parseInt(nowTime/60) + ":" + (nowTime%60);
	},1000)

	progressVedio.onmouseover = function(event){
	 	 var mourseTime = parseInt(countTime/progressVedio.offsetWidth*(event.clientX - progressVedio.offsetLeft))
	 	 showTime.innerHTML = ""+ parseInt(mourseTime/60)+":"+(mourseTime%60);
	 	 showTime.style.left = event.clientX + "px"
	}

	progressVedio.onclick = function(event){
		videoSource.currentTime = countTime/progressVedio.offsetWidth*(event.clientX - progressVedio.offsetLeft)
	}

}

</script>
</html>
```







