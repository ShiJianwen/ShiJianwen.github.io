title: 浅谈 React、Flux 与 Redux
date: 2016-6-30 19:02:10
categories: "JavaScript"

---
###React
React 是一个 View 层的框架，用来渲染视图，它主要做几件事情：
-  组件化
-  利用 props 形成单向的数据流
-  根据 state 的变化来更新 view
-  利用虚拟 DOM 来提升渲染性能

![](http://7tszky.com1.z0.glb.clouddn.com/FgHh-hjZfigrSqf_9MZhjgmknC5N)

<!-- more -->
前面说到 React 能够根据 state 的变化来更新 view，一般来说引起 state 变化的动作除了来自外部（如服务器），大部分都来自于页面上的用户活动，那页面上的用户活动怎样对 state 产生作用呢？React 中每个组件都有 setState 方法用于改变组件当前的 state，所以可以把更改 state 的逻辑写在各自的组件里，但这样做的问题在于，当项目逻辑变得越来越复杂的时候，将很难理清 state 跟 view 之间的对应关系（一个 state 的变化可能引起多个 view 的变化，一个 view 上面触发的事件可能引起多个 state 的改变）。我们需要对所有引起 state 变化的情况进行统一管理，于是就有了 Flux。 

###Flux
Flux 是一种应用架构，或者说是一种思想，它跟 React 本身没什么关系，它可以用在 React 上，也可以用在别的框架上。前面说到 Flux 在 React 中主要用来统一管理引起 state 变化的情况。Flux 维护着一个或者多个叫做 `Store` 的变量，就像 MVC 里面的 Model，里面存放着应用用到的所有数据，当一个事件触发时 ，Flux 对事件进行处理，对 Store 进行更新，当 Store 发生变化时，通常是由应用的根组件（也叫 controller view）去获取最新的 store，然后更新 state，之后利用 React 单向数据流的特点一层层将新的 state 向下传递实现 view 的更新。这里的 controller view 可以有多个也可以不是根组件，但是这样数据流维护起来就比较麻烦。

Flux 的思维模型如下：
![](http://7tszky.com1.z0.glb.clouddn.com/FonZpI0A0bUAcv1jwAhJdALdqDOj)

Flux 主要包括四个部分，`Dispatcher`、`Store`、`View`、`Action`，其中 Dispatcher 是 Flux 的核心枢纽，它相当于是一个事件分发器，将那些分散在各个组件里面的逻辑代码收集起来，统一在 Dispatcher 中进行处理。完整的 Flux 处理流程是这样的：用户通过与 view 交互或者外部产生一个 Action，Dispatcher 接收到 Action 并执行那些已经注册的回调，向所有 Store 分发 Action。通过注册的回调，Store 响应那些与他们所保存的状态有关的 Action。然后 Store 会触发一个 change 事件，来提醒 controller-views 数据已经发生了改变。Controller-views 监听这些事件并重新从 Store 中获取数据。这些 controller-views 调用他们自己的 setState() 方法，重新渲染自身以及组件树上的所有后代组件。使用 Flux 有个好处就是我只需要用 action 对象向 Dispatcher 描述当前的事件就可以执行对应的逻辑，因为 Dispatcher 是所有 Action 的处理中心，即使没有对应的事件发生，我们也可以“伪造”一个出来，非常利于测试。

###Redux
Redux 的作用跟 Flux 是一样的，它可以看作是 Flux 的一种实现，但是又有点不同，具体的不同总结起来就是：

***1. Redux 只有一个 store***
Flux 里面会有多个 store 存储应用数据，并在 store 里面执行更新逻辑，当 store 变化的时候再通知 controller-view 更新自己的数据，Redux 将各个 store 整合成一个完整的 store，并且可以根据这个 store 推导出应用完整的 state。同时 Redux 中更新的逻辑也不在 store 中执行而是放在 reducer 中。
***2. 没有 Dispatcher***
Redux 中没有 Dispatcher 的概念，它使用 reducer 来进行事件的处理，reducer 是一个纯函数，这个函数被表述为 `(previousState, action) => newState`，它根据应用的状态和当前的 action 推导出新的 state。Redux 中有多个 reducer，每个 reducer 负责维护应用整体 state 树中的某一部分，多个 reducer 可以通过 `combineReducers` 方法合成一个根reducer，这个根reducer负责维护完整的 state，当一个 action 被发出，store 会调用 dispatch 方法向某个特定的 reducer 传递该 action，reducer 收到 action 之后执行对应的更新逻辑然后返回一个新的 state，state 的更新最终会传递到根reducer处，返回一个全新的完整的 state，然后传递给 view。

在我看来，Redux 和 Flux 之间最大的区别就是对 store/reducer 的抽象，Flux 中 store 是各自为战的，每个 store 只对对应的 controller-view 负责，每次更新都只通知对应的 controller-view；而 Redux 中各子 reducer 都是由根reducer统一管理的，每个子reducer的变化都要经过根reducer的整合。用图表示的话可以像这样：

Flux 中的 store 是这样的：
![](http://7tszky.com1.z0.glb.clouddn.com/FulidOFq7yfm-fyPHy9qm50JDu-K)

Redux 中的 store（或者叫 reducer）是这样的：
![](http://7tszky.com1.z0.glb.clouddn.com/FqwrgoH93cl8a5f3oFc0XZL7waBQ)


ps：刚接触 React，很多地方了解地不是特别深入，如有错漏，欢迎指正。