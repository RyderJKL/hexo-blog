# Operators(4)

## debounce,debounceTime

`debouce` 通俗点讲是 `防抖`。它会把每次接收到的元素 `cache` 一段时间，如果超过这个时间都还没有收到新的元素，则将 `cache` 中的内容发送出去。如果在这段时间之内又有新的值送过来，则丢弃原来 `cache` 中的值，并开始缓存新的值。

```js
let input = document.querySelector('#input');
let example$ = Observable.fromEvent<KeyboardEvent>(input,'keypress');
example$.debounceTime(300)
.map((e:any)=>e.target.value)
.subscribe(value=>console.log(value))
```

 与 `buffer`,`bufferTime` 一样。`debounce` 接收的是一个 `observable`，`debouncTime` 接收的是以毫秒为单位的时间参数。

## throttle,throttleTime

`throttle` 通俗点讲就是 `节流`。可以限制一个动作在规定的时间内至少被执行一次，而且只能执行一次。

```js
let example1$ = Observable.fromEvent<KeyboardEvent>(input2,'keypress')
example1$.throttleTime(1000)
.map((e:any)=>e.target.value)
.subscribe(
    value=>console.log(value)
```

如上，使用 `throttleTime` 我们可以让`keypress` 触发的值每隔一秒送出一次。这样可以减少 `request` 的次数。但是这种存在一个问题，就是每次拿到的值并不是最新的，总是上一次的 `input.value`。这是因为浏览器中的 `keypress` 等原生的事件总是会在自定义事件之前触发，这不难理解，类似于`click` 等事件，它们都是观察者模式，只有原生事件触发以后才能执行自定义事件。

解决这个问题的方法，在原生 `JavaScript` 中可以使用 `setTimeout`:

```js
document.getElementById('input2').onkeypress = function() {
  var self = this;
  setTimeout(function() {
    self.value = self.value.toUpperCase();
  }, 0);
}
```

但结合 `Rx.js` 中的 `debouce` 和 `throtle` 可以更加完美的解决这个问题:

```js
example1$
.debounceTime(300)
.throttleTime(1000)
.map((e:any)=>e.target.value)
.subscribe(value=>console.log(value)
```

## distinct, distinctUntilChanged

`distinct` 可以过滤掉相同的数据而只留下一份。`distinct` 与 `distinctUntilChanged` 的不同之处在于，`distinct` 会缓存所以已经发送的元素并与新的元素进行对比，而 `distinctUntilChanged` 只会缓存最后一个已经发送的元素然后与新元素对比，如果相同则不发送，如果不同则丢弃之前缓存的元素，换成最新的元素并发送该元素。

```js
let obs1$ = Observable.from(['a','b','c','a','b','c'])
      .zip(Observable.interval(300),(x,y)=>x)
let example1$ = obs1$.distinct().subscribe(value=>console.log(value))
// a
// b
// c
```

```js
let obs2$ = Observable.from(['a','b','c','a','a','c'])
    .zip(Observable.interval(300),(x,y)=>x)
let example2$ = obs2$.distinctUntilChanged().subscribe(value=>console.log(value))
// a
// b
// c
// a
// c
```

