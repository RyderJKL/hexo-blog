---
title: jQuery(1)选择器    
date: 2016-11-28 08:12    
tags: ['jQuery']
toc: true
categories: technology

---
### 0x01 JQuery 选择器

---
#### 基本选择器

```
// ID 选择器
$("#item1").css({})

// Class 选择器
$(".items").css({})

// * 选择器
$("*div").css({})

```


---
#### 层次选择器

```
// 组合层次选择器
$('#item3,#item1>span').css({})

// 后代选择器
$('#wrap #item1 span').css({})

// 直接子代选取器
$('#wrap>div').css({})

// 相邻兄弟选择器
$('#item3 + div').css({})

// 同胞兄弟选择器
$('#item2 ~ div').css({})
```

---
#### 过滤选择器

```
// :fisrt
$('#wrap div:first').css({})

// :last
$('#wrap div:last').css({})

// :not
$('#wrap div:not').css({})

// :even 
// 所匹配的集合中索引为偶素的项
$("#wrap div:even").css({})

// :odd
// 所匹配的集合中索引为奇数的项
$("#wrap div:odd").css({})

// :eq
// 指定索引的项
$(".items:eq(1)").css({})

// :gt 大于指定索引的项
$(".items:gt(1)").css({})

// :lt 小于指定索引的项
$(".items:lt(3)").css({})

// :nth-child(an+b)
// 返回的集合中的第几项
$(".items:nth-child(2n)").css({})

// :nth-child(even/odd/index)
/// 下标从 1 开始

// :nth-of-type(2a+b)

// :last-of-type()

// :nth-last-of-type()

// :only-of-type()
// 选择所有没有兄弟元素，且具有相同的元素名称的元素。

// 同理,还有
// :first-child()

// :last-child()

// :only-child()

// :empty-child()

// :focus
选择当前获得焦点的项

// :animated
// 正在执行动画的元素

```
---
#### 属性过滤选择器

同样，JQuery 支持 JS 中所有的属性选择器，此外，还支持组合式的属性选择器:

```
//选择指定属性值等于给定字符串或以该字符串为前缀的项
$("div[class|=isDiv).css({})

// 所有属性都符合的的匹配项 && 的关系
$("div[class^=items][diy]").css({})
```


---
#### 内容过滤选择器

```
// 选择所有包含指定文本的所有元素
:contains(text)

// 选择选择元素其中至少包含指定选择器匹配的一个种元素。
:has(selector)
$('div:has(p)')
// 所有含有 p 标签的 div 元素
```

---
#### 表单选择器




