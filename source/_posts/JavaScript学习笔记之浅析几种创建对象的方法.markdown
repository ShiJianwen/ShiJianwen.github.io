title: JavaScript学习笔记之浅析几种创建对象的方法
date: 2015-04-11 14:25:10
categories: "JavaScript"

---
&emsp;&emsp;在 JavaScript 中，创建对象有几种方法，我们平时最常用的是用 Object 构造函数和对象字面量：
```javascript
    // Object 构造函数方法
    var person = new Object();
    person.name = "Sibarone";
    person.age = "19";
    
    //对象字面量方法
    var person = {
        name: "Sibarone",
        age: 19;
    };
```
<!-- more -->
&emsp;&emsp;这两种方法都能创建单个对象，但当用它们来创建多个类似对象时会产生很多重复的代码,因为每生成一个新对象都需要像上面那样重新定义一次，为了解决这类问题，人们开始使用各种模式方法去创建对象，常见的有：

***工厂模式***
```javascript
    function createPerson (name, age, job) {
        var o = new Object();
        o.name = name;
        o.age = age;
        o.job = job;
        return o;
    }
    var person = createPerson ("ShiJianwen", 19, "Frontend Engineer");
```
&emsp;&emsp;工厂模式是用函数封装创建对象的接口，从而提高代码的复用性，在创建多个相似对象时无需重复定义，但工厂模式的缺点就是无法确定对象类型，即无法得知所创建对象是谁的实例，当你获取该对象的 constructor 属性时无法确定其对象类型，为此人们又提出了新的模式即构造函数模式。

***构造函数模式***
```javascript
    function Person (name, age, job) {
        this.name = name;
        this.age = age;
        this.job = job;
        this.alertName = function () {
            alert(this.name);
        };
    }
    var person1 = new Person("ShiJianwen", 19, "Frontend Engineer");
    var person2 = new Person("Sibarone", 19, "Frontend Engineer");
```
&emsp;&emsp;在使用构造函数模式时，可以解决工厂模式无法确定对象类型的问题，此时创建的函数的 constructor 属性即为构造函数 Person，并且当运行 `instanceof` 方法检测对象类型时也能确定对象类型如
```javascript
    person instanceof Object; //true
    person instanceof Person; //true
```
&emsp;&emsp;然而构造函数也并非完美，它会重复定义对象内的函数，就像上面代码的 `alertName` 函数一样，任何一个新建对象的内部都会新建一个 `alertName` 函数，在 JavaScript 里函数会被当做对象处理，所以每新建一个对象都会实例化一个新的 `alertName` 对象，以下代码可证明这点
```javascript
    console.log(person1.alertName == person2.alertName); //false
```
&emsp;&emsp;重复地实例化对象会增加性能开销，为了解决这个问题，就出现了原型模式

***原型模式***
&emsp;&emsp;在 JavaScript 里，创建的每一个函数都有一个 prototype 属性，该属性指向一个对象，其中包含所有实例共享的属性和方法，它同时也是所有通过这个构造函数创建的实例的原型对象（关于原型的知识将会在另一篇博文中详细提到）。使用原型模式创建的对象可以将对象实例的信息直接添加到原型对象中，然后让所有实例共享这些信息。像这样
```javascript
    function Person () {
        //构造函数为空函数
    }
    Person.prototype.name = "ShiJianwen";
    Person.prototype.age = 19;
    Person.prototype.job = "Frontend Engineer";
    var person = new Person() //实例化对象
```
&emsp;&emsp;在定义原型对象时，我们也可以用对象字面量的形式重写原型对象，像这样
```javascript
    function Person () {
        
    }
    Person.prototype = {
        name: "ShiJianwen",
        age: 19,
        job: "Frontend Engineer"
    };
```
&emsp;&emsp;在上面的代码中，我们通过重写字面量来定义原型对象，这样虽然能达到定义原型对象的目的，但是却会有一个严重的问题，就是此时定义的原型对象跟构造函数没有任何关系了。因为每一个原型对象在初始化都会拥有一个 `constructor` 属性，该属性指向这个原型对象对应的构造函数，像上面的 Person.prototype 对象它本来默认的 `constructor` 属性就是指向 Person 构造函数的，但是当我们用重写字面量的方式定义原型对象的时候会把 `constructor` 属性擦除，那么此时定义的原型对象跟构造函数唯一的联系就消失了，为了解决这个问题，我们需要在定义原型对象的时候手动加入 `constructor` 属性，像这样
```javascript
    function Person () {
        
    }
    Person.prototype = {
        constructor: Person,
        name: "ShiJianwen",
        age: 19,
        job: "Frontend Engineer"
    };
```
&emsp;&emsp;这样定义的原型对象就能跟构造函数保持原来的关系了。说完这个我们再转过原型模式创建对象这个问题上来，那么用原型模式来创建对象是不是就是最好的方法呢？当然不是，刚才说到了原型对象里面的所有变量和方法都会被构造函数的所有对象实例共享，如果原型对象只包含基本类型的变量还好，因为在对象实例中重写的基本类型变量会覆盖掉原型里面对应的变量，但是引用类型的变量不一样，如果原型对象里面定义了引用类型的变量，那么对象中所有引用类型的变量都是所有实例共用一份数据的，一旦在哪个实例中改变，那么就会在其他所有实例中体现出来。举个栗子：
```javascript
    function Person () {
        
    }
    Person.prototype = {
        constructor: Person,
        name: "ShiJianwen",
        age: 19,
        job: "Frontend Engineer",
        arr: [1,2,3,4,5]
    }
    //定义两个对象实例
    var person1 = new Person();
    var person2 = new Person();
    console.log(person1.arr); //输出[1,2,3,4,5]
    console.log(person2.arr); //输出[1,2,3,4,5]
    
    person1.name = "Sibarone"; //改变其中一个实例的基本类型值
    person1.arr[0] = 5;        //改变其中一个实例的引用类型值
    
    console.log(person1.name); //输出Sibarone，原型中的变量被覆盖
    console.log(person2.name); //输出ShiJianwen，依然是原型里的变量
    console.log(person1.arr); //输出[5,2,3,4,5]
    console.log(person2.arr); //输出[5,2,3,4,5]
```
&emsp;&emsp;在上面的例子中，由于原型中存在引用类型的变量（arr），所以实际上存储在原型对象中的是该引用类型变量的地址，于是在所有实例对象中该地址都指向同一个数组，只要其中一个实例改变了该数组的元素，那么其他实例也会跟着改变，这就是使用原型模式不好的地方。
&emsp;&emsp;所以，为了弥补这些模式诸多的缺点，我们可以使用多种模式组合创建对象的方式，比如构造函数模式跟原型模式的组合使用就是如今创建对象最常见的方式，其中用构造函数模式来定义属性，用原型模式来定义实例间共享的方法和属性，这样既避免了重复定义对象的内存浪费，又避免了因为共享造成的使用不方便的问题。我们可以用这种模式来重新定义前面的例子：
```javascript
    function Person (name, age, job) {
        this.name = name;
        this.age = age;
        this.job = job;
        this.arr = [1,2,3,4,5];
    }
    Person.prototype = {
        constructor: Person,
        alertName: function () {
            alert(this.name);
        }
    };
    var person1 = new Person();
    var person2 = new Person();
    
    person1.arr[0] = 5;
    
    console.log(person1.arr);//输出 [5,2,3,4,5]
    console.log(person2.arr);//输出[1,2,3,4,5]
    
```
&emsp;&emsp;这样就不存在前面说的那些问题啦。当然如果你觉得这样把两种模式独立起来创建对象不好的话也可以使用***动态原型模式***，它就是在同一个构造函数中初始化对象，同时保持使用原型模式和构造函数模式的优点。再来个栗子：
```javascript
    function Person (name, age, job) {
        this.name = name;
        this.age = age;
        this.job = job;
        
        if(typeof this.alertName != "function") {
            Person.prototype.alertName = function () {
                alert(this.name);
            }
        }
    }
```
&emsp;&emsp;这样就是能在同一个构造函数中初始化对象而不用把两种模式独立起来使用。除此之外，在上面几种模式都不适用的情况下，我们可以试试使用***寄生构造函数模式***，栗子如下：
```javascript
    function Person (name, age, job) {
        var o = new Object();
        o.name = name;
        o.age = age;
        o.job = job;
        o.alertName = function () {
            alert(this.name);
        }；
        return o;
    }
    var person = new Person();
```
&emsp;&emsp;这种模式看起来像是工厂模式和构造函数模式的结合，它的基本思想就是创建一个函数，用来封装创建对象的代码。这个模式可以在特殊情况下为对象创建构造函数，比如我们想要数组拥有一个特殊的方法，但是我们却不能去修改 Array 构造函数，这是就可以使用这种模式：
```javascript
    function specialArr () {
        var values = new Array();
        values.push.apply(values,arguments);
        values.pipedString = function () {
            return this.join("|");
        };
        return values;
    }
    var arr = new specialArr(1,2,3);
    console.log(arr.pipedString()); //输出[1|2|3]
```
&emsp;&emsp;上面的例子定义一个可以创建特殊数组的构造函数，我们在里面定义了 `pipedString` 方法，它可以生成一个用 “|” 分割的数组，一般来说在 Array 构造函数里面是不允许修改 Array 构造函数，所以就无法借助 Array 构造函数来生成这个特殊数组，但是使用寄生构造函数模式就能达到这个目的，这也就是它为什么叫寄生构造函数模式的原因，因为它能够在不影响其他构造函数的情况下去拓展这个构造函数。但是使用它有一个需要注意的地方就是它跟工厂模式一样无法确定对象类型，用它创建的对象实例跟这个构造函数之间没有任何关系，所以在能用其他模式创建对象的情况下，一般不建议用这种模式创建。
&emsp;&emsp;在寄生构造函数模式之后，有人提出了***稳妥对象***的概念，稳妥对象指的是没有公共属性，且其中方法不访问 this 关键字的对象，这种对象能够保证数据的安全并且防止数据被其他应用程序使用，这种模式也适合在一些安全要求比较高的环境中使用，具体实例如下：
```javascript
    function Person (name, age, job) {
        var o = new Object();
        o.alertName = function () {
            alert(name);
        };
        return o;
    }
    var person = Person("ShiJianwen", 19, "Frontend Engineer");
    person.alertName();//输出ShiJianwen
```
&emsp;&emsp;从上面的代码看起来，稳妥构造函数模式跟寄生构造函数模式很像，但不同的是，稳妥构造函数模式没有引用 this，同时在实例化时也没有使用 new 操作符。这种模式下创建的对象中除了那个 alertName 函数，谁也无法访问 name 属性，这种安全性就是该模式最大的特点。但同样要注意的是，稳妥构造函数模式跟寄生构造函数模式一样，创建的对象都无法确定其对象类型。
&emsp;&emsp;好了，总的这几种创建对象方法都讲得差不多了，其中关于原型的知识可能没有说得太明白有些人依旧会有些迷惑，所以有关原型跟原型链的知识我都会写在另一篇博文中，敬请期待。