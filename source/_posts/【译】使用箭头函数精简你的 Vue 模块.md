title: 【译】使用箭头函数精简你的 Vue 模块
date: 2016-12-05 15:46:10
categories: 外文翻译

---

> 原文链接：https://dotdev.co/clean-up-your-vue-modules-with-es6-arrow-functions-2ef65e348d41#.vkndfgci3
> 众成翻译地址：http://www.zcfy.cc/article/clean-up-your-vue-modules-with-es6-arrow-functions-dotdev-1872.html


最近在重构一个用 Vue1.0 写的项目，我通过使用 ES6 的箭头函数来让代码在不升级 Vue2.0 的情况下变得更加简洁和统一。在这个过程中我也遇到了很多坑，所以想借此机会分享一下我从中学到的东西以及总结出来的一些规范，这些规范以后都将会落实到我的 Vue 项目中。

<!-- more -->

我们最好还是通过代码示例来讲解，下面给出一段代码，我们一步一步来分析它

```javascript
// require vue-resource...

new Vue({

  data: {
      item: {
        title: '',
        description: '',
      }
  },

  methods: {

    saveItem: function() {

      let vm = this;

      this.$http.post('item', this.item)
        .then(

          function (response) {
            vm.item.title = '';
            vm.item.description = '';
          }, 

          function (response) {
            console.log('error', response);
          }

        );
    }

  }
});
```

上面给出的这段代码实现了一个表单提交逻辑，用户提交表单之后发送请求在数据库新建一个数据项。但即使是这么简单的逻辑，其中也还有很多可以优化的地方。

* * *

### 箭头函数和 this 关键字

先来看一下代码中的 `saveItem` 方法：
```
saveItem: function() {

let vm = this;

this.$http.post('item', this.item)
  .then(

    function (response) {
      vm.item.title = '';
      vm.item.description = '';
    }, 

    function (response) {
      console.log('error', response);
    }

  );
}
```

开发中我经常很不爽的就是总是要把 `this` 关键字存起来，像上面的 `vm = this` 这个变量定义就是为了待会我们能够不受函数执行上下文影响地获取到 Vue 实例对象。假如有一种方法能够让我们彻底摆脱这种声明并且函数能够自动继承 this 关键字，岂不美哉？幸运的是，现在我们完全可以实现这个想法，因为有[箭头函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)。

在使用箭头函数的时候，`this` 是一个常量，这意味着现在的 this 不再动态指向当前的执行上下文了，而是继承了外围作用域。这意味着我们可以把上面代码中的 promise 回调函数用一种更加简洁的方法来重写并且不需要用临时变量来存储 this 就能取到 Vue 实例对象：
```
saveItem: function() {

  // let vm = this;

  this.$http.post('item', this.item)
   .then(

    //function (response) => {

    response => {
     this.item.title = '';
     this.item.description = '';
    }, 

    //function (response) => {

    response => {
     console.log('error', response);
    }

   );
}
```

看起来很不错吧！

* * *

### 滥用箭头函数

使用箭头函数的确很酷，但是不是每个地方用它都这么好呢？有些人可能不喜欢每次都声明一个 `function() {}` 所以把它们都用箭头函数的 `() => {}` 来简写。所以刚刚的 `saveItem()` 方法还可以改写成这样：

```
methods: {
  saveItem: () => {
    this.$http.post('item', this.item)
      .then(
        // callbacks in here
      );
  }
}
```

你会觉得这样改写后简直完美，整个代码都变得特别简洁，但是这样你将会踩到一个坑。

现在 `saveItem()` 方法里面的 `this` 指向的是 `window` 而不是我们希望的 Vue 实例对象（因为是继承外围作用域的this），当我们想要在给函数传递 `this.item` 整个参数的时候，你会发现它获取的是 `window.item`。

* * *

### 方法定义

[ES6](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Method_definitions) 约定了一种新的函数定义方式，可以直接把函数名当成函数的声明，像下面这样：
```
var obj = {
  foo: function() {},
  bar: function() {}
};

// with ES6 method definitions, this becomes

var obj = {
  foo() {},
  bar() {}
};
```
所以我们可以用这种方法来简写我们的 `saveItem()` 方法，同时也不会出现刚刚箭头函数带来的 this 继承的问题。
```
...
methods: {
  saveItem() {
    this.$http.post('item', this.item)
      .then(
        // callbacks in here
      );
  }
}
...
```
如果你觉得还不够简洁的话，可以按照这个方法改写所有 Vue 实例对象里面的顶级方法（`data` 和 `created` 这些）

* * *

### data 相关

在我们的代码里，我们的 `data` 是一个对象字面量。如果你熟悉 Vue 的话你会发现我们在真正开发的时候会把 `data` 这个对象当做闭包 return 回来。官方文档和[这篇博客](http://codebyjeff.com/blog/2016/11/vue-js-simple-tuts-component)有解释为什么这样做（译者注：这里要返回闭包是为了保证组件内部的状态独立，避免多个相同组件共用一个 data）。

我们刚刚了解到了很多优化的点，还知道了箭头函数里面的 this 是一个常量，它继承自外围作用域，除此之外，箭头函数还有一些[函数体定义](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Functions/Arrow_functions)的新特性，前面的例子中我们定义函数体的时候用的是传统的块级结构方法（花括号包裹），箭头函数中我们可以使用一种更加简洁的代码结构来定义函数体，看下面的两段代码：

```
var sum = (a,b) => {return a+b;}  // 传统块级结构，必须要有 return
var sum = (a,b) => a+b;           // 简单结构，不用声明 return

var sum = (a,b) => ({sum: a+b});  // 如果要返回一个对象字面量，则必须用括号包裹
```
当你的函数只返回一个值的时候，可以直接把值写上，不再需要以往的花括号和 `return` 了，但如果需要返回一个对象字面量的话，就必须把你要返回的对象用括号包裹起来（译者注：花括号是运算符，声明这是一个计算值，否则会把对象字面量的花括号认为是箭头函数的函数体声明）。

我很喜欢这个小改动，另外你也可以使用 ES6 的函数定义方法来写

```
// method definition style
...
data() {
  return {
    item: {
      title: '',
      description: '',
    }
  }
}
...
```

* * *

### Vue ES6 规范

踩过那么多坑之后，我总结出了以下几条 Vue 模块定义规范：

1.  使用 [ES6 方法定义规范](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Method_definitions)来定义所有顶层方法

2.  使用[箭头函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions)定义所有在顶层方法里面的回调函数

3.  使用[“简单结构”](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions#Function_body)来定义 `data` 的函数体

希望这些规范能够让你的 Vue 模块代码和组件更加吸引人并且更加可读，Thx！

* * *

### 脚注

[https://rainsoft.io/when-not-to-use-arrow-functions-in-javascript/](https://rainsoft.io/when-not-to-use-arrow-functions-in-javascript/)

* * *

_Originally published at_ [_gist.github.com_](https://gist.github.com/JacobBennett/7b32b4914311c0ac0f28a1fdc411b9a7)_._