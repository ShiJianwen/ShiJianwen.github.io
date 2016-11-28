title: 在 AngularJS 应用中无法预览微信 SDK 选择的本地图片的解决办法
date: 2015-11-16 19:08:10
categories: "Web 开发"

---

通过微信 SDK 选择了本地图片后，在 AngularJS 应用中无法通过把 localId 赋值给 img 的 ng-src 属性进行预览，但是当直接赋值给 img 标签的 src 属性时却可以正常预览。出现这个问题是的原因是 AngularJS 自身的安全策略，为了避免别人通过图片 link 发起 XSS 攻击，凡是通过 ng-src 指令给元素赋值的在编译阶段都会进行 src 路径合法性的检查，并且由 Angular 维护着一份正则表达式形式的白名单，只有 src 符合白名单里的要求的才被允许赋值，否则都会使这个 src 无效并在前面加上一个 unsafe 标记。所以这个问题的解决办法就是修改本地的白名单，让微信的 localId 不被 Angular 当做不安全的 url，具体代码如下：
```javascript
var app = angular.module('myApp', []);

//配置图片白名单
app.config(['$compileProvider', function($compileProvider) {
    $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|weixin|wxlocalresource):/);
    //其中 weixin 是微信安卓版的 localId 的形式，wxlocalresource 是 iOS 版本的 localId 形式
}]);

```




