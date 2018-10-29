---
title: AngularJS(9)高级指令  
date: 2017-02-11
tags: ['AngularJS']
toc: true
categories: technology

---
### 0x00 嵌入包含
`ng-transclude` **嵌入包含** 从，字面意义理解是先嵌入再包含,指令首先使用模板嵌入指令所在位置，然后再吸纳指定的内容。

demo 如下：

被嵌入的模板 `#template`:

```
<script type="text/ng-template" id="template">
        <div class="panel panel-default">
            <div class="panel heading">
                <h4>This is the panel</h4>
            </div>
            <div class="panel-body" ng-transclude>
                <!--ng-transclude，此处显示需要吸纳的内容，比如，来自 panel中的 div#origin-content -->
            </div>
        </div>
    </script>
```

自定义指令所在的位置，即模板被嵌入的位置:

```
<body ng-controller="defaultCtrl">
    <panel>
        <!--panel 是自定义指令，并将其作为元素使用-->
        <!--此处便是模板将会嵌如的为位置-->
        <div id="origin-content" class="well">
            <p class="text-center"> The data value comes fome the: {{dataSource}}</p>
        </div>
    </panel>
```

自定义指令内容:

```
 <script type="text/javascript">
        angular.module("exampleApp",[])
        .directive("panel", function () {
            return {
            	link: function (scope, element, attrs) {
                    scope.dataSource = 'directive';
	            },
                restrict: 'E',
                scope: false,
                template: function () {
                    return angular.element(
                    	document.querySelector("#template")
                    ).html();
                },
                transclude: true
            }
        }).controller("defaultCtrl", function ($scope) {
            $scope.dataSource = "Controller";
        })
    </script>
```

值得注意的是，被嵌入包含的内容中的表达式是在控制器作用域中被计算的，而不是指令作用域。

如果想使用指令作用域，可以将 `scope` 设置为 `false`。

```
restrict: 'E',
scope: false,
```

[清单9-1]()

---
### 0x01 在指令中使用控制器
指令可以创建出被其它指令所用的控制器。这允许指令被组合起来创建出更复杂的组件。

[清单9-2]()

