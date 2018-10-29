---
title: 前端之坑(2)之CSS
date: 2017-01-12
tags: ['JavaScript','前端之坑']
toc: true
categories: technology

---


### overflow

满足以下条件，overflow 不会隐藏元素。


1.拥有overflow:hidden样式的块元素不具有position:relative和position:absolute样式；
2.内部溢出的元素是通过position:absolute绝对定位；

CSS 这些坑爹的怪异行为 overflow



---
### body的overlfow问题

```
body{
     position: relative;
     border: 10px solid red;
     overflow-y: auto;
     height: 200px;
   }

   .drag-demo {
     width: 200px;
     height: 400px;
     background: red;
     padding: 10px;
     border:5px dashed darkorange;
     overflow: auto;
   }

   .drag-demo > div {
     width: 100px;
     height: 2000px;
     border: 1px solid floralwhite;
   }

<body>
   <div class="drag-demo">
  <div>sadfsa</div>
</div>
</body>
```

---
### body的background-color问题

