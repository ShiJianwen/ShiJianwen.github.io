title: 【译】使用 ndb 调试 node 应用
date: 2018-09-30 16:14:10
categories: "node.js"
tags: "好东西"


---

> 原文链接：[Debugging Node.js Application Using ndb](https://nitayneeman.com/posts/debugging-nodejs-application-in-chrome-devtools-using-ndb/)

> Google Chrome 实验室发布了一款新的 node debug 工具来提升开发者体验，本文将会全面介绍 ndb 这款 node 工具

熟悉 node 的人可能知道，node 一直支持一个无头调试工具:

![node 原生无头调试器](https://qpic.url.cn/feeds_pic/ajNVdqHZLLApzPeccD5DzWfU7farOgGkl30x5CyEqC1MDibmZBYWBfQ/)

它使用了一个已经被弃用的协议叫做 V8 调试器协议，并且它并不算是一个功能完备的调试器，只有一些简单的检查功能。

过去在这种情况下，一个新的基于 V8 调试器协议和 Blink 的调试工具出现在开发者眼前，它能够允许我们在任何一个 Webkit 内核的浏览器 DevTools 上面调试我们的 node 应用，是的，它就是 node-inspector，它的出现大幅增加了我们调试 node 应用的效率。

在 node 的 V6.3.0 版本中，V8 Inspector 作为一个实验特性被加入到这个版本中，它带来了一个非常强大的调试协议，同时还集成了 Chrome 的 DevTools 并且支持非常多的新特性如Blackbox、profiling、workspaces和sourcemap等等。此外，它并不依赖已经被弃用的 V8 调试器协议，而是直接基于 Chrome 的调试协议，因此它可以直接跑在调试客户端里面，像 Chromium 内核浏览器、VSC ode、WebStorm这些。启动它也非常简单，只需要输入命令 `node --inspect scrip.js` 即可。

在 7.20 号的时候，一个叫做 ndb 的全新 node 调试工具也同步开源了。

有新的 node 调试工具的确令人振奋，但这个新的 ndb 拥有哪些新特性呢？

<!-- more -->

## ndb 出现的背景

首先附上 ndb 的官方定义：

> ndb is an improved debugging experience for Node.js, enabled by Chrome DevTools
> （ndb 是一次对 node 调试体验的升级，Chrome DevTools 原生支持 ndb）

从上面的定义中，我们可以发现：

1. ndb 能够提升调试体验
2. Chrome DevTools 原生支持 ndb，意味着它使用的是 Chrome 的调试协议，类似于 V8 Inspector
3. ndb是谷歌 Chrome 实验室维护的

因此，你可能认为 ndb 只是提供了一个升级版的 V8 Inspector ，然而事实并非如此。


我们可以发现，使用 V8 Inspector 和 Chrome DevTools 有两个前提：一是 node 版本要大于 6.3.0，另一个是必须要用 Chrome 或者 Chromium 内核的浏览器。如果我们不满足这两个条件或者想在非 Chromium 内核下调试的话怎么办呢？

前面我们没说到 ndb 的使用依赖什么环境，它依赖一个叫做 `Puppeteer` 的包，Puppeteer 是一个通过 Chrome DevTools 协议来控制 Chromium 的包，它提供了很多封装好的接口。

<center>

![Puppeteer is a dependency of ndb](https://qpic.url.cn/feeds_pic/Q3auHgzwzM4FhfQWKaBM0IP6ZRQKQlVgTouqWQpibLvoGYBq1H0GgUw/)

</center>

当 ndb 安装了 Puppeteer 之后，一个最新的与当前环境兼容的 Chromium 也被安装到了依赖包里。

因为是独立安装的，所以 ndb 不依赖操作系统的浏览器，这种对浏览器不依赖的特性也成为了 ndb 的一个优势。

但它同时也带来一个问题，那就是 node_modules 会比较大，毕竟里面有一个 Chromium。

那么 ndb 在调试上的体验如何呢？

## 探索ndb

第一步我们先用 express 建一个 node 应用 demo：

```JavaScript

// app.js
const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('Hello World!'));

app.listen(3000, () => console.info('Example app listening on port 3000!'));


```

再在 package.json 定义一个运行脚本：

```JavaScript

"scripts": {
  "start": "node app.js"
}

```

### 如何安装

首先我们在全局环境或者本地安装 ndb。

```bash

npm install -g ndb

```

### 启动ndb

我们有好几种方法启动 ndb：

#### 1️⃣  - 直接执行文件

我们可以通过直接用 ndb 命令执行一个文件来开启 ndb，如：

```

ndb app.js


```

![Debugging a script file directly](https://qpic.url.cn/feeds_pic/Q3auHgzwzM53dKibCr4eYObJ8PHomd0qAHpCaJfkD7JUd3074MkPt1A/)


#### 2️⃣ - 运行一个二进制可执行文件

有时候我们想要用 ndb 来调试一些可执行二进制文件启动的服务，如 npm 脚本、webpack、单元测试这些。

只需要执行如下命令：

```

ndb npm start

```

上面我们用 ndb 运行了一个 npm 脚本，同样的，只要配置妥当我们还可以运行 `ndb webpack` 或 `ndb mocha` 等命令

![Debugging by running npm script](https://qpic.url.cn/feeds_pic/Q3auHgzwzM6KiaaY5icSmrOHibLUC6ws55tW8ibnXsem7oDXmwAYb2LJicg/)


#### 3️⃣ - 运行一个项目

如果我们只是需要打开一个 ndb 服务，可以直接在项目目录里面执行 `ndb .` 来打开，这个命令允许我们在执行脚本之前设置断点、编辑文件或其他任何东西。

![Debugging a project](https://qpic.url.cn/feeds_pic/Q3auHgzwzM61pUyUWsSOc4Dwbswso2LKAF49WygwWhgA2aB5mzznJw/)

PS：接下来的示例我们都采用第三种启动方法来示范

### 放置断点

在调试的时候放置断点非常简单

![Placing a breakpoint on the HTTP response](https://qpic.url.cn/feeds_pic/ajNVdqHZLLBAK93Uqhfjz4152uwlzeQtUViclM7tiawtxfNsOadybEaw/)

我们可以在模块被实际加载之前就放置断点

### 处理文件

使用 Chrome DevTools，我们可以在项目中创建和编辑文件，并将它们保存

![Changing the source code of a script file
](https://qpic.url.cn/feeds_pic/ajNVdqHZLLBmnHl7odggDfFWPfIGWD5cic8hLpH02sZ03PVy46QAOrQ/)

### 运行 npm 脚本

如果项目中包含一些 npm 脚本，可以通过 ndb 的面板中运行

![Running an npm script]https://qpic.url.cn/feeds_pic/ajNVdqHZLLCCqn70fPBokRibIfgaMI0CmRA12NrqaEziadRICOVvl8iaA/)

### 内置终端

通过 ndb 也可以直接访问终端

![Opening the built-in terminal panel](https://qpic.url.cn/feeds_pic/Q3auHgzwzM6vpUibtDxHJljiagXjRXXibwSmiafvtyVIjtrPQo7SDQqtfg/)

### Blackboxing

在默认情况下，ndb 会屏蔽一些外部文件，如 node 内置库，我们调试的时候对这些外部文件并不需要关心

![Blackboxing the module loader of Node.js](https://qpic.url.cn/feeds_pic/Q3auHgzwzM4wvA0hVIP6MnD5AibIT35ezbjovw9fqibKhJ75fBQ5Gufw/)

### 进程面板

这个面板会列出当前由 ndb 启动的所有 node 进程。此外，子进程会收拢到它的父进程中，方便管理和终止

![Terminating a child and parent process by single click](https://qpic.url.cn/feeds_pic/ajNVdqHZLLB9ZtAVpkH5X9dEwdSxchd4VfsEIiaNIC7uPbhve4liarFw/)

### 代码片段

ndb 支持创建一些代码片段来执行和调试

![Creating and executing a snippet](https://qpic.url.cn/feeds_pic/ajNVdqHZLLDh8ickQzgN576V99756qxNSq9WhErXp6nqxvlY0uzLBHA/)

### 变量访问

当前进程变量和 node 的全局变量，ndb 都可以访问到

![Logging `process` object to Console](https://qpic.url.cn/feeds_pic/Q3auHgzwzM5IRAVnoQE9aBsLFW2hdYck77KrlqQAmI2ARicmPx9OU9A/)
