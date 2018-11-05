---
title: JS设计模式(2)策略模式  
date: 2017-02-06      
tags: ['JavaScript','JS设计模式']
toc: true
categories: technology

---
### 0x00 策略模式



**策略模式** 的定义是: _定义一系列算法，把他们一个个封装起来，并且使他们可以相互替换_

---
### 0x01 策略模式实现缓动动画

策略模式的一个经典运用场景就是缓动动画。

其核心思想是使用策略模式把算法传入动画类库中，来达到给种不同的缓动效果，而这些算法可以轻易的被另一个算法替代。

```
let tween = {
// 动画类库，用于封装缓动算法
//    	t:动画已经消耗的时间
//        b:小球的原始位置
//        c:小球目标位置
//        d:动画持续的总时间
    linear: function (t, b, c, d) {
        return c * t / d + b;
    },
    easeIn: function (t, b, c, d) {
        return c * (t /= d) * t + b;
    },
    strongEaseIn: function (t, b, c, d) {
        return c * (t /= d) * t * t * t * t + b;
    }
};
```

[完整代码:策略模式-缓动动画]()


---
### 0x02 策略模式实现表单验证

其实，仅仅把策略模式用于封装算法有点大材小用，实际开发中，通常会把算法的含义扩散开来，使策略模式可以用来封装一系列的 **业务规则**。

在一个 Web 项目中，表单验证往往是在所难免的，当需要验证的字段很少的时候，比如几条，十几条，没问题，我们完全可以重复的使用 `if...else` 去验证表单字段，但如一个表单中的字段多大几十个，甚至上百个时，考虑到代码的可复用性和后期的可以维护性，便十分有必要使用一些模式去组织我们的代码了。 比如，策略模式。


使用策略模式编写表单校验代码的第一步就是将校验逻辑都封装成为策略对象:

```
let strategies = {
    //	策略对象，封装验证表单的规则
    isNotEmpty: function (value, errorMsg) {
        if (value == '') {
            return errorMsg;
        }
    },

    minLength: function (value, length, errorMsg) {
        if (value.length < length) {
            return errorMsg;
        }
    },

    legalPhone: function (value, errorMsg) {
        let regPhone = /^1[345678]\d{9}$/g;
        if (!regPhone.test(value)) {
            return errorMsg;
        }
    },

    legalEmail: function (value, errorMsg) {
        let regEmail = /^\w{1,18}@([a-z][0-9]){2,7}.[a-z]{2,4}$/i;
        if (!regEmail.test(value)) {
            return errorMsg;
        }
    }

};
```

然后，我们会创建 `Validate` 类，它的作用是作为 `Context`，负者接收用户的输入并将用户输入的内容委托给 `strategy` 对象。

```
let validateFunc = function () {
//		validateFunc 执行表单验证函数
//        添加验证规则
    let validator = new Validate();
    // 创建一个 Validate 类，作用是作为 `Context`，负者接收用户的输入并将用户输入的内容委托给 `strategy` 对象。
    validator.add(regForm.userName, [
        {
            strategy: "isNotEmpty",
            errorMsg: "用户名不能为空",
        }, {
            strategy: "minLength:6",
            errorMsg: "密码长度不能小于六位"
        }]);
    validator.add(regForm.userPassword, [{
        strategy: "minLength:6",
        errorMsg: "密码长度不能小于六位"
    }]);
    validator.add(regForm.phoneNumber, [{
        strategy: "legalPhone",
        errorMsg: "手机号格式不正确"
    }]);
    validator.add(regForm.userEmail, [{
        strategy: "legalEmail",
        errorMsg: "邮箱格式不正确"
    }]);

    return validator.start();
    // 返回校验结果
};
```

如上，`validate`  类的 `add` 方法用于向我们的 `strategy` 的对象添加校验规则，它接收两参数:参与校验的 `input` 输入框以及一个数组，数组中存放的是验证的策略规则和验证失败返回的提示信息。

下面是 `validate` 对象的具体实现:

```
let Validate = function () {
    //  验证表单的类
    // Validate 类作为 Context，负者接收用户的请求并委托给 strategies 对象
    this.cache = [];
//        保存验证规则的数组
};

Validate.prototype = {
    constructor: Validate,
    add: function (dom, rules) {
        //        规则关联，将规则与对应的元素进行绑定，并返回验证结果

        let self = this;
        for (let i =0, rule; rule = rules[i++];){
            (function (rule) {
                let strategyArr = rule.strategy.split(":");
                // 参数解析
                let errorMsg = rule.errorMsg;
                // 获取错误信息
                self.cache.push(function() {
                    // 推入策略规则
                    let strategy = strategyArr.shift();
                    // 首先截取策略名称
                    strategyArr.unshift(dom.value);
                    // 添加 dom 的内容
                    strategyArr.push(errorMsg);
                    // 推入错误信息
                    return strategies[strategy].apply(dom, strategyArr);
                    // 信息策略，并返回校验结果
                });
            })(rule);
        }
    },

    start: function () {
        for (let i = 0, validaterFunc; validaterFunc = this.cache[i++];) {
            let msg = validaterFunc();
            // 开始校验，并取得校验后的返回信息
            if (msg) {
                // 如若有返回值，说明校验不成功
                return msg;
            }
        }

    },
};
```

当我们往 `validate` 对象添加完校验规则以后，便调用 `validate.start` 方法来启动校验，该方法返回的 `errorMsg` 字符串代表校验没有通过，那么便需要调用 `regForm.onsubmit` 方法返回 `false` 阻止表单的提交。

```
    regForm.onsubmit = function () {
        let errorMsg = validateFunc();
        // 若，validateFunc 没有任何值返回，则代表校验通过
        if (errorMsg) {
            alert(errorMsg);
            return false;
//          阻止表单提交
        }
    }
```

[ 策略模式实现表单验证](---
title: JS设计模式(2)策略模式  
date: 2017-02-06      
tags: ['JavaScript','JS设计模式']
toc: true
categories: technology

---
### 0x00 策略模式



**策略模式** 的定义是: _定义一系列算法，把他们一个个封装起来，并且使他们可以相互替换_

---
### 0x01 策略模式实现缓动动画

策略模式的一个经典运用场景就是缓动动画。

其核心思想是使用策略模式把算法传入动画类库中，来达到给种不同的缓动效果，而这些算法可以轻易的被另一个算法替代。

```
let tween = {
// 动画类库，用于封装缓动算法
//    	t:动画已经消耗的时间
//        b:小球的原始位置
//        c:小球目标位置
//        d:动画持续的总时间
    linear: function (t, b, c, d) {
        return c * t / d + b;
    },
    easeIn: function (t, b, c, d) {
        return c * (t /= d) * t + b;
    },
    strongEaseIn: function (t, b, c, d) {
        return c * (t /= d) * t * t * t * t + b;
    }
};
```

[完整代码:策略模式-缓动动画]()


---
### 0x02 策略模式实现表单验证

其实，仅仅把策略模式用于封装算法有点大材小用，实际开发中，通常会把算法的含义扩散开来，使策略模式可以用来封装一系列的 **业务规则**。

在一个 Web 项目中，表单验证往往是在所难免的，当需要验证的字段很少的时候，比如几条，十几条，没问题，我们完全可以重复的使用 `if...else` 去验证表单字段，但如一个表单中的字段多大几十个，甚至上百个时，考虑到代码的可复用性和后期的可以维护性，便十分有必要使用一些模式去组织我们的代码了。 比如，策略模式。


使用策略模式编写表单校验代码的第一步就是将校验逻辑都封装成为策略对象:

```
let strategies = {
    //	策略对象，封装验证表单的规则
    isNotEmpty: function (value, errorMsg) {
        if (value == '') {
            return errorMsg;
        }
    },

    minLength: function (value, length, errorMsg) {
        if (value.length < length) {
            return errorMsg;
        }
    },

    legalPhone: function (value, errorMsg) {
        let regPhone = /^1[345678]\d{9}$/g;
        if (!regPhone.test(value)) {
            return errorMsg;
        }
    },

    legalEmail: function (value, errorMsg) {
        let regEmail = /^\w{1,18}@([a-z][0-9]){2,7}.[a-z]{2,4}$/i;
        if (!regEmail.test(value)) {
            return errorMsg;
        }
    }

};
```

然后，我们会创建 `Validate` 类，它的作用是作为 `Context`，负者接收用户的输入并将用户输入的内容委托给 `strategy` 对象。

```
let validateFunc = function () {
//		validateFunc 执行表单验证函数
//        添加验证规则
    let validator = new Validate();
    // 创建一个 Validate 类，作用是作为 `Context`，负者接收用户的输入并将用户输入的内容委托给 `strategy` 对象。
    validator.add(regForm.userName, [
        {
            strategy: "isNotEmpty",
            errorMsg: "用户名不能为空",
        }, {
            strategy: "minLength:6",
            errorMsg: "密码长度不能小于六位"
        }]);
    validator.add(regForm.userPassword, [{
        strategy: "minLength:6",
        errorMsg: "密码长度不能小于六位"
    }]);
    validator.add(regForm.phoneNumber, [{
        strategy: "legalPhone",
        errorMsg: "手机号格式不正确"
    }]);
    validator.add(regForm.userEmail, [{
        strategy: "legalEmail",
        errorMsg: "邮箱格式不正确"
    }]);

    return validator.start();
    // 返回校验结果
};
```

如上，`validate`  类的 `add` 方法用于向我们的 `strategy` 的对象添加校验规则，它接收两参数:参与校验的 `input` 输入框以及一个数组，数组中存放的是验证的策略规则和验证失败返回的提示信息。

下面是 `validate` 对象的具体实现:

```
let Validate = function () {
    //  验证表单的类
    // Validate 类作为 Context，负者接收用户的请求并委托给 strategies 对象
    this.cache = [];
//        保存验证规则的数组
};

Validate.prototype = {
    constructor: Validate,
    add: function (dom, rules) {
        //        规则关联，将规则与对应的元素进行绑定，并返回验证结果

        let self = this;
        for (let i =0, rule; rule = rules[i++];){
            (function (rule) {
                let strategyArr = rule.strategy.split(":");
                // 参数解析
                let errorMsg = rule.errorMsg;
                // 获取错误信息
                self.cache.push(function() {
                    // 推入策略规则
                    let strategy = strategyArr.shift();
                    // 首先截取策略名称
                    strategyArr.unshift(dom.value);
                    // 添加 dom 的内容
                    strategyArr.push(errorMsg);
                    // 推入错误信息
                    return strategies[strategy].apply(dom, strategyArr);
                    // 信息策略，并返回校验结果
                });
            })(rule);
        }
    },

    start: function () {
        for (let i = 0, validaterFunc; validaterFunc = this.cache[i++];) {
            let msg = validaterFunc();
            // 开始校验，并取得校验后的返回信息
            if (msg) {
                // 如若有返回值，说明校验不成功
                return msg;
            }
        }

    },
};
```

当我们往 `validate` 对象添加完校验规则以后，便调用 `validate.start` 方法来启动校验，该方法返回的 `errorMsg` 字符串代表校验没有通过，那么便需要调用 `regForm.onsubmit` 方法返回 `false` 阻止表单的提交。

```
    regForm.onsubmit = function () {
        let errorMsg = validateFunc();
        // 若，validateFunc 没有任何值返回，则代表校验通过
        if (errorMsg) {
            alert(errorMsg);
            return false;
//          阻止表单提交
        }
    }
```

[ 策略模式实现表单验证](---
title: JS设计模式(2)策略模式  
date: 2017-02-06      
tags: ['JavaScript','JS设计模式']
toc: true
categories: technology

---
### 0x00 策略模式



**策略模式** 的定义是: _定义一系列算法，把他们一个个封装起来，并且使他们可以相互替换_

---
### 0x01 策略模式实现缓动动画

策略模式的一个经典运用场景就是缓动动画。

其核心思想是使用策略模式把算法传入动画类库中，来达到给种不同的缓动效果，而这些算法可以轻易的被另一个算法替代。

```
let tween = {
// 动画类库，用于封装缓动算法
//    	t:动画已经消耗的时间
//        b:小球的原始位置
//        c:小球目标位置
//        d:动画持续的总时间
    linear: function (t, b, c, d) {
        return c * t / d + b;
    },
    easeIn: function (t, b, c, d) {
        return c * (t /= d) * t + b;
    },
    strongEaseIn: function (t, b, c, d) {
        return c * (t /= d) * t * t * t * t + b;
    }
};
```

[完整代码:策略模式-缓动动画](https://github.com/onejustone/JavaScriptDesignModel/blob/master/%E7%AD%96%E7%95%A5%E6%A8%A1%E5%BC%8F-%E7%BC%93%E5%8A%A8%E5%8A%A8%E7%94%BB.html)


---
### 0x02 策略模式实现表单验证

其实，仅仅把策略模式用于封装算法有点大材小用，实际开发中，通常会把算法的含义扩散开来，使策略模式可以用来封装一系列的 **业务规则**。

在一个 Web 项目中，表单验证往往是在所难免的，当需要验证的字段很少的时候，比如几条，十几条，没问题，我们完全可以重复的使用 `if...else` 去验证表单字段，但如一个表单中的字段多大几十个，甚至上百个时，考虑到代码的可复用性和后期的可以维护性，便十分有必要使用一些模式去组织我们的代码了。 比如，策略模式。


使用策略模式编写表单校验代码的第一步就是将校验逻辑都封装成为策略对象:

```
let strategies = {
    //	策略对象，封装验证表单的规则
    isNotEmpty: function (value, errorMsg) {
        if (value == '') {
            return errorMsg;
        }
    },

    minLength: function (value, length, errorMsg) {
        if (value.length < length) {
            return errorMsg;
        }
    },

    legalPhone: function (value, errorMsg) {
        let regPhone = /^1[345678]\d{9}$/g;
        if (!regPhone.test(value)) {
            return errorMsg;
        }
    },

    legalEmail: function (value, errorMsg) {
        let regEmail = /^\w{1,18}@([a-z][0-9]){2,7}.[a-z]{2,4}$/i;
        if (!regEmail.test(value)) {
            return errorMsg;
        }
    }

};
```

然后，我们会创建 `Validate` 类，它的作用是作为 `Context`，负者接收用户的输入并将用户输入的内容委托给 `strategy` 对象。

```
let validateFunc = function () {
//		validateFunc 执行表单验证函数
//        添加验证规则
    let validator = new Validate();
    // 创建一个 Validate 类，作用是作为 `Context`，负者接收用户的输入并将用户输入的内容委托给 `strategy` 对象。
    validator.add(regForm.userName, [
        {
            strategy: "isNotEmpty",
            errorMsg: "用户名不能为空",
        }, {
            strategy: "minLength:6",
            errorMsg: "密码长度不能小于六位"
        }]);
    validator.add(regForm.userPassword, [{
        strategy: "minLength:6",
        errorMsg: "密码长度不能小于六位"
    }]);
    validator.add(regForm.phoneNumber, [{
        strategy: "legalPhone",
        errorMsg: "手机号格式不正确"
    }]);
    validator.add(regForm.userEmail, [{
        strategy: "legalEmail",
        errorMsg: "邮箱格式不正确"
    }]);

    return validator.start();
    // 返回校验结果
};
```

如上，`validate`  类的 `add` 方法用于向我们的 `strategy` 的对象添加校验规则，它接收两参数:参与校验的 `input` 输入框以及一个数组，数组中存放的是验证的策略规则和验证失败返回的提示信息。

下面是 `validate` 对象的具体实现:

```
let Validate = function () {
    //  验证表单的类
    // Validate 类作为 Context，负者接收用户的请求并委托给 strategies 对象
    this.cache = [];
//        保存验证规则的数组
};

Validate.prototype = {
    constructor: Validate,
    add: function (dom, rules) {
        //        规则关联，将规则与对应的元素进行绑定，并返回验证结果

        let self = this;
        for (let i =0, rule; rule = rules[i++];){
            (function (rule) {
                let strategyArr = rule.strategy.split(":");
                // 参数解析
                let errorMsg = rule.errorMsg;
                // 获取错误信息
                self.cache.push(function() {
                    // 推入策略规则
                    let strategy = strategyArr.shift();
                    // 首先截取策略名称
                    strategyArr.unshift(dom.value);
                    // 添加 dom 的内容
                    strategyArr.push(errorMsg);
                    // 推入错误信息
                    return strategies[strategy].apply(dom, strategyArr);
                    // 信息策略，并返回校验结果
                });
            })(rule);
        }
    },

    start: function () {
        for (let i = 0, validaterFunc; validaterFunc = this.cache[i++];) {
            let msg = validaterFunc();
            // 开始校验，并取得校验后的返回信息
            if (msg) {
                // 如若有返回值，说明校验不成功
                return msg;
            }
        }

    },
};
```

当我们往 `validate` 对象添加完校验规则以后，便调用 `validate.start` 方法来启动校验，该方法返回的 `errorMsg` 字符串代表校验没有通过，那么便需要调用 `regForm.onsubmit` 方法返回 `false` 阻止表单的提交。

```
    regForm.onsubmit = function () {
        let errorMsg = validateFunc();
        // 若，validateFunc 没有任何值返回，则代表校验通过
        if (errorMsg) {
            alert(errorMsg);
            return false;
//          阻止表单提交
        }
    }
```

[ 策略模式实现表单验证](https://github.com/onejustone/JavaScriptDesignModel/blob/master/%E7%AD%96%E7%95%A5%E6%A8%A1%E5%BC%8F-%E8%A1%A8%E5%8D%95%E9%AA%8C%E8%AF%81.html)

