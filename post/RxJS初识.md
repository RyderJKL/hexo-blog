# RxJS

可以把`RxJS`想象成为非同步的`Loadsh`。

`RxJS`是基于观察者模式和迭代器模式以函数式编程思维来实现的，`RxJS`可以很好的解决**异步和事件组合**的问题。

它的两个核心的基本概念: `Oberservable`和`Observer`，`Observable`作为被观察者，是一组值或者事件的流的集合。 而`Obsever`作为观察者，根据`Observable`进行处理，它们关系如下:

* 订阅: `Observer` 通过`Observable`的`Subcribe`方法订阅`Observable`.
* 发布: `Observable` 通过回调`next`方法向`Observer`发布事件。

## 创建 Observable

在`RxJS`中，我们可以通过多种方式来创建一个`Observable`对象：

* create
* of
* from
* fromEvent
* fromPromise
* never
* empty
* throw
* interval
* timer

下面通过`Observable.create()`方法来创建`Observable`:

```js
let observable = Observable.create(function (observer) {
  // 创建 Observable 对象
      observer.next('jack')
      // 通过 next() 方法向 Observer 中发布数据
      observer.next('mark')
    })

observable.subscribe((value) => console.log(value))
// 订阅 Observerable
// jack
// mark
```

## 创建 Observer

观察者是一个包含三个方法的对象，每当`Observable`出发事件时，便会自动调用观察者对应的方法。

`Observer`的接口定义:

```js
interface observer<T>{
   // 标志是否已经取消对 Observable 对象的订阅
  closed?: boolean;
  //每当 Observable 发送新值的时候，next 方法会被调用
  next:(value T) => void;
  //当 Observable 内发生错误时，error 方法就会被调用
  error:(err:any)  => void;
  // 当 Observable 数据终止后，complete 方法会被调用。在调用 complete 方法之后，next 方法就不会再次被调用
  complete:() => void;
}
```

```js
// 创建被观察者
let observable$ = Observable.create((observe) => {
  observe.next('Jack')
  observe.next('mark')
  observe.complete();
  observe.next('haha')
})

// 创建观察者
let observe = {
  next: (value) => console.log(value),
  error: (error) => console.log(error),
  complete: () => console.log('done')
}

observable$.subscribe(observe)
```

## Subscription

Subscription 用来取消定义的资源。有些时候对于一些 Observable 对象 (如通过 interval、timer 操作符创建的对象)，当我们不需要的时候，要释放相关的资源，以避免资源浪费。

```js
let source$ = Observable.timer(1000,1000);
    let subscription = source$.subscribe((value) => console.log(value))
    setTimeout(() => subscription.unsubscribe(),10000)
```

## pull VS push

`pull` 和 `push` 是生产者/消费者之间数据传输的两种不同的体系。

### pull

`pull` 体系中，消费者决定何时从数据生产者那里获取数据。而生产者本身并不知道数据什么时候会发送个消费者。

JavaScript 中在函数就是一个 `pull` 的体系，函数是数据的生产者，负责产生数据(`return 一个返回值`)，然后当调用该函数的时候,消费其所返回的值。

![pull VS push](https://res.cloudinary.com/dohtkyi84/image/upload/v1482240798/push_pull.png)

如上图所示，调用 `iterator.next()` 的 `x` 是消费者，在 `pull` 体系中。

### push

在 `push` 体系中，数据的生产者决定何时将数据发送给消费者，消费者不会在接收数据之前意识到它将要接收这个数据。

而 JavaScript 的 **事件系统** 就是一个 `push` 体系，比如我们通过 `addEventListener` 去监听 `body` 的 `click` 事件，当 `click` 被触发的时候便会便会将数据 `event` 对象传递给消费者，即是 `addEventListener` 中的处理函数。

## Observable VS Promise

当然还有 `Promise`，他算是 JavaScript 中最常见的 `push` 体系了。一个 `Promise` (数据的生产者)发送一个 `resolved value` (成功状态的值)来执行一个回调(数据消费者)，但是不同于函数的地方的是：`Promise` 决定着何时数据才被推送至这个回调函数。

而 Rx 中的 `Observable`（被观察对象） 是一个全新的 `push` 体系，** Observable 是基于 推送（Push）运行时执行（lazy）的多值集合。**.

