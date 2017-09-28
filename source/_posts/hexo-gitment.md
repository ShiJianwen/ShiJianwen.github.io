title: hexo 使用 Gitment 作为评论系统
date: 2017-09-12
category: '博客日志'

---

[Gitment](https://github.com/imsun/gitment) 是一个基于 Github issue 的博客评论系统，它的原理是利用 Github 官方提供的 api 操作你某个仓库下的 issue，使用 label 来标记不同的文章，因为是基于 Github issue 的，所以只支持 Github 用户登录，不过无妨。调用 Github api 需要用户提供 Github oAuth 鉴权的 id 和密钥，这个可以在 Github 上申请。在这里必须佩服一下作者的脑洞，接连几家第三方评论系统的停止服务，Gitment 的出现的确解了燃眉之急。我的博客是基于 Hexo 搭建的，所以这里简单讲一下怎样在 hexo 博客里使用 Gitment 作为评论系统。

<!-- more -->

#### 申请 oAuth 应用

Gitment 操作 issue 需要进行鉴权，这个鉴权的 id 和密钥要我们自己提供，我们可以在 [Github Setting](https://github.com/settings/applications/new) 这里申请新的 oAuth 应用，这里都可以随便填，只要注意把最后的 callback url 填成你的博客的 URL（如 http://blog.shijianwen.com）。申请完成之后会得到一个 client id 和 secret，这就是后面鉴权需要用到的东西。

#### 接入博客

在你博客的主题下，找到文章的模板文件（一般叫做 post.xxx），我用的 hexo 主题是 next，我的路径是 `themes/next/layout/post.swig`，进入模板文件，引入下面这段代码：

```
<div id="container"></div>
<link rel="stylesheet" href="https://imsun.github.io/gitment/style/default.css">
<script src="https://imsun.github.io/gitment/dist/gitment.browser.js"></script>
<script>
var gitment = new Gitment({
  id: '页面 ID', // 可选。默认为 location.href
  owner: '你的 GitHub ID',
  repo: '存储评论的 repo',
  oauth: {
    client_id: '你的 client ID',
    client_secret: '你的 client secret',
  },
})
gitment.render('container')
</script>
```

这里有几个注意点，如果你跟我一样是 next 主题用户，那么建议你最好把代码引入到 `block content` 下。另外在 js 代码里，id 最好使用 location.pathname，保证唯一性的情况下还不会被别的干扰（之前用location.href，如果 url 带 hash 会被认为是两篇不同的文章），如果你有更好的标识方法请忽略这条。

#### 初始化评论

代码添加完成之后，重新生成并部署到 github，打开你的博客，进入文章页，会看到最下面有一个评论框，此时评论框会提示一个未初始化的错误，这时候你需要在这个页面点击 login，然后点击初始化按钮进行初始化，这也是 Gitment 一个比较繁琐的地方，你需要给每篇文章都初始化一次评论，初始化做的工作就是新建一条当前文章的 issue，之后所有的评论都添加到该 issue 下的评论中去。这里有一个地方需要注意，如果你的文章 url 有些字符被 URL
 编码了，比如文章名带了空格等特殊字符，在 url 显示的时候被编码了，这时候登录 github 会报一个 callback url 的错误，提示你当前登录的 url 跟你申请 oAuth 鉴权的时候填的 callback 不一样，但实际上是一样的。所以为了避免这个问题，你的文章的 md 文件名字，最好不要出现空格等特殊字符，一般就用英文加连字符号就行，md 文件的名字只影响你文章 url 的显示，不会影响你真实的文章标题，标题还是以 md 文件里面的 title 字段为准。
