title: DOM & BOM
date: 2015-7-16 16:18:10
categories: "JavaScript"

---

## BOM

BOM 即是浏览器对象模型（Browser Object Model），它定义了 JavaScript 可以进行操作的浏览器的各个功能部件的接口，提供访问文档各个功能部件（如窗口本身、屏幕功能部件、浏览历史记录等）的途径以及操作方法。遗憾的是，BOM只是JavaScript脚本实现的一部分，没有任何相关的标准，每种浏览器都有自己的 BOM 实现，这是 BOM 最大的缺陷，在浏览器 JavaScript 中，BOM 主要有以下几个功能：

◆关闭、移动浏览器及调整浏览器窗口大小； 
◆弹出新的浏览器窗口； 
◆提供浏览器详细信息的定位对象； 
◆提供载入到浏览器窗口的文档详细信息的定位对象； 
◆提供用户屏幕分辨率详细信息的屏幕对象； 
◆提供对cookie的支持； 
◆加入ActiveXObject类扩展BOM，通过JavaScript实例化ActiveX对象。

<!-- more -->

### Window对象

在 BOM 中，Window 对象是所有对象的核心，它是 BOM 中所有对象的父对象。

***1.全局的 Window 对象***
在浏览器中，Window 对象有双重角色，它既是通过 JavaScript 访问浏览器窗口的一个接口，又是 ECMAScript 规定的全局对象，所有全局变量和全局函数都会归类成 Window 对象的属性。但是虽说全局变量会自动变成 Window 对象的属性，但全局变量跟显式定义的 Window 对象属性还是有一些差别的，差别在于全局变量不可以用 delete 操作符删除而 Window 对象属性可以，代码如下：
```javascript
var a = 1;  //定义一个全局变量
window.b = 2; //定义一个 window 属性
delete a; //输出 false
console.log(a); //输出 1
delete window.b; //输出 true
console.log(window.b); //undefined
```

***2.兼容问题***
由于 BOM 并没有一套系统的规范来约束它，所以在使用一些浏览器窗口的方法的时候需要对不同的浏览器进行兼容，以确定窗口位置的这个方法为例，在 IE、Safari、Opera 和 Chrome 浏览器下使用 screenLeft 和 screenTop 属性来获取窗口与屏幕左边和上边的距离，而在 FireFox 浏览器中则要通过 screenX 和 screenY 来获取，这种情况下为了能够在各种浏览器下都能正常使用这个方法，我们就需要改写代码去兼容各个浏览器，具体写法如下：
```javascript
//IE、Safari、Opera 和 Chrome 使用 screenLeft 和 screenTop 属性
//Firefox 则使用 screenX 和 screenY
var leftPos = (typeof window.screenLeft == "number") ?
window.screenLeft : window.screenX;
var topPos = (typeof window.screenTop == "number") ?
window.screenTop : window.screenY;
```
***3.超时调用 setTimeout 和间歇调用 setInterval***
setTimeout 和 setInterval 都是 Window 对象中常用的方法，从名称上来看，超时调用 setTimeout 是在等待一段时间后去执行一个函数，它接收两个参数，第一个参数是要执行的函数，第二个参数是要等待的时长，它的单位是毫秒。间歇调用 setInterval 是每隔一段时间就执行一次函数，它也接收两个参数，两个参数跟 setTimeout 的一样。
setTimeout 和 setInterval 方法在调用的时候都会返回一个独一无二的数字 ID 用以识别当前的计时器，我们在代码中一般都会定义一个变量来保存这个数字 ID，以便给后来需要的 clearTimeout 和 clearInterval 传递参数。
setTimeout 和 setInterval 都有各自相对应的一个 clear 方法，分别是 clearTimeout 和 clearInterval，它们的作用是用来阻止超时调用和间歇调用的进行，它们都接收一个参数，就是上面说的数字 ID。对超时调用 setTimeout 来说，如果等待时间还没完的情况下就执行 clearTimeout 函数的话就会终止执行，如果等待时间已经完成的话则 clearTimeout 对其无效。clearInterval 比较简单，它就是用来终止间歇调用的循环的。
超时调用 setTimeout 的调用例子如下：
```javascript
//调用例子如下
setTimeout(function(){console.log('哈哈哈');},1000);

//每次调用都会返回一个独一无二的数字代码用于识别这个计时器，以用来取消
//取消计时器可使用 clearTimeout，参数为 setTimeout 返回的数字代码

var timer = setTimeout(function(){console.log("哈哈哈哈");},1000);
clearTimeout(timer);
```

间歇调用 setInterval 的调用例子如下：

```javascript
//一个间歇调用例子
var num = 0;
var max = 10;
var intervalId = null;
function incrementNumber() {
num++;
console.log("蛤蛤");
//如果执行次数达到了 max 设定的值,则取消后续尚未执行的调用
if (num == max) {
clearInterval(intervalId);
alert("Done");
}
}
intervalId = setInterval(incrementNumber, 500);

```

我们还可以利用一些技巧使用超时调用 setTimeout 来模仿间歇调用 setInterval

```javascript
//可以使用超时调用来模拟间歇调用
var num = 0;
var max = 10;
function incrementNumber() {
num++;
//如果执行次数未达到 max 设定的值,则设置另一次超时调用
if (num < max) {
console.log("蛤蛤");
setTimeout(incrementNumber, 500);
} else {
alert("Done");
}
}
setTimeout(incrementNumber, 500);
```

此处有一个点需要注意，当使用 setInterval 的时候，如果处理的函数比较费时的话，会出现函数堆积的情况，因为 setInterval 的计时并不会等待函数执行完毕，也就是说，假设我的间隔时长为 500ms，而我的函数执行需要 1000ms，当我第一次调用的函数还没有执行完的时候，第二次调用又已经开始了，这样函数堆积起来不光影响性能，还会导致计时混乱，因为我们直观理解的间隔计时就是第一个函数执行完毕到第二个函数开始执行的这段时间。当使用 setTimeout 模拟的间歇调用的时候就不会出现这种情况，同时它的计时也是从一个函数结束开始计时的。所以一致推荐使用 setTimeout 来模拟间歇调用。

***4.JavaScript 执行机制***

既然说到了 setTimeout，那这里也就有必要提一下 JavaScript 的执行机制了，作为一门网页脚本语言，JavaScript 的用途决定了它单线程的命运，在单线程里，所有的代码都是同步执行的，也就是说，后面的代码必须要等待前面的代码执行完毕之后才能被执行到，这是一种效率极低方式，特别是当前面的代码有涉及到设备 IO 和数据库存取等耗时操作时，整个线程将会处于挂起状态，严重情况下甚至会导致整个网页失去响应，因为在等待状态的时候网页是没有办法响应用户操作的，这也就是常说的代码阻塞，特别是很多时候当处于阻塞状态时，CPU 的负载并不高，这就在另一方面造成了性能的浪费。超时调用 setTimeout 就是一个非常常见的阻塞操作，除此之外还有 Ajax 的异步请求以及 DOM 事件。

JavaScript 的执行机制正是为了解决它的单线程的局限性而来的，它的基本想法是这样的：
对于那些比较耗时的操作（DOM，Ajax，setTimeout 这些），可以暂时把它们放到别的地方去让它们自己去执行，我的主线程继续执行这之后的代码，当那些耗时操作在另一个地方执行完毕的时候，再把该操作对应的回调函数加入到主线程中来去执行，这就是异步操作，所以在 JavaScript 代码里会同时存在同步任务和异步任务，同步任务指的是，在主线程上排队执行的任务，只有前一个任务执行完毕，才能执行后一个任务；异步任务是指不在主线程上执行的任务，它必须带有回调函数，用于异步任务执行完毕之后进行后续的处理。

在 JavaScript 的底层实现中，执行机制一般有以下几步：
一、按顺序扫描代码，把所有同步任务加入主线程，形成一个执行栈；
二、把扫描到的异步任务另外执行，并在异步任务执行完毕后放入到一个“回调队列”中，处于等待被执行的状态；
三、当执行栈中的所有任务执行完毕时，系统就会读取"回调队列"，让最早排队的那个事件结束等待状态，进入执行栈，开始执行。
四、重复第三步。

用图表示如下：
![此处输入图片的描述][1]
图中的 stack 即为执行栈，WebAPIs 为异步任务执行的地方，图下方是一个回调队列，回调队列与执行栈之间有一个“事件循环（Event Loop）”的东西，它是用来监视执行栈的，一旦执行栈里的任务全部执行完毕后，事件循环会马上从回调队列里取出一个位于队列头部的事件，把它丢进执行栈中执行。

这里举一个执行机制的例子，我们知道 setTimeout 是异步任务的一种，在一开始它是不会进入执行栈的，我们先写一段代码如下：

```javascript
setTimeout(function(){console.log('1');},0);
console.log('2');
```

这段代码的第一行是一个超时调用 setTimeout，它是一个异步任务，第二行代码是一个控制台输出，它是一个同步任务。在执行的时候，setTimeout 不会进入执行栈，而是在别的地方进行它的计时，当计时结束后会进入回调队列等待被事件循环加进执行栈中执行，在这期间代码会继续往下执行，所以这段代码最终的运行结果是先在控制台输出 2，最后再在控制台输出 1。如果现在你能理解这个例子，那就说明你已经对执行机制有了初步的了解，在执行机制的基础上还有很多复杂的运用，后面我们还会遇到越来越难的东西。

从上面这么多的解释我们还可以发现一个小特性，那就是

由于事件机制的存在，使得 setTimeout 并不完全会在指定的时间后被执行，知道是为什么吗？因为当计时结束的时候，setTimeout 里面的函数只是被加到了回调队列里，除非此时执行栈是空的，否则就还会有一段等待的时间，当然这段时间也不光是等待执行栈清空的时间，也包含了等待回调队列前面的函数被执行的时间。

### Location 对象

location 对象既是一个 Wwindow 对象的属性，也是一个 Ddocument 对象的属性，它可以访问当前浏览器 URL 的字符串信息，也可以通过更改浏览器位置信息来实现 URL 跳转等操作，具体看书，此处上图两张。
![此处输入图片的描述][2]
![此处输入图片的描述][3]

### Navigator 对象

Navigator 对象一般用来查看浏览器的各种版本信息，也可以用来检测插件，但最常用的还是用它查看浏览器的代理信息从来进行浏览器兼容。
方法：
![此处输入图片的描述][4]

用户代理信息：
![此处输入图片的描述][5]

除此之外，没有介绍的还有 Hhistory 对象和 Sscreen 对象，这几个都是不常用的，而且兼容问题也很严重，浏览器长年累月的各成一派已经使得拥有一个跨浏览器的解决方案的难度非常大。
其中，Hhistory 对象有如下特点
![此处输入图片的描述][6]



### 浏览器兼容（客户端检测）

***1.能力检测***
最常用也最为人们广泛接受的客户端检测形式是能力检测(又称特性检测)。能力检测的目标不是
识别特定的浏览器,而是识别浏览器的能力。采用这种方式不必顾及特定的浏览器如何,只要确定
浏览器支持特定的能力,就可以给出解决方案。能力检测的基本模式如下:
```javascript
//IE5.0 之前的版本不支持 document.getElementById() 这个 DOM 方法。尽管可以使
//用非标准的 document.all 属性实现相同的目的,但 IE 的早期版本中确实不存在 document.get-
//ElementById() 。于是,也就有了类似下面的能力检测代码:
function getElement(id) {
  if (document.getElementById) {
    return document.getElementById(id);
  } else if (document.all) {
    return document.all[id];
  } else {
    throw new Error("No way to retrieve element!");
  }
}
//进行能力检测的时候一定要检测实际用到的特性，不能根据能力检测来判断当前浏览器
//最好使用 typeof 操作符去进行能力检测，因为你检测的目标很可能是某个对象的属性
if(object.sort){
//...
}//这样写是不对的，万一我有某个对象刚好有个属性叫做 sort 呢？

if(typeof object.sort == 'function') {
//...
}//这样写比较好
```

***2.怪癖检测***
与能力检测类似,怪癖检测的目标是识别浏览器的特殊行为。但与能力检测确认浏览器支持什么能力不同,怪癖检测是想要知道浏览器存在什么缺陷(也就是 bug)。由于检测“怪癖”涉及运行代码,因此建议仅检测那些对你有直接影响的“怪癖”
,而且最好在脚本一开始就执行此类检测,以便尽早解决问题。

***3.用户代理检测***
程序通过检测用户代理字符串来识别浏览器。用户代理字符串中包含大量与浏览器有关的信息,包括浏览器、平台、操作系统及浏览器版本。用户代理字符串有过一段相当长的发展历史,在此期间,浏览器提供商试图通过在用户代理字符串中添加一些欺骗性信息,欺骗网站相信自己的浏览器是另外一种浏览器。用户代理检测需要特殊的技巧,特别是要注意 Opera 会隐瞒其用户代理字符串的情况。即便如此,通过用户代理字符串仍然能够检测出浏览器所用的呈现引擎以及所在的平台,包括移动设备和游戏系统。

在决定使用哪种客户端检测方法时,一般应优先考虑使用能力检测。怪癖检测是确定应该如何处理代码的第二选择。而用户代理检测则是客户端检测的最后一种方案,因为这种方法对用户代理字符串具有很强的依赖性（而用户代理字符串可能具有欺骗性）。

## DOM
DOM 是文档对象模型 (Document Object Model) 是 HTML 和 XML 文档的编程接口。它提供了对文档的结构化的表述，并定义了一种方式可以使从程序中对该结构进行访问，从而改变文档的结构，样式和内容。DOM 将文档解析为一个由节点和对象（包含属性和方法的对象）组成的结构集合。简言之，它会将  Web 页面和脚本或程序语言连接起来。

###节点类型
Node.ELEMENT_NODE (1);（元素节点）
Node.ATTRIBUTE_NODE (2);（属性节点）
Node.TEXT_NODE (3);（文本节点）
Node.CDATA_SECTION_NODE (4);
Node.ENTITY_REFERENCE_NODE (5);
Node.ENTITY_NODE (6);
Node.PROCESSING_INSTRUCTION_NODE (7);
Node.COMMENT_NODE (8);
Node.DOCUMENT_NODE (9);（文档节点）
Node.DOCUMENT_TYPE_NODE (10);
Node.DOCUMENT_FRAGMENT_NODE (11);
Node.NOTATION_NODE (12)。

其中最重要的节点类型有三个：元素节点，属性节点，文本节点

在确定元素节点类型的时候有两种写法：
```javascript
//第一种是把节点的 nodeType 属性跟节点类型的名称作比较，这种方法在 IE 下不适用
if (someNode.nodeType == Node.ELEMENT_NODE) { //如果成立则是元素节点
    alert("Node is an element.");
}

//一般采用的是这第二种方法，跟节点类型对应的数字作比较
if (someNode.nodeType == 1){
    alert("Node is an element.");
}
```

***节点属性***
节点有三个最重要的属性：
1. nodeName : 节点的名称
2. nodeValue ：节点的值
3. nodeType ：节点的类型

一、nodeName 属性: 节点的名称，是只读的。
1. 元素节点的 nodeName 与标签名相同
2. 属性节点的 nodeName 是属性的名称
3. 文本节点的 nodeName 永远是 #text
4. 文档节点的 nodeName 永远是 #document
 
二、nodeValue 属性：节点的值
1. 元素节点的 nodeValue 是 undefined 或 null
2. 文本节点的 nodeValue 是文本自身
3. 属性节点的 nodeValue 是属性的值
 
三、nodeType 属性: 节点的类型，是只读的。以下常用的几种结点类型:
```
元素类型    节点类型
   元素          1
   属性          2
   文本          3
   注释          8
   文档          9
```
### 节点关系

```javascript
childNodes  //访问当前元素的所有子节点
firstChild  //访问第一个子节点
lastChild   //访问最后一个子节点
parentNode  //访问父节点
nextSibling //访问下一个兄弟节点
previousSibling //访问前一个兄弟节点

```

### 节点操作

```javascript
//创建节点的方法：
createElement()
createTextNode()

//向 chileNodes 末尾添加一个节点，返回值为新添加的这个节点
appendChild ()
var returnedNode = someNode.appendChild(newNode);
alert(returnedNode == newNode);//true
alert(someNode.lastChild == newNode);//true
/*如果传入到 appendChild() 中的节点已经是文档的一部分了,那结果就是将该节点从原来的位置
转移到新位置。即使可以将 DOM 树看成是由一系列指针连接起来的,但任何 DOM 节点也不能同时出
现在文档中的多个位置上。因此,如果在调用 appendChild() 时传入了父节点的第一个子节点,那么
该节点就会成为父节点的最后一个子节点*/

//把节点插入到某个子节点之前
insertBefore() 
/*这个方法接受两个参数:要插入的节点和作为参照的节点。插入节点后,被插入的节点会变成参照节点的前一个同胞节点( previousSibling ),同时被方法返回。如果参照节点是 null ,则 insertBefore() 与 appendChild() 执行相同的操作*/

//插入后成为最后一个子节点
returnedNode = someNode.insertBefore(newNode, null);
alert(newNode == someNode.lastChild);//true
//插入后成为第一个子节点
var returnedNode = someNode.insertBefore(newNode, someNode.firstChild);
alert(returnedNode == newNode);//true
alert(newNode == someNode.firstChild); //true
//插入到最后一个子节点前面
returnedNode = someNode.insertBefore(newNode, someNode.lastChild);
alert(newNode == someNode.childNodes[someNode.childNodes.length-2]); //true

replaceChild()
//replaceChild() 方法接受的两个参数是:要插入的节点和要替换的节点。要替换的节点将由这个方法返回并从文档树中//被移除,同时由要插入的节点占据其位置。

//替换第一个子节点
var returnedNode = someNode.replaceChild(newNode, someNode.firstChild);
//替换最后一个子节点
returnedNode = someNode.replaceChild(newNode, someNode.lastChild);
//replaceChild 并不是将被替换的节点完全抹去，只是把它的指针替换，它本身并没有消失，还是真实存在的，但是文档中已经没有它的位置了

//如果只想移除而非替换节点,可以使用 removeChild() 方法。这个方法接受一个参数,即要移除的节点。
```

### Document 操作

document.getElementById()
document.getElementsByTagName()
document.getElementsByName()

### Element 操作

操作各个元素的属性的方法有两种：一种是用编程方式去访问节点对象，一种是用 Element 操作，Element 操作使用下面三种方法：
***getAttribute()***
接收一个参数，即需要获取值的属性名，该方法返回当前节点的目标属性的属性值。

***setAttribute()***
接收两个参数，一个是属性名，第二个是属性值，用于设置当前节点的属性。

***removeAttribute()***
接收一个参数，即属性名，移除当前节点的该属性。

有两类特殊的特性,它们虽然有对应的属性名,但属性的值与通过 getAttribute() 返回的值并不相同。第一类特性就是 style ,用于通过 CSS 为元素指定样式。在通过 getAttribute() 访问时,返回的 style 特性值中包含的是 CSS 文本,而通过编程属性来访问它则会返回一个对象。

第二类与众不同的特性是 onclick 这样的事件处理程序。当在元素上使用时, onclick 特性中包
含的是 JavaScript 代码,如果通过 getAttribute() 访问,则会返回相应代码的字符串。而在通过编程方式访问
onclick 属性时,则会返回一个 JavaScript 函数(如果未在元素中指定相应特性,则返回 null )
。这是因为 onclick 及其他事件处理程序属性本身就应该被赋予函数值。

由于存在这些差别,在通过 JavaScript 以编程方式操作 DOM 时,开发人员经常不使用 getAttri-
bute() ,而是只使用对象的属性。


这里先附一张 DOM 操作的思维导图，DOM 里面涉及到的操作都在图里：
![此处输入图片的描述][7]


### DOM 拓展

querySelector 和 querySelectorAll
querySelector 和 querySelectorAll 是 DOM 选择符 API 里面新增的两个方法，它们支持以 CSS选择器 的形式去获取节点，这里不赘述。

querySelectorAll 与 getElementsBy 方法最大的不同就是它返回的是一个静态的 nodeList，而 getElementsBy 系列方法返回的是一个动态的 nodeList，看代码：

***HTML***
```html
<ul>
    <li></li>
    <li></li>
    <li></li>
</ul>
```
***JavaScript***
```javascript
// Demo 1
var ul = document.querySelectorAll('ul')[0],
    lis = ul.querySelectorAll("li");
for(var i = 0; i < lis.length ; i++){
    ul.appendChild(document.createElement("li"));
}
/*这里使用 querySelectorAll 来获取所有 li 元素，方法返回一个 nodeList，然后执行一个相当于 nodeList 长度的循环，每次循环都新增一个 li，这段代码最终就产生三个新的 li*/

// Demo 2
var ul = document.getElementsByTagName('ul')[0], 
    lis = ul.getElementsByTagName("li"); 
for(var i = 0; i < lis.length ; i++){
    ul.appendChild(document.createElement("li")); 
}
/*这里使用了 document.getElementsByTagName 来获取 li 元素，同样执行一个 nodeList 长度的循环，但是这段代码会进入死循环，原因在于使用 document.getElementsByTagName 所返回的是一个动态的 nodeList，即 lis 变量是动态的，我每次访问这个变量，它都会重新计算新的值并且更新，所以我的 for 循环里每一次访问 lis.length，它都是不一样的，因为每次循环 lis 的长度都会增加，这样就使这段代码陷入的死循环，而上面的 querySelectorAll 方法恰恰相反，它返回的是一个静态 nodeList，它们两者之间最大的区别就在于此 */
```

PS：这篇博文篇幅比较长，因为客户端 JavaScript 的内容实在不少，本文也只是选取了其中比较常用并且重要的知识进行介绍，要想全面理解客户端 JavaScript 还是要好好看书。

## 参考资料

[JavaScript DOM 概述][8]
[JavaScript 运行机制详解：再谈Event Loop][9]


  [1]: http://7xiuuj.com1.z0.glb.clouddn.com/EventLoop.png
  [2]: http://7xiuuj.com1.z0.glb.clouddn.com/1406945151689398.png
  [3]: http://7xiuuj.com1.z0.glb.clouddn.com/Location_URL.png
  [4]: http://7xiuuj.com1.z0.glb.clouddn.com/Navigator.png
  [5]: http://7xiuuj.com1.z0.glb.clouddn.com/UA.png
  [6]: http://7xiuuj.com1.z0.glb.clouddn.com/1406944676467640.png
  [7]: http://7xiuuj.com1.z0.glb.clouddn.com/63918611gw1ek0h01ps7yg20ve1rowjt.gif
  [8]: https://developer.mozilla.org/zh-CN/docs/Web/API/Document_Object_Model/Introduction
  [9]: http://www.ruanyifeng.com/blog/2014/10/event-loop.html