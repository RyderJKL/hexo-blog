# Operators(6)

## concatAll

`switch`,`mergeAll`,`concatAll` 都是用来处理 `height Order Observable`的。

`concatAll` 的特性是只有当前一个 `Observable` 处理完成以后才会处理后面的。
`switch` 的特性是永远只处理最新的 `Observable`,而不管旧的 `Observable` 是否完成,如果旧的 `Observable` 未完成则直接退订`unsubscribe`。
`mergeAll` 与 `merge` 是一样的，不过 `mergeAll` 会把二维的 `Observable` 拍扁以后再进行合并。

## switch

```js
let demo = document.querySelector('.demo')
let click = Observable.fromEvent<KeyboardEvent>(demo,'click')
let source = click.map((ev:any)=>Observable.interval(300).take(3))
let example = source.switch();
example.subscribe((value)=>console.log(value));
```

Marble Diagram 如下:

```bash
click  : ---------c-c------------------c--..
        map(e => Rx.Observable.interval(1000))
source : ---------o-o------------------o--..
                   \ \                  \----0----1--...
                    \ ----0----1----2----3----4--...
                     ----0----1----2----3----4--...
                     switch()
example: -----------------0----1----2--------0----1--...
```

```js
let demo = document.querySelector('.demo')
let click = Observable.fromEvent<KeyboardEvent>(demo,'click')
let source = click.map((ev:any)=>Observable.interval(300).take(3))
let example = source.concatAll();
example.subscribe((value)=>console.log(value));
```

Marble Diagram:

```bash
click  : ---------c-c------------------c--..
        map(e => Rx.Observable.interval(1000))
source : ---------o-o------------------o--..
                   \ \                  \
                    \ ----0----1----2|   ----0----1----2|
                     ----0----1----2|
                     concatAll()
example: ----------------0----1----2----0----1----2--..
```

## mergeAll

```js
let demo = document.querySelector('.demo')
let click = Observable.fromEvent<KeyboardEvent>(demo,'click')
let source = click.map((ev:any)=>Observable.interval(300).take(3))
let example = source.concatAll();
example.subscribe((value)=>console.log(value));
```

Marble Diagram如下:

```bash
click  : ---------c-c------------------c--..
        map(e => Rx.Observable.interval(1000))
source : ---------o-o------------------o--..
                   \ \                  \----0----1--...
                    \ ----0----1----2----3----4--...
                     ----0----1----2----3----4--...
                     switch()
example: ----------------00---11---22---33---(04)4--...

```

## concatMap

`concatMap` 其实就是 `map` 和 `concatAll` 的简化写法。

`concatMap` 最常应用的场景就是从后台获取数据。

```js
let demo = document.querySelector('.demo')
let source = Observable.fromEvent<KeyboardEvent>(demo,'click')
let getData = this.http.get(this.base_api);
let example = source.concatMap((e:any)=>Observable.from(getData));
example.subscribe((value)=>console.log(value));
```

`concatMap` 可以接收第二个参数，该参数一个 `callback`,该回调函数接受四个参数，分别是:

* 外部 `Observable` 送出的元素
* 内部 `Observable` 送出的元素
* 外部 `Observable` 送出的元素的 `index`
* 内部 `Observable` 送出的元素的 `index`

```js
let base_api = 'https://api.github.com/search/repositories?sort=stars&order=desc&q=123';
let  demo = document.querySelector('.demo')
let source = Observable.fromEvent<KeyboardEvent>(demo,'click')
let getData = this.http.get(base_api).map((res:any)=>res.json());
let example = source.concatMap(
  (e:any)=>Observable.from(getData),
  (e,res,eIndex,resIndex)=>res.total_count
);
example.subscribe((value)=>console.log(value));
```

这个方法很适合用在 `request` 要选取的值跟前一个事件或在 `index` 有管理的情况下。

## siwtchMap

`switchMap` 顾名思义，就是 `map` 加上 `switch` 的简化。

同样，下面是一个通过 `switchMap` 请求 `request` 的例子:

```js
let base_api = 'https://api.github.com/search/repositories?sort=stars&order=desc&q=123';
let  demo = document.querySelector('.demo')
let source = Observable.fromEvent<KeyboardEvent>(demo,'click')
let getData = this.http.get(base_api).map((res:any)=>res.json());
let example = source.switchMap(
  (e:any)=>Observable.from(getData),
  (e,res,eIndex,resIndex)=>res.total_count
);
example.subscribe((value)=>console.log(value));
```

同样 `switchMap` 会在下一个 `Observable` 被送出以后直接退订前一个未处理完成的 `Observable`。

`switchMap` 与 `concatMap` 一样可以接受第二个回调函数当作参数。

## mergeMap

同样 `mergeMap` 可以看作是`map` 和 `mergeAll` 的合体简化。

`mergeMap` 的特性在于，可以并行处理多个 `Observable`。

此外，`mergeMap` 可以接受三个参数，第二参与 `concalMap`,`switchMap` 一样，为一个回调函数，而第三个参数可以用来控制 `mergeMap` 并行处理 `Observable` 的数量。

```js
let base_api = 'https://api.github.com/search/repositories?sort=stars&order=desc&q=123';
let  demo = document.querySelector('.demo')
let source = Observable.fromEvent<KeyboardEvent>(demo,'click')
let getData = this.http.get(base_api).map((res:any)=>res.json());
let example = source.mergeMap(
  (e:any)=>getData,
  (e,res,eIndex,resIndex)=>res.total_count,
  3
);
example.subscribe((value)=>console.log(value));
```

连续触发 5 次 `click` 事件，可以发现前 3 个 `request` 是同步发出的，但是第四个是等待第一个完成以后才发出的。

RxJS5 中的 `flatMap` 与 `mergeMap` 是同样的。

## 场景使用

> `concatMap`,`switchMap`,`mergeMap` 还有一个共同的特点，就是会将第二个参数传回的 `promise` 对象自动转换为 `Observable`。

至于各自的使用场景:

* `concatMap` 可以用在确定内部的 `Observable` 结束时间比外部 `Observable` 发送时间要快的情况，并且不希望有任何并行处理的行为，适合一次一次完成到底的 UI 动画，或者特别的 `request`

* `siwtchMap` 适合大多数的场景，用于只要最后一次行为结果。

* `mergeMap` 用在并行处理多个 `Observable`的情况，比如多个 I/O 的并行处理。

