---
title: JS正则(2)常用匹配规则
date: 2016-09-29
tags: ['JavaScript','JS正则']
toc: true
categories: technology

---

### 0x00 常用匹配规则

##### 匹配并替换手机号

```
// HTML:
//<p><input type="text" id="phone" value="123" name=""><span id="alertSpan">123</span></p>

var pattern = /^1[3456789]\d{9}$/;
//开头必需是数字1，第二位必需是3-9之间的一个数字，末尾必需是9个数字

phone.onblur = function(){
var patternPhone = /^1[345678]\d{9}$/;
isTel = patternPhone.test(phone.value);
// 判断是否符合规则
if(isTel){
	var patternReplace = /(\d{3})(\d{4})(\d{4})/;
	//对号码进行分段划分，3,4,4
	var replaTel = (phone.value).replace(patternReplace,"$1****$3");
	//替换第二组的内容，将其变为 ****
	//$1~$9 代表不同的匹配组
	alertSpan.innerHTML = replaTel;
    }
}
```

##### 检测汉字

```
var pattern = /[\u4e00-\u9fa5]+/;
```

##### 匹配邮箱
```
var patternMail = /\w+@([a-z][0-9]){2,7}.[a-z]{2,4}$/i;
```

##### 检测网址

```
var patternUrl = /^https?:\/\/www\.\w+\.[a-z]{2,4}$/i;
```

##### 验证密码等级


```
// 验证密码强度
var patternNumAndLetter = ^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$;

必需是字母和数字的组合,长度为6-8位
```

##### 检测IP
```
//ip:1-255.0-255.0-255.0-255
var reg = /^(1\d{2}|25[0-5]|2[0-4]\d|[1-9]\d|[1-9])\.(1\d{2}|25[0-5]|2[0-4]\d|[1-9]\d|[0-9])\.(1\d{2}|25[0-5]|2[0-4]\d|[1-9]\d|[0-9])\.(1\d{2}|25[0-5]|2[0-4]\d|[1-9]\d|[0-9])$/
//100-199 250-255 200-249 11-99 1-9 \.
```

##### 过滤HTML中的标签元素

```
var patterTags = /<[^<>]+>/g;
//匹配所有标签
var patternBr = /(<br\/>)+/g;
//匹配 <br/>
var documentContent = document.body.innerHTML;
var replceBrContent = documentContent.replace(patternBr,"\n")
console.log(replceBrContent)
//将HTML 代码中的　<br/> 标签替换为 \n
var brContent = replceBrContent.replace(patterTags,"");
// 将所有标签替换为 ""
document.write(brContent);
// 打印带有换行符标识的文本
```

