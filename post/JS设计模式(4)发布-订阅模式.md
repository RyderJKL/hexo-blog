---
title: JS设计模式(4)发布-订阅模式
date: 2017-02-07
tags: ['JavaScript','JS设计模式']
toc: true
categories: technology

---

### 发布/订阅模式
观察者模式(Observer Pattern)：定义对象间的一种一对多依赖关系，使得每当一个对象状态发生改变时，其相关依赖对象皆得到通知并被自动更新。观察者模式又叫做发布-订阅（Publish/Subscribe）模式、模型-视图（Model/View）模式、源-监听器（Source/Listener）模式或从属者（Dependents）模式。。这是设计模式中最常用的一种模式了。最简单的JavaScript 中事件就是一种观察者模式。

观察者模式由主体(被观察者)和观察者两个对象组成。主体负责发布事件（这时可以认为主体是个生产者），同时观察者通过订阅这些事件来观察主体。

下面是一个发布订阅模式的一个通用实现。

---
### 发布订阅模式的通用实现

以 <<JavaScript 高级程序设计>> 中的自定义事件为例:


```
function EventTarget() {
      // EventTarget 其实就是发布者（主体），也可以理解为母体，因为是通用模式，她将构造出所有发布者

    this.handlers = {}
    // 存放订阅者的消息(回调函数)的缓存对象
    // handlers 用于存储事件处理程序的缓存对象
  }

  EventTarget.prototype = {
    constructor: EventTarget,
    addHandler: function (type,handler/*接收两个参数:自定的事件类型和事件处理程序*/) {
      if (typeof this.handlers[type] === 'undefined') {
          // 初次判断，是否存在该类型的消息
        this.handlers[type] = [];
        // 为每一种事件类型建立一个事件类型数组
      }
      this.handlers[type].push(handler)
      // 将订阅的消息存放进缓存列表
      // 将对应的事件处理函数推入到事件类型数组中
    },

    fire:function (event) {
      // 发布消息
      console.log(this)
      event.target || (event.target = this)
      // 为自定义事件构造 event 对象
      if (this.handlers[event.type] instanceof Array){
          // 如何消息池中没有消息，就什么都不干
        var handlers = this.handlers[event.type];
        // 获取要发布的消息类型
        for(var i = 0;i< handlers.length;i++){
          handlers[i](event);
          // 发布消息
        }
      }
    },
    removeHandler:function (type,handler) {
        // 取消订阅
      if(this.handlers[type] instanceof Array) {
        var i = this.handlers[type].indexOf(handler)
        if (i > -1) {
          this.handlers[type].splice(i,1)
        }

      }
    }
  }
```

```
subject = new EventTarget()
// 新建一个主体，即发布者，一个发布者可以对应多个订阅者

function message1(event) {
  console.log(event.message)
}
function message2(event) {
  console.log(event.message)
}

function message3(event) {
  event.message;
}

observable1 = subject.addHandler('sayHello', message1)
// 订阅者二 订阅 sayHello 种类的消息，消息的内容是 message1
observabler2 = subject.addHandler('sayWorld', message2)
  // 订阅者二 订阅 sayWorld 种类的消息，消息的内容是 message2
observabler3 = subject.addHandler('say', message3)
// 订阅者三 订阅 say 种类的消息，消息的内容是 message3

/*先订阅消息，才能发布消息*/

subject.fire({
      /*fire 的参数就是 event 对象，
      通过在 fire 内部对 event 对象的改造，
      使得 event 对象最少具有 target 和 type 属性。
      然后将 event 对象传递给订阅者，即是要发布的消息
      */
      // 发布 message 消息
      type:'sayHello',
      message: 'hello'
  })

  subject.fire({
      // 发布 message2 消息
      type: 'sayWorld',
      message: 'world'
  })

  subject.removeHandler('say',message3)
  // 取消订阅 消息3
```

总结下,实现一个通用类型的发布/订阅模式需要注意的几个点:

