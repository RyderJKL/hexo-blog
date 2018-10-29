---
title: fs模块(3)读写数据流stream  
date: 2016-12-25 12:45              
tags: ['Node.js']
toc: true
categories: technology

---
### 0x00 stream
流是一个抽象接口，在 `Node.js` 中它借助于多种对象实现。例如，一个对HTTP服务器的请求是一个流， 可以是 `stdout(标准输出流)`。流是可读的，可写的，或两者兼备。而所有的流都是 `EventEmitter` 的实例。

`Node.js` 中的很多模块都是用到了流，例如 `http` 和 `fs` 模块。例如在文件系统模块（`fs`）中， 我们可以通过流来创建读写文件数据的实例。


`fs` 模块提供了创建文件可读流与创建文件可写流的方法：`fs.createReadStream()` 和 `fs. createWriteStream()`，这两个方法分别分返回一个 `Readable Stream` 对象和 `Writable Stream` 对象。通过这两个对象，我们可以进行基于流的文件处理，在读写大文件时及基于流的转接、暂停、读取等操作方面有很大的作用。


---
### 0x01 创建可读流方法 fs.createReadStream()

**fs.createReadStream(path[, options])** 

该方法会读取指定文件，并返货一个 `ReadStream` 对象。


* `path`: 要创建可读流的文件的路径。
* `options`: 创建选项，可以一个字符串或对象。

其中 `options` 的默认值如下:

```
{
    flags: 'r',
    encoding: null,
    fd: null,
    mode: o0666,
    autoClose: true
}
```

`options` 选项中还可以包含 `start` 和 `end` 选项，用于设置读取文件的位置范围，而不是读取整个文件。

`encoding` 可以是：`utf8`、`ascii`、`base64`。

如果提供了文件描述符 `f` 的值，`ReadStream` 将会忽略 `path` 参数并从文件描述创建可读流。但种创建方法不会触发任何 `open` 事件。




---
#### 可读流对象 fs.ReadStream

使用 `fs.createReadStream()` 方法以后便会返回一个 `ReadStream` 实例，该对象是一个 **ReadStream**。该可读流对象不同于其它可读流的一点是，该对象包含一个 `open` 事件。

我们可以通过 `fs.ReadStream` 对象的构造方法或者使用 `fs.createReadStream()` 方法得到一个 `ReadStream` 实例。

```
const fs = require('fs');
const stream = fs.ReadStream('sample.txt');
//const stream = fs.createReadStream('sample.txt')
stream.setEncoding('utf-8');
stream.on('data', chunk => {
    console.log('read some data');
});
stream.on('close', () => {
    console.log('all the data is read')
})
```

如上，我们创建了一个可读流，并在流读取文件的过程中监听事件，在收到新数据时触发事件数据。 当文件读取完成后触发关闭事件。

在流中，我们可以按照自己的方式去处理数据，但是最好在数据事件接收到数据的时候处理它。如果想要读取所有的数据，则必须将其拼接到一个变量中：

```
const fs = require('fs');
const stream = fs.ReadStream('sample.txt');
let data = ''
stream.setEncoding('utf-8');
stream.on('data', chunk => {
    data += chunk;
    console.log('read some data');
});
stream.on('close', () => {
    console.log('all the data is read')
})
```

当文件很大的时候，就会触发多个data事件，这就需要开发者可以在以接收到数据的时候就做一些事情， 而不是等到整个文件都读取完成。


---
### 0x02 创建可写流方法 fs.createWriteSream()

**fs.createStreamWrite(paht[, options])**

如上，该方法创建一个 **WriteStream** 对象，`options` 是创建选项，可以是一个字符或者对象。其默认值如下:

```
{
    flags: 'w',
    defaultEncoding: 'utf-8',
    fd: null,
    mode: o0666
}
```

像 `ReadStream` 对象一样，如果提供了文件描述符 `fd` 的值，`WriteStream` 将
忽略 `path` 参数并从文件描述符中创建可写流。当这种创建方式不会触发 `open` 事件。

---
#### 可写流对象 fs.WriteStream

使用 `fs.createWriteStream()` 方法以后便会返回一个 `WriteStream` 实例，该对象是一个**WriteStream**。同样，该对象包含一个 `open` 事件。

我们可以通过 `fs.WriteStream` 对象的构造方法或者使用 `fs.createWriteStream()` 方法得到一个 `WriteStream` 实例。
使用 `stream` ，我们可以很方便的读入文件，然后将写入另一文件。

```
const fs = require('fs')
let readStream = fs.ReadStream('sample.txt')
let writeStream = fs.WriteStream('out.txt')
readStream.setEncoding('utf-8')
readStream.on('data', chunk => {
    writeStream.write(chunk)
})

readStream.on('close', () => {
    writeStream.end()
})
```

如上，当接收到 `data` 事件的时候，我们便将数据写入到可写流 `writeStream` 中，这非常的高效， 因为只要从可读文件接收到数据事件，数据就会被写入文件。尤其是对大文件而言，不会被阻塞。因此， 对于网络和文件系统中移动数据而言，流的方式非常的高效。

当然，我们后边将会介绍 **管道(pipe)** 的概念，当 **流** 遇上 **管道**，世界会清爽很多。

---
### 0x03 流(stream)与管道(pipe)
在输入和输出之间通过管道传输数据在Node.js中是很常见的，这就像水管之于水流，水流从一端流经水管，水管在内部将水流改变成不同的形状，然后通过水管的另一端流出。


针对此，node.js 提供了连接两个可读和可写流并在它们之间通过管道传输数据的方法 **pip()** 。 例如：`readStream.pipe(writeStream)`。



所以在 Node.js 中，读写文件还可以使用"流"来描述:

```
'use strict'
let fs = require('fs')

fs.createReadStream('./input.txt').pipe(fs.createWriteStream('./out.txt'))
```

如上，我们创建了一个读取流和一个写入流，将 `input.txt` 文件中内容通过`管道(pip)`输入到 `out.txt` 中。从语法形式上可以看到 **数据流** 从 `fs.createReadStream` 创建然后经过 `pipe` 流出，最后到 `fs.createWriteStream`。

当然这只是基于 Node.js 强大的流特性一个及其简单的例子。基于流我们可以构建和创造更多复杂和高效的代码或工具，比如 **Gulp** 就是完全基于 Node.js 流之上的一个非常优秀的构建工具。

我们再来看下面一个例子:



```
/**
 * Created by onejustone on 2017/1/2.
 */
'use strict';

let fs = require('fs')
let through = require('through2')

fs.createReadStream('./in.txt')
    .pipe(through.obj(function (contents, enc ,done) {
        if( enc === 'buffer') {
            contents = contents.toString('utf-8')
            enc = 'utf-8'
        }
    done(null, contents, enc)
})).pipe(through.obj(function (contents, enc, done) {
    done(null, contents.toUpperCase(), enc)
})).pipe(through.obj(function (contents, enc, done) {
    contents = contents.split("").reverse().join("")
    done(null, contents, enc)
})).pipe(fs.createWriteStream("./out.txt"))
```

如上，我们通过 `Node.js`的 `through2` 库（这是一个针对“流”的包装库），将输入流一步步转换成输出流，在中间的 `pipe` 中我们先是将 `Buffer` 转成 `String`，然后将它变成大写，最后再 `reverse` 然后传给输出流。

所以如果 `in.txt` 的文件内容是 hello world，那么 `out.txt` 的文件内容将是： DLROW OLLEH。







