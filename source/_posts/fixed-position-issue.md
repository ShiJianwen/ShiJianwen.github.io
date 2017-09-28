title: 移动 Web 下 fixed 定位问题
date: 2017-09-28 17:56:21
tags: "bug异闻录"
categories: "Web 开发"
---


## 问题表现

移动 web 下，当父元素使用 translate 或者 rotate 旋转的时候，它的所有子元素的 fixed 定位都不生效（据说连 background-attachment 里面的 fixed 也会失效）

## 问题原因

浏览器的 bug

## 解决方案

<!-- more -->

### 1. 别用 translate
但一般我们会用 translate 来开启硬件加速，如果为了避免这个问题而舍弃硬件加速似乎有点得不偿失

### 2. 模拟 fixed
可以花点心思，用 absolute 来模拟 fixed 定位，效果一毛一样的，具体文章就自己搜啦

### 3. 元素分离
把需要旋转的元素和需要fixed定位的元素分离，不要呈父子关系，可以尝试把旋转下发到各个子元素上
