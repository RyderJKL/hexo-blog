---
title: fs模块(1)基本文件操作  
date: 2016-12-23 22:45              
tags: ['Node.js','fs模块']
toc: true
categories: technology

---
### 0x00 fs
javascript 内置的 `fs` 模块就是文件系统模块，用于操作文件。不同于 Node.js 其它模块，`fs` 支持同步和异步操作。


---
### 0x01 查询文件信息 fs.stat()
`fs.stat(path, callback)` 用于查询文件的大小、创建时间、权限等相关信息。 `fs.stat()` 是异步方法，还有一个同步方法 `fs.statSync(path)` 。示例如下：

```
fs.stat('sample.txt', function (err, stats) {
        console.log(stats)
});
```

输出:

```
{ dev: 438983934,
  mode: 33206,
  nlink: 1,
  uid: 0,
  gid: 0,
  rdev: 0,
  blksize: undefined,
  ino: 1125899906928368,
  size: 272,
  blocks: undefined,
  atime: 2016-12-23T14:47:12.378Z,
  mtime: 2016-12-23T14:47:12.380Z,
  ctime: 2016-12-23T14:47:12.407Z,
  birthtime: 2016-12-23T14:46:59.200Z }
```

执行 `fs.stat()` 后会返回一个 `stats` 对象给回调函数，通过 `stats` 对象的属性和方法可以判断文件类型:

```
fs.stat('sample.txt', function (err, stats) {
        console.log(stats.isFile())
});
```

---
#### stats 对象中的方法
* stats.isFile()
* stats.isDirectory()
* stats.isBlockDevice() 如果hi块设备，返回 true
* stats.isCharacterDevice() 如果是字符设备，返回 true
* stats.isSymbolicLink() 如果是符号链接(软连接，快捷方式)，返回 true
* stats.isFIFO()
* stats.isSocket()


---
### 0x02 打开文件 fs.open()
标准的文件操作流程是先选择目标进行 `fs.open()` 操作，然后再对其进行读写访问。

`fs.open(path, flags[, mode], callback)`

`fs.open()` 方法第一个参数是文件路径。第二个参数是标志位，标志位表示文件的打开模式。标志含义与 UNIX中 `open` 的标识位相同：


* `r`:以只读方式打开文件，数据流的初始位置在文件开始  
* `r+`:以可读写方式打开文件，数据流的初始位置在文件开始  
* `w`:如果文件存在，则将文件长度清0，即该文件内容会丢失。如果不存在，则尝试创建它。数据流的初始位置在文件开始  
* `w+`以可读写方式打开文件，如果文件不存在，则尝试创建它。如果文件存在，则将文件长度清0，即该文件内容会丢失。数据流的初始位置在文件开始  
* `a`:以只写方式打开文件，如果文件不存在，则尝试创建它，数据流的初始位置在文件末尾，随后的每次写操作都会将数据追加到文件后面。  
* `a+`:以可读写方式打开文件，如果文件不存在，则尝试创建它，数据流的初始位置在文件末尾，随后的每次写操作都会将数据追加到文件后面。

---
### 0x03 读取文件数据 fs.read()
`fs.read(fd, buffer, offset, length, position, callback)`

文件打开后，就可以使用 `fs.read()` 方法进行读取，读取前需要创建一个用于保存文件数据的缓冲区。缓冲区数据最终会被传递到回调函数中。

```
/**
 * Created by onejustone on 2016/12/23.
 */
'use strict';
 
var fs = require('fs');
// 导入 fs 模块

fs.open('sample.txt','r',function (err, fd) {
    // 打开文件
    if(err){
        console.log(err)
    } else {
        var readBuffer = new Buffer(102),
            // 创建保存数据的缓冲区 readBuffer
            offset = 0,
            // 读取文件的偏移量
            len = readBuffer.length,
            // 读取文件的长度
            filePosition = 100;
            // 读取文件的起始位置
        fs.read(fd, readBuffer, offset, len, filePosition, function (err, dataBuffer) {
            // 开始读取文件数据(二进制内容)
            if (err){
                console.log(err)
            } else {
                console.log(readBuffer)
                // 直接以二进制形式输出内容
                console.log('获取得数据:'+' '+readBuffer)
                // 以人类可读的形式输出内容
                console.log('读取的总字节数:' +' '+ dataBuffer + 'bytes');
                // 获得总的数据长度
            }
            
        })
    }
});
```

输出:

```
<Buffer ae e7 9a 84 20 60 61...>
获取得数据: 的 `fs` 模块就是文件系统模块，用于操作文件。不同于 Node.js 其它模块，`fs` 
读取的总字节数: 102bytes
```

如上，文件 `open` 以后会从第 100 个字节开始，读取其后的 102 个字节的数据。读取完成后，`fs.read()` 会回调最后一个回调方法，然后就可以可以处理读取到的的缓冲的数据了。

`fs.openSync()` 是 `fs.open()` 方法的同步版本。


---
### 0x04 写入文件数据 fs.write()

`fs.write(fd, buffer, offset, length[, position], callback)`  

文件打开后，可以通过 `fs.write()` 方法传递一个数据缓冲区，以向打开的文件中写入数据。


```
/**
 * Created by onejustone on 2016/12/23.
 */
'use strict';
 
var fs = require('fs');
// 导入 fs 模块

//写入数据
fs.open('sample.txt', 'a', function (err, fd) {
    var writerBuffer = new Buffer("夜色中静悄悄，----"),
        offset = 0,
        len = writerBuffer.length,
        filePosition = null;

    fs.write(fd, writerBuffer, offset, len, filePosition, function (err, writeBytes) {
        if(err){
            console.log(err)
        } else {
            console.log('yes, write data successful!')
        }
    })
});
```

`fs.writeSync()` 是 `fs.write()` 方法的同步版本。

---
### 0x05 关闭文件
`fs.close` 用于关闭打开的文件。

```
fs.open('sample','a+',function (err, fd) {
    // Do something
    
    // close file
    fs.close(fd, function (err) {
        
    })
})
```

---
### 0x06 目录操作 fs.readdir(),fs.mkdir(),fs.rmdir()
`fs` 模块对目录的操作主要有：`fs.readdir()`，读取文件夹下所有文件名。`fs.mkdir()`，创建目录。`fs.rmdir()`，删除目录。

`fs.readdir(path, callback)`  
`fs.mkdir(path[, mode], callback)`    
`fs.rmdir(path, callback)`   

`fs.mkdir()` 创建目录时有第二个可选参数用于指定目录权限，不指定是权限为 `0777`。这三个方法都有 `sync` 同步方法。

```
// 目录操作
var fs = require('fs');
// 导入 fs 模块
var path = require('path');
// 导入 path 模块
// 读取目标文件内容
fs.readdir('./', function (err, files) {
    if(err){
        console.log(err)
    } else {
       console.log(files)
    }
});

// 创建目录
fs.mkdir(path.join(__dirname, './test'), function (err) {
    if(err){
        console.log(err)
    } else {
        console.log('make dir successful!')
    }
});

// 删除目录
fs.rmdir(path.join(__dirname, './test'), function (err) {
    if(err){
        console.log(err)
    } else{
        console.log('remove successful!')
    }
})
```


---
### 0x07 异步读取 封装的 fs.readFile()

---
#### 异步读取文本文件
Node.js 异步读取文本文件的代码如下:

```
/**
 * Created by onejustone on 2016/12/23.
 */
'use strict';
 
var fs = require('fs');
// 导入 fs 模块

fs.readFile('sample.txt', 'utf-8', function (err, data) {
    if (err){
        console.log(err)
    } else {
        console.log(data)
    }
});
```

异步读取时，传入的回调函数接收两个参数，当正常读取时，`err` 参数为 `null`，`data` 参数为读取到的 `String` 。当读取发生错误时，`err` 参数代表一个错误对象，`data` 为 `undefined`。

这也是Node.js标准的回调函数：第一个参数代表错误信息，第二个参数代表结果。

---
#### 异步读取二进制文件
使用 Node.js 读取二进制文件，比如一张图片:

```
fs.readFile('1.jpg', function (err, data) {
    if (err) {
        console.log(err)
    } else {
        console.log(data)
        console.log(data.length + 'bytes')
    }
})
```

当读取二进制文件时，不传入文件编码时，回调函数的data参数将返回一个`Buffer` 对象。在 Node.js 中，`Buffer` 对象就是一个包含零个或任意个字节的数组（注意和Array不同）。 


`Buffer` 对象和 `String` 可以互换:

```
// Buffer -> String
vat text = data.toString("utf-8")

// String -> Buffer
var buf = new Buffer(text, "utf-8");
```


---
#### 同步读取文件 fs.readFileSync()
`fs` 模块中使用 `readFileSync` 来同步读取文本文件，该方法不接收回调函数，函数直接返回结果。

用 `fs` 模块同步读取一个文本文件的代码如下：

```
'use strict';
 
var fs = require('fs');
// 导入 fs 模块

//同步文件操作
//同步读取文本文件
var  data = fs.readFileSync('sample.txt','utf-8')
console.log(data)
```

如果同步读取文件发生错误，则需要用 `try...catch` 捕获该错误：

```
try {
    var data = fs.readFileSync('sample.txt', 'utf-8')
    console.log(data)
} catch (err) {
    console.log('something error');
}
```

---
### 0x08 异步写文件 封装的 fs.writeFile()
Node.js 中的 `fs` 模块通过 `fs.writeFile()` 来实现异步写文件。


语法:

```
fs.writeFile(filename, data, [options], [callback(err)])
```

使用 `fs.writeFile()` 写入数据到文件:

```
var fs = require('fs')

var data = '忧郁的一片天，飘零的一片叶'

fs.writeFile('sample.txt', data, function (err) {
    if (err){
        console.log(err)
    } else {
        console.log('yes')
    }
})
```

和 `fs.readFile()` 类似，`fs.writeFile()` 也有一个同步方法，叫 `fs.writeFileSync()`。

---
### 0x08 文件，目录的重名(移动)与删除

---
#### fs.rename() 文件,目录的命名(移动) 
`fs.rename(oldPath, newPath, callback)` 

```
const fs = require('fs')

// 重命名文件
fs.rename('sample.txt','title.txt',function (err) {
    if (err){console.log(err)}
    console.log("yes")
})


// 移动并重命名文件
fs.rename('title.txt','./ES6/new_sample.txt',function (err) {
    if (err){console.log(err)}
    console.log("yes")
})
```

---
#### fs.unlink() 删除文件

```
const fs = require('fs')
let file = 'out.txt'
fs.unlink(file,function (err) {
    if(err){console.log(err)}
    else {
        console.log('yes delete!')
    }
})
```

---
#### fs.rmdir() 删除目录

```
s.rmdir('newDirectory',function (err) {
    if(err){console.log(err)}
    else {
        console.log('yes delete!')
    }
})
```





