---
title: yarn初步
date: 2017-03-26 09:45
tags: ['JavaScript','前端工具化','yarn']
toc: true
categories: technology

---
### 0x00

Yarn 对你的代码来说是一个包管理器，Yarn 与 npm 很相似，但又有很多的不同，Yarn 致力于解决 npm 中的一些遗留问题，比如版本依赖，锁文件。


---
### 0x01 安装

在 Linux 环境下直接使用 `apt-get` 来安装:

首先配置 repository：

```
sudo apt-key adv --keyserver pgp.mit.edu --recv D101F7899D41F3C3
echo "deb http://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
```

安装 Yarn 之前，需要最新版本的 Node，支持，如果系统中安装了多个不同版本的 node，那么可以使用 `nvm`
先指定系统默认的 node 版本:

```
nvm alias default 7
default -> 7 (-> v7.5.0)
```

安装 Yarn:

```
apt-get update && apt-get install yarn
```

或者，你已经安装了 Node.js,那么还可以通过 `npm` 来安装 `yarn`(但是，强烈不建议这种方式):

```
 npm i -g yarn
```

最后，为 Yarn 配置环境变量:

添加 _export PATH="$PATH:\`yarn global bin\`"_ 到你的配置文件 (这可能在你的 .profile, .bashrc, .zshrc 等文件里)

当然，最后不要忘了激活配置:

```
$ source .zshrc
```

> [yarn中文网](https://yarnpkg.com/zh-Hans/docs/getting-started)

---
### 0x01 使用依赖



Yarn 通过 `yarn add [package]` 来添加依赖:

```
$ yarn add [packaege]@version
```

于此类似的命令是:

```
yarn add --dev 添加到 devDependencies
yarn add --peer 添加到 peerDependencies
yarn add --optional 添加到 optionalDependencies
```

这些将会自动对 `package.json` 和 `yarn.lock` 文件做出更新。

升级依赖:

```
yarn upgrade [package]
yarn upgrade [package]@[version]
```

移除依赖:

```
yarn remove [package]
```


---
### 0x02 从 npm 迁移到 Yarn

从 npm 迁移到 Yarn 很简单，只需要在原有的 npm 项目中运行 `yarn init` 命令就可以了，Yarn 会自动生成 `yarn.lock`锁文件，然后就可以使用上述 Yarn 命令来管理项目了。



