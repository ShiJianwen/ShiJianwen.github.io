title: centos 7 配置 lnmp 环境
date: 2017-11-15
category: 'Web 开发'
---

> 最近折腾 vps 的迁移，各种环境要重新部署，查各种文档让人头疼，年久失修的文档真是害人不浅，于是折腾好环境之后将各个有效的文档做一遍整合，看看 CentOS 7 64 位环境下怎样搭建 LNMP 环境

## 安装 Nginx

### 安装依赖

#### 1. gcc

安装 nginx 需要先将官网下载的源码进行编译，编译依赖 gcc 环境，如果没有 gcc 环境，则需要安装：

<!-- more -->

`yum install gcc-c++`

#### 2. PCRE pcre-devel

PCRE(Perl Compatible Regular Expressions) 是一个Perl库，包括 perl 兼容的正则表达式库。nginx 的 http 模块使用 pcre 来解析正则表达式，所以需要在 linux 上安装 pcre 库，pcre-devel 是使用 pcre 开发的一个二次开发库。nginx也需要此库。命令：
`yum install -y pcre pcre-devel`

#### 3. zlib
zlib 库提供了很多种压缩和解压缩的方式， nginx 使用 zlib 对 http 包的内容进行 gzip ，所以需要在 Centos 上安装 zlib 库。

`yum install -y zlib zlib-devel`

#### 4. OpenSSL
OpenSSL 是一个强大的安全套接字层密码库，囊括主要的密码算法、常用的密钥和证书封装管理功能及 SSL 协议，并提供丰富的应用程序供测试或其它目的使用。
nginx 不仅支持 http 协议，还支持 https（即在ssl协议上传输http），所以需要在 Centos 安装 OpenSSL 库。

`yum install -y openssl openssl-devel`

### 下载 nginx 包

在 https://nginx.org/en/download.html 手动下载安装包或者使用 wget 命令获取对应版本的安装包：
`wget -c https://nginx.org/download/nginx-1.10.1.tar.gz`

### 解压

`tar -zxvf nginx-1.10.1.tar.gz
cd nginx-1.10.1`

### 配置

`./configure`

### 编译安装

`make`
`make install`

启动这些不用我写了吧？

### 配置

附上一个支持 php 的 nginx 配置：
```nginx
server {
  listen        80;
  server_name   nginx.ninghao.net;
  root          html;
  index         index.php index.html;

  location / {
    try_files $uri $uri/ /index.php?$query_string;
  }

  location ~ \.php$ {
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    include fastcgi.conf;
  }
}
```

## 安装 PHP

如果你对 PHP 没有特殊版本要求的话，直接执行以下命令即可，不然还需要小心分辨不同版本

### 安装 PHP
`yum install php`

### 安装 PHP 扩展包
`yum install php-mysql php-gd libjpeg* php-imap php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-mcrypt php-bcmath php-mhash libmcrypt`

### 安装 php-fpm

`yum install php-fpm`

用命令 `systemctl start php-fpm` 启动 php-fpm，看看现在 9000 端口有没被监听，有的话就可以写个 php 文件试试看了

## 安装 MySQL

最简单就是安装 MySQL 啦。

`yum install mysql mysql-server`

然后设置 root 用户密码，先用 root 身份登录 mysql

`mysql -u root`

进去后设置密码：

`use mysql;`
`UPDATE user SET Password=PASSWORD('newpassword') WHERE user='root';`
`exit;`

重启 mysql 服务

`sevice mysqld restart`

搞定！





参考文章：

[CentOS 7 下安装 Nginx](http://www.linuxidc.com/Linux/2016-09/134907.htm)

[CentOS 6.5系统安装配置LAMP(Apache+PHP5+MySQL)服务器环境](http://www.linuxidc.com/Linux/2014-12/111030.htm)

[在阿里云 CentOS 服务器（ECS）上搭建 nginx + mysql + php-fpm 环境](https://ninghao.net/blog/1368)
