title: Flutter 初探
date: 2018-04-02 0:48:10
categories: "移动开发"

---

> 对应用开发来说，跨平台是一个永恒的话题，无数工程师们在不断地探索技术的边界，使业界涌现了一批又一批优秀的跨平台开发框架，Flutter 就是其中的一员。本文旨在介绍 Flutter 的初阶使用，如果大家有兴趣，后面会陆续输出一些深入的文章。

## 什么是Flutter
Flutter 是由 Google 开源的一个全新的跨平台开发框架，致力于让开发者可以通过它在 iOS 和 Android 两个平台开发原生应用，同时能够在跨平台的基础上较好地保证应用的性能和质量。
> Flutter 官网：http://flutter.io

## Flutter的特点

<!-- more -->

先以前端工程师熟悉的 RN 举例，RN 是典型的通过驱动原生 UI 组件进行开发的跨平台框架，得益于 React 本身的 VDOM 设定，使得在 RN 中，上层的 DSL 只需关注如何使用 VDOM 去描述 UI 界面，然后由不同平台的 renderer 进行 VDOM 的绘制来达到跨平台的目的。一个简单的架构图如下：
![1609086-88b683f05674b315](http://7xawh4.com1.z0.glb.clouddn.com/1609086-88b683f05674b315.jpeg)
上图 VDOM 和 renderer 之间，通过一层 bridge 通信来交换 UI 信息和对应的事件信息，可以看出这种跨平台的方式有它天然的瓶颈，那就是 js 和 native 之间通信的成本和性能消耗，特别是在一些动画和富交互的场景中，想要达到流畅的标准（60fps），很容易会碰到性能问题，在低端机器上的表现更是不忍直视（这个问题业界也有一些优化方案，阿里给 weex 出过一个 BindingX 的解决方案，里面的 express-binding 专门为了解决这个问题，但是感觉舍弃了一些灵活性和控制性，具体不展开了）。

再说回 Flutter，相比于 RN，Flutter 可以说完全是另外一种风格，这里捡几个重要的点说下。首先，为了避免使用 bridge 通信导致出现明显的性能瓶颈，Flutter 使用 Dart 语言编译成了不同平台的原生代码，直接与平台通信，并且原生代码也让应用的性能更加出色；另外在 UI 上 Flutter 也做了突破，它不再依赖原生的 UI 组件，所有组件都由 Flutter 在框架层面上提供，并且支持各种拓展和定制，然后由 Flutter Engine 绘制在真实的画布上，这个过程只需要平台提供 canvas 能力即可，同时因为 UI 完全可控，使得 Flutter 有更好的兼容性。

![](http://7xawh4.com1.z0.glb.clouddn.com/15225939129608.jpg)

（上图除了底层的 Flutter Engine，其他都是可以由开发者自由定制）
说完了 Flutter 的亮点，再说说一个令人担忧的点，那就是应用的动态性。目前来看，Flutter 应用因为是编译出来的，不能像 RN 那样动态加载 js 文件然后执行。不过跨平台跟动态化本身就是两件事情，Flutter 目前也才 beta，未来发展如何也未可知。


## 如何入门


- 安装 flutter

`git clone -b beta https://github.com/flutter/flutter.git`

- 配置开发环境

可以通过 flutter doctor 命令检查当前开发环境配置，并按照提示安装即可，Flutter 可以在 Android Studio 、 Xcode 和 VSCode 里面搭配 Flutter 插件跑，也可以用编辑器 + Shell 跑，IDE 配置详见：https://flutter.io/get-started/editor/
![](http://7xawh4.com1.z0.glb.clouddn.com/15219789336660.jpg)

![](http://7xawh4.com1.z0.glb.clouddn.com/15219817737408.jpg)

- 初始化项目

终端执行 `flutter create myapp` 命令或者 IDE 里面新建 Flutter 项目，然后终端执行 `flutter run` 或者 IDE 里启动调试即可预览 Flutter 应用
![](http://7xawh4.com1.z0.glb.clouddn.com/15225969203941.jpg)
更多入门细节请移步 https://flutter.io/get-started/install/











