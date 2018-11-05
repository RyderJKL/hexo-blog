---
title: AngularJS(1)概览  
date: 2017-01-18  
tags: ['AngularJS']
toc: true
categories: technology

---
### 0x00 模块 module
模块(module) 是 AngularJS 应用程序中的顶层组件。

AngularJS 中的模块主要有三种角色:

* 使用模块，可以将 AngularJS 应用程序与 HTML 文档中的一部分关联在一起，以此设置 AngularJS 应用程序的边界。
* 使用模块可以使用 AngularJS 的一些内置组件和自定义组件。
* 使用模块可以组织代码和管理组件。


---
### 0x00 创建模块

模块通过 `angular.module` 方法定义，如下:

```
var myApp = angular.module("exampleApp", []);
```

`module` 方法接受三个参数：

* `name`: 模块名称。
* `requires`: 模块所依赖的模块集合。
* `config`: 该模块配置，等价于`modeule.config` 方法。

通常只使用前两个参数。


值得注意的是，模块创建和模块查找的区别,`requires` 参数在创建模块时是不可忽略的。依赖是必须添加的，即使没有依赖模块，也必须写上 `[ ]`。没有添加 `requires` 则会被认为是模块查找。



模块定义完成，还必须通过 `ng-app` 指令应用到 HTML 中在去。

```
<html ng-app="exampleApp">
```

---
### 0x02 使用模块定义组件
`angular.module` 方法将会返回一个 `Module` 对象，而 `Module` 对象包括如下属性和方法：

* `animation(name, factory)`:  支持动画特性。
* `config(callback)`:  注册一个在模块加载时对该模块进行配置的函数。
* `constant(key, value)`: 定义一个返回常量的服务。
* `controller(name, constructor)`: 创建控制器。
* `directive(name, factory)`: 创建自定义指令。
* `factoty(name, provider`: 创建一个服务。
* `service(name, constructor)` : 创建一个服务。
* `provider(name, type`: 创建服务。
* `filter(name, factory)`: 创建过滤器。
* `name`: 返回模块名称。
* `run(callback)`: 注册一个在 AngularJS 加载完毕后用于对所有模块进行配置的函数。

* `value(name, value)`: 定义一个返回一常量的服务。

---
#### 创建控制器
控制器使用 `Module.controller` 创建，它接收两个参数: 控制器名称和一个工厂函数。

```
var myApp = angular.module("exampleApp", []);
myApp.controller('firstCtrl', ['$scope', function($scope){
    // do somthing
}])
```

如上，我们创建了一个 `firstCtrl` 控制器，并注入了其对 `$scope` 服务的依赖。

>  依赖注入  
依赖很好理解，就是一个应用程序中的一些组件依赖于其它的组件。而依赖注入则简化了组件之间处理依赖的过程。AngularJS 通过在组件的工厂函数的参数中声明依赖，当然声明的依赖要与所依赖的组件相匹配。

**控制器** 扮演了 **模型** 和 **视图** 之间的渠道的角色。


##### Fluent API  
Module 对象定义的方法返回的结果仍然是 Modeule 对象，这个简洁的特性使得我们可以使用 fulent API，即多个方法调用可以链式的连接在一起:

```
angular.module('exampleApp', [])
.constant(...)
.config(...)
.controller(...)
.controller(...)
```

---
#### 创建指令
AngularJS 内置了很多优秀的指令，但是如果仍然无法满足，便可以创建自己的自定义指令。

自定义指令通过 `Module.directive` 方法创建:

```
<script>
var myApp = angular.module('exampleApp', []);

myApp.controller('dayCtrl', function ($scope) {
    var dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday'];
    $scope.day = dayNames[new Date().getDay()];
}).directive('highlight', function () {
    return function (scope, element, attrs) {
        if (scope.day == attrs['highlight']){
            element.css("color", "red");
        }
    }
})
</script>

<div class="panel" ng-controller="dayCtrl">
    <div class="page-header">
        <h3>AngularJS </h3>
    </div>
    <h4 highlight="Wednesday">Today is {{day || "(unkown)"}}</h4>
</div>
```

如上 `Module.directive` 方法接收的两个参数是: 要创建的指令的名称和一个用于创建指令的工厂函数。

然后将该指令当做一个属性使用，而当 AngularJS 在 HTML 中遇到 `highlight` 属性时，会调用传给 `directive` 方法的工厂函数，而工厂函数将会传入三个参数给工人函数: **视图的作用域(scope)**, **指令所应用到的元素**， **该元素的属性**。

如上，如果 `highlight` 属性的值与作用域中的 `day` 变量的值相等，就会使用 `element` 参数来设置 HTML 的内容。

---
#### 创建过滤器
过滤器被用于视图，用来格式化需要显示的数据。过滤器一旦定义，就可以在整个模块中全面应用，以次保证跨多个控制器和视图之间的数据展示的一致性。

```
<div class="panel" ng-controller="dayCtrl">
    <div class="page-header">
        <h3>AngularJS </h3>
    </div>
    <h4 highlight="Wednesday">Today is {{day || "(unkown)" | dayName }}</h4>
</div>

<script>
var myApp = angular.module('exampleApp', []);

myApp.controller('dayCtrl', function ($scope) {
    var dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday'];
    $scope.day = new Date().getDay();
})

myApp.filter("dayName", function () {
    var dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday'];
    return function (input) {
        return angular.isNumber(input) ? dayNames[input] : input;
    }
})
</script>
```

AngularJS 提供了 **声明式(通过 HTML)** 和 **命令式(通过 Javascript)** 两种方式访问所创建的组件。

如上，我们使用的是声明访问构建的组件，如下，我们可以对我们的代码进行改造:

```
myApp.directive('highlight', function ($filter) {
    var dayFilter = $filter("dayName");

    return function (scope, element, attrs) {
        if (dayFilter(scope.day) == attrs['highlight']){
            element.css("color", "red");
        }
    }
})
```

我们对自定义指令 `highlight` 注入了 `$filter` 服务依赖，如此通过 `$filter` 服务便可以访问所有已定义的过滤器。

---
#### 创建服务

服务是一个单例对象，它所提供的功能可以被整个应用应用程序使用。比如，AngularJS 中一些内置的服务，`$scope`, `$filter`, `$http`。

> 关于单例对象: 即是只有一个对象会被 AngularJS 创建出来，并被程序需要服务的各个不同部分所分享

AngularJS 提供三种不同方法用以创建不同类型的服务: **service**, **factory**, **provider**。

以 **service** 为例，接收的两个参数是:服务名和创建服务对象的工厂函数。当 AngularJS 调用工厂函数时,会分配一个可通过 **this** 访问的新对象，而该对象中定义的属性可被全局访问到。


```
myApp.controller('dayCtrl', function ($scope, days) {
    var dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday'];
    $scope.day = days.today;
})
 myApp.service('days', function () {
    this.today = new Date().getDay();
})
```

如上，通过依赖注入来查找 `days` 服务从而将其作为参数传递给控制器的工厂函数，如此便可以访问 `days` 服务了。

---
#### 定义值

`Module.value` 方法用于创建返回固定值和对象的服务。只用 **值服务** 看似增加了不必要的复杂性，但是 AngularJS 会假设工厂函数的任意参数都声明了需要解析的依赖。

如果，不使用值服务，而写出如下代码将会报错:

```
var now = new Date();
myApp.service('days', function (now){
    this.today = now.getDay();
})
```

运行错误:

```
Error: [$injector:unpr] Unknown provider: nowProvider <- now <- days
```

问题的原因在于，当调用工厂函数时，AngularJS 不会为 `now` 参数使用那个局部变量，当引用 `now` 变量时它已经不存在与 AngularJS 模块的作用域中了。

所以，最好的建议是使用并遵循 AngularJS 的创建值服务的方法。 


---
### 0x03 使用模块组织代码
任何 AngularJS 模块都可以依赖于在其他模块中定义的组件。比如，我们可以将上述定义的控制器，过滤器，服务，自定义指令等全部提取出来，放在单独的模块中去:

```
<!-- controller.js -->
 
/**
 * Created by onejustone on 2017/1/18.
 */
angular.module('exampleApp.Controllers', [])
.controller('dayCtrl', function ($scope, days) {
    console.log(days)
    $scope.day = days.today;
})
 

```

```
<!-- filter.js -->
/**
 * Created by onejustone on 2017/1/18.
 */

 
angular.module('exampleApp.Filters', [])
.constant('dayNames', ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'])
.filter('dayName', function (dayNames) {
    return function (input) {
        return angular.isNumber(input) ? dayNames[input] : input;
    }
})
```

```
<!-- directive.js -->
/**
 * Created by onejustone on 2017/1/18.
 */

angular.module('exampleApp.Directive', [])
.directive('highlight', function ($filter) {
    var dayFilter = $filter("dayName");
    return function (scope, element, attrs) {
        if (dayFilter(scope.day) == attrs['highlight']){
            element.css("color", "red");
        }
    }
})
```

```
<!-- service.js -->
angular.module('exampleApp.Services', [])
.service('days', function (nowValue) {
    this.today = nowValue.getDay();
});
```

```
<!-- example.html -->
<!DOCTYPE html>
<html ng-app="exampleApp">
<head>
    <meta charset="UTF-8">
    <title>AngularJS Demo</title>
    <link rel="stylesheet" href="../sass/bootstrap.css">
    <link rel="stylesheet" href="../sass/bootstrap-theme.css">
    <script src="../angular.js"></script>
    <script src="controller.js"></script>
    <script src="filter.js"></script>
    <script src="services.js"></script>
    <script src="directive.js"></script>

</head>
<body>
<div class="panel" ng-controller="dayCtrl">
    <div class="page-header">
        <h3>AngularJS </h3>
    </div>
    <h4 highlight="Wednesday">Today is {{day || "(unkown)" | dayName }}</h4>
</div>
    <script>
        var myApp = angular.module('exampleApp', ['exampleApp.Services',
            'exampleApp.Directive', 'exampleApp.Controllers',
            'exampleApp.Filters'])
        var now = new Date();
        myApp.value('nowValue', now);
    </script>
</body>
</html>
```

首先，对主模块声明依赖，将每个模块的名称添加到主模块的依赖数组中，当然前提是先引入了对应模块的 `js` 文件。

值得注意的是，这些模块并没有按照某种特定的顺序定义。而且 AngularJS 会自动加载定义在程序中的所有模块并解析依赖，将每个模块所包含的构件进行合并。如此，便可以使得无缝地使用来自其他模块的功能成为可能。而不必考虑模块间的依赖关系。

---
### 0x04 在模块生命周期工作
`Modeule.config` 和 `Module.run` 方法注册了在 AngularJS 应用的生命周期的关键时刻所调用的函数。
传给 `config` 方法的函数在当前模块被加载后调用，而 `run` 方法中的函数在所有模块加载完成以后被调用.

```
<!-- example.html -->
var myApp = angular.module('exampleApp', ['exampleApp.Services',
    'exampleApp.Directive', 'exampleApp.Controllers',
    'exampleApp.Filters']);

myApp.constant("startTime", new Date().toLocaleTimeString())

myApp.config(function (startTime) {
    console.log("Main module config:" + startTime)
});

myApp.run(function (startTime) {
    console.log("Main module run:" + startTime)
});
```

```
<!-- servies.js --> 
angular.module('exampleApp.Services', [])
.service('days', function (nowValue) {
    this.today = nowValue.getDay();
}).config(function (startTime) {
    console.log("Services module config:" + startTime);
}).run(function (startTime) {
    console.log("Services module run: " + startTime);
});
```

如上，我们使用了 `constant` 方法，该方法与 `value` 值服务类似，但是使用 `constant` 创建的服务能
作为 `config` 方法所声明的依赖（而值服务却不能）。

输出:

```
Services module config: (no time)
Main module config:下午8:52:57
Services module run: 下午8:52:57
Main module run:下午8:52:57
```

[本文源代码](https://github.com/onejustone/SimpleAngularDemo/tree/master/src/AngularJS(1)%E6%A6%82%E8%A7%88)

