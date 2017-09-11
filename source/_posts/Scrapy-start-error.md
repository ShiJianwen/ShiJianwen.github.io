title: Scrapy 启动报错 'module' object has no attribute 'OP_NO_TLSv1_1
date: 2017-03-26 18:48
categories: "Python"
tags: "bug异闻录"

---

![](http://7xiuuj.com1.z0.glb.clouddn.com/wallheven-python.png)
这个问题是因为 Twisted 的版本引起的，具体查看 [issue](https://github.com/scrapy/scrapy/issues/2473)，解决办法是安装指定版本的 Twisted：`pip install Twisted==16.4.1`，关于 Twisted，是一个 Python 里面的异步编程框架，具体可见 [文档](https://www.gitbook.com/book/likebeta/twisted-intro-cn/details)