---
title: JS引用类型(4)之Date    
date: 2016-10-06     
tags: ['JavaScript','JS引用类型']
toc: true
categories: technology

---
### Date
JS 没有日期数据类型。但是可以在程序里使用 Date 对象和其方法来处理日期和时间。Date对象有大量的设置、获取和操作日期的方法。 它并不含有任何属性。

JS 处理时间是从1970年1月1日00:00:00以来的毫秒数来储存数据类型的。

```
var dateObjectName = new Date([parameterss]);
```

参数可以是以下任意一种:

* 无参数: 创建今天的日期和时间
* 参数为一个完整的日期和时间:" moth day, year houer: minute: seconds"
```
var thistime = new Date("December 25, 1990 20:12:34");
```
* 一个年，月，日，时，分，秒的整数集合
```
var thistime = new Date(1990,11,23,9,45,0);
```

如果想根据特定的日期和时间创建日期对象，必须传入该日期的毫秒数(从UTC时间1970.1.1 00:00:00 起到该日期的毫秒数)。当然这太麻烦了，所以 JS 提供了 `Date.parse()` 和 `Date.UTC()` 方法来简化这一过程。


#### Date.parse()

使用 `Date.parse()` 方法解析日期字符串

```
var objectDate = new Date(Date.parse("9/16/1994 20:00:55"));
alert(objectDate);
```

如果直接将日期字符串传入 Date 构造函数，也会在后台调用 `Date.parse()` 方法。

```
var objectDate = new Date("May 25, 2004");
alert(objectDate);
```

**Date.parse()** 通常接收如下日期格式:

* "/月/日/年/"，如 "9/16/1996";
* "英文 月名 日,年",如 "January 12,2008";
* "英文 星期几 月名 日 年 时:分:秒 时区", 如 "Tue May 25 20034 09:00:00 GMT-0700"



#### Date.UTC()

Date.UTC() 方法同样也返回日期表示的毫秒数，但是它与Date.parse() 在构建时使用不同的信息。

* 秒，分： 0~59
* 时： 0~23
* 星期：0（周日）~6（周六）
* 日期： 1~31
* 月份： 0（一月）~11（十二月）
* 年份：从1970开始的年数


`Date.parse()` 接收的是时间字符串形式的参数，而`Date.UTC()` 接收的是时间数值形式的参数。还有一个不同之处便是，`Date.UTC()` 的日期和事件都基于本地时区而非 GMT 来创建。

```
var today = new Date(2016, 5, 1, 22, 0, 17);
//Wed Jun 01 2016 22:00:17 GMT+0800 (中国标准时间)
var today2 = new Date(Date.UTC(2016, 5, 1, 22, 0, 17));
//Thu Jun 02 2016 06:00:17 GMT+0800 (中国标准时间)
```

使用 `Date.UTC()` 方法创建的时间比 `Date` 的构造函数多了 8 个小时。


---
### 0x01 获取、设置日期方法
Date 类型提供了将日期格式化为字符串的方法。

```
var today = new Date(2016, 5, 1, 22, 0, 17);    
console.log(today.getDate(());              // 获得天数 0-31
console.log(today.getDay());                // 获得星期 0-6
console.log(today.getMonth());              // 获得月份 0-11
console.log(today.getFullYear());           // 返回四位数年份
console.log(today.getHours());              // 获得时 0-23
console.log(today.getMinutes());            // 获得分 0-59
console.log(today.getSeconds());            // 获得秒 0-59
console.log(today.getMilliseconds());       // 获得毫秒 0-999
console.log(today.getTime());               // 获得从1970 到现在的毫秒数
```


---
### 0X02 日期格式化方法
以下方法将根据本地时间格式，将 Date 对象表示为时间字符串。

```
console.log(today.toDateString());          // Wed Jun 01 2016
console.log(today.toTimeString());          // 22:00:17 GMT+0800 (中国标准时间)
console.log(today.toLocaleDateString());    // 2016/6/1
console.log(today.toLocaleTimeString());    // 下午 10:00:17
console.log(today.toUTCString());           // Wed, 01 Jun 2016 14:00:17 GMT
```

