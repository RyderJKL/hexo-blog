---
title: JS服务器编程(4)JSON  
date: 2016-11-8  
tags: ['JavaScript','JSON']
toc: true
categories: technology

---
### 0x00 JSON
JSON(JavaScript Object Notation, JavaScript对象表示法)。

JSON 利用了 JS 中的一些模式来表示结构化数据。

> JSON 是一种数据格式，而不编程语言。

JSON 可以表示三种类型的值，**简单值**,**对象**，**数组**。

对于简单值，在JS中，JSON 可以表示，`字符串`,`数值`,`布尔值`,`null`,但是不支持JS 中的特殊值 undefined。

> JSON 不支持变量，函数或对象实例。

---
#### 使用 JSON 表示对象

```
//JSON 中的对象
{   "name":"Jack",
    "age":29,
    "school":{
        "name":"huaxin school",
        "location":"china"
    }
}

//JS 中的对象
var object = {
    "name":"Macil",
    "age":29
};

```

在 JSON 中表示对象时必须给对象的属性添加**双引号**。此外，没有声明变量，其次，末尾没有分号。

---
#### JSON 表示数组
JSON 中数组采用的是 JS 中数组的字面量形式。

```
[24,"hello",false]
```

同样的，JSON 中数组也没有变量好分号。

把数字和对象结合起来，便可以构成复杂的数据集合。

---
### 0x01 解析和序列化
JSON 数据结构可以被解析为有用的 JS 对象，这也是 JSON 成为 Web 服务开发中交互数据的事实标准的重要原因。

JSON 对象有两个方法: **stringify()** 和 **parse()**。

**stringify()**:把 JS 对象序列化为 JSON 字符串
**parse()**:把 JSON 字符串解析为原生的 JS 值

---
#### JSON.stringify()
`JSON.stringify()` 除了要序列化的 JS 对象外，还可以接受另外两个参数。需要添加的第二个参数是过滤器，可以是数组(数组过滤器)或者函数(函数过滤器)。第三个参数表示，是否在 JSON 字符串中保留缩进。


##### 数组过滤器

如果过滤器参数是数组，那么 `JSON.stringify()` 的结果中将只包含数组中列出的属性。

```
var books = {
	"title":"挪威的森林",
	"authors":["村上春树"],
	"edition":3,
	"year":2011
};

var jsonText = JSON.stringify(books,["title","edition"]);
console.log(jsonText);
//{"title":"挪威的森林","edition":3}
```


##### 函数过滤器
函数过滤器中的函数接受两参数:`属性名` 和 `属性值`，而属性名只能是字符串。
 
 函数过滤器会根据传入的键来决定返回的结果。但若是函数返回了 `undefined` 那么相应的属性会被忽略。
 
 
 ```
 var books = {
	"title":"挪威的森林",
	"authors":["村上春树","芥川龙之介","松下幸之助","太宰治"],
	"edition":3,
	"year":2011
};

var jsonText = JSON.stringify(books,function(key,value){
	switch(key){
		case "authors":
			return value.join(",");
		case "year":
			return 50000;
		case "edition":
			return undefined;
		default :
			return value;
	}
});
console.log(jsonText);
//{"title":"挪威的森林","authors":"村上春树,芥川龙之介,松下幸之助,太宰治","year":50000}
```


##### 字符缩进
`JSON.stringify()` 的第上参数可以为数字或者任意字符。分别表示要缩进的空格数和用来表示的缩进字符串(不再使用空格)

```
var jsonText = JSON.stringify(book,null,"---");
```


---
#### JSON.parse()
与 `JSON.stringigy()` 方法对应，`JSON.parse()` 可以接受一个函数作为还原函数(reviver),它也同样接收两参数，一个键和一个值。

如果还原函数返回 `undefined` 则表示要在结果中删除相应的键。

在将日期对象转换为 Date 对象时，便经常使用到还原函数了。

```
var books = {
	"title":"挪威的森林",
	"authors":["村上春树","芥川龙之介","松下幸之助","太宰治"],
	"edition":3,
	"year":2011,
	"releaseDate":new Date(2016,11,8)
};

var jsonText = JSON.stringify(books,function(key,value){
	switch(key){
		case "authors":
			return value.join(",");
		case "year":
			return 50000;
		case "edition":
			return undefined;
		default :
			return value;
	}
});

var bookCopy = JSON.parse(jsonText,function(key,value){
	if (key == "releaseDate"){
		return new Date(value);
	} else {
		return value;
	}
})
```


