---
title: AngularJS(8)创建复杂指令  
date: 2017-02-05  
tags: ['AngularJS']
toc: true
categories: technology

---
### 0x00 定义复杂指令
以下是自定义指令对象所定义的属性:

* `link`: 为指令指定一链接函数；
* `compile`: 指定一个编译函数；
* `restrict`: 指定指令如何被使用；
* `template`: 指定一被嵌入到 HTML 文档的模板；
* `templateUrl`: 指定一个外部 HTML 模板；
* `scope`: 创建一个新的作用域或者隔离作用域；
* `controller`: 为指令创建一个控制器；
* `replace`: 指定模板内容是否替换指令所应用到的元素；
* `require`: 声明对某个控制器的依赖；
* `transclude`: 指令是否被用于包含任意内容。

当指令只返回一个链接函数时，所创建的指令只能被当做一个属性来使用，此时，我们可以通过 `restrict` 属性来修改默认配置，其对应的属性值有 `E(将指令用作一个元素)`,`A(将指令用作一个属性)`,`C(将指令用作一个类)`,`M(将指令用作一个注释)`。

---
#### 使用指令模板

##### 使用 template

[清单8-1](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS%E5%9F%BA%E7%A1%80/AngularJS(8)%E5%88%9B%E5%BB%BA%E5%A4%8D%E6%9D%82%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%958-1.html)

生成一个模板，最简单的方式就是使用 `template` 属性，为其写入要生成的模板内容。

如上清单所示，其核心代码如下:

```
.directive("unorderedList", function () {
	return {
		link: function (scope, ele, attrs) {
			scope.data = scope[attrs["unorderedList"]];
		},
		restrict: "A",
		template: "<ul><li ng-repeat='item in data'>" +"{{item.price | currency}}</li></ul>"
	}
})
```

但是 `template` 属性的灵活性也是显而易见的，就是并不怎么灵活。所以 AngularJS 还提供了 `templateUrl` 属性以提供外部来进行指令渲染。

##### 使用 tempateUrl

[清单8-2](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS%E5%9F%BA%E7%A1%80/AngularJS(8)%E5%88%9B%E5%BB%BA%E5%A4%8D%E6%9D%82%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%958-2.html)

如上清单所示，其核心代码如下:

```
.directive("unorderedList", function () {
    return {
        link: function (scope, ele, attrs) {
            scope.data = scope[attrs["unorderedList"]];
        },
        restrict: "A",
        templateUrl: "itemTemplate.html"
    }
})
```

当然，我们还可以更灵活的使用 `templateUrl` 属性，即是为其指定一个函数使其动态的选择需要展示自定义指令的模板。

传递给 `templateUrl` 属性的函数接收一个代表指令所应用的元素以及该元素上定义的属性集。

##### 使用 replace 
默认情况下使用 `templateUrl` 指定的模板，将会作为指令所在元素的子元素被插入。为 `replace` 指定属性值 `true` 便会替换所在的父级元素。


---
### 0x01 管理指令作用域
简单的将，我们可以为自定义指令的 `scope` 属性设置为 `true`，从而为指令所应用到的每一个实例创建独立的作用域，这种方式使得我们在一定程度上减少了控制器的数量，即不用使用大量的控制器以分隔作用域就可以复用自定义指令，但是我们所定义的自定义指令仍然会受到顶层控制器的支配，作用域继承规则总是有效的。


---
#### 单向数据绑定
我们渴望创建一纯粹独立的自定义指令，不受任何控制器或作用域层次上的继承关系的影响，以在任何地方重用该指令。解决的方案是将 `scope` 属性设置为对象，通过对对象定义的属性做修改便不会被传播到控制器作用域上，因此此时，作用域的隔离是从作用域层次结构上别隔离的，即指令和控制器之间的作用域没有任何关系。

在这种情况下，便可以自定义指令的中 `scope` 对象上的特殊属性 `@prop` 实现单项数据绑定(从控制器作用域流向自定义指令作用域):

```
<script type="text/ng-template" id="scopeTemplate">
    <div class="panel-body">
       <p>Data Value: {{local}}</p>
    </div>
</script>
<div class="panel panel-default" ng-controller="scopeCtrl" >
    <div class="panel-body">
        Direct binding: <input ng-model="data.name">
    </div>
    <div class="panel-body" scope-demo="" nameprop="{{+ 'from Chinese'}}"></div>
</div>

angular.module('exampleApp', [])
    .directive("scopeDemo", function () {
        return {
        	template: function () {
                return angular.element(document.querySelector('#scopeTemplate')).html();
	        },
            scope: {
        		local: '@nameprop'
            }
        }
    }).controller("scopeCtrl", function ($scope) {
        $scope.data = {name: "jack"};
        $scope.city = "london";
    })
```

[清单8-3](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS%E5%9F%BA%E7%A1%80/AngularJS(8)%E5%88%9B%E5%BB%BA%E5%A4%8D%E6%9D%82%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%958-3.html)

---
#### 双向数据绑定
当然， 我们还可以创出双向数据绑定，只需要使用 `=prop` 特性就可以了:

```
<p>Data Value: <input ng-model="local"></p>

scope: {
      local: '=nameprop'
 }

 <div class="panel-body" scope-demo="" nameprop="data.name"></div>
```


---
#### 计算表达式

下面的 Demo 将演示，如何将控制器作用域中的函数与自定义指令进行关联，并对来自控制器作用域中的数据进行计算或传递给自定义指令。

需要使用 `&Fnuc` 特性来讲所指定特性的值绑定到一个函数。
 
```
<script type="text/ng-template" id="scopeTemplate">
    <div class="panel-body">
        <p>Name: {{local}}, City:{{cityFn({nameVal: local})}}</p>
    </div>
</script>

angular.module('exampleApp', [])
	.directive("scopeDemo", function () {
		return {
			template: function () {
				return angular.element(document.querySelector('#scopeTemplate')).html();
			},
			scope: {
				local: '=nameprop',
                cityFn: "&city"
			}
		}
	}).controller("scopeCtrl", function ($scope) {
		$scope.data = {
			name: "Jack",
		    defaultCity: "China"
		};


		$scope.getCity = function (name) {
            return name == "Jack" ? $scope.data.defaultCity : "Unknown";
		}
	})
		}
    <div class="panel-body" scope-demo="" city="getCity(nameVal)" nameprop="data.name"></div>
```

[清单8-4](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS%E5%9F%BA%E7%A1%80/AngularJS(8)%E5%88%9B%E5%BB%BA%E5%A4%8D%E6%9D%82%E6%8C%87%E4%BB%A4/%E6%B8%85%E5%8D%958-4.html)

---
#### 使用隔离作用域的数据

最后，可以为表达式传递一个控制器作用域上没有被定义过的属性名，来实现将隔离作用域的数据作为控制器作用域表达的一部分。

```
<!--修改指令模板数据-->
<p>Name: {{local}}, City:{{cityFn({nameVal: local})}}</p>

<!--修改指令实例-->
<div class="panel-body" scope-demo="" city="getCity(nameVal)" nameprop="data.name"></div>
```

