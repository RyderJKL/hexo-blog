---
title: CSS3新增属性  
date: 2016-09-08 11:55  
tags: ['CSS3']
toc: true
categories: technology

---
### 0x00 boxshadow [ CSS3 ]

`box-shadow` 有以下属性值：

```
h-shadow : 必需。水平阴影位置。值为正投影在对象右边，值为负，投影在对象左边。
v-shadow : 必需。垂直阴影位置。值为正投影在对象低部。值为负，投影在对象顶部。
color : 阴影颜色。
blur : 可选。模糊距离
radial: 可选。扩展半径。
inset : 可选。将外部阴影（outset）改为内部阴影。
```

##### 设置四边不同的阴影:

```
box-shadow:-10px 0px 5px yellow,
	       10px 0px 5px red,
	       0px -10px 5px green,
	       0px 10px 5px blue;

```

##### 多重阴影:

```
box-shadow:10px 0px 5px yellow,20px 0px 20px green;
```


#### text-shadow [ CSS3] 
`text-shadwo` 与 `boxs-hadow` 基本相同，只是 `text-shadwo` 不可以定义内阴影。

---
### 0x01 box-reflect
这是一个实验中的属性，并且实现情况并不理想，目前只有 Chrome 和 safari 支持。

语法样式:

```
-webkit-box-reflect: below 10px -webkit-linear-gradient(rgba(0,0,0,0.2) 33%,rgba(0,0,0,0.6) 63%,rgba(0,0,0,0.8) 99%);
```

支持的参数值：Direction，Offset，Mask Value。
分别代表倒影的方向: `above`,`below`,`left`,`right`
距离原图的距离: 像素
倒影的渐变样式:


---
### 0x02 Animation
`animation` 的子属性有:  

`animation-name`:使用 `@keyframes` 描述的关键帧名称  

`animation-duration`:动画执行的时间  

`animation-timing-function`:动画速度变化函数  

其值有:`linear`,`ease`,`ease-in`,`ease-out`,`ease-in-out`
`animation-delay`:动画延时执行的时间    

`animation-iteration-count`:设置动画重复的次数，`infinite` 无限次重复动画  

`animation-direction`:动画运行完成以后是反向运行还是重新回到开始位置重复运行。取值有 `normal` 和 `alternate`.当设置为 alternate时，表示轮流播放，并且动画会在奇数次数正常播放，在偶数次数反向播放。  

`animation-fill-mode`:指定动画执行前后的元素样式。其常用值有 `forwards`(当动画执行完成以后，保持最后一个属性值,在最后一个关键帧中定义) 和 `backwards`(在动画显示前，应用开始属性值，在第一个关键帧中定义) 

`animation-play-state`:控制动画的播发状态，可取值:`paused`(暂停),`running`(动画播放).

```
<style type="text/css">
	body{
		position: relative;
	}

	
	#box{
		width: 100px;
		height: 40px;
		background: linear-gradient(red,deeppink,green);
		position: absolute;
		left: 0;
		top:100px;
		animation: turnBack 6s linear 1s infinite;
	}

	@-webkit-keyframes turnBack {
		from{
			left: 0px;
			transform: rotateY(0deg)
		} 50% {			
				left: 600px;	
				transform: rotateY(0deg)
		} 51%{
			transform: rotateY(180deg);					
			}to{
			left: 0px;
			transform: rotateY(180deg);
		}
	}


</style>
</head>
<body>
    <div id="box">
    	I'am box,sir!
    </div>
</body>
```


---
### 0x03 Transition 
`Transition` 属性用于过渡效果的 CSS 属性。

常见用法:
```
trasition: peroperty duration timing-function delay
```



