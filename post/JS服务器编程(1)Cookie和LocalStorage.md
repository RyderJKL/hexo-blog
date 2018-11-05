---
title: JS服务器编程(1)Cookie和LocalStorage  
date: 2016-11-9    
tags: ['JavaScript','Cookie','LocalStorage']
toc: true
categories: technology

---
### 0x00 使用Cookie记录信息
简单的讲，cookie 就是一文件，用于在本地存储用户信息。其可以储存的数据类型可以是数字和字符串。可以存储的容量为 5 KB.


```
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>FirstWeb</title>
	<style type="text/css">
		*{
			margin: 0;
			padding: 0;
		}

		label{
			text-align:right;
			width: 60px;
			display: inline-block;
		}
	</style>
</head>
<body>
<p><label>用户名:</label><input type="text" id="user" name=""></p>
<p><label>密码:</label><input type="password" id="password" name=""></p>
<button id="del">删除用户名和密码</button>
<button id="rem">记住用户名和密码</button>

</body>
<script type="text/javascript">
	var user = document.querySelector("#user")
	var password = document.querySelector("#password")
	var del = document.querySelector("#del")
	var rem = document.querySelector("#rem")

	rem.onclick = function (){
		var nowDate = new Date();
		nowDate.setDate(nowDate.getDate() +1);
		// 记录 cookie 的有效时间
		document.cookie = "usrName=" + user.value +";expires=" +nowDate;
		// 将用户名记录到 cookie 中
		document.cookie = "password="+password.value+";expires="+nowDate; 
		// 将密码记录到 cookie 中		
	}


	del.onclick = function(){		
		
		var nowDate = new Date();
		nowDate.setDate(nowDate.getDate() -1);
		// 将当前时间减去一天 设置 cookie 立即失效
		document.cookie = "usrName=" + user.value +";expires=" +nowDate;
		document.cookie = "password="+password.value+";expires="+nowDate; 
	}

	window.onload = function (){
		// 文档加载完成以后，获得 cookie 中的信息

		var arrCookie = document.cookie.split("; ")
		// 使用 "; "(分号和空格) 分隔原始 cookie，获的多个不同的键值对组合的一个数组
		console.log(arrCookie);
    	for(var i=0;i<arrCookie.length;i++){
    		// 遍历数组中的键值对
    		var cookieVlue = arrCookie[i].split("=");
    		// 使用 "=" 分隔键和值
    		console.log(cookieVlue)
    		if( cookieVlue[0] == "usrName"){
    			user.value = cookieVlue[1]
    		}else if(cookieVlue[0] == "password"){
    			password.value = cookieVlue[1]
    			console.log(password.value);
    		}
    	}
	}
</script>
</html>
```

---
### 0x01 LocalStorage
cookie 的优势是支持它的厂家众多，几乎所有的浏览器厂商都是支持的，但是其最大的缺点就是可以存储的容量太少， 5KB。

H5 时代，LocalStorage 应运而生，它可以存储 5M 的资源。LocalStroage 是本地存储，与之对应的是 Session Strogae，窗口一旦关闭就没有了。二者用法完全相同。

##### 检测浏览器是否支持 localSorage

```
if(window.localStorage){
    //supports
} else {
    // not supports
}
```

相比于 cookie 的操作，操作localStorage 是在是太容易了，设置  localStorage 的三种方式:**"."**,**"[ ]"**,**"setItem()"**.此外，我们只需要使用**"removeItem()"** 来删除本地存储就可以了

```
//设置 localStorage 的三种方式
localStorage.name = "Jack"
localStorage["age"] = 29
localStorage.setItem("school","MIT")

// 获得 localStorage
console.log(localStorage.name)
console.log(localStorage.["age"])
console.log(localStorage.getItem("school"))

// 删除 localStorage
localStorage.removeItem("school")
```


