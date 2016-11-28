title: JavaScript学习笔记之深入理解继承
date: 2015-05-02 12:44:11
categories: JavaScript

---

&emsp;&emsp;之前说到了创建对象的几种方法，所以决定在这里讲讲对象继承的几种方法，两者有所共通，如果这里的文章有何不解可以参考前一篇文章 [JavaScript 学习笔记之创建对象的几种方法][1]。


###1.原型链继承

&emsp;&emsp;***原型链***
&emsp;&emsp;在讲继承之前先来说一下关于原型链的事情，JavaScript 是依靠原型链来实现继承的，之前讲过构造函数，原型与实例之间的关系：每一个构造函数都会有一个自己的原型对象比如 Object.prototype，构造函数用一个内部属性 [[prototype]] 指向该原型对象；原型对象包含一个指向构造函数的指针 constructor；而每一个实例也都有一个指向原型对象的内部指针 __proto__。假设当前构造函数 A 的原型对象 A.prototype 等于另一个构造函数 B 的实例的话，那么此时 A.prototype 内部将会有一个指向构造函数 B 的原型对象 B.prototype 的指针，B.prototype 里也会有指向构造函数 B 的指针（***因为刚才说了每一个实例都会有一个指向原型对象的内部指针 __proto__，所以如果我当前这个原型对象 A.prototype 是另一个构造函数 B 的实例的话它就有了双重身份了，也就是说这个原型对象 A.prototype 它现在既是一个原型对象也是一个实例，既然是构造函数 B 的实例，就一定会有一个指向 B.prototype 的指针，相应地，在 B.prototype 里面也会包含着一个指向构造函数 B 的指针***）。同样的，如果此时 B.prototype 又是另外一个原型的实例的话，上述关系也依然成立，这样一直延续下去，就构成了一条原型链。用图表示出来就是这样：
<!-- more -->
![原型链][2]


&emsp;&emsp;此外，所有引用类型的数据都是默认继承自 Object 的，所以任何一个引用类型数据的默认原型都是 Object 的实例，它们内部都有一个指针指向 Object.prototype，这也是所有引用类型数据都有 toString(),valueOf() 方法的原因，所以在上图的原型链中还应在最上方加入一个 Object 继承层次。实现原型链继承的代码基本如下：
```javascript
    function Father () {
        this.fatherProperty = true;
    }
    Father.prototype.getFatherValue = function () {
        return this.fatherProperty;
    };
    function Son () {
        this.sonProperty = false;
    }
    
    //继承父类
    Son.prototype = new Father();
    Son.prototype.getSonValue = function () {
        return this.sonProperty;
    };
    
    //实例化
    var oneObject = new Son();
    console.log(oneObject.getFatherValue());
```

&emsp;&emsp;上面的代码中，Son 类型继承自 Father 类型，我们把 Father 的实例赋给 Son 的原型，达到重写 Son 的原型对象的目的，也达到了实现原型链的目的（***此时 Son 的原型内部有指向 Father 原型的指针***）。实现原型链后，我们的原型搜索机制也会因此得到拓展，当我们访问一个实例属性的时候，首先会在当前实例中查找该属性，如果没有则会继续搜索该实例的原型，在通过原型链实现继承的情况下，该搜索过程会沿着原型链继续往上直到原型链末端。同时有一点需要注意的是，上面的代码中我们定义 Son 类型的 getSonValue 方法的时候是在继承父类之后才添加进去的，在使用原型链继承的时候特别要注意这一点，因为我们在继承父类的时候是通过重写子类原型对象的方法来实现继承的，如果我的子类原型方法定义在继承父类之前，那么当我继承父类重写原型对象的时候我之前定义的子类原型方法就会被擦除。

&emsp;&emsp;***原型链的问题***
&emsp;&emsp;之前也讲到过，原型方式创建对象的问题就是引用类型数据的问题，在原型继承中这个问题也同样存在，原因跟用原型创建对象一样，原型属性中如果存在引用类型数据的话会被所有实例共享，如果你有多个实例，那么只要更改其中一个实例中的该属性，就会在所有实例中体现出来。除此之外，原型链继承的第二个问题就是很难在不影响所有实例的情况下给父类型的构造函数传递参数（***因为不能通过传参在父类中定义属性，在父类中定义不符合面向对象编程的规则，属性应该由实例来定义，如果在父类定义，就会强制给所有实例继承这个属性***）。基于这两个问题，实践中很少会单独使用原型链。


###2.借用构造函数

&emsp;&emsp;在讲创建对象的几种方式的时候，我们也使用过构造函数来解决原型带来的问题，在这里也是如此，为了解决原型继承中引用类型值的问题，我们采用借用构造函数的方法，其基本原理就是：在子类型构造函数内部调用父类型的构造函数从而实现从父类型的继承，同样考虑到函数的执行环境，我们一般通过使用 `apply()` 或者 `call()` 方法来调用父类型构造函数。具体代码如下：

```javascript
    function Father () {
        this.numbers = [1,2,3,4,5];
    }
    function Son () {
        //继承父类
        Father.call(this);
    }
    
    //实例化
    var Object1 = new Son();
    var Object2 = new Son();
    
    //更改其中一个实例的值
    Object1.numbers.push(6);
    
    console.log(Object1.numbers); // [1,2,3,4,5,6]
    console.log(Object2.numbers); // [1,2,3,4,5]
```
&emsp;&emsp;上面的代码在子类中调用父类构造函数实现了继承，虽然 numbers 是引用类型值，但因为继承是在每一个子类中单独调用父类的，所以每一个实例都会拥有一份数据副本，不会共享。除此之外，借用构造函数还能解决原型链继承中不能向父类传递参数的问题，代码如下：

```javascript
    function Father (name) {
        this.name = name;
    }
    function Son () {
        Father.call(this,"ShiJianwen");
    }
    
    var Object1 = new Son();
    console.log(Object1.name); // ShiJianwen
```

&emsp;&emsp;***构造函数的问题***
&emsp;&emsp;虽然借用构造函数能够解决原型链的两大问题，但它自己也不是完美的，借用构造函数继承的时候，所有函数这些可复用的东西你都要重新定义一遍，因为实际上你就是通过构造函数在继承，每实例化一次你就重新定义一次所有属性和方法，所以根本没有代码复用性可言。还有一个问题也是由于构造函数继承导致的，那就是你父类型中原型里定义的所有东西都无法继承到子类中，只有在父类构造函数中定义的东西才能继承到子类，具体代码如下：

```javascript
    function Father (name) {
        this.name = name;
    }
    //在父类型原型中定义属性和方法
    Father.prototype.Say = function () {
        console.log('aa');
    };
    Father.prototype.age = 19;
    
    function Son () {
        Father.call(this,"ShiJianwen");
    }
    
    var Object1 = new Son();
    console.log(Object1.age); // undefined
    console.log(Object1.Say()); // Object1.Say() is not a function
```
&emsp;&emsp;所以一般也不建议使用这种方法继承。

###3.组合继承

&emsp;&emsp;组合继承是指结合原型继承和借用构造函数两种方法来实现继承的方法，它的本质是用原型链实现对原型属性和方法（可复用的代码）的继承，用构造函数实现对实例属性（不适合共享的代码）的继承。这样既能实现代码复用，也能实现每个实例都有自己的一套属性，是 JavaScript 中最常用的实现继承的方法。代码如下：

```javascript
    function Father (name) {
        this.name = name;
        this.numbers = [1,2,3,4,5];
    }
    Father.prototype.Say = function () {
        console.log(this.name);
    };
    
    function Son (name, age) {
        //用构造函数方法继承父类
        Father.call(this, name);
        this.age = age;
    }
    
    //用原型链继承方法
    Son.prototype = new Father();
    Son.prototype.constructor = Son;
    Son.prototype.sayAge = function () {
        console.log(this.age);
    };
    
    //实例化
    var Object1 = new Son("Sibarone", 19);
    var Object2 = new Son("ShiJianwen", 19);
    
    Object1.numbers.push(6);
    
    Object1.Say(); // Sibarone
    Object2.Say(); // ShiJianwen
    
    console.log(Object1.numbers); // [1,2,3,4,5,6]
    console.log(Object2.numbers); // [1,2,3,4,5]
```
###4.原型式继承

&emsp;&emsp;原型式继承跟原型链继承有很大不同，它的本质是借助原型基于已有的对象创建新对象，代码如下：

```javascript
    function object (o) {
        //创建一个空对象
        function F () {}
        //用原型实现在原有对象 o 的基础上继承
        F.prototype = o;
        //返回这个对象
        return new F ();
    }
```

&emsp;&emsp;这种继承方式要求你必须要有一个现成的基础对象供你继承，当你只是需要定义一个与另一个对象相似的对象并且不想大动干戈去创建构造函数的时候，这种方法是可行的，为了规范化这种继承方式，ECMAScript5 为此新增了 Object.create() 方法，但有一点需要注意的是：原型式继承跟原型链一样，对于引用类型值是共享一套数据的，所以具体相关请自主取舍。

###5.寄生式继承

&emsp;&emsp;寄生式继承跟原型式继承非常相似，它们都是由 JavaScript 大神 DK 推广的，所以它们的思路类似，代码如下：
```javascript
    function object (o) {
        function F () {}
        F.prototype = o;
        return new F ();
    }
    
    function createObject (origin) {
        var clone = object(origin);
        clone.sayHi = function () {
            alert('Hi');
        };
        return clone;
    }
    
    //使用寄生式继承
    //定义原始对象
    var person = {
        name: "ShiJianwen",
        numbers: [1,2,3,4,5]
    };
    
    var onePerson = createObject(person);
    onePerson.sayHi();
```

&emsp;&emsp;在这个例子中，object 函数不是必需的，任何能够返回新对象的函数都能取代它，同样注意：使用寄生式继承跟构造函数模式一样，不能做到函数代码复用。

###6.寄生组合继承

&emsp;&emsp;寄生组合继承是为了弥补组合继承中的不足而来的，虽然组合继承是最常用的继承方式，但它还是存在一个问题，就是在使用它的时候会先后调用两次父类型构造函数，这样就会导致实例和原型中拥有两套相同属性，举个例子，在组合继承中代码实现如下：
```javascript
    function Father (name) {
        this.name = name;
        this.numbers = [1,2,3,4,5];
    }
    Father.prototype.Say = function () {
        console.log(this.name);
    };
    
    function Son (name, age) {
        //用构造函数方法继承父类
        Father.call(this, name);  //第二次调用 Father()
        this.age = age;
    }
    
    //用原型链继承方法
    Son.prototype = new Father(); //第一次调用 Father()
    Son.prototype.constructor = Son;
    Son.prototype.sayAge = function () {
        console.log(this.age);
    };
    
```

&emsp;&emsp;在上面的代码中，我们在定义子类型的时候调用过一次父类型构造函数，在定义子类型的原型的时候又调用了一次，这样一来，子类型的实例和原型中将会拥有两套完全相同的来自父类型的属性，这样会造成不必要的性能以及内存浪费。寄生组合式继承就是为了解决这个问题而生的，所谓寄生组合式继承，就是利用寄生式继承来继承父类型的原型，然后再把结果赋给子类型的原型，基本模式如下：

```javascript
    function inheritPrototype (son, father) {
        var prototype = object(father.prototype); //取出一份父类型原型的副本
        prototype.constructor = son; //让实例跟原型重新联系起来
        son.prototype = prototype;
    }
```

&emsp;&emsp;上例中的 inheritPrototype() 函数实现了一个简单的寄生组合式继承，这个函数接受两个参数分别是子类型和父类型的构造函数，第一步是创建父类型的一个副本，第二部是添加 constructor 属性让实例跟原型重新联系起来（因为原型经过重写），最后一步是将新创建的对象赋值给子类型的原型，这样我们就能用这个函数替换掉上面组合继承中的 `Son.prototype = new Father();` 这一句了，在使用寄生组合式继承的时候我们只调用了一次父类型构造函数，因此避免了重复定义属性，同时原型链也没有遭到破坏，因此普遍认为寄生组合式继承是引用类型最理想的继承方式。


  [1]: http://shijianwen.github.io/2015/04/11/JavaScript%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0%E4%B9%8B%E6%B5%85%E6%9E%90%E5%87%A0%E7%A7%8D%E5%88%9B%E5%BB%BA%E5%AF%B9%E8%B1%A1%E7%9A%84%E6%96%B9%E6%B3%95/
  [2]: http://7xiuuj.com1.z0.glb.clouddn.com/scope.png