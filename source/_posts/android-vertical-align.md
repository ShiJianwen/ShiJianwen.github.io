title: Android 浏览器文本垂直居中问题
date: 2016-11-29 15:04:11
categories: Web 开发
tags: "bug异闻录"

---

## 问题描述
在开发中，我们常使用 line-height 属性来实现文本的垂直居中，但是在安卓浏览器渲染中有一个常见的问题，就是对于小于12px的字体使用 line-height 属性进行垂直居中的时候，渲染出来的效果并不是文字垂直居中，而是会偏上一些。举两个代码示例如下：

*** 1. 大于12px ***

html
```vbscript-html
<span>testtesttest</span>
```

css
```css
span {
    display: inline-block;
    height: 16px;
    background-color: gray;
    line-height: 16px;
    font-size: 12px;
}
```
<!-- more -->

显示效果

![](/images/1480324637887.png)

*** 2. 小于12px ***

html
```vbscript-html
<span>testtesttest</span>
```

css
```css
span {
    display: inline-block;
    height: 16px;
    background-color: gray;
    line-height: 16px;
    font-size: 10px;
}
```

显示效果

![](/images/1480324744155.png)

可以看到当 font-size 小于 12px 的时候，利用 line-height 属性进行垂直居中布局明显是偏上的，这里为了避免由于 font-size 是奇数带来的偏差，特意把 font-size 都设置成了偶数

## 问题原因

起初对这个问题有过两种推测，一是认为是字体的问题，或者是浏览器渲染的问题。但后面发现即使换了字体只要 font-size 还是小于 12px 一样会出现这个问题。

## 解决办法

看起来问题的根源在于字体大小小于 12px，所以解决问题可以从这个方向入手，要么改变字体大小，要么换个方式让它垂直居中。

*** 1. 改变字体大小 ***
最直接的方法就是改变字体大小让它大于 12px 能够正常居中，如果页面对字体大小要求比较严格的话，可以先将原来包括 font-size 在内的属性放大两倍，再用 scale 缩小一倍，这样测试之后也是可行的：

```vbscript-html
<span class="content">testtesttesttesttest</span>
```

```css
.content {
    display: inline-block;
    height: 40px;
    background-color: gray;
    line-height: 40px;
    font-size: 20px;
    transform: scale(0.5);
    transform-origin: 0% 0%;
}
```
![](/images/1480389681672.png)

但不知道为什么，用这种方法之后我总是感觉文字没有绝对地居中，好像是有一点细微的偏下，不知道什么原因，不是 line-height 就是我的眼睛有问题。。。



*** 2. table布局 ***
在元素外再包一层，使用表格布局

```html
<div class="container">
    <span class="content">testtesttesttesttest</span>
</div>
```
```css
.container {
    display: table;
}
.content {
    background-color: gray;
    font-size: 10px;
    display: table-cell;
    vertical-align: middle;
}
```

![](/images/1480400251642.png)


利用 table 布局能够比较好地实现文本垂直居中，缺点是要在外面多包一层容器。

## 总结
在查阅了很多资料之后，虽然能够解决这个问题，但导致问题的具体原因还是不够明显，只知道是安卓端浏览器的渲染问题，再往深一点的原因就有点鞭长莫及了，若有同行研究过这个问题，还望不吝赐教哈~





