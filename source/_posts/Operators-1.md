# Operators(1)

## map

`map`和数组的`map`一样.

## mapTo

`mapTo`可以将传入的值改为一个固定的值:

```js
Observable.interval(1000).mapTo(2).subscribe(console.log(2))
```

## filter

`filter`和数组的`filter`一样

## take

`take`用来拿取前几个元素以后就结束。

```js
let source$ = Observable.interval(1000);
let example = source$.take(3);

example.subscribe(
  (value) => console.log(value),
  (error) => console.log(error),
  () => {console.log('done')}
)
// 0
// 1
// 2
```

## skip

而`skip`用来跳过前几个元素。

```js
let source$ = Observable.interval(1000);
let example$ = source$.skip(3);

example$.subscribe(
  (item) => console.log(item)
)
// 等待三秒以后开始输出
// 3
// 4
// ...
```

## takeLast

与`take`相对应，`takeLast`用来获取最后的几个元素。需要注意的是，`tackLast`必须等待整个`Observable`完成以后才能获取元素并且**同步输出**。

```js
let source$ = Observable.interval(1000).take(6);
let example$ = source$.takeLast(3);

example$.subscribe(
  (item) => console.log(item)
)
```

Marble Diagram 如下:

```js
source : ----0----1----2----3----4----5|
                takeLast(2)
example: ------------------------------(45)|
```

## first 与 last

`first` 是`take(1)`的快捷方法，获取第一个元素

`last`与此有类似的行为，是`takeLast(1)`的快捷方法

## takeUntil

`takeUntil`可以在某个事件发生时，立即让一个`Observabel`达到`complete`状态，这在实际用中经常用到:

```js
let source$ = Observable.interval(1000)
let dragDom = this.el.nativeElement.querySelector('.move-demo');
let click$ = Observable.fromEvent<KeyboardEvent>(dragDom,'click');
let example$ = source$.takeUntil(click$);
example$.subscribe(
  (value) => console.log(value),
  (error) => console.log(error),
  () => console.log('done')
)// 0
// 1
// 2
// 3
// complete (点击 demo了)
```

我们一开始使用 `interval` 建立了一个 Observable，让其每隔一秒输出，然后使用 `takeUntil` 传入另一个 `Observable`
,这个 `Observable` 在点击点击元素时产生，并完成上一个 `Observable`。

## concat

在一维的情况下，将多个`Observable`合并为一个`Observable`

> 需要注意是，`concat`必须等待前一个`Observable`完成以后，才会进行下一个。

```js
let obs1$ = Observable.interval(1000).take(3);
let obs2$ = Observable.of(3)
let obs3$ = Observable.of(4,5,6)
let example$ = obs1$.concat(obs2$,obs3$)

example$.subscribe(
  (item) => console.log(item)
)
```

Marble Diagrm 如下:

```bash
obs1$: ----0----1----2|
obs2$: (3)|
obs3$: (456)|
            concat()
example: ----0----1----2(3456)|
```

## concatAll

在二维，注意只能是二维，`concatAll`可以将多个`Observable`拍扁合成一个 `Observable`。同样，必须等到上一个`Observable`完成以后才处理下一个 `Observable`。

`concat`适用于一维，只是在单一时间上将所有一维的`Observable`和在一起:

```js
let obs$ = Observable.interval(500).take(3);
let obs1$ = Observable.interval(300).take(4)
let obs2$ = Observable.interval(400).take(5)

let example$= obs$.concat(obs1$,obs2$);

example$.subscribe(
      (item) => console.log(item)
    )
```

Marble Diagram 如下:

```bash
obs$: ----0----1----2|
obs1$:--0--1--2--3|
obs2$:---0---1---2---3---4
        concat()
example$: ----0----1----2--0--1--2--3---0---1---2---3---4
```

`contcatAll`适用于二维:

```js
let obs$ = Observable.interval(500).take(3);
let obs1$ = Observable.interval(300).take(4)
let obs2$ = Observable.interval(400).take(5)

let source$ = Observable.of(obs$,obs1$,obs2$)

let example$ = source$.concatAll()

example$.subscribe(
     (item) => console.log(item)
   )
```

Marle Diagram 如下:

```bash
source$: obs$~~~~~~~~~~~~~~~~~obs1~~~~~~~~~~~~~~~~~obs2$
      (拍扁)\                   \                     \
            ----0----1----2|  --0--1--2--3| ---0---1---2---3---4
      (合并)|                   |                    |
example$：----0----1----2--0--1--2--3---0---1---2---3---4
```

## startWith

`startWith`可以在一开始的时候推入一个元素，经常用于程序初始化。

```js
let obs$ = Observable.interval(1000).take(3);
let example$ = obs$.startWith(-1);

example$.subscribe(
  (item) => console.log(item)
)
```

__需要注意的是 startWith 的值一开始就是同步的__ Marble Diagram 如下:

```bash
obs$ : ----0----1----2----3--...
                startWith(0)
example: (0)----0----1----2----3--...
```

## merge

`merge`与`concat`都是用来合并`observable`的，但是`merge` 和`concat` 和非常大的不同的:

```js
let obs$ = Observable.interval(500).take(3);
let obs1$ = Observable.interval(300).take(6)
let example$ = obs$.merge(obs1$)

example$.subscribe(
  (item) => console.log(item)
)
```

`merge`不会等待上一个`obsrevable`完成，而是直接合并同一时间序列上的所有`observable`。

Marble Diagram 如下:

```bash
obs$ : ----0----1----2|
obs1$: --0--1--2--3--4--5|
            merge()
example: --0-01--21-3--(24)--5|
```

## 在Angular4中的一个拖拽的简单例子

```js
import { Component, OnInit,ElementRef } from '@angular/core';

import {Observable} from 'rxjs/Observable'

@Component({
  selector: 'app-drag-demo',
  templateUrl: './drag-demo.component.html',
  styleUrls: ['./drag-demo.component.css']
})
export class DragDemoComponent implements OnInit {

  constructor(
    private el:ElementRef
  ) { }

  ngOnInit(){
    let dragDom = this.el.nativeElement.querySelector('.move-demo');
    let githubBox = this.el.nativeElement.querySelector('.github-box');
    let mouseDown$ = Observable.fromEvent<KeyboardEvent>(dragDom,'mousedown');
    let mouseMove$ = Observable.fromEvent<KeyboardEvent>(githubBox,'mousemove');
    let mouseUp$ = Observable.fromEvent<KeyboardEvent>(githubBox,'mouseup')

    mouseDown$.map(
      // 鼠标按下时开始监听 mousemove 事件
      (event:any) =>
        mouseMove$.takeUntil(mouseUp$)
      // mousemove 要在 mouseup 之后立刻结束，使用 takeUntil
      // #！ 在 mouseup 没有来到之前，返回的流，都是 mousemove 的流
    ).concatAll(/*使用 concatAll 将所有的 mousemove Observable 合并成一个*/)
      .map((event:any) => ({
        x: event.clientX,
        y: event.clientY
      })).subscribe(pos => {
      dragDom.style.left = pos.x + 'px';
      dragDom.style.top = pos.y + 'px'
    })
  }
}
```

