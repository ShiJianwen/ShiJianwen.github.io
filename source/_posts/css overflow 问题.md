title: css overflow 问题,
category: 'Web 开发'
date: 2017-09-06 13:10
tags: ['bug异闻录', '问题解决']
---

#### 问题表现
---
当给一个容器设置 `overflow-x: hidden` 同时 `overflow-y: visible` 时，垂直方向的的设置总是失效。

```
// css
.wrap {
  height: 400px;
  width: 200px;
  border: 4px solid gray;
  overflow-x: hidden;
  overflow-y: visible;
}
.inner {
  height: 500px;
  width: 300px;
  background: red;

}

// html
<div class="wrap">
	<div class="inner">
	
	</div>
</div>
```
<!-- more -->
![Alt text](http://7xawh4.com1.z0.glb.clouddn.com/1504665163676.png)

####  原因
---

参考 https://stackoverflow.com/questions/6421966/css-overflow-x-visible-and-overflow-y-hidden-causing-scrollbar-issue 和 w3c 关于 overflow 值的说法 https://www.w3.org/TR/css3-box/#overflow-x


> The computed values of ‘overflow-x’ and ‘overflow-y’ are the same as their specified values, except that some combinations with ‘visible’ are not possible: if one is specified as ‘visible’ and the other is ‘scroll’ or ‘auto’, then ‘visible’ is set to ‘auto’. The computed value of ‘overflow’ is equal to the computed value of ‘overflow-x’ if ‘overflow-y’ is the same; otherwise it is the pair of computed values of ‘overflow-x’ and ‘overflow-y’.

> overflow-x 和 overflow-y 的计算值跟给定的值相同，除了某些跟 visible 值的不合理组合：如果其中一个属性的值为 visible，而另一个为 scroll 或 auto，那么 visible 会被重置为 auto 。在 overflow-y 与 overflow-x 值相同的情况下，overflow 的计算值取决于 overflow-x；否则就按上面的规则计算



当 overflow-x 和 overflow-y 为不同值的时候，值为 visible 的属性总是会被重置为 auto，这也解释了上面为什么垂直方向有滚动条的问题。

在解决问题的过程中发现有另一个说法是说跟 BFC 有关，因为 visible 和非 visible 对 BFC 的产生刚好相反，为了不引起歧义于是加了一条这样的规则（这个看看就好）

#### 解决方案
---
***wrap 包裹***
还是参考 [stackoverflow](https://stackoverflow.com/questions/6421966/css-overflow-x-visible-and-overflow-y-hidden-causing-scrollbar-issue) 的讨论，既然同一个元素里面不能同时设置 overflow-x 和 overflow-y 为对立的值，那么可以加多一个容器，然后分别设置 overflow-x 和 overflow-y

```
<style>
 .wrap {
   height: 400px;
   width: 200px;
   border: 4px solid gray;
   overflow-y: visible;
 }

 .wrap2 {
   overflow-x: hidden;
 }

 .inner {
   height: 500px;
   width: 300px;
   background: red;
 }
</style>

<body>
  <div class="wrap">
    <div class="wrap2">
      <div class="inner">

      </div>
    </div>
  </div>
</body>
```

问题解决。



