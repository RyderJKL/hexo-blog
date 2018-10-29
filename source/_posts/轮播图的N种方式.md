---
title: 轮播图的N种方式  
date: 2016-10-08  
tags: ['JS小项目']
toc: true
categories: technology

---
### 0x00 JS+CSS 图片轮播

功能描述: 图片自动轮播，鼠标可通过左右选择滑动下一张图片。


```
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>myExperimentPages</title>	
  <style type="text/css">
 
    *{
      margin:0;
      padding: 0;
      list-style: none;
      text-decoration: none;
    }

    #wrapper{
      position: relative;
      width: 1024px;
      height: 768px;
      border:1px solid green;
      overflow: hidden;
    
    
    }
    
    #imageboxs {
      border:1px red solid;
      width: 6000px;
      height: 600px;
      position: absolute;
      left: 0;
      top: 0;
      transition:all .5s ease-in .1s;    
    }

    #control {
      width: 360px;
      height: 35px;
      border: 1px solid red;
      position: absolute;
      bottom: 10; 
      right: 0;      
    }

    #control ul {
      float:left;
    }
    
    #control li {
      float:left;
      width: 30px;
      height: 30px;
      border-radius: 15px;
      border:1px solid red;
      text-align: center;
      cursor:pointer;
    }


    #control li  a {
      display: inline-block;
      width: 30px
      height:30px;
    }
    #control p {
      float: left;
      width: 100px;
      background-color: red;
      line-height: 35px;
      text-align: center;      
      cursor:pointer;
    }

  </style>
</head>
<body>
  <div id="wrapper">
  //轮播框，必不可少，相对定位
      <div id="imageboxs">
      // 图片载体，必不可少，相对定位
        <a href=""><img src="myImages/1.jpg" alt=""></a><a href=""><img src="myImages/2.jpg" alt=""></a><a href=""><img src="myImages/3.jpg" alt=""></a><a href=""><img src="myImages/4.jpg" alt=""></a>
      </div>
      <div id="control"
      //控制按钮，绝对定位
        <p id = "prevNext">前一页</p>
          <ul>
            <li class="con-li"><a href="">1</a></li>
            <li class="con-li"><a href="">2</a></li>
            <li class="con-li"><a href="">3</a></li>
            <li class="con-li"><a href="">4</a></li>
          </ul>
         <p id = "afterNext">后一页</p>
      </div>
  </div>
</body>
<script type="text/javascript">
       var isWrapper = document.getElementById("wrapper");
       var boxsImage = document.getElementById("imageboxs");
       var liControlArr = document.getElementsByClassName("con-li");
       var nextPrev = document.getElementById("prevNext");
       var nextAfter = document.getElementById("afterNext");

       var i = 0;
       // 记录当前显示的图片
       nextAfter.onclick = function function_name(argument) {

         // body...
          i ++;
          if(i > 3){
            i=0;
          }
          boxsImage.style.left = (-1024*i) + "px";


       }

       nextPrev.onclick = function (){
          i --;
          if ( i < 0){
            i = 3;
            boxsImage.style.left = (-1024*i) + "px";
          }else{
            boxsImage.style.left = (-1024*i) + "px";
          }
       }
       
       function autoPlay (){
       // 移动图片函数
          i ++;
          if(i > 3){
            i=0;
          }
          boxsImage.style.left = (-1024*i) + "px";
       }
       
       var timer = setInterval(autoPlay,1000);
       //自动轮播

       isWrapper.onmouseover = function (){
       // 鼠标划中，停止轮播
          clearInterval(timer);
       }

       isWrapper.onmouseout = function (){
       //鼠标划出，开始轮播
          timer = setInterval(autoPlay,1000);
       }



       for( var j=0;j<liControlArr.length;j++){
       //为每个 li 添加 对应的图片移动事件
          console.log(liControlArr.length);
          liControlArr[j].index = j;
          liControlArr[j].onmouseover = function (){
            console.log(this.index);
            boxsImage.style.left = (-1024*(this.index)) +"px";
          }
       }

</script>
</html>
```

---
### 0x01 为轮播添加一个短暂的停留

```

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title></title>
	<style type="text/css">
		*{
			margin:0;
			padding: 0;
			box-sizing: border-box;
		}
		#wrap {
			height: 400px;
			width:260px;
			border: 1px solid red;
			position: relative;
			overflow: hidden;
		}

		#boxImg {
			width:5000px;
			height: 100%;
			position: absolute;
			left:0;
			top:0;
		}

		#boxImg img {
			float: left;
		}

		#btnDiv {
			position: absolute;
			top:100px;

		}
	</style>
</head>
<body>
	<div id="wrap">
		<div id="boxImg">
			<a href=""><img src="../20DAY/1.jpg" alt=""></a>
			<a href=""><img src="../20DAY/2.jpg" alt=""></a>
			<a href=""><img src="../20DAY/3.jpg" alt=""></a>
			<a href=""><img src="../20DAY/4.jpg" alt=""></a>
			<a href=""><img src="../20DAY/5.jpg" alt=""></a>
		</div>
		<div id="btnDiv">
		<button class="btn" onclick="nextLeft()"><</button>
		<button class="btn" onclick="nextRight()">></button>
		</div>
	</div>
</body>
<script type="text/javascript">
	var boxImg = document.getElementById("boxImg");
	var mySetTiem1 = "";
	var mySetTiem2 = "";
	var timer1 = "";
	var timer = "";

	function clearAlltimer (){
		clearInterval(timer);
		clearInterval(timer1);
		clearTimeout(mySetTiem2);
		clearTimeout(mySetTiem1);
	}

	var x = 0;	
	function nextLeft (){
		clearAlltimer();
		clearTimeout(mySetTiem2);
		timer1 = setInterval(function (){
		x -=1;
		if(x % 259 == 0){
			clearInterval(timer1);
			mySetTiem1 = setTimeout(nextLeft,1000);		
		}
		if( x < -1036)
		{
			
			x = 0;

		}		
		boxImg.style.left = x +"px";
		
		}, 1);
	}

	function nextRight () {

		
		clearAlltimer();
		timer = setInterval(function (){
		x +=1;
		if(x % 259 == 0){
			clearInterval(timer);
			mySetTiem2 = setTimeout(nextRight,1000);
		}
		if( x > 0)
		{
			x = -1036;
		}
		boxImg.style.left = x +"px";
		}, 1);
	}
	
</script>
</html>
```


---
### 0x02 Tween.js 为轮播添加动画效果

```
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<script type="text/javascript" src="tween.js"></script>
	<style type="text/css">
		*{
			margin: 0;
			padding: 0;
		}
		ul{
			list-style: none;
		}
		#bannerBox{
			/*banner盒子，宽度和高度应该等于图片高度宽度*/
			width: 1000px;
			height: 600px;
			border: 2px solid red;
			margin: 0 auto;
			position: relative;
			overflow:hidden;
		}
		#bannerImgs{
			/*banner 图片载体*/
			width: 9999px;
			height: 600px;
			background-color: purple;
			position: absolute;
			left: 0;
			top: 0;
		}
		#bannerControl{
			width: 360px;
			height: 40px;
			border: 2px solid yellow;
			position: absolute;
			bottom: 0;
			right: 0;
		}
		#bannerControl p{
			float: left;
			width: 100px;
			background: #ccc;
			line-height: 40px;
			text-align: center;
			cursor: pointer;
		}
		#btns li{
			float: left;
			width: 40px;
			height: 40px;
			background-color: #ccc;
			border-radius: 20px;
			line-height: 40px;
			text-align: center;
			cursor: pointer;
		}
	</style>
</head>
<body>
	<div id="bannerBox">
		<div id="bannerImgs">
			<a href="#"><img src="../img/01.jpg"/></a><img src="../img/02.jpg"/><img src="../img/03.jpg"/><img src="../img/04.jpg"/>
		</div>
		<div id="bannerControl">
			<p id="prev">前一页</p>
			<ul id="btns">
				<li>1</li>
				<li>2</li>
				<li>3</li>
				<li>4</li>
			</ul>
			<p id="next">后一页</p>
		</div>
	</div>
	<script type="text/javascript">
		//找对象
		var imgs = document.getElementById("bannerImgs");
		var prevbtn = document.getElementById("prev");
		var nextbtn = document.getElementById("next");
		var lis  = document.getElementsByTagName("li");		

		var timerIntCavans = "";
		// 定时器，用于控制banner移动的动画效果
		var timerOutAutoPlay = "";
		//定时器，延时调用自动轮播
		var timerIntAutoPlay = "";
		//定时器，用于banner自动轮播
		var num = 0;
		// num 用于匹配当前聚焦的 li 或者imgs所在的位置
		
		function clearAllTimer(argument) {
			// body...
			// 清除定时器
			clearInterval(timerIntCavans);
			clearInterval(timerIntAutoPlay);
			clearTimeout(timerOutAutoPlay);
		}

		//为每一个 Li 按钮添加 imgs 移动事件
		for(var i = 0; i < lis.length; i++){
			
			lis[i].index = i;//把i的值记录一下,添加到每一个li对象的index属性里
			lis[i].onclick = function(){
				clearAllTimer();
				num = this.index;	
				clickMove();			
			}
			
		}

		function clickMove (){
			// 控制 imgs 移动
				var step = 30; 
				//分三十次完成移动
				var start = 0;
				//移动初始量
				var targetPosition = num*1000*-1;
				//目标位置
				var nowPosition = imgs.offsetLeft;
				//目标当前的位置
				var changeDisplacement = targetPosition - nowPosition;
				//目标需要改变的位置
				timerIntCavans = setInterval(function(){
					//timer 设置定时器，使其每十帧移动一次
					start ++;					
					if( start >= step){						
						clearInterval(timerIntCavans);
					}
					imgs.style.left = Tween.Bounce.easeInOut(start,nowPosition,changeDisplacement,step)+"px";
				},10);
				timerOutAutoPlay = setTimeout(autoPlay,2000);
				// 定时器，延时调用自动轮播
				changeColors(num);		
				// 改变 当前 li 的颜色
		}

		prevbtn.onclick = function () {			
			clearAllTimer();
			num --;
			if( num < 0){
				num = 3;
			}
			clickMove();
			
		}

		nextbtn.onclick = function (){
			clearAllTimer();
			num ++;
			if (num > 3){
				num = 0;
			}
			clickMove();			
		}

		
		function autoPlay (){			
			clearAllTimer();
			var x = imgs.offsetLeft;
			timerIntAutoPlay = setInterval(function(){
				x -=1;
				if( x%1000 == 0){
					num ++;
					clearInterval(timerIntAutoMove);
					timerOutAutoPlay = setTimeout(autoPlay,2000);
				}

				if(num > 3){
					num = 0;
				}

				changeColors(num);
				if (x < -3000){
					x = 0;
				}
				imgs.style.left = x + "px";
			},1);
		}

		
		function changeColors (index){
			for(var i = 0; i < lis.length; i ++){
				lis[i].style.backgroundColor = "red";
			}
			lis[index].style.backgroundColor = "black";
		}

		autoPlay();		
	</script>
</body>
</html>
```

---
### 0x03 使用opcaity实现图片轮播

```
// HTML
<div class="swiper-container">
	<div class="swiper-wrapper">
		 <div id="swiper-img-box">
                        <img src="images/rendering/Z.jpg" alt="">
		 	<img src="images/rendering/Z-1.jpg" alt="">
		 	<img src="images/rendering/Z-2.jpg" alt="">	
		 </div>
		  <div id="swiper-controll">
		 	<div class="swiper-con-item swiper-con-item-one"></div>
		 	<div class="swiper-con-item swiper-con-item-two" ></div>
		 	<div class="swiper-con-item swiper-con-item-three"></div>
		 </div>
	</div>
</div>


//CSS
.swiper-wrapper {
	height: 78vh;
	width: 100%;
	position: relative;
	overflow: hidden;
	border: 4px solid black;
}

#swiper-img-box {	
	width: 100%;
	height: 100%;
	position: absolute;
	left: 0;
	top: 0;
	
}

#swiper-img-box img {
	width: 100%;
	height: 100%;
	position: absolute;
	left: 0;
	top:0;
	transition: all 1s ease ;
}

#swiper-controll {
	position: absolute;
	bottom: 20px;
	left: 50%;
	z-index: 999;

}

.swiper-con-item {
	width: 10px;
	height: 10px;
	border-radius: 5px;
	background: gray;
	margin-right: 5px;
	float: left;

}

.swiper-con-item:focus,
.swiper-con-item:hover {
	background: yellowgreen;
}

//js
	var swiper = document.querySelector("#swiper-img-box");
	var imgs = document.querySelectorAll("#swiper-img-box img");
	var controlItem = document.querySelectorAll(".swiper-con-item")

	
	function moveSwiper (){	
		var num =0;	
		moveSwiperTimer = setInterval(function(){					
			for(var i=0;i<imgs.length;i++){
				imgs[i].style.opacity = 0;
			}			
			imgs[num].style.opacity = 1;
			num ++;
			if(num > imgs.length-1){
				num =0;
			}
		},5000);
	}

	function SwiperClick (){
		clearTimeout(callmoveSwiper);
		for(var i=0;i<controlItem.length;i++){
			controlItem[i].index = i;
			controlItem[i].onclick = function(){
				
				clearInterval(moveSwiperTimer);
				for(var i=0;i<imgs.length;i++){
				imgs[i].style.opacity = 0;
			}			
				imgs[this.index].style.opacity = 1;
				callmoveSwiper = setTimeout(moveSwiper,1000);
			}
		}
	}

```

