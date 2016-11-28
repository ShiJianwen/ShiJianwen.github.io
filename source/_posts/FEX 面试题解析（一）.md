title: FEX 面试题解析（一）
date: 2016-01-14 18:37:10
categories: "待业青年"

---

前言：这学期大三了，马上就到了找实习的日子，感谢百度 FEX 开源了一个面试题目库[Front-end Job Interview Questions][1]，让我能够审查一遍自己的知识疏漏，这个系列的博文将会根据题库里面的非主观题目做一些力所能及的解释。

 ***1. Can you describe the difference between progressive enhancement and graceful degradation?（描述一下渐进增强和优雅降级的不同）***
渐进增强和优雅降级是对待同种事物的两种不同看法，举例来说，渐进增强就是做网站的时候先做一个基础的完整功能，然后针对一些先进的浏览器做一些更加先进的匹配以提升用户体验；优雅降级就是做网站的时候先按照先进浏览器的高标准做，然后再针对一些比较落后的浏览器做一些匹配使它们不会完全无法使用。
<!-- more -->

***2. How many resources will a browser download from a given domain at a time?（浏览器能够同时从一个域名下下载多少个资源）***
Chrome、Firefox、Safari 最新版本都支持同时下载 6 个资源，IE11 支持同时 8 个资源。
详见 [StackOverFlow][2]

***What are the exceptions?（有什么解决办法）***
因为浏览器的并发连接数限制是针对同一个域名的，所以可以使用多个域名指向同一个 ip 地址的方式来解决浏览器并发连接数的问题，多域名通常用来储存网站需要用到的静态资源，把静态资源从主域名移出到专门的静态资源服务器的好处之一是解决并发连接数的限制，另一个好处是如果静态资源放在主域名下，在请求这些资源的时候浏览器会发送本地存储好的对应主域名的 cookie 信息，这些 cookie 在请求这些静态资源的时候是不需要的，这是一种性能的浪费，使用多域名可以解决这个问题。但是多域名随之而来还有一个缺点就是增加了 DNS 查询的时间。

***3. What is Flash of Unstyled Content? How do you avoid FOUC?（什么是浏览器无样式闪烁，怎样避免）***
FOUC 是指当样式表迟于 HTML DOM 结构加载的时候，浏览器出现的短暂的没有样式的屏幕闪烁现象，这是因为当加载到这个迟来的样式表并解析的时候，浏览器会停止之前的渲染转而重新去渲染现在的这个样式表，这样就造成了短暂的花屏现象。这种现象的成因有两个：一个是使用了 import 加载样式表，一个是把样式表放在了页面底部加载。解决办法就是避免使用 import 并且把样式放在 head 标签内部加载。

***4. Explain some of the pros and cons for CSS animations versus JavaScript animations.（CSS 动画对比 JavaScript 动画有哪些有点和缺点）***
优点：浏览器对 CSS 有优化、GPU 加速（这个 JS 也能做到）、代码简单；
缺点：不灵活，无法控制很细粒度的动画效果、兼容性。

***5. What does CORS stand for and what issue does it address?（CORS 是什么意思）***
CORS（跨域资源共享）是指服务器允许不同域名下的请求发过来进行处理，因为浏览器有跨域限制，为了安全起见只允许将请求发送到相同域名下的服务器进行处理，CORS 可以通过设置服务器响应头部信息接收来自指定域的请求。


 


  [1]: https://github.com/h5bp/Front-end-Developer-Interview-Questions/blob/master/README.md#fun-questions
  [2]: http://stackoverflow.com/questions/985431/max-parallel-http-connections-in-a-browser/14768266#14768266