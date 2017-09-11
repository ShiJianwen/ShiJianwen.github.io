title: FEX 面试题解析（二）
date: 2016-01-24 18:37:10
categories: "待业青年"

---

***1. What does a doctype do?（doctype 是什么）***
doctype 是指网页的文档类型，用来指定这个网页用什么版本的 HTML 或者 XHTML，如果不指定文档类型，代码里的标签和样式就没办法正确地解释出来。

***2. What's the difference between standards mode and quirks mode?（标准模式和怪异模式有什么区别）***
标准模式和怪异模式（也称兼容模式）是浏览器的渲染网页的两种标准，W3C 标准普及之后，为了兼容那些年代久远的网页，就采用了两种模式渲染的方式来解决这个问题，一般通过识别网页的 doctype 声明来决定使用哪种模式渲染。这两种模式最大的区别在于对盒模型的定义上，在标准模式中，盒子的 width 等于盒子的内容区的宽度，在怪异模式中，盒子的 width 等于内容区宽度加上边界宽度、内边距和外边距的宽度。
<!-- more -->
***3. What's the difference between HTML and XHTML?（HTML 和 XHTML 有什么区别）***
HTML 是基于 SGML 的一种应用，同样基于 SGML 的还有 XML，XML 主要用来携带和传递数据，HTML 主要用来表示数据，两者各有优势，为了能让 HTML 过渡到 XML 统一标准，出现了 XHTML。XHTML 能够兼容所有的 HTML 语法，但是在要求上更加严格，比如 XHTML 中所有的标签必须小写，所有标签必须闭合，每一个属性都必须使用引号包住。

***4. Are there any problems with serving pages as application/xhtml+xml?（使用 application/xhtml+xml 有什么问题）***
IE6，7，8不支持，IE6，7，8支持text/html。

***5. How do you serve a page with content in multiple languages?（如何实现一个多种语言版本的页面）***
一个可以用域名跳转，不同的语言版本跳转到不同的域名
另一个可以通过浏览器发送带 accept-language 头部信息的请求请求不同版本的页面文档
参考：[How do you serve a page with content in multiple languages?][1]

***6. What are data- attributes good for?（data 属性有什么好处）***
data- 属性使 HTML 有了存储数据的能力，它让 HTML 更加灵活，JavaScript 可以通过 dataset 方法访问到 data-* 的自定义属性，CSS 中也可以通过 attr 方法来引用 data-* 属性的值。

***7. Describe the difference between a cookie, sessionStorage and localStorage.（cookie，sessionStorage，localStorage 之间的区别）***
1）. 大小
cookie 最多只有 4kb，而 sessionStorage 和 localStorage 大小一般可以有 5M
2）. 生命周期
cookie 的生命周期由服务器控制，默认是关闭浏览器后删除；sessionStorage 仅在当前的窗口有效，localStorage 除非手动删除否则一直存在。
3）. http 通信
浏览器每次向服务器发送请求的时候都要带上该域的 cookie，而 sessionStorage 和 localStorage 仅存在于浏览器端。
4）. 作用域
cookie 和 localStorage 在同个域名下的多个窗口都有效，sessionStorage 只在一个窗口有效，不能跨窗口共享。
5）. 易用性
sessionStorage 和 localStorage 属于 HTML5 的 Web Storage 的 API，更加灵活易用。

***8. Describe the difference between < script >, < script async > and < script defer >.（普通脚本加载方式和 async、defer 方式有什么区别）***
普通脚本加载方式在加载和执行时会阻塞页面的渲染，async 和 defer 方式是用异步的方式加载脚本，不会阻塞页面渲染，它们之间的不同在于何时执行，async 方式是加载后马上执行，defer 方式是加载后等所有 DOM 都渲染好触发 DOMContentLoaded 事件之前执行，所以 async 方式里面的脚本都是乱序执行，defer 方式加载的代码都是按序执行的，按序执行对有依赖的代码非常重要。

***9. Why is it generally a good idea to position CSS < link >s between < head >< /head > and JS < script >s just before < /body >? Do you know any exceptions?（为什么要建议把 css 放到 head 标签内 和 js 要放到 body 结束标签之前？有什么例外吗）***
把 css 放在 head 标签内是为了首先下载样式表然后进行渲染，这样能够避免页面由于没有样式造成的 FOUC，把 js 放到 body 结束标签之前是为了不让 js 的加载阻塞页面的渲染，而且一般情况下 js 会包含 DOM 操作，如果在还没有完全加载好 DOM 树的情况下就执行 js 很可能会报错。例外就是，当脚本使用 defer 方式加载的时候可以不用约束放置的位置。

***10. What is progressive rendering?（什么是渐进式渲染）***
渐进式渲染是指浏览器不用等待所有页面资源都渲染好之后再呈现给用户看，而是边下载边渲染，所以用户打开一个网页的时候往往不能第一时间看到所有的内容，但是能够看到一个大概的样子，后续的内容浏览器会慢慢补上形成一个完整的页面。这个有点像 bigpipe。

  [1]: http://www.pro-tekconsulting.com/blog/how-do-you-serve-a-page-with-content-in-multiple-languages/