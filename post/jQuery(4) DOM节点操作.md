---
title: jQuery(4)DOM节点操作   
date: 2016-11-28 11:12          
tags: ['jQuery']
toc: true
categories: technology

---
### 0x00 节点操作

#### 创建节点

#### 插入节点
内部插入
* A.appendTo(B):将 A 插入到 B 的最后
* A.append(B): 在 A 的最后插入 B
* A.prependTo(B): 将 A 插入到 B 的最前
* A.prepend(B): 在 A 的最前插入 B


平级插入
* A.insertbefore(B): 把 A 插入到 B 之前
* A.before(B): 在 A 之前插入 B 
* A.insertafter(B): 把 A 插入到 B 之后
* A.after(B):在 A 之后插入 B

#### 删除节点

* remove()
将匹配元素集合从DOM中删除，包括元素本身和其中的内容（注：同时移除元素上的事件及 jQuery 数据。）

* empty()
 从DOM中移除集合中匹配元素的所有子节点,该方法不接受任何参数。

#### 替换节点

* replaceAll(target)
用集合的匹配元素替换每个目标元素。

#### 克隆

* clone()  
基于原生 JS 的深层克隆，可以传递布尔值作为参数，但是不同 JS 的布尔值的含义，jQuery 中 `.clone(ture)` ，表示进行深层克隆，并且克隆与之相关的事件。


---
### 0x01 节点关系
* children(Selector)
.children()不返回文本节点;让所有子元素包括使用文字和注释节点，建议使用.contents()。

查找含有 "selected" 样式的 div 的所有子元素。

```
<div>
    <span>Hello</span>
    <p class="selected">Hello Again</p>
    <div class="selected">And Again</div>
 
    <p>And One Last Time</p>
  </div>
<script>$("div").children(".selected").css("color", "blue");</script>

```
* siblings(Selector)
获取同辈元素，包括目标元素之前的同辈元素。

* next() 
获得下一个同辈元素

* prev()
获得上一个同辈元素

* parent()
获取该元素的直接父级，即是只向上查询一层。

* parents(Selector)
获取该元素的所有父级，可传入选择器作为参数以提取指定的祖先元素。

* offsetParent()
取得离指定元素最近的含有定位信息的祖先元素。



