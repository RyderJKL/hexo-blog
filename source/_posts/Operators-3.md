# Operators(3)

## scan

`scan`类似于`Array.reduce`，但是`reduce`返回的结果由`callback`决定，而`scan`一定返回一个`observable`。

## buffer

`buffer`是一整个家族: `buffer`,`bufferTime`,`bufferCount`,`bufferToggle`,`bufferWhen`

其中比较常用的是`buffer`,`bufferTime`,`bufferCount`

`buffer`要传入一個`observable(source2)`，它會把原本的`observable(source1)`送出的元素缓存在内存中，等到传入的`observable(source2)`送出元素时，就素触发把缓存的元素送出去。

## delay

`delay`对于 UI 操作是非常有用的，它通过给定的超时或者直到一个给定的时间来延迟源`Observable`的发送。

## delayWhen

`delayWhen`与`delay`类似，不过`delayWhen`可以影响源`Observable`中每一个元素，并且该时间段由另一个`Observable`的发送决定。

