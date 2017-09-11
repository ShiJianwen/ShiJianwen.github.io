title: pyspider 初探
date: 2017-09-10
category: 'Python'
tags: ['爬虫', 'Python']
---


[pyspider](http://www.pyspider.cn/) 是一款强大方便的爬虫框架，如果你有一个需要快速实现的爬虫任务，pyspider 是一个不错的选择。

### 安装

#### pip

我们使用 pip 来安装 pyspider，pip 安装见[这里](http://pip-cn.readthedocs.io/en/latest/installing.html)

<!-- more -->

#### phantomjs

爬虫在抓取页面的时候经常会遇到需要模拟浏览器行为的问题，如点击、执行加载等。这些问题在 pyspider 里面都需要靠 phantomjs 去解决。phantomjs 可以理解成是一个没有 UI 界面的浏览器，可以通过代码来完成浏览器的所有行为。安装的命令如下：
- Ubuntu

```bash
sudo apt-get install phantomjs
```

- Mac

```bash
brew install phantomjs
```

依赖安装完成之后我们可以执行 `pip install pyspider`
命令安装 pyspider。

Ubuntu 系统如果报错请确保安装了以下依赖：

```bash
sudo apt-get install python python-dev python-distribute python-pip libcurl4-openssl-dev libxml2-dev libxslt1-dev python-lxml
```

Mac 系统安装过程中可能会遇到一个 `Operation not permitted` 的错误，具体解决方法看 [这里](http://blog.shijianwen.com/2017/03/26/Mac%20%E5%AE%89%E8%A3%85%20Scrapy%20%E6%8A%A5%E9%94%99/)

安装过程没有报错即代表安装成功。

### 启动

命令行使用 `pyspider all`  命令启动 pyspider，参数 all 代表启动所有 pyspider 的插件。启动完成之后会自动打开 pyspider 的 WebUI 界面，我们后面所有的代码编写、调试、结果查看都在这里完成。

![enter image description here](http://7xawh4.com1.z0.glb.clouddn.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-09-10%20%E4%B8%8B%E5%8D%888.34.08.png)

点击 `create` 新建一个爬虫任务然后进入代码编辑界面

![enter image description here](http://7xawh4.com1.z0.glb.clouddn.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-09-10%20%E4%B8%8B%E5%8D%888.41.35.png)

里面有一些预置的代码，分别是：

crawl_config
爬虫配置信息，一些公共配置如请求头等

@every(minutes=24*60)
设置 on_start 方法执行的频率，这里是一天一次

on_start
入口代码

self.crawl
新建一个爬虫任务，丢到等待队列里，callback 参数指定爬虫请求返回后的处理函数

@config(age=10*24*60*60)
设置请求过期时间，这里表示十天内相同请求将会被忽略

index_page
爬虫请求的响应的处理函数，response 参数是请求的响应，response.doc 是一个类似 jquery 的对象，可以使用 jq 选择器查找文档里的元素

@config(priority=2)
优先级，数字越大优先级越高

detail_page
另一个处理函数，该函数的返回值将会直接存到 pyspider 的结果数据库中去，在爬虫任务面板点击查看结果查看的就是所有任务的 detail_page 函数返回的结果

以上几个方法是 pyspider 的核心方法，它同时也揭示了爬虫任务的生命周期。利用好这几个方法即可快速完成你的爬虫任务。

在基于以上几个方法写好爬虫代码之后，可以现在代码编辑调试爬虫代码，点击右上角 save 保存代码，然后在左边绿色区域点击 run 运行爬虫代码，在调试阶段，每次抓取并分析之后（也就是每次执行完 detail_page 之后）都会暂停，供开发者进行分析，点击左侧区域下方的几个按钮，可以看到此时不同的信息。`enable css selector helper` 可以打开 css 选择器；`web` 按钮可以展示当前页面的 UI，`html` 按钮可以展示当前页面的 HTML 结构；`follows` 按钮可以看到此时等待队列里面的所有待抓取的爬虫请求；`message`按钮可以显示抓取过程中的信息。当分析完毕需要继续执行爬虫的时候，可以在 `follows` 队列里面选择一个爬虫任务点击执行，即可进入下一个抓取任务。

对于一些动态页面的抓取，爬虫无法直接抓取，需要模仿浏览器的动态加载过程，就需要用到刚刚我们装的 phantomjs 了，使用 phantomjs 很简单，只要在使用 crawl 函数的时候增加一个参数 `fetch_type='js'` 即可。

当代码调试完成之后，即可开始运行，点击 `save` 按钮保存代码，回到 pyspider 的任务列表页，改变任务 status 为 running，点击右侧 run 按钮即可开始执行爬虫代码。progress 里面会实时显示当前爬虫任务的进度，点击右侧 `results`
 按钮可以进入结果页面查看当前爬虫的结果（也就是detail_page函数返回的结果）

到这里一个完整的 pyspider 爬虫过程就结束啦，是不是很方便很强大呢？如果希望对 pyspider 了解更多，可以查看它的[官方文档](http://www.pyspider.cn/book/pyspider/pyspider-Quickstart-2.html)