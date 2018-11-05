---
title: TWEEN.JS动画类库  
date: 2016-10-08  
tags: ['JS小项目']
toc: true
categories: technology

---
### 0x00 


---
### 0x01 简单演示

```
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<script type="text/javascript" src = "tween.js"></script>
	<!-- 引用 teween.js类库 -->
	<style type="text/css">
		*{
			background-color: black;
		}
		#ball {
			position: absolute;
			height: 80px;
			width:80px;
			border-radius: 40px;
			background-color: white;			
		}
	</style>
</head>
<body>
	<div id="ball">		
	</div>	
	<script type="text/javascript">
		var myBall = document.getElementById("ball");

		var start = 0; // 开始的步数
		var step = 30; // 步长
		var nowPosition = 0; //初始位置
		var targetPosition = 500; //目标位置
		var changePosition = targetPosition - nowPosition; //改变的位移
		var timer = setInterval(function(){
			start ++;
			if(start > step){
				clearTimeout(timer);
			}
			myBall.style.left = Tween.Elastic.easeInOut(start,nowPosition,changePosition,step) + "px";			
		}, 100)
	</script>
</body>
</html>
```



---
### 0x02 使用TWEEN 实现动态导航

```
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<script type="text/javascript" src = "tween.js"></script>
	<!-- 引用 teween.js类库 -->
	<style type="text/css">
		*{
			background-color: grey;
			text-decoration: none;
			list-style: none;
			margin:0;
			padding: 0;
			text-align:center;
		}

		
		ul {
			position: absolute;
			height: 30px;
		}
		li {
			float: left;
			width:100px;
			line-height: 30px;
		}

		#navLine {
			clear:both;
			width:100px;
			height: 4px;
			background-color: red;
			position: absolute;
			top:28px;
		}
	</style>
</head>
<body>
	<nav>
	<ul>
		<li>我是第1个</li>
		<li>我是第2个</li>
		<li>我是第3个</li>
		<li>我是第4个</li>
		<li>我是第5个</li>
		<div id="navLine">			
	</div>		
	</ul>
	
	</nav>
	<script type="text/javascript">
		var navLine = document.getElementById("navLine");
		var lisArr = document.getElementsByTagName("li");


		for (var i = lisArr.length - 1; i >= 0; i--) {
			lisArr[i].onmouseover = function (){
				var start = 0;
				var step = 30; 
				var nowPosition = navLine.offsetLeft;
				var targetPosition = this.offsetLeft;
				var changePosition = targetPosition - nowPosition;
				var timer = setInterval(function (){
					start ++;
					if(start >= step){
						clearTimeout(timer);
					}
					navLine.style.left = Tween.Elastic.easeInOut(start,nowPosition,changePosition,step) + "px";	
				},10);
			}
		}
	</script>
</body>
</html>
```

