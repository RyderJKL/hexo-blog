---
title: npm,nvm,node
date: 2017-02-18
tags: ['JavaScript','包管理器','npm']
toc: true
categories: technology

---
### 0x00 使用 nvm 管理 node 版本
**npm** 是 `node` 的包管理器，它类似于 CommonJS 规范，但是并不完全遵循 CommonJS 规范。

**nvm** 是 `npm` 中专门用来管理 `node` 版本的工具。它可以让我们轻松灵活的管理不同版本的node。比如，你在 Windows 下的 Vue 编码环境时 node v7.4.0，而在 Linux 下的 node 版本是 v5.0.0，而 v5.0.0 只支持 ES6 部分语法，由于 node 版本不同，导致代码根本不能运行，这时可以使用 nvm 升级 node 的版本:

#### 使用 nvm 升级 node

```
nvm install stable
// 安装 node 最新的稳定版本
// 或者制定要安装版本
nvm install 7.4.0
```

#### 升级 npm

```
npm cache clean -f
rm -rf node_modules
npm -g install npm@next
// npm -g install npm@latest
// npm -g install npm@stable
``


#### 查看当前系统中的 node 版本

查看当前 node 版本,node 见版本默认为最后一次安装的版本:

```
nvm current
v7.5.0
```

####  node 版本切换

```
// 切换到 node 5
 root  /  NEMBlog  nvm use 5                                       master 
Now using node v5.0.0 (npm v3.3.6)

// 再切回来，切换到 node 7
 root  /  NEMBlog  nvm use 7                                       master 
Now using node v7.5.0 (npm v4.1.2)
```
#### 显示所有安装的 node

```
nvm ls
```

#### 设置系统默认的 node 版本

```
nvm alias default 7
default -> 7 (-> v7.5.0)
```

---
### 0x01 nvm 的沙箱机制

nvm 的强大之处在于其沙箱机制，它可以让我们很方便的在多运行环境中管理和切换。以沙箱的方式，全局组件会装到
 `.nvm` 目录的当前版本 node 下，也就是装在 nvm 这个沙箱里，跟在指定版本的 node 下，当前有什么版本的 node，就有对应的全局组件。

---
#### .nvmrc
当服务器上运行了多个应用系统，而每个应用系统使用的node版本又不一样，为了让不同的应用系统使用各自所需的 node版本运行，我们只需在各应用系统内的根目录里生成一个 `.nvmrc` 文件，在其内写一个版本号，利用 `nvm run <系统启动文件>` 的方式运行系统,如此运行的应用程序的node版本将取决于 `.nvmrc` 中写的版本。

```
 root  /  NEMBlog  echo '5' > .nvmrc                               master 
 root  /  NEMBlog  vim index.js                                    master 
 root  /  NEMBlog  nvm current                                     master 
v7.5.0
 root  /  NEMBlog  nvm run index.js                                master 
Found '/NEMBlog/.nvmrc' with version <5>
Running node v5.0.0 (npm v3.3.6)
{ http_parser: '2.5.0',
  node: '5.0.0',
  v8: '4.6.85.28',
  uv: '1.7.5',
  zlib: '1.2.8',
  ares: '1.10.1-DEV',
  icu: '56.1',
  modules: '47',
  openssl: '1.0.2d' }
```

如上，我们在根目录下创建了 `index.js` 文件，它会输出运行时的 node 版本。然后使用命令行在 `echo '5' > .nvmrc` 指定应用程序的运行环境为 `v5.0.0`。最后切换本地的 node 版本到最新状态 v7.5.0。`index.js` 将输出运行时的 node 版本是 `v5.0.0`。

---
### 0x02 npm shrinkwrap
我们知道直接使用 `npm i` 安装的模块是不会写入 `package.json` 的 `dependencies` (或 `devDependencies`)，需要额外加个参数:

1. `npm i express --save/npm i express -S` (安装 `express`，同时将 `"express": "^4.14.0"` 写入 `dependencies` )
2. `npm i express --save-dev/npm i express -D` (安装 `express`，同时将 `"express": "^4.14.0"` 写入 `devDependencies` )
3. `npm i express --save --save-exact `(安装 `express`，同时将 `"express": "4.14.0"` 写入 `dependencies` )

第三种方式将固定版本号写入 dependencies，以保证在各个平台上使用的都是相同的版本。

运行如下命令:

```
npm config set save-exact true
```

如此，每次 `npm i xxx --save` 的时候会锁定依赖的版本号，相当于加了 `--save-exact` 参数。

但是这种方式只能锁定最外层的依赖，而里层依赖的模块的 `package.json` 有可能写的是 `"mongoose": "*"`。

为了彻底锁定依赖，可以使用 `npm shrinkwrap`，会在当前目录下产生一个 npm-shrinkwrap.json，里面包含了通过 node_modules 计算出的模块的依赖树及版本。

然后使用 `npm install` 的时候会优先使用 `npm-shrinkwrap.json` 进行安装，没有则使用 `package.json` 进行安装。

> 如果 `node_modules` 下存在某个模块（如直接通过` npm install xxx` 安装的）而 `package.json` 中没有，运行 `npm shrinkwrap` 则会报错。另外，`npm shrinkwrap` 只会生成 dependencies` 的依赖，不会生成 `devDependencies` 的。

