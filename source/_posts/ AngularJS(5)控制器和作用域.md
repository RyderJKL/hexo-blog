---
title: AngularJS(5)控制器和作用域    
date: 2017-01-09  
tags: ['AngularJS']
toc: true
categories: technology

---
### 0x00 前言
控制器作为视图与模型之间的纽带，它将模型中的数据暴露给视图，以及基于用户与视图的交互使模型产生变化所需的逻辑。具体来说，控制器是通过作用域向视图提供数据和逻辑的。这种方式加强了 AngularJS 数据绑定技术的基础。


---
### 0x01 创建控制器


控制器是通过 AngularJS 的 Module 对象提供的 controller 方法创建出来的。controller 方法的参数是新建控制器的名字和一个用于创建控制器的函数（或者是构造器，又或者被称为工厂函数）。

之后通常使用这个工厂函数去创建另一个函数(工人函数)，我们称之为**工厂/工人模式**。

然后将相关的依赖注入到工厂函数（构造器）中去。

```
/**
 * Created by onejustone on 2017/1/9.
 */
angular.module('serviceDemo', [])
// 创建一个模块,注意这里的中括号 [],存在中括号代表创建一模块，并且可以写入相关依赖，
// 如果一个模块没有被创建，那么，是无法被查找的。
.controller('demo1Ctrl', ['$scope', function ($scope) {
	$scope.demo1Content = "啊，多么美丽的,";
}])
```

如上，我们创建了一个属于 `serviceDemo` 应用的 `demo1Ctrl` 控制器，并声明了该控制器对 `$scope` 对象的依赖，如此，控制器就可通过其对应的作用域向视图提供各种能力。

---
### 0x01 修改作用域
对于作用域其最重要的一点是 **修改会传播下去，并自动更新所有相关依赖的数据值，即使是通过行为产生的**。

```
<div class="well" ng-controller="simpleCtrl">
    <label for="">Select a city:</label>
    <select name="" id="" ng-options="city for city in cities" ng-model="city">
    </select>
    <div class="well">
        <p>the city is {{city}}</p>
        <p>the country is {{getCountry(city)}}</p>
    </div>
</div>
</body>
<script>
    var app = angular.module('serviceDemo', []).controller('simpleCtrl', ['$scope',function ($scope) {
        $scope.cities = ['London', 'New York', 'Paris'];

        $scope.city = 'London';

        $scope.getCountry = function (city) {
            switch (city){
                case 'London':
                	return 'UK';
                case 'New York':
                	return 'USA';
            }
        }
    }])
</script>
```

如上，当选中 `select` 元素中的值时，不只 `city` 所绑定的元素中的值会变，`getCountry()` 函数所在元素的值也会变，这是因为使用 **ng-model，将会隐式的在控制器的作用域中声明一个变量**。

这是 AnjularJS 的优点之一，但也是一个大坑。

---
### 0x02 组织控制器
在 AngularJS 中我们可以使用很多种方式去组织控制器，我们可以在整个 `HTML` 文档中只定义一个应用并在应用中只使用一个控制器，如此，还不用去担心作用域之间的通信问题,而且行为还可以被整个 `HTML` 所用，诚然这是最简单的组织控制器的方法，可当页面越来越复杂时，这种方式显然是无法驾驭的。

当但在一个应用中定义多个控制器时，那么在实际应用中，这些控制器之间又如何能通信呢?

---
#### 控制器通信
实际上，作用域是以层级结构的形式组织起来的，顶层是根 **作用域($rootScpe)** ,每个控制器都会被赋予一个新的作用域，而该作用域是根作用域的一个子集。

基于此，AngularJS 为作用域(包括根作用域( **$rootScope** ))提供了若干用于发送和接收事件的方法，以实现在各个作用域之间通信。它们是:

* **$broadcast**: 向下广播事件，向当前作用域下的所有子作用域发送一个事件。
* **$emit**: 向下广播事件，向当前作用域的父级作用域发送一个事件，直到根作用域。
* **$on**: 注册一个事件，通常用来监听广播信息。

但是 AngularJS 更习惯于将这些在作用域之间通信的功能写在服务中，如此，在较少代码的同时更加便于维护。


```
/**
 * Created by onejustone on 2017/1/9.
 */
// 创建一个在不同控制器的作用域中传递消息的服务
angular.module('serviceDemo')
.service('broadCastService', ['$rootScope', function ($rootScope) {
	return {
	//	返回一个对象，该对象是一个自定义类型
		broadCast: function (eventName, type, data) {
			// eventName
			$rootScope.$broadcast(eventName, {
				type: type,
				data: data
			})
		}
	}
}])
```

如上，我们使用 `module.service` 方法创建了一个 `broadCastService` 服务对象，该服务可被控制用来发送和接收事件，而无需与作用域中的事件方法产生交互。


服务创建完成以后，可以在控制器中调用服务模块中的服务并使用 **$on()** 方法注册对应的监听事件。


```
/**
 * Created by onejustone on 2017/1/9.
 */
angular.module('serviceDemo')
// 查找 serviceDemo APP
.controller('demo2Ctrl', ['$scope','$rootScope','broadCastService',
	// 创建 demo2Ctrl 控制器，并在控制器构造函数中注入相关依赖
	function ($scope, $rootScope,broadCastService) {

	$scope.sendInformation = function (type, data) {
		// 新建 sendInformation 方法，用于广播信息
		broadCastService.broadCast('listenInformation', type, data);
		// 调用 indexService 服务模块中 broadCastService 服务中的 broadCast 对象并为其注册一个
		// listenInformation 事件
	};

	$scope.$on('listenInformation', function (event, args) {
		// 使用 $on() 方法监听 listenInformation
		$scope.c = args.data;
	})

}]).controller('demo2SecondCtrl', ['$scope', '$rootScope', function ($scope, $rootScope) {

	$scope.$on('listenInformation', function (event, args) {
		// 使用 $on() 方法监听 listenInformation
		$scope.c = args.data;
	})
}])
```

然后在相应的视图中为元素绑定对应的控制器:

```
<div ng-controller="demo2Ctrl">
    这里是 demo2 页面
    <input type="text" ng-model="c">
    <hr>
    <button ng-click="sendInformation('broadCast', '那年，大明湖畔。。。')">发送广播信息</button>
    <p>来自广播信息：{{c}}</p>
</div>

<div ng-controller="demo2SecondCtrl">
    来自广播信息: {{c}}
</div>
```

最后，再主页面(APP)中引入相应模块:

```
<body>
 <div class="col-xs-8">
        <div ng-view></div>
 </div>

</body>
<script>
</script>


<!--应用控制器-->
<script src="js/app/controller/demo1Ctrl.js"></script>
<script src="js/app/controller/demo2Ctrl.js"></script>

<!--引入服务器-->
<script src="js/app/services/indexService.js"></script>

<!--引入路由器-->
<script src="js/app/route/indexRoute.js"></script>
```

而在引入模块时必须注意相互之间的依赖关系，如上，控制器是依赖于服务器的，所以，服务器需要在控制器之后引入。

具体的代码在这里: 

[使用服务器控制作用域间的通信](https://github.com/onejustone/AngularServiceDemo/tree/master/src)

---
#### 控制器继承
`ng-controller` 可以被内嵌在 HTML 元素上，产生一种被称为控制器继承的效果，从而在一个父级控制器中定义公用功能并在一个或者多个子控制器中使用，以此减少代码重复。

[清单5-1](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(5)%E4%BD%BF%E7%94%A8%E6%8E%A7%E5%88%B6%E5%99%A8%E5%92%8C%E4%BD%9C%E7%94%A8%E5%9F%9F/%E6%B8%85%E5%8D%955-1.html)

当通过 `ng-controller` 指令将控制器嵌入到另一控制器时，子控制器的作用域便继承了父控制器作用域中的数据和行为。

```
<body ng-controller="topLevelCtrl">
<div class="well" ng-controller="firstChildCtrl"></div>
<div class="well" ng-controller="secondChildCtrl"></div>
</body>
```

控制器继承的最大好处在于可以将父控制器继承来的功能和子控制器定义的其它功能混合使用，比如只在 `secondChildCtrl` 控制器的作用域中才有效的  `shiftFout()` 行为可以对继承自父级作用域中的属性 `dataValue` 进行修改。但子控制器将会覆盖与父控制器中同名的属性或者行为。


---
#### 数据继承
值得注意的是 AngularJS 对作用域上的数据值的继承的处理方式以及使用 `ng-model` 指令对其的影响。

```
$scope.dataValue = "Hello, Jack";
<input ng-model="dataValue" class="form-control">
```

当读取一个直接在作用域上定义的属性的值时，AngularJS 会沿着作用域链去检查该属性。而当使用 `ng-model` 指令来修改这样一个属性时，AngularJS 会检查当前作用域是否存在该名称的属性，如果没有，便会隐形创建一该属性，结果便会覆盖父级中的同名属性。

_如果想要数据值在开始时是共享的但在修改时会被复制一份，就直接在作用域上定义数据属性。如果想确保始终只有一份数据值，可以通过以对象来定义数据属性。

```
$scope.data = {
		dataValue: "hello, world!"
	};

<input ng-model="data.dataValue" class="form-control">
```

如果使用在顶层控制器中使用对象来定义数据属性，那么便会使用 javascript 的 **基于原型** 的继承关系。

[清单5-1]()

---
#### 使用多控制器

[清单5-2](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(5)%E4%BD%BF%E7%94%A8%E6%8E%A7%E5%88%B6%E5%99%A8%E5%92%8C%E4%BD%9C%E7%94%A8%E5%9F%9F/%E6%B8%85%E5%8D%955-2.html)

使用多控制器，每一个都应用于独立的 HTML 元素，意味着各个控制器之间是相互独立的，彼此不共享作用域，也不继承数据或行为。此时，若想在每个控制器创建的作用域之间进行通信则必须使用到根作用域。

---
### 0x02 使用无作用域控制器

对于 AngularJS 也可以不使用作用域的情况下向视图提供数据和行为，取而代之的是一个提供给视图的代表控制器的特殊变量。


[清单5-3](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(5)%E4%BD%BF%E7%94%A8%E6%8E%A7%E5%88%B6%E5%99%A8%E5%92%8C%E4%BD%9C%E7%94%A8%E5%9F%9F/%E6%B8%85%E5%8D%955-3.html)

如上清单所示，在控制器中并未声明对 `$scope` 的依赖，而是通过 javascript 的关键字 `this` 定义了自己的数据值和行为。

而当应用无作用域控制器时，`ng-controller` 指令的表达式需要指定一代表控制器的变量名:

```
<div class="well" ng-controller="simpleCtrl as ctrl"></div>
```

表达式上的格式形如 _<要应用的控制器> as <变量名>_,然后在视图中使用 `ctrl` 变量访问数据和行为。

```
<input class="form-control" ng-model="ctrl.dataValue">
```

---
### 0x03 显示的更新作用域
通过显示的更新作用以实现对其更直接的控制，可以将 AngularJS 和其它的 javascript 框架结合起来。

作用域集成方法:

* `$watch(expression, handler)`: 注册一个处理函数，当 `expression` 表达式所引用的值变化时，该函数将被通知到；
* `$watchCollection(object, handler)`: 注册一个处理函数，当指定的 `object` 对象的任意属性变化时，该函数将被通知到；
* `$apply(expression)`: 向作用域应用变化。

[清单5-4](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(5)%E4%BD%BF%E7%94%A8%E6%8E%A7%E5%88%B6%E5%99%A8%E5%92%8C%E4%BD%9C%E7%94%A8%E5%9F%9F/%E6%B8%85%E5%8D%955-4.html)

如上，清单中编写了对 AngularJS 复选框的响应，以便启用或者禁用 jQuery UI 按钮，核心代码如下:

```
$scope.$watch('buttonEnabled', function (newValue) {
            $('#jqui button').button({
            	disabled: !newValue
            })
        })
```

`$wacth` 方法提供了对外集成的手段，作用域上的某个变化可以触发调用另一个框架中的相应变化。

> $watch 方法的第一个参数是一表达式，AngularJS 会计算它并找出你想计算什么。其实也可以是一个函数，该函数会产生一个属性名，但也意味着如果想直接指定一个属性的话就必需使用字符串。 


`$apply` 方法则提供了对内集成的手段，如此在其他框架中的变化就可以引起 AngularJS 中的相应变化。

比如，对按钮单击进行计数:

```
angular.element(angularRegion).scope().$apply('handleClick()');
```
AngularJS 提供了 `angular.element` 方法，只有对其传递一个所关心元素的 `id`,就可以得到一个定义了 `scope` 方法的对象，并返回所需要的作用域。

找到作用域以后调用 `$apply` 方法来调用 `handleClick` 行为。必须通过 `$apply` 方法指定一个表达式，以便让作用域知道产生的变化并传播给所绑定的表达式。



