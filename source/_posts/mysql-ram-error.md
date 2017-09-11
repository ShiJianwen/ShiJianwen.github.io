title: MySQL5.6 内存占用过高问题
date: 2017-03-23 09:46:30
categories: "Linux"
tags: "bug异闻录"

---

这几天在给 vps 配 LNMP 环境的时候，安装 mysql 选择的是 5.6 版本，使用的时候经常提示连接数据库失败，使用 mysql 登录的时候一直提示找不都 socket 文件（一个启动后会自动生成的文件），后来发现是整个 mysql 进程都挂掉了，使用 `service mysqld restart` 重启时也一直无响应，去查看日志，发现启动时发生了一个错误：

```verilog

140416 11:37:24 mysqld_safe Number of processes running now: 0
140416 11:37:24 mysqld_safe mysqld restarted
140416 11:37:24 [Note] Plugin 'FEDERATED' is disabled.
140416 11:37:24 InnoDB: The InnoDB memory heap is disabled
140416 11:37:24 InnoDB: Mutexes and rw_locks use GCC atomic builtins
140416 11:37:24 InnoDB: Compressed tables use zlib 1.2.3
140416 11:37:24 InnoDB: Using Linux native AIO
140416 11:37:24 InnoDB: Initializing buffer pool, size = 128.0M
InnoDB: mmap(137363456 bytes) failed; errno 12
140416 11:37:24 InnoDB: Completed initialization of buffer pool
140416 11:37:24 InnoDB: Fatal error: cannot allocate memory for the buffer pool
140416 11:37:24 [ERROR] Plugin 'InnoDB' init function returned error.
140416 11:37:24 [ERROR] Plugin 'InnoDB' registration as a STORAGE ENGINE failed.
140416 11:37:24 [ERROR] Unknown/unsupported storage engine: InnoDB
140416 11:37:24 [ERROR] Aborting

```

<!-- more -->


注意这个：`Fatal error: cannot allocate memory for the buffer pool`，说明是内存不足了，因为这时候进程已经挂掉了没办法看到内存占用情况，但我从 vps 的统计报表里面能看到当时的内存占用情况：

![](http://7xiuuj.com1.z0.glb.clouddn.com/QQ20170323-0.png)

差不多 400M 的样子，吓得我赶紧搜了一下，结论是 mysql5.6 相对前代性能有大幅提升，但同时内存占用也是水涨船高，对于个人小站点来说，mysql5.6并不适用，所以如果你对数据库不太挑剔的话，还是建议用旧版本吧。如果你坚持使用5.6版本，那么要么升级你的内存，要么在配置文件里限制 mysql 的资源数，在 `/etc/my.cnf` 文件里面添加如下配置：

```
performance_schema_max_table_instances=400  //检测的表对象的最大数目
table_definition_cache=400  //能缓存的最大表定义数
table_open_cache=256  //最多能打开的表数目
```

配置完成之后用命令 `service mysqld restart` 重启 mysql 即可。

除此之外，`innodb_buffer_pool_size`，`innodb_additional_mem_pool_size`，`innodb_log_buffer_size` 也可以做相应调整，还有 `performance_schema` 在 vps 里面没什么意义，可以关掉：

```
innodb_buffer_pool_size = 8M 
innodb_additional_mem_pool_size = 1M 
innodb_log_buffer_size = 1M
performance_schema = OFF
```

所以。。。为什么不直接换5.5呢？