title: BAE 多个执行单元使用 socket.io
date: 2015-12-25 18:27:10
categories: "Web 开发"
---

&nbsp;&nbsp;&nbsp;&nbsp;在许愿墙开放前夕，我任性地将原来百度云擎四毛钱的套餐升级成了三块钱的套餐，升级的主要动作就是增加执行单元的数量，升级之后出现了一个问题就是 socket.io 有时候不管用了，在许愿墙里 socket.io 我是用来做实时的消息推送和用户之间的实时私信功能的，升级之后出错的具体问题就是有时候跟用户发私信的时候对方并不能实时接收，只能等到下次登录的时候去数据库拿未读消息的时候才能看到。本地调试的时候发现 socket.io 抛出的错误信息是 `socket.io connection closed before receiving a handshake response` 。几番查询之后发现是由于服务端开了多条进程而进程之间无法通信导致的。这时候我就明白了原来百度云擎增加执行单元的数量就相当于多开了一条独立的进程跑你的后台，从而提高整个服务的性能和负载能力，难怪这么贵。。。
&nbsp;&nbsp;&nbsp;&nbsp;为了解决多进程之间通信的问题，我决定使用 redis 服务器做成一个事件订阅和发布的模型，在网上搜索找到了一篇类似的文章：[《利用扩展服务实现基于websocket的聊天室》][1]，不同的是那篇文章使用的是 nodejs-websocket 这个库，我在许愿墙里使用的是 socket.io，两种不同的库做起来方法有所不同，所以这里我打算总结一下在使用 socket.io 的时候如何利用 redis 做一个进程间的消息发布与订阅模块。


<!-- more -->

&nbsp;&nbsp;&nbsp;&nbsp;首先就是开通 BAE 的 port 服务和 redis 服务了，这里不赘述，参考上面那篇文章就行，另外最好也像文章里那样开一个 log 服务，因为多个执行单元的运行的时候不同执行单元的日志会打印到不同的地方，因此我们需要 log 服务来统一管理这些日志方便我们 debug。
&nbsp;&nbsp;&nbsp;&nbsp;当你把服务都开通并且能够跑的时候，需要在 server.js 里面加入以下代码：

```javascript
var io = require("socket.io").listen(xxx);
var channel = ak; //channel 就是你待会发布和订阅的频道，这里给它随便取一个名字
var db = '{db}';  //这个 db 是你的 redis 数据库的名字
var auth = ak + "-" + sk + "-" + db; //ak，sk 分别是数据库的 access_token 和 secret_token，在 BAE 后台可查
var redis = require("redis"); 
//创建两个 redis 客户端，subClient 是订阅了某个频道的客户端，pubClient 负责在某个频道发布消息的客户端
var subClient = redis.createClient(80, "redis.duapp.com", {"no_ready_check": true}); 
var pubClient = redis.createClient(80, "redis.duapp.com", {"no_ready_check": true}); 
subClient.auth(auth); 
pubClient.auth(auth); 
subClient.on("message", function (channel, message) { 
    // 当收到redis的订阅通知时，将消息发送给所有的 websocket 连接 
    io.sockets.emit(message);
}); 
//让 subClient 订阅 channel 这个频道
subClient.subscribe(channel);

//接下来的就跟普通的 socket.io 那样用了
.
.
.
```


  [1]: http://godbae.duapp.com/?p=1096