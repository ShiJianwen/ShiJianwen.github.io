title: hexo 博客 next 主题 js 加载 404 问题
date: 2016-11-21 0:48:10
categories: "博客日志"
tags: "bug异闻录"


---


这几天想要更新博客，打开之后发现所有 js 都加载失败了，查阅之后发现是近期 github page 升级造成了，自动屏蔽了 vendors 文件夹，next 原作者回复：
![Alt text](/images/1479660158479.png)

问题有两个解决办法，一个是升级 next 的版本，但是新版本的一些配置可能不兼容了，所以谨慎升级，另一个方法是将 next 主题文件夹下的 `source/vendors` 文件夹重命名，然后将所有引用到了 vendors 的地方也一并重命名。