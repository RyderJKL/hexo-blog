
---
title: Table无切换刷新   
date: 2016-10-08    
tags: ['JS小项目']
toc: true
categories: technology

---
### 0x00 Table无切换刷新


```
<style type="text/css">
		*{
			margin:0;
			padding:0;
			list-style:none;
			box-sizing: border-box;
		}

		ul{
			text-align: center;
			width:600px;
			height: 40px;		
			background: yellowgreen;	

		}

		li {
			float:left;
			border:1px deeppink solid;
			width:200px;
			cursor: pointer;			
		}
		
		#wrap{
			width:600px;
			height: 400px;
			/*background-color: red;*/
		}

		.box {
			width: 100%;
			height: 100%;
			float: left;
		}

		.box:first-child{
			background: green;
			display: none;
		}
		
		.box:nth-child(2){
			background: black;
			display: none;
		}
		.box:last-child{
			background: deeppink;
		}
		

</style>
	
	
	
<body>
	<ul>
		<li>1</li>
		<li>2</li>
		<li>3</li>
	</ul>
	<div id="wrap">
		<div class="box"></div>
		<div class="box"></div>
		<div class="box"></div>
	</div>
</body>

<script type="text/javascript">
	var lis = document.getElementsByTagName("li");
	var div = document.getElementsByClassName("box");
	for(var i = 0;i < lis.length;i++){
		lis[i].index = i;
		lis[i].onclick = function function_name(argument) {
			// body...
			num = this.index;
			for(var j = 0; j < div.length;j ++){
				div[j].style.display = "none";
				div[num].style.display = "block";
			}
		}
	}
</script>
```

