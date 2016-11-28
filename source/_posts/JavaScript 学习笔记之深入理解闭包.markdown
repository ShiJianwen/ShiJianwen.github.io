title: JavaScript学习笔记之深入理解闭包
date: 2015-09-12 15:29:20
categories: "JavaScript"

---

***变量的作用域***
作用域分为全局作用域和局部作用域，因为 JS 里没有块级作用域的概念，所以所谓的局部作用域是指函数内部的作用域，因为 JS 里函数外部是无法访问到函数内部的变量的，而函数内部却可以访问函数外部的变量，由此形成了局部作用域。

这里要注意一点，声明变量的时候一定要带上 var 关键字，如果没有 var 关键字则默认声明一个全局变量
```javascript
var n = 1;
function func1(){
    console.log(n); 
}
func1();//输出1

function func2(){
    var n = 1;
}
console.log(n); //undefined
```
<!-- more -->
***闭包***
由于作用域的这个特性，使得从外部访问函数内部的变量变得不可能，但是也不是全无办法，我们可以在函数内部再定义一个函数：

```javascript
function func1 () {
    var n = 2;
    function func2 () {
        console.log(n);
    }
    return func2;
}
var getN = func1();
getN();//输出 2
```
上面代码中，函数 func1 里面又定义了一个内部函数 func2，这时候 func1 里面的所有变量对 func2 来说都是可见的， 这样我们在外部就可以通过里面的这个 func2 函数来访问 func1 内部的变量了,这个内部函数 func2，就叫做闭包。

从概念上来说，闭包就是能够访问函数内部变量的函数。

***闭包的用途***
闭包的用途主要有两个，一个是用来访问函数内部变量，另一个是让某些变量保持在内存中不会被 GC 回收：
```javascript
function func1(){
    var n = 999;
    nAdd = function(){
        n+=1;
    };
    function func2(){
        console.log(n);
    }
    return func2;
}

var result = func1();
result();//999
nAdd();
result();//1000
```
正常情况下，一个函数在调用结束之后就会被垃圾回收机制回收，此时函数作用域里面的所有变量都会被销毁，所以正常情况下上面运行两次输出的应该都是 999，因为运行完一次后所有变量都会被销毁，但是这里没有，这里在运行两次后 n 的值累加了，这说明变量 n 没有被回收，它一直都在内存里面。
这是因为 func2 被赋值给了全局变量 result，使得 func2 一直保持在内存中(因为 result 是全局变量，浏览器不关闭，全局变量就一直存在)，而且 func2 又是依赖于 func1 的（要引用 func2 必先调用 func1），所以只要 func2 还在，func1 也一定在。

闭包还有一个用途就通过闭包可以建立对象的私有属性
```javascript
var someObject = (function(){
    var privateVar = 'private';//定义私有变量
    return {
        publicVar: 'public', //公有变量
        publicFunc: function(){//公有方法，也是特权方法
            console.log(privateVar);
        } 
    };
})();
console.log(someObject.privateVar); //undefined
console.log(someObject.publicFunc());//输出 private
```
上面的代码 someObject 定义了一个立即执行的匿名函数，这个函数的执行结果是返回了一个匿名对象，匿名对象里定义了一个公有变量和一个公有方法，这两个属性都是对外公开的，然而因为这个函数是立即执行的，并且是一个匿名函数，所以我们从外部是无法访问到函数内部定义的 privateVar 这个变量的，只能通过函数返回的公有方法 publicFunc，因为函数内部变量对这个公有方法来说是公开的，所以这个公有方法也被叫做特权方法。可以看到，利用了闭包技术，可以一定程度上弥补 JavaScript 天生的缺陷，使它更像一门真正的面向对象语言，因为在原生的 JavaScript 里面是没有定义像传统面向对象语言那样的诸如块级作用域，私有变量，特权方法这些东西的。

P.S 参考文献：[如何学习 JavaScript 闭包  --阮一峰][1]


  [1]: http://www.ruanyifeng.com/blog/2009/08/learning_javascript_closures.html