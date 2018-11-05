# position

## 格式化宽度

---

`格式化宽度`只出现在`position:absolute/fixed`是绝对定位模型中。默认情况下绝对定位元素的宽度表现是`包裹性`，既宽度由`内部尺寸`决定，但对于`非替换元素`，当`left/right`或`top/bottom`对立方位的属性值同时存在的时候，元素的宽度表现为`格式化宽度`: 既其宽度大小相对于最近的具有定位特性（非`static`）的祖先元素计算。

```stylus
.parent
  position relative
  width 1000px
  .child
    position absolute
    left 20px
    right 20px
```

如上，根据格式化宽度，此时元素`child`的宽度为`1000 -20 -20 = 960 px`。

