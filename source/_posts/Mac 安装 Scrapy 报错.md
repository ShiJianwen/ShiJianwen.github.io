title: Mac 上安装 Scrapy 报错，Operation not permitted
date: 2017-03-26 18:00
categories: "OS X"
tags: "bug异闻录"

----------

![](http://7xiuuj.com1.z0.glb.clouddn.com/wallhaven-423175.png)
这个问题在 `OS X El Capitan` 普遍存在，后面会说明原因。

前几天在 Mac 上安装 Scrapy，按照官方文档的步骤使用 pip 安装 scrapy 后报一个权限错误
`OSError: [Errno 1] Operation not permitted: '/var/folders/6t/h404bjcd5tb_4q86tpv_251rv_0h0j/T/pip-sYsqDS-uninstall/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python/six-1.4.1-py2.7.egg-info'`
看起来像是一个普通的权限问题，但问题是即使使用 sudo 命令也还是报相同的错误，搜索之后发现是因为 pip 在更新本机 six 模块的时候，没有权限卸载本机旧版本的 six 模块。网上给出的解决办法是加个 ignore 参数，完整命令如下：
`pip install scrapy --ignore-installed six`，忽略本机已安装的 six，这样就可以避免没有权限删除的问题了。使用此命令可以正常安装 Scrapy，安装完成之后运行 Scrapy，发现又报一个引用错误 `ImportError: cannot import name xmlrpc_client`，搜索之后发现解决办法是要手动删除机子上的 six 模块然后重装机。。。（又回到原地了），这时候我们就不可避免地要弄清楚刚刚那个权限错误是怎么回事了。所以又是一顿查，发现 [这里](http://www.macworld.com/article/2986118/security/how-to-modify-system-integrity-protection-in-el-capitan.html) 有说到新版的 Mac 里面新增了一个 SIP（System Integrity Protection 系统完整性保护）机制，即在底层限制 root 用户的某些权限，让即使是 root 用户也无法删除/修改某些系统核心文件，这样即使在系统完全被黑的情况下也能够保证系统的完整性，这也算是整个电脑的最后一重安全保障。我们这里遇到的问题就是跟 SIP 有关，解决办法就是进入 Recovery 模式关闭它。关闭的具体步骤是，重启 Mac，按住 `cmd + R`，等待进入 Recovery 界面，在 Recovery 界面唤出命令行，执行以下命令然后重启机器即可：
`csrutil disable`

重启后就可以正常启动 Scrapy 啦~