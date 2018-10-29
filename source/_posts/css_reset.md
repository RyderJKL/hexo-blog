# CSS 重置属性

```stylus
<!-- 解决替换元素宽带自适应问题 -->
input, textarea, img, video, object
  box-sizing border-box

<!-- 解决 firefox 下 img 不是替换元素而是内联元素无法设置宽带的问题  -->
img
  display inline-block
```

