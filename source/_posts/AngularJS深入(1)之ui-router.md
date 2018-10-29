---
title: AngularJS深入(1)之ui.router
date: 2016-11-28
tags: ['AngularJS深入']
toc: true
categories: technology

---
### 0x00 ngRoute VS ui.router
AngularJS 原生的路由mok `ngRoute` 只是提供了最基本的路由功能在很多实际的使用场景中的表现并不理想。庆幸的是 AngularJS 开发团队设计了 `ui.router` 这个第三方库来弥补原生路由的不足。

两者的区别在于，`ui.router` 是基于 `state(状态)` 的，它通过状态填充某一部件 ， `ngRoute` 是基于 `url`，它通过指令填充某一部件。`ui.router` 模块具有更强大的功能，主要体现在视图的嵌套方面。


---
#### ngRoute

使用 `ngRoute` 配置路由过程如下:

```
let app = angular.module('app', ['ngRoute']);
app.config(['$routerProvider', function($routerProvider){
  $routerProvider.when('/main',{
    templateUrl: 'main.html',
    controller: ;MainCtrl'
}).otherwise({ redirectTo: '/tabs'});
}])
```

`ngRoute` 中的服务与指令如下:

* `ngRoute`: 路由模块名
* `$routerProvider`: 服务提供者，用来定义一个路由表，即地址栏与视图模板的映射，对应于 `ui.router` 中的 `urlRouterProvider` 和 `stateProvider`
* `$route` 服务:完成路由匹配，并且提供路由相关的属性访问及事件，如访问当前路由对应的 `Controller`，对应于下面的 `$urlRouter` 和 `$state`
* `$routeParams`: 服务，保存了地址栏中的参数，对应于下面的 `$stateParams`

* `ng-view` 指令: 用来在主视图中指定加载子视图的区域，对应于下面的 ui-view。

---
#### ui.router

其基本的路由配置如下:

```
myApp.config(['$stateProvider','$urlRouterProvider',function ($stateProvider, $urlRouterProvider) {
$urlRouterProvider.otherwise('/globalBuy');
$stateProvider
		.state("Main", {
			url: "/main",
			templateUrl: "main.html",
            controller: 'MainCtrl'
		})
```

`ui.router` 中的服务与指令如下:

* `ui.router` 路由模块名
* `$urlRouterProvider`: 服务提供者，用来配置路由重定向
* `$stateProvider`: 服务提供者，用来配置路由
* `$urlRouter`: 服务
* `$state`: 服务，用来显示当前路由状态信息，以及一些路由方法（如：跳转）
* `$stateParams`: 服务，用来存储路由匹配时的参数
* `ui-view`: 指令，路由模板渲染，对应的 dom 相关联
* `ui-sref`: 指令，链接到特定状态

