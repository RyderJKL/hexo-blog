---
title: JS服务器编程(2)表单脚本  
date: 2016-12-19 15:17  
tags: ['JavaScript','表单脚本']
toc: true
categories: technology

---
### 0x00 表单基础
在 HTML 中，表单由 `<form>` 元素来表示，但是在 JavaScript 中，表单对应的是 `HTMLFormElement` 类型，它具有的一些独有的属性和方法。

* action: 接收请求的 URL
* elements: form 中所有控件的集合
* length: form 中控件的数量
* method: 要发送的 HTTP 请求类型
* name: 表单的名称
* reset(): 重置 form 域为默认值
* submit(): 提交 form
* target: 用于发送请求和接收响应的窗口的名称
* acceptCharset: 服务器能够处理的字符集
* enctype: 请求的编码类型。

---
#### 查找表单

```
// 通过 ID 查找
var form = document.querySelector("#form1");

// 通过 document.forms 集合查找
var firstForm = document.forms[0] // 索引查找
var myForm = document.forms["form2"] // 取得 name 为 form2 的表单
```

---
#### 提交表单

```
// 通用提交表单
<input type="submit" value="Submit">

// 自定义提交表单
<button type="submit">Submit</button>

// 图像按钮
<input type="image" src="pho.gif">
```

---
#### 阻止表单提交的默认行为

```
var form = document.querySelector("#myForm")
EventUtil.addHandler(form, "submit", function(event){
    // 取得事件对象
    event = EventUtil.getEvent(event)
    
    var target = EventUntil.getTarget(event)
    
    // 阻止默认事件
    EventUtil.preventDefault(event);
    
    // 取得提交按钮
    var btn = target.elements["submit-btn"]
    
    // 验证表单
    // do something
    
    // 禁用提交按钮
    btn.disabled = true
})
```

> 为避免用户重复提交，应该在第一次提交表单以后就禁用提交按钮，或者利用 `onsubmit` 事件处理程序取消后续的表单提交操作

如上，要在第一次点击后就禁止提交，只需要监听 `submit` 事件，并在该事件发生时禁用提交表单按钮即可。

---
#### 表单字段
通过 `form` 的 `elements` 属性可以获得所有表单字段，然后可以安装索引或者 `name` 特性来访问它们。

如果多个表单控件都使用一个 `name` ，那么会放回一改 `name` 命名的一个 `NodeList` 集合

##### 共有的表单字段属性
共有的表单字段属性:
* disabled: 布尔值，表示当前字段是否被禁用
* form: 指向所属的 form
* name: 当前字段的名称
* type: 当前字段的类型

除了 `<fieldset>` 之外，所有的表单都有 `type` 属性，对于 `<input>` 元素，
该值等于 HTML 的 `type` 值。

对于`<selete>`元素该值如下:

* <select>单选列表</select>：type 属性值 `select-one`
* <select multiple>多选列表</select>：type 属性值 `select-multiple`

##### 共有的方法和事件
每个表单字段都有两个方法:`focus()` 和 `blur()` 方法。

此外，所有表单字段都支持下列 3 个事件:
* blur: 字段失去焦点时 触发
* focus: 字段获得焦点时触发
* change: 对于`<input>` 和 `<textarea>` 元素，在它们失去焦点且 value 值改变时触发；对于 `<select>` 元素，在其选项改变时触发。


---
### 0x01 文本框脚本
有两种方式表现文本框:`<input>` 的单行文本框和 `<texarea>` 的多行文本框。

```
<input type="text" size="25" maxlenth="50" value="how are you?">
```

对于单行文本框，通过 `size` 特性可以指定文本框能够显示的字符数，通过 `value` 特性访问其内容，而`maxlength`则用于指定其可以接受的最大字符数。

相对于 `<textarea>` 要指定文本框的大小可以使用 `rows` 和 `cols` 特性。

```
<textarea rows="24" cols="5">who are you?</textarea>
```

---
#### 选择文本 
`<input type="text">` 和 `<textarea>` 都支持 `select()` 方法用于选中所有文本，而与此对应的是 `select` 事件。

`select`事件在选中文本的时候就会触发

```
var textbox = form.elements['textbox']
textbox.onselect = function(){
	alert(textbox.value)
}
```

但是通过 `select` 事件只能确定用户何时选择了文本，却不知道用户到底选择了哪些文本，基于此 HTML5 添加了 `selectionStart` 和 `selectionEnd` 方法。

要取得用户在文本框中选取的文本，可以使用如下方法:

```
textbox.onselect = function(){
	alert(textbox.value.substring(textbox.selectionStart, textbox.selectionEnd))
}
```

---
#### HTML5 约束验证 API

##### required 必填在字段

任何标注有 `required` 的字段，在提交表单时都不能空着。

```
<input text="text" name="username" required>
```

该属性适用于 `<input>`,`<textarea>`,`<select>` 字段。

##### plachholer 提示符


---
### 0x02 选择框脚本
选择框通过 `<select>` 元素和 `<option>` 元素创建，它们同属于 `HTMLSelectElement` 类型，为了方便交互，该类型提供了如下属性:

* add(newOption, relOption): 插入新的 `<option>` 元素，在相关项之前
* multiple: 布尔值，是否允许多项选择
* options: 所有的 `<option>` 元素集合
* remove(index): 移除给定位置的索引项

> 选择框 `<select>` 的 `type` 属性值不是 `select-one` 即是 `select-muitiple`

为了便于访问数据，每个 `<option>` 元素都有一个 `HTMLOptionElement` 对象，该对象具有如下属性:

* index: 当前选择项在 `options` 集合中的索引
* selected: 布尔值，表示当前选项是否被选中
* select: 选项的文本
* value: 选项的值

> `<select>` 元素的值，就是选中的  `<option>` 元素的 `value` 特性值。如果没有 `value` 特性，则是 `<option>` 元素的文本值


---
#### 选择项
对于只能选择一项的选择框，最简单的方式就是使用 `selectedIndex` 属性:

```
var selectedOption = selectbox.options[selectbox.selectedIndex]
```

而对于可以选择多项的选择框，我们需要循环遍历选择集合，然后测试每个选择项的 `seleted` 属性

```
function getSelectedOption(selectBox){
	var result = new Array()
	var option = null

	for(let i=0,len = selectBox.options.length;i < len;i++){
		option = selectBox.options[i]
		if(option.selected){
			result.push(option)
		}
	}

	return result
}

var selectBox = document.querySelector("#selectBox")
var selectedOptions = getSelectedOption(selectBox)
// 获得所有被选中的项
```

---
### 0x03 表单序列化
在表单对服务器发送数据之前，需要将表单中的有效数据进行格式化的编码，即表单序列化。

下面的 `serialize` 函数可以实现表单的序列化操作:

```
function serialize(form){
	let parts = [],field = null, i, len, j, optLen, option, optValue;
	for(i =0, len = form.elements.length; i<len;i++){
		field = form[i]

		switch(field.type){
			case "select-one":
			case "select-multiple":

				if(field.name.length){
					for(j=0,optLen = field.options.length;j < optLen;j++){
						option = field.options[j]
						if (option.selected){
							optValue = ""
							if (option.hasAttribute){
								optValue = option.hasAttribute("value")? option.value : option.text
							} else {
								optValue = option.attributes["value"].specified ? option.value : option.text
							}

							parts.push(encodeURIComponent(field.name) + "=" +encodeURIComponent(optValue))
						}
					}
				}
				break;
			case undefined: //字段集
			case "file": 	//文件输入
			case "submit": 	//提交按钮
			case "reset": 	//重置选项 
			case "button": 	//自定义按钮
				break;
			case "radio": 	//单选按钮
			case "checkbox": //复选按钮
				if (!field.checked){
					break;
				}

			// 执行默认操作
			default:
				// 不包含没有名字的字段
				if (field.name.length){
					parts.push(encodeURIComponent(field.name) + "=" + encodeURIComponent(field.value))
				}
		}
	}
	// 对表单字段的名称和值进行 URL 编码，各字段之间使用 "&" 分隔
	return parts.join("&")
}
```

在整个表单序列化的过程中，稍微复杂一点的就是 `<select>` 元素了，它能是单选框或者多选框，那么我们需要去遍历控件中的每一项。当不存在 `value` 特性时，使用 `text` 的值，我们使用了 `hasAttribute()` ，而在 IE 中需要使用 `specified` 特性。

对于单选按钮和复选按钮，需要检查其 `checked` 属性书否为 `false`,是则退出 switch 循环。若为 `true` 则将其键值对进行编码，推到 `parts`数组。







