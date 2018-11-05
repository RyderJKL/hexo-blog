
# Operators(7)

## Subject

`subject`的一个作用是当有新的订阅的产生的时候，可以延续上一个订阅的结果，而不从头开始订阅。

```js
const subject = new Subject
const source$ = Observable.interval(1000).take(6)

source$.subscribe(subject)

const observableA = {
  next(value) {
    console.log('A:', value)
  },
  error (e) {

  },
  complete () {
    console.log('complete A')
  }
}


const observableB = {
  next(value) {
    console.log('B:', value)
  },
  error (e) {

  },
  complete () {
    console.log('complete B')
  }
}

subject.subscribe(observableA)

setTimeout(() => {
  subject.subscribe(observableB)
}, 2000)
// 输出
A: 1
A: 2
B: 2
A: 3
B: 3
A: 4
B: 4
A: 5
B: 5
complete A
complete B
```

## multicast

`multicast` 可以用来挂载 `Subject` 并返回一个可连接的 `Observable`。

```js
const subject = new Subject
const source$ = Observable.interval(1000).take(6)
  .multicast(new Subject())

source$.connect()

const observableA = {
  next(value) {
    console.log('A:', value)
  },
  error (e) {

  },
  complete () {
    console.log('complete A')
  }
}


const observableB = {
  next(value) {
    console.log('B:', value)
  },
  error (e) {

  },
  complete () {
    console.log('complete B')
  }
}

source$.subscribe(observableA)

setTimeout(() => {
  source$.subscribe(observableB)
}, 2000)

// 输出 同上
```

使用 `multicast` 可以简化多个`obsevser` 对 `subject` 依次订阅的操作，不过必须和`connet`一起使用，这时可以使用`refCount` 简化 `connet`操作。

## refCount

`refCount`同样必须和`multicast`一起使用，他可以建立一个只要订阅就自动`connect`的`observale`。

```js
const subject = new Subject
const source$ = Observable.interval(1000)
  .multicast(new Subject())
  .refCount()

const observableA = {
  next(value) {
    console.log('A:', value)
  },
  error (e) {

  },
  complete () {
    console.log('complete A')
  }
}


const observableB = {
  next(value) {
    console.log('B:', value)
  },
  error (e) {

  },
  complete () {
    console.log('complete B')
  }
}

const subscriptionA = source$.subscribe(observableA)
let subscriptionB = ''

setTimeout(() => {
  subscriptionB = source$.subscribe(observableB)
}, 2000)

setTimeout(() => {
  // 手动取消订阅
  subscriptionA.unsubscribe()
  subscriptionB.unsubscribe()
}, 5000)
```

## publish

`multicast(new Subject())`可以简写成`publish`。

```js
const source$ = Observable.interval(1000)
  .multicast(new Subject())
  .refCount()

// 等价于：
const source$ = Observable.interval(1000)
  .publish()
  .refCount()
```

加上 Subject 的三种变形：

```js
const source$ = Observable.interval(1000)
  .multicast(new ReplaySubject(1))
  .refCount()

// 等价于：
const source$ = Observable.interval(1000)
  .publishReplay(1)
  .refCount()
```

```js
const source$ = Observable.interval(1000)
  .multicast(new BehaviorSubject(0))
  .refCount()

// 等价于：
const source$ = Observable.interval(1000)
  .publishBehavior(0)
  .refCount()
```

```js
const source$ = Observable.interval(1000)
  .multicast(new AsyncSubject(1))
  .refCount()

// 等价于：
const source$ = Observable.interval(1000)
  .publishLast(0)
  .refCount()
```

## share

最后的最后，`publish` 和 `refCount` 可以简化为 `share`。

```js
const source$ = Observable.interval(1000)
  .multicast(new Subject())
  .refCount() // 自动 connect

// 等价于：
const source$ = Observable.interval(1000)
  .publish()
  .refCount()

// 等价于
const source$ = Observable.interval(1000).share()
```

## 最终 demo

```js
const source$ = Observable.interval(1000).take(6).share()
// 返回一个新的 Observable，该 Observable 多播(共享)源 Observable。

const observableA = {
  next(value) {
    console.log('A:', value)
  },
  error (e) {

  },
  complete () {
    console.log('complete A')
  }
}


const observableB = {
  next(value) {
    console.log('B:', value)
  },
  error (e) {

  },
  complete () {
    console.log('complete B')
  }
}

const subscriptionA = source$.subscribe(observableA)
let subscriptionB = ''

setTimeout(() => {
  subscriptionB = source$.subscribe(observableB)
}, 2000)

setTimeout(() => {
  // 手动取消订阅
  subscriptionA.unsubscribe()
  subscriptionB.unsubscribe()
}, 10000)
```

## 在 vue 中一个例子

```js
<template lang="pug">
  .section
    .title Operators-7 share
    .section
      p.title subject
</template>

<script>
import { Observable, Subject } from 'rxjs'

export default {
  name: 'Operators7',

  subscriptions () {
    const source$ = Observable.timer(1000)
    const example$ = source$
      .do(v => console.log('***SIDE EFFECT***'))
      .mapTo('***RESULT***')
      .share() // 共享的话副作用只执行一次
      // .share() // 不共享副作用执行两次

    const observableA$ = example$
    const observableB$ = example$

    return {
      observableA$,
      observableB$
    }
  }
}
</script>
```

