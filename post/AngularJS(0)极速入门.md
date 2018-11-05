---
title: AngularJS(0)极速入门  
date: 2017-01-03           
tags: ['AngularJS']
toc: true
categories: technology

---
### 0x00 内置指令

AngularJS 指令是扩展的 HTML 属性，带有前缀 **ng**。



###### ng-app 

初始化一个 Angular 应用程序

###### ng-init

初始化应用程序数据。通常情况下，不使用 ng-init。而是使用一个控制器或模块来代替它。

###### ng-model

指令把元素值（比如输入域的值）绑定到应用程序。



```
<!DOCTYPE html>
<html ng-app>
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    <div ng-init="name='Jack'">
        <input type="text" ng-model="name">
        <p><b>{{name}}</b></p>
    </div>
</body>
<script src="../angular.js"></script>
</html>
```

如上， `{{ name }}` 表达式是一个 AngularJS 数据绑定表达式。`{{name}}` 通过 `ng-model = "name"` 进行同步。

###### ng-repeat

重复一个 HTML 元素：

```
<!--ng-repeat-->
    <div ng-init="arr=['first', 'second', 'third']">
        <p>循环对象</p>
        <ul>
            <li ng-repeat="x in arr">
                {{x}}
            </li>
        </ul>
    </div>
```

---
### 0x01 自定义指令

 AngularJS 内置的指令外，我们还可以使用 `.directive` 来创建自定义指令。
###### .directive
使用驼峰法来命名一个指令， `myDirective`, 但在使用它时需要以 `-` 分割, `my-directive`:

要调用自定义指令，HTML 元素上需要添加自定义指令名。

```
<div ng-app="myApp">
        <my-directive></my-directive>
</div>

    <script>
        var app = angular.module("myApp", [])
        app.directive("myDirective", function () {
            return {
                template: "<h1>自定义指令</h1>"
            }
        })
    </script>
```

你可以通过以下方式来调用指令：
* 元素名 [E]: `<my-directive></my-directive>`
* 属性 [A]: `<div my-directive></div>`
* 类名 [C]: `<div class="my-directive"></div>`
* 注释 [M]: `<!-- directive: my-directive -->`


###### restrict

如下，我们可以使用限制指令 `resrict` 规定只能以某种特性的方式调用.

```
    return {
        restrict: "A",
        template: template: "<h1>自定义指令</h1>"
    }
```

`restrict` 默认值为 EA, 即可以通过元素名和属性名来调用指令。


---
### 0x02 ng-model 指令
`ng-model` 指令用于绑定应用程序数据到 HTML 控制器(input, select, textarea)的值。

```
<div ng-app="myApp" ng-controller="myCtrl">
        名字: <input ng-model="name">
        <h1>你输入了: {{name}}</h1>
    </div>

    <script>
        var app = angular.module('myApp', []);
        app.controller('myCtrl', function($scope) {
            $scope.name = "John Doe";
        });
    </script>

    <p>修改输入框的值，标题的名字也会相应修改。</p>
```

---
### 0x03 控制器 Controller
AngularJS 应用程序被控制器控制。我们可以使用 **ng-controller** 指令定义控制器。

AngularJS 控制是一个由 JavaScript 创建的对象，所以其内部当然可以包含属性和方法。

```
<body>

    <div id="appBox" ng-app="myApp" ng-controller="personCtrl">
        姓: <input type="text" ng-model="firstName">
        名: <input type="text" ng-model="lastName">
        <br>
        <hr>
        姓名: {{sayName()}}

    </div>

    <script>
        var app = angular.module('myApp', []);
        app.controller('personCtrl', function($scope) {
            $scope.firstName = "马";
            $scope.lastName = "云"
            $scope.sayName = function () {
                return $scope.firstName + $scope.lastName;
            }
        });
    </script>
    <p>在输入框的值，名字也会同步显示。</p>
</body>
```

如上, `ng-app` 定义了一个 AngularJS 应用程序，该程序运行在 `div#appBox` 中，并使用 `ng-controller` 定义了一个控制器。


当然，在大型项目中，都是将应用程序存放在外部文件中的，然后再在 `app.html` 中引入就行了:

```
// personControl.js 
/**
 * Created by onejustone on 2017/1/4.
 */
angular.module('myApp', [])
    .controller('personCtrl', function ($scope) {
        $scope.firstName = '马'
        $scope.lastName = '云'
        $scope.sayName = function () {
            return $scope.firstName + $scope.lastName
        }
})


// index.html
<body>
<div ng-app="myApp" ng-controller="personCtrl">
        姓: <input type="text" ng-model="firstName">
        名: <input type="text" ng-model="lastName">
        <br>
        <hr>
        姓名: {{sayName()}}
</div>
</body>
<script src="../controllers/personController.js"></script>
```

---
### 0x04 过滤器 Filter
过滤器可以使用一个 **管道字符 ( | )** 添加到表达式和指令中。

Angular 过滤器可以转换数据，下面是其内置的几种过滤器:
* `currency`: 格式化数字为货币格式。
* `filter`: 从数组项中选择一个子集。
* `lowercase`: 格式化字符串为小写。
* `uppercase`: 格式化字符串为大写。
* `orderBy`: 根据某个表达式排列数组。

来看看下面的例子:

```
// index.html
<div ng-app="myApp" ng-controller="myCtrl">
    <input type="text" ng-model="test">
       <p ng-repeat="x in names | filter:test | orderBy:country">
           {{(x.name | uppercase) + x.country}}
       </p>
</div>
<script src="../controllers/myController.js"></script>

// myController.js
angular.module('myApp', [])
    .controller('myCtrl', function ($scope) {
        $scope.names = [{name:'Jani',country:'Norway'},
            {name:'Hege',country:'Sweden'},
            {name:'Kai',country:'Denmark'}]
})
```

---
### 0x05 模块 Module
我们可以把模块看作一个容器，模块定义了一个应用程序，而这个应用程序是模块中不同部分的容器。

所以，可以把控制器也看作是模块的一部分，那么我们自然也可以把控制器与模块与拆开：

```
<body>

    <div ng-app="myApp" ng-controller="myCtrl">
        <input type="text" ng-model="test">
       <p ng-repeat="x in names | filter:test | orderBy:country">
           {{(x.name | uppercase) + x.country}}
       </p>
    </div>

</body>
<script src="../controllers/myApp.js"></script>
<script src="../controllers/myController.js"></script>
```

注意 `myApp.js` 与 `myController.js` 的引入顺序。

```
// myApp.js
/**
 * Created by onejustone on 2017/1/4.
 */
var myApp = angular.module("myApp", [])
```

在模块定义中 `[]` 参数用于定义模块的依赖关系。
中括号 `[]` 表示该模块没有依赖，如果有依赖的话会在中括号写上依赖的模块名字。

```
// myController.js
myApp.controller('myCtrl', function ($scope) {
        $scope.names = [{name:'Jani',country:'Norway'},
            {name:'Hege',country:'Sweden'},
            {name:'Kai',country:'Denmark'}]
    })
```


---
### 0x06 依赖注入
Angular 使用以下五个核心组件来实现依赖注入:

* `value`： Value 是一个简单的 javascript 对象，用于向控制器传递值（配置阶段）：
* `factory`：是一个函数用于返回值。在 service 和 controller 需要时创建。
通常我们使用 factory 函数来计算或返回值。
* `provider`: AngularJS 中通过 provider 创建一个 service、factory等(配置阶段)。
* `service`:
* `constant`: constant(常量)用来在配置阶段传递数值，注意这个常量在配置阶段是不可用的。


---
### 0x07 路由
AngularJS 路由允许我们通过不同的 URL 访问不同的内容。而正是得益于路由功能，才能让我们实现多视图的单页 Web 应用（single page web application，SPA）。

值得注意的是，通常我们的 URL 形式为 `http://onejustone.xyz/first/page`，但在单页 Web 应用中 AngularJS 通过 **# + 标记** 实现，如: `http://onejustone.xyz/#/first`

