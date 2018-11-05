---
title: AngularJS(4)表单
date: 2017-01-21
tags: ['AngularJS']
toc: true
categories: technology

---
### 0x00 双向数据绑定
[本章初始清单4-1](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-1.html)

我们除了在控制器显示的定义属性以外，还能通过双向数据绑定隐式的在数据模型中创建属性。而这对于需要使用表单元素收集用户输入数据从而在模型中创建新的属性或对象时非常有用。
 
```
$scope.addNewItem = function (newItem) {
    $scope.todos.push({
        action: newItem.action + "(" + newItem.location + ")",
        complete: false
    })
}
```

```
<input type="text" ng-model="newTodo.action" id="actionText" class="form-control">
<select name="" ng-model="newTodo.location" id="actionLocation" class="form-control">
<button class="btn btn-primary btn-block" ng-click="addNewItem(newTodo)">Add</button>
```

如上，我们使用 `mg-model` 指令，用于更新未曾显示定义的模型属性值: `newTodo.action` 和 `newTodo.location`,然后通过为 `button` 添加 `ng-click` 事件调用 `addNewItem()` 传入用户通过表单输入的两个参数然后在控制器中将其推入代办事项数组中。

> 也可以直接访问 `$scope.newTodo` 对象进行操作，而不用采取参数传递的方式。

AngularJS 这种隐式定义使得处理数据变得简洁易用，但有一个普遍的问题是，我们很有可能会去访问一些没有定义的对象或属性，这时会导致错误异常，所以，有必要在访问之前对所使用的对象或属性进行检查:

```
$scope.addNewItem = function (newItem) {
    if (angular.isDefined(newItem) && angular.isDefined(newItem.action) && angular.isDefined(newItem)) {
        $scope.todos.push({
            action: newItem.action + "(" + newItem.location + ")",
            complete: false
        })
    }
}
```

[清单4-2](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-2.html)

---
### 0x01 表单校验

AngularJS 对表单的支持主要是基于标准的 HTML 元素进行替换，当 AngularJS 遇到表单元素时指令会自动将 AngularJS 的特性和表单元素结合在一起，并且还提供了一些额外的功能用于增强开发体验。

为了获得 AngularJS 最佳的校验效果，必需为表单元素设置 `name` 属性,因为这样，就可以通过对应的 `name` 表单元素访问 AngularJS 所提供的给种特性变量,而通过这些变量可以检测当个元素或者整个表单的有效性:

* `$pristine`: 用户没有与元素/表单产生交互，返回 `true`;
* `$dirty`: 用户与元素/表单产生交互，返回 `true`;
* `$valid`: 当元素/表单内容的校验结果有效时返回 `true`;
* `$invalid`: 当元素/表单内容的校验结果无效时返回 `true`;
* `$error:` 提供校验错误的信息。


```
<form name="myForm" novalidate ng-submit="addUser(newUser)">
<button type="submit" ng-disabled="myForm.$invalid">Ok</button>
</form>
```

如上，可以通过 `name` 属性访问 `myForm` 元素的 `$invalid` 变量以校验表单的有效性。

但，不止于此，AngularJS 还提供了一个类集合以结合 CSS 来对用户进行反馈以告知其输入的有效性。

 以下是 AngularJS 校验中的四种类:

* `ng-pristine`: 未曾交互过的元素添加到该类；
* `ng-dirty`: 交互过的元素添加到该类；
* `ng-valid`: 校验结果有效的添加到该类；
*  `ng-invalid`: 校验结果无效的添加到该类。

```
form .ng-invalid.ng-dirty{ background-color:lightpink;}
/*交互过，无效类*/
form .ng-valid.ng-dirty { background-color: lightgreen;}
/*交互过，有效类*/
span.summary.ng-invalid { color: red; font-weight: bold;}
/*表单无效提醒*/
span.summary.ng-valid { color: green;}
/*表单有效提醒*/
```

我们也可以对特定的校验约束提供反馈信息，即 AngularJS 也会将元素添加到类中以给出关于应用到的该元素的每一个校验约束的具体信息，而所使用的类名正是基于相应的元素的:

```
form .ng-invalid-required.ng-dirty { background-color: lightpink;}
/* required 无效时样式*/
form .ng-invalid-email.ng-dirty { background-color: lightgoldenrodyellow;}
/* input email 元素无效时样式 */
```

最后，使用特性变量结合 `ng-show` 指令给出反馈信息:

```
<style>
     div.error{ color: red; font-weight: bold;}
</style>
<div class="form-group">
    <label for="">Email:</label>
    <input type="email" name="userEmail" required ng-model="newUser.email" class="form-control">
    <div class="error" ng-show="myForm.userEmail.$invalid && myForm.userEmail.$dirty">
        <span ng-show="myForm.userEmail.$error.email">
            Please enter a valid email address.
        </span>
        <span ng-show="myForm.userEmail.$error.required">
            Please enter a value.
        </span>
    </div>
</div>
```

[清单4-3](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-3.html)

但若，表单中存在多个表单元素需要验证，这样写未免太过冗余，我们可以进一步，将返回的错误信息使用控制器来处理，修改如下:

```
$scope.getError = function (error) {
    if (angular.isDefined(error)) {
        if (error.required){
            return "Please enter a value";
        } else if (error.email){
            return "Please enter a valid email address";
        }
    }
}

<div class="error" ng-show="myForm.userEmail.$invalid && myForm.userEmail.$dirty">
    <!-- 注意此处是如何引用 input 元素以访问特性校验变量的-->
    {{getError(myForm.userEmail.$error)}}
</div>
```

[清单4-4](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-4.html)

---
### 0x02 使用表单指令属性
AngularJS 使用的指令对 `input` 元素提供了额外的属性，以更好的实现对数据模型的集成。但这些属性仅适用于在 `input` 元素没有使用 `type` 属性或者 `type` 属性为 `text`,`url`,`email`,`number` 时适用。

```
<form name="myForm" novalidate>
<div class="well">
    <div class="form-group">
        <label>Text:</label>
        <input name="sample" class="form-control" ng-model="inputValue"
        ng-required="requireValue" ng-minlength="3"
        ng-maxlength="10" ng-pattern="mathPattern">
    </div>
</div>
<div class="well">
    <p>Required Error: {{myForm.sample.$error.required}}</p>
    <p>Min Length Error: {{myForm.sample.$error.minlength}}</p>
    <p>Max Length Error:　{{myForm.sample.$error.maxlength}}</p>
    <p>Pattern Error: {{myForm.sample.$error.pattern}}</p>
    <p>Element Valid: {{myForm.sample.$valid}}</p>
</div>
</form>
```

适用于 `input` 元素的指令:

* `ng-model`: 双向数据绑定；
* `ng-change`: 用于指定一表达式，该表达式在元素内容被改变时被计算；
* `ng-minlength`: 设置元素所需的最小字符数；
* `ng-maxlength`: 设置元素所需的最大字符数；
* `ng-pattern`: 设置一个正则表达式；
* `ng-required`: 通过数据绑定设置 `required` 属性值。

[清单4-5](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-5.html)

当 `type` 属性为 `checkbox` 时适用于 `input` 元素的属性:

* `ng-model`: 双向数据绑定；
* `ng-chage`: 指定一个表达式，当元素的内容发生改变时，计算表达式的值；
* `ng-true-value`: 被勾选时所绑定的表达式的值；
* `ng-false-value`: 取消勾选时所绑定的表达式的值。

[清单4-6](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-6.html)


##### 使用文本区

[清单4-7](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-7.html)

##### 使用选择列表

使用 `ng-options` 指令和使用 `ng-repeat` 指令是类似的，但会额外有一些专属于 `selecte` 元素的额外方法。

###### 改变第一个选项元素
AngularJS 会在 `ng-model` 指令所指定的变量值为 `undefined` 时生成一个值是问号并且没有任何内容的元素。

于是可以通过添加一个空值的 `option` 元素来替代默认的 `option` 元素。

[清单4-8](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-8.html)


###### 改变选项值
有时并不希望使用整个元数据对象来设置 `ng-model` 的值，那么此时可以使用一个表达式来为 `ng-options` 属性指定对象中的一个属性。

[清单4-9](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-9.html)

###### 创建选项组元素
`ng-options` 属性可以按照某个属性值将各个选项进行分组，为每个选项值生成一组 `optgroup` 元素。

[清单1-10](https://github.com/onejustone/SimpleAngularDemo/blob/master/src/AngularJS(4)%E8%A1%A8%E5%8D%95/%E6%B8%85%E5%8D%954-10.html)

