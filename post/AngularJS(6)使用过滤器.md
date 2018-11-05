---
title: AngularJS(6)使用过滤器  
date: 2017-02-04  
tags: ['AngularJS']
toc: true
categories: technology

---
### 0x00 关于过滤器
过滤器在数据从作用域传递到指令上时进行转换，但不改变源数据，这样可以允许同一份数据在应用中以不同的形式展示。

理论上，过滤器可以执行任何类型的转换，但是大多情况下用于格式化或者对数据以某种顺序排序。

---
### 0x01 过滤单个数据的值
AngularJS 有两种类型的内置过滤器:一类对单个数据值，另一类对数据集合进行操作。

用于单个数据的内置过滤器：

* `currency`: 对货币值进行格式化；
* `date`: 对时间进行格式化；
* `json`: 从 JSON 字符串中生成一个对象；
* `number`: 对数字值进行格式化；
* `uppercase`，`lowercase`：大小写格式化。

> 过滤器可以进行链式调用，这样便可以使用多个过滤器按照一定的顺序对同一数据进行操作。


---
### 0x02 过滤集合
AngularJS 包含了三个内置的集合过滤器: 

* `limitTo`: 从一个数组中选出一定数量的对象；
* `filter`: 从数组中选取对象；
* `orderBy`: 对数组中的对象进行排序。

---
#### 限制项目数量

`limitTo` 过滤器可以限制从一个数据对象构成的数组中取出的项目的数量。

[清单6-1](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(6)%E4%BD%BF%E7%94%A8%E8%BF%87%E6%BB%A4%E5%99%A8/%E6%B8%85%E5%8D%956-1.html)

如上清单所示，其核心代码如下:

```
$scope.limitVal = "5";
$scope.limitRange = [];
for(let i = (0 - $scope.products.length); i <= $scope.products.length;i ++){
  	$scope.limitRange.push(i.toString());
}

Limit: <select ng-model="limitVal" ng-options="item for item in limitRange"></select>

<tr ng-repeat="p in products | limitTo:limitVal">
```

`limitTo` 过滤器的值被指定为一个变量。而当该变量为负数时，例如 -5，过滤器会从数组中选出最后的五个对象。


---
#### 选取项
`filter` 过滤器用于从数组中选出一些对象。选取的条件可以是表达式，一个匹配属性值的  `map` 对象，或者一个函数。

比如，使用 `map` 对象选取对象:

```
<tr ng-repeat="p in products | filter: {category: 'Fish'} | limitTo:limitVal">
```

[清单6-2](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(6)%E4%BD%BF%E7%94%A8%E8%BF%87%E6%BB%A4%E5%99%A8/%E6%B8%85%E5%8D%956-2.html)

---
#### 对项目排序

`orderBy` 过滤器可对数组中的对象进行排序。

```
<tr ng-repeat="p in products | limitTo:limitVal | orderBy: '-price'">
```

在只设定了一个属性名的情况下，相当于隐式的请求过滤器为对象进行生序排序，可以通过使用 `+` 或 `-` 字符来设置排序顺序。


> 注意此处的属性名使用了引号: 'price' 而不是 price。没有引号，过滤器会将该属性看作一个作用域变量或者控制器变量。

当然，按照某个属性的值进行排序是最简单的一种方式，`orderBy` 过滤器也能使用一个函数进行排序，用于排序的函数需要传入一个数据数组中的对象，然后再返回一个在排序时用于参考的对象或者值。

[清单6-3](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(6)%E4%BD%BF%E7%94%A8%E8%BF%87%E6%BB%A4%E5%99%A8/%E6%B8%85%E5%8D%956-3.html)

函数 `myCustomSorter` 的作用是将 `expiry` 值小于 100 的项放到数据数组的前面。

最后，`orderBy` 还支持使用多个谓语进行排序，即通过为 `orderBy` 过滤器配置为使用一个属性名或者函数名构成的数组，用于依次进行排序。

```
<tr ng-repeat="p in products | orderBy: [myCustomeSorter, '-price']">
```

[清单6-4](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(6)%E4%BD%BF%E7%94%A8%E8%BF%87%E6%BB%A4%E5%99%A8/%E6%B8%85%E5%8D%956-4.html)

---
### 0x03 使用自定义过滤器
过滤器由 `Module.filter` 方法创建，该方法接收两个参数:过滤器名称和一个工厂函数，该函数用于创建实际工作的 work 函数。

---
#### 创建格式化数据值的过滤器

[清单6-5](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(6)%E4%BD%BF%E7%94%A8%E8%BF%87%E6%BB%A4%E5%99%A8/%E6%B8%85%E5%8D%956-5.html)

如上，在清单中创建了 `labelCase` 过滤器，它会将一个字符串格式化为只有首字母是大写的。

在将该过滤器应用于 category 属性时指定了配置项为 `true`,将会颠倒过滤器所应用的大小写转换过程。

---
#### 创建一个集合过滤器

[清单6-6](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(6)%E4%BD%BF%E7%94%A8%E8%BF%87%E6%BB%A4%E5%99%A8/%E6%B8%85%E5%8D%956-6.html)

如清单中所示，过滤器 `skip` 将会跳过数组对象中的前两项并选出之后的五项。

---
#### 组合过滤器

我们可以在已有过滤器的基础上将多个过滤器的功能合并到单个过滤器中。 

```
.filter("take", function ($filter) {
	return function (data, skipCount, takeCount) {
		let skippedData = $filter("skip")(data, skipCount);
		return $filter("limitTo")(skippedData, takeCount);
	}
});
```

如上，首先在工厂函数中声明对 `$filter` 服务的依赖，如此便可以访问模块中所有已经定义的过滤器。

过滤器在工人函数中通过名称来访问和调用:

```
let skippedData = $filter("skip")(data, skipCount);
```

[清单6-7](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(6)%E4%BD%BF%E7%94%A8%E8%BF%87%E6%BB%A4%E5%99%A8/%E6%B8%85%E5%8D%956-7.html)

