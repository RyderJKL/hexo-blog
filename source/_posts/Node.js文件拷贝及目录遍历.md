---
title: 从博客迁移到异步目录遍历
date: 2017-03-26 19:45
tags: ['Node.js应用篇','Node.js','fs']
toc: true
categories: technology

---
### 前言

最近想要将简书中的文章全部迁移到 hexo 中来，整个过程可是说很很苦逼的。

hexo 是静态的，这意味着首先需要将简书中下载的存放在不同目录中的 `.md` 文件全部提取出来，存放到 hexo 的 `_posts` 目录中，当然这一步比较简单，在 Linux 中一条命令就可以搞定:

```
 $ cp `find /jianshuo/blog -name "*.md"` /hexo/my_blog/source/_post
```

但是发布以后，发现生成的 `tags` 标签有问题，当一篇文章存在过多标签时，会全部生成为一个标签，查看 hexo 官方文档，发现是写作格式不对。

下面是 hexo 的文章格式:

```
tags: ['javascript','node.js','前端']
```

而我所有的文章格式是这样的:

```
tags: ['javascript','node.js','前端']
toc: true
categories: technology
```

既在 `tags` 中，多个标签之间直接使用空格分开的，而不是 `['',''']` 的形式，这就操蛋了，我所有的文章加起来 300+，不会让我一篇篇改吧。。。

当然一个偷懒的程序猿是绝对不会干这种蠢事情的，于是有了这篇文章。

显然，一条 `find` 命令是搞不定了，因为涉及到对文章内容的读写操作，我将从一个简单的 node.js 文件拷贝开始，然后到递归遍历目录及其子文件，提取所有的 `.md` 文件，一步一步来实现文章格式化的需求。


---
### 0x00 文件拷贝

#### 小文件拷贝

```
const fs = require('fs')

function copy(src, dst) {
    fs.writeFileSync(dst, fs.readFileSync(src))
}

function main(argv) {
    console.log(argv)
    copy(argv[0], argv[1])
}
console.log(process.argv)
main(process.argv.slice(2))
```

`process` 是一个全局变量，可通过 `process.argv` 获得命令行参数。由于 `argv[0]` 固定等于 Node.js 执行程序的绝对路径，`argv[1]` 固定等于主模块的绝对路径，因此第一个命令行参数从 `argv[2]` 这个位置开始。


运行:

```
$ node copy.js a.txt b.txt
[ '/root/.nvm/versions/node/v5.0.0/bin/node',
  '/root/Git-Repository/test/copy.js',
  'a.txt',
  'b.txt' ]
```

如上，我们使用同步的方法将文件 a.txt 中的内容复制到了 b.txt 中。

上边的程序拷贝一些小文件没啥问题，但这种一次性把所有文件内容都读取到内存中后再一次性写入磁盘的方式不适合拷贝大文件，内存会爆仓。对于大文件，我们只能读一点写一点，直到完成拷贝。


#### 大文件拷贝

```
const fs = require('fs')

function copy(src, dst) {
    fs.createReadStream(src).pipe(fs.createWriteStream(dst));
}

function main(argv) {
    console.log(argv)
    copy(argv[0], argv[1])
}
main(process.argv.slice(2))
```

以上程序使用 `fs.createReadStream` 创建了一个源文件的只读数据流，并使用 `fs.createWriteStream` 创建了一个目标文件的只写数据流，并且用 `pipe` 方法把两个数据流连接了起来。

---
### 0x02 目录遍历

#### 遍历算法

遍历目录通常使用递归算法，这样可以使得代码更加的简洁，但是递归的问题是，性能消耗很高，不过我们可以通过 ES6 函数尾调用来优化性能，或则，结合栈，使用非递归的方式遍历目录，我们慢慢来。

下面，将采用深度优先和先序遍历算法实现。

#### 同步遍历


```
const fs = require('fs')

const path = require('path')
const targetDir = process.argv[2];

function travel(dir, callback) {
    fs.readdirSync(dir).map(file => {
    // 同步读取目标目录下的所有内容
        let pathname = path.join(dir, file)
        // 获得文件的绝对路径
        if(fs.statSync(pathname).isDirectory()){
        // 同步获取文件状态，如果是目录，递归调用 travel 函数
            travel(pathname, callback)
        } else {
        // 非目录，执行回调函数
            callback(pathname)
        }
    })
}

travel(targetDir, function (pathname) {
    console.log(pathname)
})
```


#### 异步遍历

下面是异步遍历的核心代码:

```
/**
 * Created by root on 17-3-30.
 */
function travelDirAsync(dir, callback, finish) {

    fs.readdir(dir, (err, files) => {
        // 异步读取目录
        // console.log(files)
        (function next(i) {
            // console.log(i)
            // console.log(files)
            // 立即执行函数，主要是为了限制变量 i,next 函数是为了同级遍历
            if( i < files.length) {
                let pathname = path.join(dir, files[i])
                // 获取文件或者目录的绝对路径
                fs.stat(pathname, (err, stats) => {
                    // 获取文件状态
                    if (stats.isDirectory()) {
                        console.log(pathname)
                        // 若是目录，则继续向下遍历(既开始深度优先搜索)
                        travelDirAsync(pathname, callback, () => next(i + 1))
                    } else {
                        // 如果不是目录，则执行回调函数，继续遍历同级目录
                        callback(pathname, () => next(i + 1))
                        // 注意 callback 中的 i 和 finish 中的 i 不是同一 i
                    }
                })
            } else {
                // 如果目录遍历完毕，执行回调,既是运行（next(i+1))
                finish()
            }
        })(0)
    })
}

travelDirAsync(process.argv[2],function (pathname, callback) {
    console.log(pathname)
    callback()
}, function () {
    console.log('yes,finish!')
})

```

可见异步调用还是比较复杂的。

举个例子，若果我们有如下目录:

```
-test
	a.js
	b.js
	-folder
		a.txt
		b.txt
	c.js
```

那么在第一次运行遍历函数 `travelDirAsyn` 时，创建了一个运行上下文。其中 `i` 的初始值为 0，`files` 的值为 `['a.js','b.js','folder','c.js']`。遍历到 `folder` 的时候 `i` 的值为 2。再一次运行 `travelDirAsyn` 进入 `folder` 目录，又创建了一个新的运行上下文。遍历两次后当前运行上下文的i的值为 2，`if` 条件不成立跳到 `else` 执行 `finish` 函数 既执行(next(i + 1))。此时 `finish` 函数的执行环境位于之前的运行上下文（因为finish函数最近一次绑定位于之前的运行上下文），之前的运行上下文中的 `i` 的值为 `2`，所以此时执行的也就是 `next(3)``。最后输出 `c.js`。


---
### 0x03 应用

ok,我们回到开始，我下载的所有文章最开始存放在 `jianshu/data`,现在需要将该目录下的所有 `*.md` 文件提取出来，并将文件中的 `tags: tag tag tag` 形式改为 `tags: ['tag','tag','tag']` 形式。

首先我们采用同步遍历目录的方法,下面是完整代码:

#### 迁移博客

```
/**
 * Created by root on 17-3-28.
 */
const fs = require('fs')

const path = require('path')
const tags = /^tags:/
// 匹配标签项
const patternFilemd = /\.md$/;
// 匹配 .md 文件
const targetDir = process.argv[2];
// 源文件目录
const distDir = process.argv[3];
// 新的文件目录
function travel(dir, callback) {
    fs.readdirSync(dir).map(file => {
        let pathname = path.join(dir, file)
        if(fs.statSync(pathname).isDirectory()){
            travel(pathname, callback)
        } else if( patternFilemd.test(pathname)) {
            // 判断是否为 .md 文件
            let tempFile = '';
            fs.readFileSync(pathname).toString().split(/\n/).forEach(function(line){

                // 根据换行符换行，将文件以行为单位进行拆分
                if(tags.test(line)) {
                    // 寻找目标行，既以 `tags` 开头的标签行，其具体格式为: tags: Node.js JavaScript 前端
                    let tempArr = line.trim().split(" ")
                    // 去掉两头的空，再以空格切割行元素
                    console.log(tempArr)

                    let temp = ''

                    // 存放临时 tags 元素
                    for(let i = 1; i < strArr.length;i ++){
                        // 格式化 tags 元素为 ['Node.js','JavaScript','前端'] 的形式
                        if(tempArr[i] != ''){
                            temp += "'" + tempArr[i] + "'" + ",";
                        }
                    }
                    line = tempArr.slice(0,1) + " " +"[" + temp.replace(/,$/,"") + "]"
                    // 拼接 tags，此时line 的形式为 tags: ['Node.js','JavaScript','前端']
                }
                tempFile += line + '\r\n'
                // 将其余的内容存放在内存的 tempFile 变量中

            })
            fs.writeFileSync(path.join(distDir, file),tempFile)
            // 将格式化的文件写入新的文件目录中
            callback(pathname)
        }
    })
}
let i = 0;

travel(targetDir, function (pathname) {
    i ++;
    console.log("finish" + i)
})
```


最有运行 `travelSync` 实现一键迁移博客:

```
node travelSync.js /root/Git-Repository/my-notes /root/Git-Repository/hexo/blog/source/_posts
```

---
### 0x04 总结
这次博客迁移得到东西还是蛮多了，为了一个小小的改动，从 Linux 搞定 Windows，从文件拷贝到递归遍历，再到异步处理和深度优先搜索，当然所有的代码都还有很多的优化空间，比如可以将异步的目录遍历封装为一个 Promise 函数，使用队列来用非递归的方法来提高递归算法因为消耗大量内存而损坏的性能。但不管怎样，我们的需求算是实现了，这些坑先挖着，以后慢慢填。

> 不折腾到死不罢休!

> (博客)[https://www.onejustone.github.io]
