title: JavaScript学习笔记之 this 关键字
date: 2015-07-18 19:14:20
categories: "JavaScript"



---
this 是 JavaScript 的一个关键字，它表示函数在运行的时候所处的执行环境，this 的值会随着执行环境的不同动态变化，总的来说，this 指的是当前调用函数的那个对象。我们常在一下几种情况下使用 this：

***纯函数调用***

在纯函数调用的情况下，this 指向全局环境：
```javascript
var a = 1; //定义全局变量
function getA() {
    var a = 2; //这里是一个局部变量
    console.log(this.a); 
}
getA(); //输出 1
```
<!-- more -->
***作为对象的方法调用***

当作为某个对象的方法调用时，this 指向这个对象：
```javasript
var a = 2; //定义一个全局变量（为了说明 this 不是指向全局环境）
function getA () {
    console.log(this.a);
}
var someObject = new Object(); //定义一个对象
someObject.a = 1;  //定义这个对象下的一个变量
someObject.func1 = getA;
someObject.func1(); //输出 1
```

***作为构造函数调用***

当作为构造函数调用时，this 指向由这个构造函数生成的新对象：
```javascript
var a = 2; //定义一个全局变量
function Person () { //定义构造函数
    this.a = 1;
}
var onePerson = new Person(); //实例化一个对象
console.log(onePerson.a); //输出 1 
```

***apply 调用***
当 apply 参数为空时，this 指向全局环境，如果不为空，则指向参数所代表的环境：
```javascript
var a = 1; //定义一个全局变量
function getA () {
    console.log(this.a);
}
var someObject = new Object(); //定义一个对象
someObject.a = 2;
getA.apply(); //输出 1
getA.apply(someObject) //输出2
```