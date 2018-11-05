# Subject(1)

## multicast 组播

`Observable` 是可以多次订阅的，而且各自的订阅之间是相互独立。但是，有时候我们并不希望每个订阅之间相互独立，而是当 `ObserverB` 订阅的时候可以接着 `ObserverA` 的进度。 **Subject** 就是干这件事情的。

先来看一个 `Subject` 的基本实现:

```js
let subject = {
     observers: [],
     subscribe: (observer) => subject.observers.push(observer),
     next:(value)=>subject.observers.forEach(o => o.next(value)),
     error:(error) => subject.observers.forEach((o => o.error(error))),
     complete:() => subject.observers.forEach(o => o.complete())
   }
```

`subject.subscribe` 的作用很明显，就是将新的 `observer` 添加到 `subject` 的缓存清单中。而同时，`subject` 继承了 `observer` 的所有方法:`next`,`error`,`complete`。

怎么用？

```js
let source = Observable.interval(1000).take(3);
let observerA = {
  next:value => console.log('A'+value),
  error:error => console.log(error),
  complete: () => console.log('completeA')
}

let observerB = {
  next:value => console.log('B'+value),
  error: error => console.log(error),
  complete: () => console.log('completeB')
}

source.subscribe(subject)

subject.subscribe(observerA)

setTimeout(() =>
  // 让 B 延迟两秒再订阅
  subject.subscribe(observerB),
2000)

// A0
// A1
// B1
// A2
// B2
// completeA
// completeB
```

如上，我们首先用 `subject` 订阅 `source`，并把 `observerA` 加入到 `subject` 内部的订阅清单中，两秒以后再把 `observerB` 加入到 `subject` 中去，这时可以看到 `observerB` 是从 `2` 开始的，这就是 **组播(multicast)**。

在 `Observable` 中使用 `subject`:

```js
import {Subject} from 'rxjs/Subject'
let subject = new Subject();
```

## 关于 Subject

`Subject` 可以拿出订阅 `Observable(source)` 代表它是一个 `Observer`，同时它也可以被 `Observer(observerA,observerB)` 订阅，代表它是一个 `Observable`。即:

* `Subject` 既是 `Observable` 也是 `Observe`。
* `Subject` 会对内部的 `observers` 清单进行组播。

> `Subject` 实际上是 `Observer Pattern` 的实例，它会在内部管理一份 `observers` 清单，并在接收到值的时候遍历这份清单并送出值。

## BehaviorSubject

有时，我们希望 `Subject` 能够代表的是当前的状态，即在一开始订阅的时候就知道的当前的状态是什么，而不是订阅后要等到有变动才能接收到最新的状态。

`BehaviorSubject` 就可以达到这样的效果，它与 `Subject` 最大的不同在于，`BehaviorSubject` 可以呈现当前的值，而不是单纯的发送事件。它会记住最新一次发送的元素，并把该元素当作目前的值。使用 `BehaviorSubject` 时需要传入一个参数来代表起始的状态。

```js
let subject = new BehaviorSubject(0);
/* ObserverB 可以获得最后的一次状态，即 2*/
// let subject = new Subject();
/*在 ObseverB 订阅以后没有任何动作，所以 ObserveB 不会有任何值输出*/
subject.subscribe(observerA);
subject.next(1)
subject.next(2)
setTimeout(() => subject.subscribe(observerB),4000)
```

## ReplaySubject

有时候，我们希望 `Subject` 即代表事件，但又能在新订阅的时候发送最后的几个元素，这时我们就可以使用 `ReplaySubject` 了。

```js
let subject = new ReplaySubject(2);// 重复发送最后两个元素
subject.subscribe(observerA);
subject.next(1)
subject.next(2)
subject.next(3)
setTimeout(() => subject.subscribe(observerB),4000)
// A1
// A2
// A3
// B1
// B2
```

`BehaviorSubject` 代表的是 **状态**,并且其在建立时就会有初始状态，而 `ReplaySubject` 只是事件的重放而已。

## AsyncSubject

`AsyncSubject` 很少用到，其行为类似于 `last` 操作符，会在 `Subject` 结束以后送出最有一个值。

```js
let subject = new AsyncSubject();
subject.subscribe(observerA);

subject.next(1)
subject.next(2)
subject.next(3)
subject.complete();
setTimeout(() => subject.subscribe(observerB),4000)
```

