---
title: JS引用类型(1)之String  
date: 2016-10-06     
tags: ['JavaScript','JS引用类型']
toc: true
categories: technology

---
### 0x00 String
String 对象是对原始 string 类型的封装。

##### String 对象的常用方法

方法 | 描述 |
---:|:---:|:---
charAt(),charCodeAt()|返回字符串指定位置的字符或者字符编码
indexOf(),lastIndexOf()|分别返回字符串中指定子串的位置或最后位
startWith(),endsWitch(),includes|返回字符串是否以指定字符串开始、结束或包含指定字符串。
concat()|连接两个字符串并返回新的字符串
split()|通过将字符串分离成一个个子串来把一个String对象分裂到一个字符串数组
slice()|从一个字符串提取片段并作为新字符串返回
substring(),sbustr()|分别通过指定起始和结束位置，起始位置和长度来返回字符串的指定子集
match(),replace(regexp/substr,replacement),search()|正则表达式
toLowerCase(),toUpperCase()|分别返回字符串的小写表示和大写表示
repeat()|将字符串内容重复指定次数后返回
trim()去掉字符串开头和结尾的空白字符



---
### 0x01 String object


#### String 对象的常用方法


charAt()        返回指定索引位置的字符串  

chaerCodeAt() 返回下标对应的字符编码
concat()        连接字符串  

indexOf()       返回字符串中检索指定字符第一次出现的位置，不存在返回 -1  



lastIndexOf()  不存在返回 -1  返回字符串中检索指定字符串最后一次出现的位置 

replace()       替换匹配字符串  

slice()         提取字符串片段，[0,N)，起始位和结束位可以是负数  
克隆数组，以妨破坏原数组的顺序


substring()     提取字符串片段, [0,N)，起始位和结束位不可以是负数 

substr()        返回从Start开始指定数量的字符   

subsplit()      分隔为数组   

toString()      转换为指定进制的字符串    

toUpperCase()   把字母转换为大写  

toLowerCase()   把字符串转换为小写   







---
### 0x02 彩票生产小程序

```
<body>
	
	<button id="caiBtn" onclick="showNum()"></button>
	<input type="text" name="" id="show_text">
</body>

<script>
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

	function showNum(){
		generateRandom(0,31,5);
		var txt = document.getElementById("show_text");
		txt.value = randomArray;
		
	}
</script>
```

这个小程序，实现了对 `Math.random()` 函数的应用。


