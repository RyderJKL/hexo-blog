# Vue Vs RxJS

本文主要探讨 Vue 的响应式与 Rxjs 的对比

Vue 的`two-ways-data binding`是通过`ES5 definedProperty`的`getter/setter`。
每当数据发生改变时，就会执行`getter/setter`从而搜集有改动的变量，这被称为 **依赖收集**

