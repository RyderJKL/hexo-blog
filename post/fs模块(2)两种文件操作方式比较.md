---
title: fs模块(2)两种文件操作方式比较  
date: 2016-12-24 16:45              
tags: ['Node.js','fs模块']
toc: true
categories: technology

---
### 0x00 fs.read() VS fs.readFile()

---
#### fs.read() 
`fs.read(fd, buffer, offset, length, position, callback)`  

从文件描述符 `fd` 中读取文件数据。

* `buffer` 是一个缓冲区，读取的数据将会写入到这里。

* `offset` 是开始向缓冲区 buffer 写入数据时的偏移量。

* `length` 是一个整型值，指定了读取的字节数。

* `position` 是一个整型值，指读取的文件起始位置，如果 `position` 为 `null`，将会从文件当前的位置读取数据。

* `callback` 中回调函数，其中包含了三个参数(`err`, `bytesRead`, `buffer`)，分别表示：错误、读取的字节数、缓冲区。

使用 `fs.read()` 方法读取文件内容时，首先需要使用 `fs.open()` 方法创建一个文件描述符 `fd`。

`fs.read()` 方法可以实现部分文件内容的读取。


---
#### fs.readFile() 

`fs.readFile(filename[, options], callback)`

* `filename` 要读取的文件。

* `options` 可选参数包含以下可选值的对象:
    * encoding {String | Null} 默认：'utf8'
    * mode {Number} 默认：438 
    * flag {String} 默认：'w'

* `callback` 回调函数有2个参数 (err, data)，参数 data 是文件的内容。如果没有指定参数encoding, 则返回值为 Buffer。

`fs.readFile()` 方法能且只能读取文件的全部内容。


---
#### 小论
其实,`fs.readFile()` 方法是对 `fs.read()` 方法的封装。使用 `fs.readFile()` 主要用于方便取得文件的全部内容:

```
fs.readFile('sample.txt', function(err, data){
    console.log(data.toString())
}
```

而如果使用 `fs.read()` 方法里实现对文件所有内容的读取则需要先使用 `fs.stat()` 检测文件的状态，然后使用 `fs.open()` 方法创建文件描述符,最后再使用 `fs.read()` 方法读取文件内容：

```
'use strict'
var fs = require('fs')
fs.stat('sample.txt',function (err, stat) {
    if (err){
        console.log(err)
    } else {
        if(stat && stat.isFile()){
            fs.open('sample.txt', 'r', function (err, fd) {
                // 创建一与文件大小相同的 缓冲区
                var readBuffer = new Buffer(stat.size)
                var len = stat.size
                var offset = 0
                var filePosition = 0
                fs.read(fd, readBuffer, offset, len, filePosition, function (err, readBytes, readResults) {
                    // 输出文件内容 readResults 
                    console.log(readResults.toString())
                })
            })
        }
    }
})
```


---
### 0x01 fs.write() VS fs.writeFile()

---
#### fs.write()

`fs.write()` 有两种形式,可以将一个 `buffer` 或 `dta` 字符串写入到文件描述符 `fd` 的指定文件中。

`fs.write(fd, buffer, offset, length[, position], callback)`  
`fs.write(fd, data[, position[, encoding]], callback)`  

`fs.write(fd, buffer, offset, length[, position], callback)` 参数如下：

* `buffer` 是一个缓冲区，是要写入到文件的数据。

* `offset` 用于确认 `buffer` 写入数据时的偏移量。

* `length` 是一个整型值，指定写入数据的长度。

* `position` 是一个整型值，指写入文件的起始位置，如果 `position` 为 `typeof position !== 'number'`，将会从文件当前的位置写入数据。

* `callback` 中回调函数，其中包含了三个参数( `err`, `writeBytes`, `buffer`)，分别表示：错误、写入文件的字节数、缓冲区。

通过 `offset` 和 `length` 可以确定 `buffer` 的哪个部分将会被写入文件。

`fs.write(fd, data[, position[, encoding]], callback)` 参数如下:

* `data` 要写入文件的字符串（当写入数据不是 `Buffer` 时，将会被转为字符串）。
* `position` 是个整数值，代表写入文件的起始位置。
* `encoding` 指定写入字符串的编码方式
* `callback` 中回调函数，其中包含了三个参数(`err`, `writeBytes`, `buffer`)，分别表示：错误、写入文件的字节数、缓冲区。
 
> `fs.write()` 在没有等待回调而多次操作同一个文件是不安全的。在这种情况下，强烈推荐使用 `fs.createWriteStream()` 方法。


---
#### fs.writeFile()
`fs.writeFile(filename, data[, options], callback)`

* `filename`: 要写入的文件。

* `data`: 要写入的文件的数据，可以是一个buffer或字符串。

* `options`: 一个包含以下可选值的对象

    * `encoding {String | Null}`: 写入数据的编码方式，默认：'utf8'。如果写入数据是buffer时，这个参数会被忽略。
    * `mode {Number}`: 默认：438
    * `flag {String}`: 默认：'w'    当写入数据是字符串时，options参数可以是一个字符串，表示字符串编码方式，如：'utf8'。

* callback回调函数有1个参数 (err)。err, 表示可能出现的错误。


---
#### 小论
同样的，`fs.writeFile()` 也是对 `fs.write()` 方法的进一步封装，使用 `fs.readFile()` 方法省略了创建文件描述符的过程，可以更方便的向文件写入数据。



