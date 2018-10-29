---
title: Canvas绘画一个时钟 
date: 2016-11-21
tags: ['HTML5']
toc: true
categories: technology

---
### 0x01 时钟样式


![Canvas_Clock](http://upload-images.jianshu.io/upload_images/1571420-25a7415e6a6dc68e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>Examples</title>
	<meta name="description" content="">
	<meta name="keywords" content="">
	<link href="" rel="stylesheet">
	<style type="text/css">
		*{
			margin: 0;
			padding: 0;
			overflow: hidden;
		}
		#myCanvas{
			background: black;
		}
	</style>
</head>
<body>
	<canvas id="myCanvas" width="2000" height="1000"></canvas>
</body>
<script type="text/javascript">
	setInterval(clock1,1000)
	// 每隔一秒调用一次 clock 函数

	function clock1(){		
		var drawing = document.querySelector("#myCanvas")
		var context = drawing.getContext("2d")
		context.save()
		//保存最原始的画布状态，如此便不需要 clearRect()清除整个画布

		context.translate(500,350)
		//新的画布状态，将圆心移到原始画布状态的(500,350)处
		context.rotate(Math.PI/180*180)			
		// 将整个坐标系选择 180 deg，方便显示之后的时间数字，以保证 12 在顶部
					
		// Start drawing clock shape(即是十二边形)
		var r= 200
		// 定义表盘半径

		context.save()
		// 保存当前状态（即是 "第一个状态"[将上一个状态记为第一个状态]）
		var radGrad = context.createRadialGradient(0,0,10,0,0,70)
		// 添加表盘渐变范围
		radGrad.addColorStop(0.4,"black")
		radGrad.addColorStop(0.2,"deeppink")
		// 添加渐变颜色
		context.fillStyle = radGrad;
		// 在 fillStyle 中应用渐变颜色
		context.strokeStyle = "deeppink"
		// 描边颜色
		context.lineWidth ="1"
		// 线条宽度
		context.beginPath()
		// 开始绘画
		moveTo(0,0)
		// 从圆心开始
		for(var i=0;i<12;i++){
			context.rotate(Math.PI/180*30)
			// 每次旋转坐标系 30 deg
			context.lineTo(0,r)		
			// 在 y  轴上描点	
		}		
		context.closePath()
		// 闭合路劲
		context.stroke()
		// 描边
		context.fill()
		// 填充
		context.restore()
		// 恢复上一个状态(恢复以后当前画布状态 “第一个状态”)

		// End clock shape

		//Start hours masks			
		context.save()
		// 保存当前状态("第一个状态")
		context.strokeStyle = "deeppink"
		context.fillStyle = "deeppink"		
		for(var j=0;j<12;j++){
			context.beginPath()
			context.rotate(Math.PI/180*30)			
			context.moveTo(0,r)
			context.lineTo(0,r-10);
			// hour masks			
			// context.closePath() 绘制直线的时候不需要闭合路径，切记！
			context.stroke()
			// 描边
		}
		context.restore()
		//恢复上一个状态(恢复以后当前画布状态 “第一个状态”)
		//End hours masks
		
		// 设置数字格式
		context.save()
		// 保存当前状态("第一个状态")
		context.strokeStyle = "deeppink"
		context.fillStyle = "deeppink"		
		context.lineWidth = "1"
		context.font = "20px 宋体"
		context.textAlign = "center"
		context.textBaseline = "middle"
		for(var k=0;k<12;k++){
			context.rotate(Math.PI/180*30)
			context.fillText(k+1,0,r-20)			
			// 添加数字
		}	
		context.restore()
		//恢复上一个状态(恢复以后当前画布状态 “第一个状态”)

		// Start minutes masks
		context.save()
		// 保存当前状态("第一个状态")
		context.strokeStyle = "deeppink"
		for(var k=0;k<60;k++){				
			if(k%5 !=0){			
				context.beginPath()			
				context.moveTo(0,r-5)
				context.lineTo(0,r-10)	
				context.stroke()
			}		
			context.rotate(Math.PI/180*6)				
		}
		context.restore()
		//恢复上一个状态(恢复以后当前画布状态 “第一个状态”)
		
		var date = new Date()
		var hour = date.getHours()
		var minute = date.getMinutes()
		var seconds = date.getSeconds()
		hour = hour>12?hour-12:hour
		// write hours
		context.save()
		// 保存当前状态("第一个状态")
		context.strokeStyle = "deeppink"
		context.lineWidth ="4"
		context.beginPath()
		context.rotate(Math.PI/180*(360/12*hour)+Math.PI/180*(30*(minute/60))+Math.PI/180*(360/12*(seconds/3600)))
		context.moveTo(0,0)
		context.lineTo(0,130)
		context.stroke()
		context.restore()
		//恢复上一个状态(恢复以后当前画布状态 “第一个状态”)

		// write minute
		//保存当前状态("第一个状态")
		context.save()
		context.strokeStyle = "deeppink"
		context.width = "3"
		context.beginPath()
		context.rotate(Math.PI/180*(6*minute)+Math.PI/180*(6*(seconds/60)))
		context.moveTo(0,0)
		context.lineTo(0,170)
		context.stroke()
		context.restore()
		//恢复上一个状态(恢复以后当前画布状态 “第一个状态”)

		// write seconds
		context.save()
		//保存当前状态("第一个状态")
		context.strokeStyle = "deeppink"
		context.width = ""
		context.beginPath()
		context.rotate(Math.PI/180*(6*seconds))
		context.moveTo(0,0)
		context.lineTo(0,180)
		context.stroke()
		context.restore()	
		//恢复上一个状态(恢复以后当前画布状态 “第一个状态”)
		
		context.restore()
		// 恢复到原始状态
	}
</script>
</html>
```

