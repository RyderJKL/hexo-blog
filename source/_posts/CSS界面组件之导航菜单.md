---
title: CSS界面组件之导航菜单
date: 2016-09-17 16:39  
tags: ['CSS界面组件','CSS']
toc: true
categories: technology

---

### 0x00 纵向菜单

代码示例:

```
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<style type="text/css">
		*{
			margin:0;
			padding:0;
		}

		nav{
			margin: 50px;
			width: 200px;
		}

		.list ul{
			border:1px solid #6a6bbc;
			border-radius: 3px;
			padding:5px 10px 3px;
		}

		.list li{
			list-style:none;
		}
		
		.list li+li a {

			border-top:1px solid #6a6bbc;
		}

		.list a{
			padding: 3px 10px;
			text-decoration: none;
			display: block;
		}
		
		.list a:hover{
			background-color: #069;
			color:white;
			font: 20px/1em "宋体";
		}
	</style>
</head>
<body>
	<nav class="list">
		<ul>
			<li><a href="">Home</a></li>
			<li><a href="">APP</a></li>
			<li><a href="">Contents</a></li>
			<li><a href="">About</a></li>
		</ul>
	</nav>
</body>
</html>
```

注释:

1. 使用 **非首位子元素** 选择符。
`li + li` 选择符意思为：任何跟在  `li`  之后的 `li`。在上面表示给除第一个 `li`  之外的所有列表项上方加一条边框。

 其它实现效果:
 ```
.list li{
  border-top:1px solid #069;
}
.list li:first-child{
   border-top:none;
}
 ```

2. 让列表可点击。
为了不让只有文本可以点击（**因为链接 a  是行内元素，它会收缩并包住其中的文本。**），为了提高用户体验，我们需要 **让列表项所在的整行都能点击**。方法就是首先把内边距从 li  元素转移到链接内部，然后让链接完全填满整个列表项。

---
### 0x01 横向菜单

代码示例:

```
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<style type="text/css">
		*{
			margin: 0;
			padding:0;
		}
		.list ul{
			overflow: hidden; 
			list-style: none; 
			margin: 0 20px;
			border:1px solid grey;   
			padding: 5px 10px;
		}

		.list li {
			
			float: left;
			border-right: 1px solid grey;
			padding: 0 10px;
		}

	
		.list li a{

			display: block;
			text-decoration: none;
			border-radius: 3px;	

		}

		.list li:last-child{
			border-right: none;
		}

		.list a:hover{
			background-color: grey;
			border-radius: 4px;
		}
	</style>
</head>
<body>
	<nav class="list">
		<ul>
			<li><a href="">Home</a></li>
			<li><a href="">Pages</a></li>
			<li><a href="">Content</a></li>
			<li><a href="">About</a></li>
		</ul>
	</nav>
</body>
</html>
```

注释:

1. 浮动可以让 `li`  元素从垂直变成水平。当然可以使用 `display:inline-block` 属性将 `li` 变成水平方向的。

2. `ul { overflow:hidden;}` 可以使 `ul` 强制包裹 浮动的 `li`。


---
### 0x02 下拉菜单

html示例代码:

```
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<link rel="stylesheet" type="text/css" href="multipule.css">
</head>
<body>
	<nav id="nav">
	<ul class="firstNav">
		<li><a href="">人类</a></li>
		<li><a href="">植物</a></li>
		<li><a href="">动物</a>
			<ul class="secondNav">
				<li><a href="">犬科</a></li>
				<li><a href="">猫科</a></li>
				<li><a href="">鸟科</a>
					<ul class="thirdNav">
						<li><a href="">大鸟</a></li>
						<li><a href="">中鸟</a></li>
						<li><a href="">小鸟</a></li>
						<li><a href="">小小鸟</a></li>
					</ul>
				</li>
				<li><a href="">昆虫科</a></li>
			</ul>
		</li>

		<li><a href="">微生物</a></li>
	</ul>
	</nav>
</body>
</html>
```

CSS示例代码：

```
*{
	margin: 0;
	padding: 0;
	text-decoration: none;
	list-style: none;
}


#nav{
	font:1em "宋体";
}

/*显示样式规则*/
/*一级菜单显示*/
	/*设置所有 a 标签的显示样式*/
#nav li a {
	color:#555;
	background-color: gray;
	padding: .2em 1em;
	border-width: 3px;
	border-color:transparent;
	border-right-style: solid;
	background-clip: padding-box;
}

#nav li:hover > a{
	color: #fff;
	background-color: #aaa;
}
	/* a 标签显示样式结束 */
/*一级菜单显示结束*/

/*二级菜单显示样式*/

#nav ul{
	height: 2em;
	
}
#nav li ul{
	
	width:9em;
	height: 7em;
}

#nav li li a{
	/*去掉继承的右边框*/
	border-right: none;	
	border-top:2px solid transparent;
}
/*结束二级菜单显示演示*/
/*显示样式规则结束*/


/*开始设置功能样式*/

#nav {
	position: relative;
}

#nav li{
	float: left;
	position: relative;
}

#nav li a{
	display: block;
}

/*二级菜单功能样式*/
#nav li ul {
	/*隐藏二级菜单*/
	display: none;
	/*相对父元素绝对定位*/
	position: absolute;
	left: 20px;
	top: 100%;

}

#nav li:hover > ul{
	/*一级菜单悬浮时显示二级菜单*/
	display: block;
	
}
/*二级菜单功能演示结束*/

#nav li li{
	/*二级菜单停止悬浮，恢复重叠*/
	float: none;
	border:none;

}

/*三级菜单功能样式*/
#nav li li ul{
	position: absolute;
	left: 100%;
	top:0;

}
/*结束三级菜单功能样式*/
/*结束功能样式*/
```


#### 核心代码

```
div.menu-bar ul ul { display: none;}
div.menu-bar li:hover > ul { display: block;}
```

