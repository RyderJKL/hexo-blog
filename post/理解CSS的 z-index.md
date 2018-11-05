---
title: 理解CSS的 z-index
date: 2016-09-08 11:55
tags: ['CSS']
toc: true
categories: technology

---

### 0x01 不含 z-index 的堆叠
当没有元素包含 z-index 元素时，元素按照如下顺序堆叠:

1. 根元素的背景和边界
2. 普通流(无定位)里的块元素(没有 position 或者 position : static)按 HTML 出现顺序堆叠
3. 定位元素按 HTML 中出现的属性堆叠

---
### 0x02 具有浮动元素的堆叠
浮动块元素被至于非定位块与定位块元素之间。其堆叠顺序是:

1. 根元素的背景与边框
2. 位于普通流中的后代块元素按照它们在 HTML 中的出现顺序堆叠。
3. 浮动块元素
4. 后代中的定位元素按照它们在 HTML 中出现的顺序堆叠

> 浮动块元素位于非定位块元素之上，非定位元素的背景和边框丝毫不会受到浮动元素的影响，但是内容却相反，浮动元素会挤压非定位元素的内容。

---
### 0x02 z-index
z-index 只对指定了 positioned 属性的元素幼小，并且该属性的值必需是整数(正负均可)。

> https://developer.mozilla.org/zh-CN/docs/Web/Guide/CSS/Understanding_z_index

