# webpack2 构建 Vue 多环境

---

## 0x00 相关依赖及版本

---

```json
"devpendencies": {
  // 生产环境依赖
  // npm install node_modules_name --save-prod
  // yarn add node_modules_name
  "vue": "^2.5.2",
  "vue-router": "^3.0.1",
  "vuex": "^3.0.1"
},
"devDependencies": {
    //开发环境依赖
    // npm install node_modules_name --save-dev
    // yarn add node_modules_name --dev/-D
    "url-loader": "^0.5.8",
    "vue-loader": "^13.3.0",
    "vue-style-loader": "^3.0.3",
    "vue-template-compiler": "^2.5.2",
    "webpack": "^3.6.0",
    "webpack-merge": "^4.1.0"
}
```

!> 值得注意的是 `vue-template-compiler` 是 `vue-loader` 的 `peerDependencies`，为了保证 `vue-template-compiler` 必须与 `vue` 版本保持一致，必须由用户来指定版本进行安装。　

关于 `dependencies/devDevpendencies/peerDependencies` 可参考：[聊聊 node.js 中各种 dependency](https://segmentfault.com/a/1190000008398819)

## 0x01 webpack 多环境配置

---

webpack 多环境配置的方案是：先有一基本配置文件`webpack.base.config.js`然后使用`webpack-merge`合并这个基本配置和针对特定环境下的配置文件，比如`webpack.dev.config.js`和`webpack.prod.config.js`

### webpack.base.config.js

```js
// 基础配置
const webpack = require('webpack')
const path = require('path')
const utils = require('./utils')

function resolve(relPath) {
  return path.resolve(__dirname, relPath)
}

module.exports = {
  entry: {
    main: resolve('../src/main.js')
  },
  output: {
    filename: 'js/[name].js'
  },
  resolve: {
        extensions: ['.js', '.vue', '.styl', '.stylus', 'pug'],
        modules: [path.resolve(__dirname, '../node_modules')],
        alias: {
            'vue$': 'vue/dist/vue.esm.js',
            '@': resolve('../src'),
            'router': path.resolve(__dirname, '../src/router'),
            'plugins': path.resolve(__dirname, '../src/plugins'),
            'store': path.resolve(__dirname, '../src/store'),
            'views': path.resolve(__dirname, '../src/views'),
            'util': path.resolve(__dirname, '../src/util'),
            'theme': path.resolve(__dirname, '../src/util')
        }
    },
  module: {
    rules: [
      {
        test: /\.js$/,
        use: "babel-loader",
        include: [resolve('../src')]
      },
      {
        test: /\.vue$/,
        use: {
          loader: "vue-loader",
          options: utils.vueLoaderOptions()
        }
      },
      {
        test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
        use: [
          {
            loader: "url-loader",
            options: {
              limit: 10000,
              name: 'images/[name].[hash:7].[ext]' // 将图片都放入images文件夹下，[hash:7]防缓存
            }
          }
        ]
      },
      {
        test: /\.(woff2?|eot|ttf|otf)(\?.*)?$/,
        use: [
          {
            loader: "url-loader",
            options: {
              limit: 10000,
              name: 'fonts/[name].[hash:7].[ext]' // 将字体放入fonts文件夹下
            }
          }
        ]
      }
    ]
  }
}
```

`webpack.base.config.js`将`vue-loader`的`options`提取出来,其主要是用来配置`CSS`及`CSS`预处理语言的`loader`,开发环境可以不用配置，但是生产环境需要提取`CSS`、增加`postcss-loader`等，
因此需要提取出来针对不同环境返回相应的`options`。

`webpack.base.config.js`不配置`CSS`的`loader`的原因和`vue-loader`一样。

同样考虑到各种环境的差异性以及个性配置，将`path`和`publicPath`放在各自的环境中配置。

### webpack.dev.config.js

```js
 // 开发配置
const webpack = require('webpack')
const merge = require('webpack-merge')

const HtmlWebpackPlugin = require('html-webpack-plugin')
const baseWebpackConfig = require('./webpack.base.config')
const utils = require('./utils')
const config = require('./config')

// 多入口热更新
// Object.keys(baseWebpackConfig.entry).forEach((name) => {
//     baseWebpackConfig.entry[name] = [
//       `webpack-dev-server/client?http://localhost:${config.dev.port}/`,
//       'webpack/hot/dev-server'
//     ].concat(baseWebpackConfig.entry[name])
// })

module.exports = merge(baseWebpackConfig, {
    devServer: {
        // 热更新配置
        hot: true,
        quiet: true, // 保证 friendly-errors-webpack-plugin 生效
        port: config.dev.port,
        open: true,
        noInfo: true,
        publicPath: config.dev.publicPath
    },
    output: {
        path: config.dev.path,
        publicPath: config.dev.publicPath
    },
    module: {
        rules: utils.styleLoaders()
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env.NODE_ENV': '"development"',
            '__ENV__': true,
            'development': true,
        }),
        new webpack.HotModuleReplacementPlugin(),
        // HtmlWebpackPlugin 会自动将生成的js代码插入到 index.html
        new HtmlWebpackPlugin({
            title: 'liangxiang',
            // filename 是相对于 webpack 配置项 output.path（打包资源存储路径）
            filename: './index.html',
            // template 的路径是相对于webpack编译时的上下文目录，就是项目根目录
            template: './index.html',
            inject: true
        })
    ]
})
```

### config.js

```js
const path = require('path')

module.exports = {
  dev: {
    path: path.resolve(__dirname, '../static'),
    publicPath: '/',
    port: 8000
  },
  test: {

  },
  prod: {
    path: path.resolve(__dirname, '../dist'),
    publicPath: '/static/'
  }
}
```

* path

打包后js、css、image等存放的目录; Webpack 2+ 要求`output.path`必须为绝对路径。

* publicPath

静态资源文件夹路径， 如果不配置，则默认为 `/`, 在实际项目中，静态资源一般集中放在一个文件夹下， 比如`static`目录，那么这里就应该改成`publicPath: '/static/'`， 相应的`index.html`中引用的`js`也要改成`src="/static/build.js"`， `publicPath`可以解释为最终发布的服务器上`build.js`所在的目录， 其他静态资源也应当在这个目录下。

### util.js

```js
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const isProd = process.env.NODE_ENV === 'production'

const cssLang = [
  {
    name: 'css',
    reg: /\.css$/,
    loader: 'css-loader'
  },
  {
    name: 'stylus',
    reg: /\.stylus$/,
    loader: 'stylus-loader'
  },
  {
    name: 'stylus',
    reg: /\.styl$/,
    loader: 'stylus-loader'
  }
]

function genLoaders (lang) {
  let loaders = ['css-loader', 'postcss-loader']
  if (lang.name !== 'css') {
    loaders.push(lang.loader)
  }

  if (isProd) {
    // 生产环境需要提取 css
    loaders = ExtractTextPlugin.extract({
      // 提取 CSS
     // 样式解析，其中css-loader用于解析，而vue-style-loader则将解析后的样式嵌入js代码
     // 也可以使用如下的配置
     // {
     //  test: /\.css$/,
     //  use: ["vue-style-loader", "css-loader"]
     // }
     // 可以发现，webpack的loader的配置是从右往左的，从上面代码看的话，就是先使用css-loader之后使用style-loader
     // webpack1 loader 后缀可以不写, webpack2 则不可省略
     // { test: /\.css$/, loader: 'vue-style!css' }
      use: loaders,
      allChunks: true, // extract-text-webpack-plugin 默认不会提取异步模块中的 CSS，需要加上配置,将所有额外的chunk都压缩成一个文件
      filename: "css/[name].[contenthash].css"
    })
  } else {
    // 开发环境需要 vue-style-loader 将 css 提取到页面头部
    loaders.unshift('vue-style-loader')
  }

  return loaders
}

exports.styleLoaders = function () {
  const output = []
  cssLang.forEach(lang => {
    output.push({
      test: lang.reg,
      use: genLoaders(lang)
    })
  })

  return output
}

// vue-loader 的 options
exports.vueLoaderOptions = function () {
  const options = {
    loaders: {}
  }

  cssLang.forEach(lang => {
    options.loaders[lang.name] = genLoaders(lang)
  })

  return options
}
```

关于`webpack`对样式文件的处理有篇不错的参考:[webpack中关于样式的处理](https://github.com/zhengweikeng/blog/issues/9)

关于使用`import`还是`require`引入CSS文件，实际应用中并不推荐使用`import`引入`css`，参考：[Getting postcss to process imported css](https://github.com/postcss/postcss-loader/issues/35)

### webpack.prod.config.js

```js
// 生产环境
process.env.NODE_ENV = 'production'
const webpack = require('webpack')
const merge = require('webpack-merge')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const baseWebpackConfig = require('./webpack.base.config')
const uitls = require('./utils')
const config = require('./config')

module.exports = merge(baseWebpackConfig, {
  output: {
    path: config.prod.path,
    publicPath: config.prod.publicPath
  },
  module: {
    rules: uitls.styleLoaders()
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': '"production"',
      '__ENV__': false
    }),
    new webpack.optimize.UglifyJsPlugin({
      // UglifyJsPlugin 它既可以压缩js代码也可以压缩css代码。
      // 开启代码压缩
      compress: {
        // 去除代码注释
        warnings: false
      }
    }),
    new ExtractTextPlugin({
      filename: 'css/style.css?[contenthash:8]'
    }),
    new HtmlWebpackPlugin({
      title: 'ahah',
      filename: 'index.html',
      template: 'index.html',
      inject: true
    })
  ]
})
```

### cli 启动

```json
// package.json
"scripts": {
  "dev": "cross-env NODE_ENV=development webpack-dev-server --progress --config build/webpack.dev.config.js",
  "prod": "cross-env NODE_ENV=development webpack --progress --config build/webpack.prod.config.js",
}
```

## 参考资料

[webpack使用优化](https://github.com/lcxfs1991/blog/issues/2)

