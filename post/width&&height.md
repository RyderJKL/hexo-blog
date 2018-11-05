# width 与 height

1. 当`widht`为`auto`时候，`margin`可以改变元素的宽度

## height 高度 100% 无效

如果父级的`height`为`auto`，只要子元素在文档流中，那其百分之就会被忽略。

让元素支持`height: 100%;`：

1. 设定显示的高度值
2. 使用绝对定位

## 绝对定位与 height/width
绝对定位元素的**宽、高**百分比计算是相对于 `padding-box`，非绝对定位元素的宽度百分比则是相对于`context-box`

