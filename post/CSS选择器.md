---
title: CSS选择器  
date: 2016-11-14 08:50    
tags: ['CSS']
toc: true
categories: technology

---
### 0x00 基础选择器
##### 通配选择器  
设置所有标签使用相同样式  
如: `*{ };`

不推荐通配符选择器，因为他是性能最低的一个选择器。

##### 标签选择器  
为所有相同标签设置相同样式  
如: `p{ };`

##### 类选择器  
为一组相同的标签设置相同的样式  
如: `.classname{ };`

##### ID选择器  
ID选择器在页面中只能被调用一次  
如: `#idname{ };`


---
### 0x02 组合选择器

##### 群组选择器  
如: `p` , `body` , `img` , `div` {}

##### 相邻兄弟选择器  
如果需要选择紧接在另一个元素后的元素，而且二者有相同的父元素，可以使用相邻兄弟选择器

如：`p + p { color:red;}`

##### 通用兄弟选择器
匹配某元素之后的所有兄弟元素。
如: `h2~a { }`

##### 包含（后代）选择器  
如： `body ul li {}`

##### 子元(子代)素选择器  
如: `div > p{}`

标签a必须跟在h2之后(不一定紧跟),当然，前提是他们拥有相同的父元素。

###### 子代选择器和后代选择器的区别

> 后代选择器的写法就是把外层的标记写在前面，内层的标记写在后面，之间用空格分隔。
> 子选择器只对直接后代有影响的选择器，而对“孙子后代”以及多层后代不产生作用。

---
### 0x03 状态伪类选择器 
定义样式在标签的状态之上，而不是标签本身  

```
a:link {}     #点击前  
a:hover {}    #鼠标悬停时  
a:focus {}    #获得聚焦时  
a:active {}   #点击时  
a:visited {}  #点击后  
```

下面的元素状态伪类，通常用于表单中，如：
`:enabled`,`:disabled`,`:checked`(只用于单选按钮和复选框)

 
---
### 0x04 目标伪类
##### :target
通常设置用于锚点被选中时的样式。

```
<p><a href="#box">点我旋转放大Box</a></p>
<div id="box"></div>

//CSS 
#box:target {
	border:4px solid red;
	transform: rotateZ(60deg) scale(1.8);
    transition: all 4s;
}
```

---
### 0x05 否定伪类
##### :not(selectoe)
匹配非指定/选择器的每个元素。

```
body:not(first-chid){}
input:not([type=text]){}
```

---
### 0x06 结构化伪类
##### :first-child

##### :first-of-type
匹配父元素的所有该子元素类型中第一个出现的元素.

```
div :first-of-type {
  background-color: lime;
}
```
(注意div后面的空格，这使得element变为了div的所有后代元素)


##### :last-child  

##### :last-of-type
 表示了在（它父元素的）子元素列表中，最后一个给定类型的元素。
 
匹配在 p 元素内部的 最后一个 em 元素:

```
p em:last-of-type{
    //
}
```


##### :nth-child(an+b)
如:`nth-child(2n)`等价于`nth-child(even)`,`nth-child(2n+1)` 等价于 `nth-child(odd)`.或者是`nth-child(3n)`

##### :nth-last-child(an+b)

##### :nth-of-type(an+b)
匹配一个在文档树中位置为an+b-1 且和伪元素前名字一样 的元素,想在不受同胞异类元素和父元素影响保证自己选择相同类型得元素，这个伪元素更加灵活实用.

---
### 0x07 伪元素选择器
 
##### ::first-line {}
选取某元素中的第一行  

##### ::first-letter{}
选择某元素中的第一个字或首字母

##### :: selection
应用于文档中被用户高亮的部份

---
### 0x08 生成性内容
`::after`
`::before`


---
### 0x09 属性选取器

##### 属性名选择器  
如： `img[title] {color:red}`

##### 属性值选择器
如: `img[title="red floewr"] { }`

##### `[attr~=value]`

##### `[attr|=value]`

##### `[attr^=value]`

##### `[attr$=value]`

##### `[attr*=value]`


### 0x0A 选择器的优先级
 
行内样式(1000) --> ID选择器(100) --> 类选择器(10) --> 标签选择器(1) --> 全局选择器(0)  


> 参考文档:
https://developer.mozilla.org/zh-CN/docs/Web/CSS/:last-of-type

