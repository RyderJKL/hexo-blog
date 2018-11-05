---
title: webpack独立打包与缓存处理 
date: 2016-12-31 09:42           
tags: ['webpack','前端自动化']
toc: true
categories: technology

---
### 工程目录

webpack 是一个集前端自动化，模块化，组件化于一体的可扩展系统，你可以更据自己的需求来进行一系列的配置和安装，最终实现想要的功能并打包输出。

假如有如下工程目录:

``` 
.webpackdeo
├── app
│   ├── hello.js
│   ├── index.html
│   └── index.js
├── package.json
├── webpack.config.js
└── yarn.lock
```

`hello.js` 的内容是:

``` 
const str = 'hello world!'

module.exports = str;
```

`index.js` 的内容是:

``` 
const $ = require('jquery')
const str = require('./hello')

function main () {
    $('body').html(str)
}
main()
```

即 `index.js` 文件会引用 `jquery` 和 `hello.js` 文件。

### web.config.js

``` 
/**
 * Created by root on 17-4-1.
 */

const webpack = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const path = require('path')


/**
 * webpack --config webpack.config.js
 * 对应的简化命令是 webpack
 *
 * webpack -p 打包的同时压缩文件
 *
 */

module.exports = {
    entry: {
        // 多个入口
        main: './app/index.js',
        // 主程序入口
        vendor: ['jquery']
        // 加入 vendor 属性，用于配置打包第三方类库，写入数组的类库名将统一打包到一个文件里
    },
    output: {
        filename: '[name].[hash].js',
        // 将生成的文件用 [name] 变量来自动生成文件名
        // [chunkHash:5] 为打包后的文件名添加 hash 值，保证每次修改后打包的文件 hash 值将改变，避免浏览器使用缓存文件
        path: path.resolve(__dirname, 'dist')
    },
    plugins:[

        new webpack.optimize.UglifyJsPlugin({
            // 优化 JavaScript 代码
            compress: {
                // 去除代码内的警告语句
                warnings: false

            }
        }),
        new webpack.optimize.OccurrenceOrderPlugin(/*优先考虑使用最多的模块，并为其分配最小的 ID*/),
        // webpack2 中 UglifyPlugin 的 compress 选项默认为 false 并且 OccurrenceOrderPlugin 默认启用
        new webpack.optimize.CommonsChunkPlugin({
            // CommonsChunkPlugin 插件，用于提取 vendor，可以看到 jquery 被提取到 vendor.js 中了
            names: ['vendor','manifest']
            // manifest.js 是 webpack 的启动文件代码，他会直接影响到 hash 值，将其独立出来，这样 vendor 的 hash 就不会改变了
        }),
        new HtmlWebpackPlugin({
            // HtmlWebpackPlugin 用于动态更新 html 页面中引入的各种模块名称
            template: 'app/index.html'
        })
    ]
}

```


### 设置 package.json 文件启动 webpack 

```
"scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "build": "webpack --config webpack.config.js",
    "dev": "webpack-dev-server --devtool eval --progress --colors --hot --content-base build"
  },
```

最后，运行 `npm build` 打包工程:
 
 ```
 webpackdemo
 ├── app
 │   ├── hello.js
 │   ├── index.html
 │   └── index.js
 ├── dist
 │   ├── index.html
 │   ├── main.8ea27c786c7c81172664.js
 │   ├── manifest.8ea27c786c7c81172664.js
 │   └── vendor.8ea27c786c7c81172664.js
 ├── package.json
 ├── webpack.config.js 
 ```
