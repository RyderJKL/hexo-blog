---
title: JS引用类型(4)之Math        
date: 2016-9-28     
tags: ['JavaScript','JS引用类型']
toc: true
categories: technology

---
### 0x01 Math object
```
	function getRandomArray (max, min, countnum){
		
			randomArray[0]= parseInt(Math.random()*(max - min +1)+min);	
			console.log(randomArray[0]);		
			NotExits = true;
			var newNum;
			for( var i = 1;i < countnum; i ++){
				console.log("我。。。。。。是外层第" + i +"次");
				console.log("我是数组长度"+randomArray.length);
				 newNum = parseInt(Math.random()*(max - min +1)+min);
				console.log("我是newNum:  " + newNum);
				for(var j = 0; j < i; j ++){
					console.log("我是内层第"+j+"次");
					if( randomArray[j] == newNum){
						NotExits = false;							
						i --;							
					}
				}

				if(NotExits == true){
					randomArray[i] = newNum;
				}
				console.log(randomArray);
			}
			
			return randomArray;

		}

		console.log(getRandomArray(4,0,5));
```

#### Math 属性

```
Math.E      //返回算术常量 e
Math.LN2    //返回2的自然对数
Math.LN10   //返回10的自然对数
Math.PI     //返回PI
Math.SQRT2  //返回2的平方根
```

#### Math 方法

* abs(x)    返回绝对值
* ceil(x)   向上取整数
* floor(x)  向下取整数
* max(x,y,z,...) 返回参数中的最大值
* min(x,y,z,...) 返回参数中的最小值
* pow(x,y)  返回 x 的 y 次幂
* random()  返回 [0,1) 之间的随机数
* round(x)  四舍五入
* sqrt(x)   返回数的平方根


##### 生成随机数

```
Math.floor(Math.random()*10));
//随机返回 0~9 之间的整数
Math.celi(Math.random()*10);
//随机返回0~10之间的整数
Math.floor(Math.random()*(10+1));
//随机返回1~10之间的整数
```



##### 返回两个数之间的任意多个不重复的数

```
var randomArray = new Array();

	function generateRandom (x,y,z){

		if ( x < y  ){
			var tmp = x;
			x = y;
			y = tmp;
		}

		for ( var i = 0; i < z; i ++){
			 var newRandom = Math.floor(Math.random()*(x - y + 1)) + y;			 
			 var exits = false;
			 for( j =0 ;j < i; j++){
			 	if(randomArray[j] == newRandom){
		 		exits = true;
		 		i--;
		 		break;
		 	}
		 }		
		 if(!exits){
		 	randomArray[i] = newRandom;
		 } 
	}
	
	return randomArray;
}

generateRandom(0,31,5);
```

> 随机返回两个整数数之间的数公式

```
Math.floor(Math.random()*(max-min)+1))+min;
```

##### 随机更改 div 的背景颜色

```
<div id="mydiv"></div>
	<button id="btnChangeDivColor" onclick="changeColor()">button</button>
</body>
<script type="text/javascript">
	function changeColor (){
		var red = Math.floor(Math.random()*(255+1));
		var green = Math.floor(Math.random()*(255+1));
		var blue = Math.floor(Math.random()*(255+1));

		// mydiv.style.backgroundColor = "#" + red.toString(16) + green.toString(16) + blue.toString(16);
		mydiv.style.backgroundColor = "rgb(" + red + "," + green + "," + blue +")"; 
	}
```





