# Operators(2)

## combineLatest

`combineLatest` 接收两种形式的参数，一个是需要参加合并的计算的 `obserable`，一个是 `callback`，而 `callback`中的参数代表的就是对应的元素。

```js
var source = Rx.Observable.interval(500).take(3);
var newest = Rx.Observable.interval(300).take(6);

var example = source.combineLatest(newest, (x, y) => x + y);

example.subscribe({
    next: (value) => { console.log(value); },
    error: (err) => { console.log('Error: ' + err); },
    complete: () => { console.log('complete'); }
});
```

`combineLatest`只会在所有参加合并的`observable`都有值产生时才回开始合并，并且只会提取每个`observable`中最新的那个值。

Marble Diagram:

```bash
source : ----0----1----2|
newest : --0--1--2--3--4--5|

    combineLatest(newest, (x, y) => x + y);

example: ----01--23-4--(56)--7|
```

## zip

`zip` 会取得每个 `observable` 序列上相同位置的元素进行合并，而与时间无关。当其中任何一个 `observable` 结束的时候，整个合并的过程结束。

```js
let s1$ = Observable.interval(400).take(3);
    let s2$ = Observable.interval(500).take(4)
    let s3$ = Observable.interval(600).take(5)
    let example$ = Observable.zip(
      s1$,
      s2$,
      s3$,
      (x,y,z) => x + y+z
    )
    example$.subscribe(
      value => console.log(value)
    )
```

Marble Diagram:

```bash
s1$:---0---1---2|
s2$:----0----1----2----3|
s3$:-----0-----1-----2-----3-----4|
      zip()
example$:-----0-----3-----6|
```

## withLatestFrom

`withLatestFrom` 与 `combineLatest` 比较相似，不过，`withLatestForm` 是具有从属关系的 `operator`。只有在主 `observable` 产生新值的时候，才会执行 `callback`。

```js
let main$ = Observable.from('hello')
  .zip(Observable.interval(500), (x, y) => x)

let some$ = Observable.from([0,1,0,0,0,1])
  .zip(Observable.interval(300), (x, y) => x)

let example$ = main$.withLatestFrom(some$, (x,y) => {
  return y === 1 ? x.toUpperCase() : x
})

example$.subscribe(value => console.log(value))
```

如上，我们在`main`产生值时，去判断`some`的最近一次的值是否为`1`,来决定是否切换大小写。

Marble Digram 如下:

```bash
main$   : ----h----e----l----l----o|
some$   : --0--1--0--0--0--1|

withLatestFrom(some, (x, y) => y === 1 ? x.toUpperCase() : x);

example$: ----h----e----l----L----O|
```

`withLatestFrom` 会在`main`产生值时才执行 `callback`，但如果`some` 之前没有送出过任何值，那么 `callback` 仍热不会执行。

> `merge` 像 `OR(||)` 一样，可以把多个 `observable` 合并并同时处理，而`combineLatest`, `withLatestFrom`,`zip` 更像一个 `AND(&&)` 运算，它们都是当有多个元素到来时只送出去一个元素。

