---
title: AngularJS(7)创建自定义指令  
date: 2017-02-04    
tags: ['AngularJS']
toc: true
categories: technology

---
### 0x00 创建自定义指令
使用 `Module.directive` 方法来创建自定义指令，接收的两个参数是:要创建的新指令的名称和一个用于创建该指令的工厂函数。

同样工厂函数会返回一个 `worker` 函数，在自定义指令中，这个 `worker` 函数被称为链接函数，它提供了将指令与 HTML 文档和作用域数据相连接的方法。

---
#### 链接函数

链接函数接收三个参数:指令被应用到的视图的作用域(`scope`)，指令被应用到的 HTML 元素(`element`)，以及 HTML 元素的属性(`attrs`)。

> scope, element, attrs 参数是普通的 JavaScript 参数，而不是通过依赖注入提供的，这意味着被传入链接函数的对象的顺序应是固定的。

```
angular.module("exampleApp", [])
.directive("unorderedList", function(){
    return function (scope, element, attrs) {
      // do something
    }
})
```

然后可以将指令当作一个属性来使用:

```
<div unordered-list="products"></div>
```

> 注意属性名和传给 `directive` 方法的名称是不同的: unordered-list 和 unorderedList。传给方法的参数中每个大写字母被认为是属性名中一个独立的词，而每个词之间用一个连字符隔开。


##### 从作用域获取数据
与 AngularJS 控制器不同，自定义指令并不声明对 `$scope` 服务的依赖，传入的是指令被应用到的视图的控制器所创建的作用域。

这样设计的目的允许单个指令在一个应用程序中被使用多次，而每个应用程序可能是在作用域层次结构上不同作用域上工作的。

链接函数的第三个参数是一个按照名字索引的属性结合，要从作用域中获取数据，可以通过该参数获得对应的属性值。

```
.directive("unorderedList", function(){
    console.log("dafa")
    return function (scope, element, attrs) {
        let data = scope[attrs["unorderedList"]];
        if (angular.isArray(data)){
            console.log(data);
        }
    }
})
```

从 `attrs` 集合中使用 `unorderedList` 作为 `key` 来获取相关值，然后传给 `scope` 对象来获取相关数据。

```
 let data = scope[attrs["unorderedList"]];
```


##### 生成 HTML 元素
AngularJS 包含了一个裁剪版的 jQuery，成为 jqLite，他具备jQuery的大多数功能。

jqLite 的功能通过链接函数的 `element` 参数暴露出来。

```
if (angular.isArray(data)){
    let listElem = angular.element("<ul>");
    element.append(listElem);
    for(let i =0;i < data.length;i++){
        listElem.append(angular.element('<li>').text(data[i].name));
    }
}
```

[清单7-1](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(7)%E5%88%9B%E5%BB%BA%E8%87%AA%E5%AE%9A%E4%B9%89%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%957-1.html)


---
#### 打破数据依赖
清单7-1 中的指令存在对于数据属性的依赖，因为它假定对象都有一个 `name` 属性。 

```
listElem.append(angular.element('<li>').text(data[i].name));
```

这种依赖将导致我们无法在别处或者其它应用程序钟使用该指令。

解决这个问题的最简单的办法是定义一个额外的属性，用来指定哪个属性值会被显示在 li 项目中。

```
let data = scope[attrs["unorderedList"]];
let propertyName = attrs["listProperty"];
if (angular.isArray(data)) {
    let listElem = angular.element("<ul>");
    element.append(listElem);
    for (let i = 0; i < data.length; i++) {
        listElem.append(angular.element('<li>').text(data[i][propertyName]));
    }
}

<div unordered-list="products" list-property="name"></div>
```

[清单7-2](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(7)%E5%88%9B%E5%BB%BA%E8%87%AA%E5%AE%9A%E4%B9%89%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%957-2.html)

添加一个额外的属性是最简单的方法，它存在的问题是无法灵活的应用指令，比如当为其添加一个过滤器时，自定义指令将被破坏。

```
 <div unordered-list="products" list-property="price | currency"></div>
```

解决该问题的方案是使用 `scope.$eval()` 方法，让作用域将属值当作一个表达式来计算，该方法接收的是要计算的表达式和用于执行该计算的数据。


##### 计算表达式

```
let propertyExpression = attrs["listProperty"];

for (let i = 0; i < data.length; i++) {
    listElem.append(angular.element('<li>').text(scope.$eval(propertyExpression, data[i])));
}
```

[清单7-3](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(7)%E5%88%9B%E5%BB%BA%E8%87%AA%E5%AE%9A%E4%B9%89%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%957-3.html)

---
#### 处理数据变化

上述所有的清单中，在 AngularJS 处理时 li 元素的内容就已经被设置了，并且在底层的数据变化时无法自动更新。


[清单7-4](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(7)%E5%88%9B%E5%BB%BA%E8%87%AA%E5%AE%9A%E4%B9%89%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%957-4.html)

如上，在清单中当点击 `button` 按钮是，`price` 也将会逐次累加。 

其核心代码如下:

```
.directive("unorderedList", function () {
    return function (scope, element, attrs) {
        let data = scope[attrs["unorderedList"]];
        let propertyExpression = attrs["listProperty"];
        if (angular.isArray(data)) {
            let listElem = angular.element("<ul>");
            element.append(listElem);
            for (var i = 0; i < data.length; i++) {
                ( function () {
                    let itemElement = angular.element('<li>');
                    listElem.append(itemElement);
                    var index = i;
                    let watcherFn = function (watchScope) {
                        return watchScope.$eval(propertyExpression, data[index]);
                    };

                    scope.$watch(watcherFn,function (newValue, oldValue) {
                        itemElement.text(newValue);
                    })
                }());

            }
        }
    }
})
```

我们使用了 `$watch` 方法来监控作用域中的变化，并定义了一个监听器函数 `watcheFn`,该函数然我们可以从容面对表达式中可能带有过滤器的数据值的情况。

每次 `watcherFn` 函数被重新计算时，该函数作为参数被传递给作用域，另外使用了 `$eval` 函数计算在使用的表达式。

然后将 `watcherFn` 函数传递个 `$watch` 函数并指定回调函数，该回调函数使用 jqLite 的 `text` 方法更新 `li` 元素的文本内容。

最后，归于 JavaScript 的特性，防止 `index` 被 `for` 循环的下一次迭代所更新，使用了 IIFE (即立即执行函数表达式)。


---
### 0x01 使用 jqLite

---
#### DOM 导航
对于简单的指令通常并不需要对 DOM 进行导航，因为已经对链接函数传入 `element` 参数了，该参数代表的是指令所引用到的元素的 jqLite 对象。但对于一些更复杂的指令，仍然需要对元素层次结构进行遍历并定位或者更复杂的 DOM 操作。

以下是 DOM 导航的 jqLite 方法:

* `children()`:  返回一组子元素(jqLite 对象)；
* `eq()`: 返回指定索引下的元素(jqLite 对象)；
* `find(tag)`: 按照指定的 tag 名称定位所有的后代元素(jqLite 对象)；
* `next()`: 获取下一个兄弟元素(jqLite 对象)；
* `parent()`: 返回父元素(jqLite 对象)。


[清单7-5](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(7)%E5%88%9B%E5%BB%BA%E8%87%AA%E5%AE%9A%E4%B9%89%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%957-5.html)

如上清单所示，其核心代码如下:

```
let items = element.children();
for ( let i=0;i<items.length;i++){
    if (items.eq(i).text() == "Oranges"){
        items.eq(i).css({"font-weight":"bold","color":"red"})
    }
}
```

如上，使用 `eq()` 方法将获得一个指定索引下的元素的 jqLite 对象。而不是将 jqLite 对象当做 JavaScript 数组来处理(例如 items[i])，因为这样得到的将是 `HTMLElement` 对象。

此外，值得注意的是，`children` 只会返回指定元素下的所有直接子元素，而不包括所有后代，要获得所有的后代元素可以使用 `find` 方法。

---
#### 创建和移除元素

以下是用于创建和移除元素的 jqLite 方法:

* `angular.element(html)`: 创建一个 jqLite 对象；
* `after(elem)`: 在元素后面插入内容；
* `append(elem)`: 将元素作为最后一个子元素插入；
* `clone()`: 复制一个 jqLite 对象；
* `prepend(elem)`: 将元素作为第一个子元素插入；
* `remove()`: 从 DOM 中删除 jqLite 对象的元素；
* `replaceWith(elem)`: 用指定元素替换调用方法的 jqLite 对象的元素；
* `wrap(elem)`: 使用特定元素包裹 jqLite 对象中的每个元素。

