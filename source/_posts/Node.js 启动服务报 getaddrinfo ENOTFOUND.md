title: Node.js 启动服务报 getaddrinfo ENOTFOUND
date: 2016-11-21 16:14:10
categories: "node.js"
tags: "bug异闻录"


---

在启动 node 服务后一直报错：

```bash
events.js:72
    throw er; // Unhandled 'error' event
          ^
Error: getaddrinfo ENOTFOUND
    at errnoException (dns.js:37:11)
    at Object.onanswer [as oncomplete] (dns.js:124:16)
```

造成这个错误的原因是本地的代理软件修改了host，让系统在 dns 解析的时候找不到 `localhost` 的地址，解决办法就是重新给系统加上host如下：

```bash
127.0.0.1 localhost
```