---
title: AngularJS(3)元素与事件指令
date: 2017-01-21
tags: ['AngularJS']
toc: true
categories: technology

---
### 0x00 元素指令
以下是用于在 DOM 中对元素进行配置和渲染样式的元素指令:

* `ng-if`: 从 DOM 中添加和移除元素；
* `ng-class`: 为元素设置 class 样式；
* `ng-class-even`: 对由 `ng-repeat` 指令生成的偶数元素设置 class 样式；
* `ng-class-odd`:  对由 `ng-repeat` 指令生成的奇数元素设置 class 样式；
* `ng-hide`: 在 DOM 中显示和隐藏元素；
* `ng-show`: 在 DOM 中显示和隐藏元素；
* `ng-style`: 设置一个或多个 CSS 属性。


##### ng-hide 和 ng-show

`ng-hide` 指令在表达式的值为 `true` 时将元素设置 `display:none`，从而隐藏元素,而 `ng-show` 在表达式的值为 `false` 时显示元素。

```
<span ng-hide="item.complete">(Incomplete)</span>
<span ng-show="item.complete">(Done)</span>
```

虽然，`ng-hide` 会将元素 CSS 样式设置为 `display:none`，从而实现了对用户的隐藏，但对浏览器而言并没有消失，它仍然在那儿，这有可能会对后续的 CSS 设置样式带来影响。

解决这个问题，可以使用 `ng-if` 来移除元素，而不仅仅是隐藏元素:

```
<!-- 使用 ng-if 指令模拟 ng-hide 和 hg-show 指令，以解决 后者带来的 CSS 样式问题-->
<span ng-if="!item.complete">(Incomplete)</span>
<span ng-if="item.complete">(Done)</span>
```

##### ng-if 和 ng-repeat
但需要注意的是 `ng-if` 指令无法和 `ng-repeat` 指令应用在同一元素上，因为两者都依赖叫作嵌入包含的技术。这种情况之下可以使用 `ng-repeat` 和过滤器 `$filter` 来解决问题。

比如实现条纹表格:

```
<!--ng-if 和 ng-repeat 实现条纹表格-->
<table class="table table-striped">
    <thead>
    <tr>
        <th>#</th>
        <th>Action</th>
        <th>Done</th>
    </tr>
    </thead>
    <tr ng-repeat="item in todos | filter: {complete: 'false'}">
        <td>{{$index + 1}}</td>
        <td>{{item.action}}</td>
        <td>{{item.complete}}</td>
    </tr>
</table>
```

##### ng-class 和 ng-style

```
<tr ng-repeat="item in todos" ng-class="settings.Rows">
    <td>{{$index +1 }}</td>
    <td>{{item.action}}</td>
    <td ng-style="{'background-color':settings.Columns}">
        {{item.complete}}
    </td>
</tr>
```

##### ng-class-even 和 ng-class-odd

使用 `ng-class-even` 和 `ng-class-odd` 实现条纹表格:

```
<tr ng-repeat="item in todos" ng-class-even="settings.Rows">
  <td>{{$index +1 }}</td>
  <td>{{item.action}}</td>
  <td ng-class-odd="setting.Columns">
  {{item.complete}}
  </td>
</tr>
```

[清单3-7](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(3)%E4%BD%BF%E7%94%A8%E5%85%83%E7%B4%A0%E4%B8%8E%E4%BA%8B%E4%BB%B6%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%953-7.html)

---
### 0x01 事件指令
以下是 AngularJS 1.6 中定义的事件指令:

* `ng-blur`
* `ng-change`
* `ng-click`
* `ng-copy`,`ng-cut`,`ng-paste`
* `ng-dblick`
* `ng-focus`
*  `ng-keydown`,`ng-keypress`,`ng-keyup`
* `ng-mousedown`,`ng-mouseenter`,`ng-mouseleave`,`ng-mousemove`,`ng-mouseover`,`ng-mouseup`
* `ng-submit`

此外，AngularJS 还提供了简单的触摸事件和手势支持。

需要指出的的是在 AngularJS 1.6 中 `mouseenter` 事件被表示为 `mouseover` ，而 `mouseleave` 事件被表示为 `mouseout`。

```
$scope.handleEvent = function (e) {
    console.log("Event type:" + e.type);
    $scope.data.columnColor = e.type == "mouseover" ? "Green" : "Blue";
}

 <tr ng-repeat="item in todos " ng-class="data.rowColor"
        ng-mouseenter="handleEvent($event)"
        ng-mouseleave="handleEvent($event)">
```

[清单3-8](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(3)%E4%BD%BF%E7%94%A8%E5%85%83%E7%B4%A0%E4%B8%8E%E4%BA%8B%E4%BB%B6%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%953-8.html)

---
#### 创建自定义事件指令
虽然 AngularJS 内置了很多事件指令，但是还不够，对于其未提供的事件便需要我们自己去创建了，比如 `touch` 指令。

```
angular.module("exampleApp", [])
        .controller("defaultCtrl", function ($scope) {
            $scope.message = "Tap Me!";
        }).directive("tap", function () {
            return function (scope, elem, attrs) {
                elem.on("touchstart touchend", function () {
                    scope.$apply(attrs["tap"])
                })
            }
        })
```

[清单3-9](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(3)%E4%BD%BF%E7%94%A8%E5%85%83%E7%B4%A0%E4%B8%8E%E4%BA%8B%E4%BB%B6%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%953-9.html)


---
### 0x03 布尔值指令

* `ng-checked`: 管理 `checked` 属性，用于 `input` 元素;
* `ng-disabled`: 管理 `disabled` 属性，用于 `input` 和 `button` 元素;
* `ng-readonly`: 管理 `readonly` 属性，用于 `input` 元素;
* `ng-selected`: 管理 `selecte` 属性，用于 `option` 元素;
* `ng-href`: 在 `a` 元素上设置 `href` 属性；
* `ng-src`: 在 `img` 元素上设置 `src` 属性；
* `ng-srcset`: 在 `img` 元素上设置 `srcset` 属性。

当使用 `ng-href` 指令时，会在 AngularJS 处理完成以后再进行跳转，以防止用户跳转到错误目标位置。

[清单3-10](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(3)%E4%BD%BF%E7%94%A8%E5%85%83%E7%B4%A0%E4%B8%8E%E4%BA%8B%E4%BB%B6%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%953-10.html)

