title: 使用微信 SDK 上传图片到七牛
date: 2015-11-5 17:17:10
categories: "Web 开发"
---
总体思路是：在微信下选好图片后将图片上传到微信服务器，在后端使用微信服务器返回的图片 serverId 加上调用接口的 ApiTicket 通过七牛的 fetch 接口向微信服务器下载多媒体文件的接口请求图片的二进制流，然后保存至自己七牛账号内的特定 bucket。 
大致过程如下：
<!-- more -->
###1.调用微信 chooseImage 接口，成功后调用 uploadImage 接口
```javascript
	wx.chooseImage({
                count: 1,
                sizeType: ['original', 'compressed'],
                sourceType: ['album', 'camera'],
                success: function(res) {
                    $scope.localIds = res.localIds; //存储localId供本地预览
                    wx.uploadImage({
                        localId: res.localIds[0],
                        isShowProgressTips: 1,
                        success: function(res) {
                            WishData.mediaId = res.serverId; //图片上传成功后保存serverId然后发给后台，让后台根据serverId去微信服务器下载对应的图片
                        }
                    });
                }
            });
```

###2.在后台使用七牛的 fetch 接口向微信服务器请求文件并存入自己的七牛仓库
```javascript
	var client = new qiniu.rs.Client();
	var random_key = Math.random().toString(36).substr(2, 15); //生成一个随机字符串来给图片命名
	//调用七牛 fetch 接口，具体用法参照文档
	client.fetch('http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=' + req.session.apptoken + '&media_id=' + req.body.mediaId, 'gdutgirl', random_key, function(err, ret) {
            if (err) {
                console.log(err.error);
                next();
            } else {
                console.log('图片请求成功');
                var url = qiniu.rs.makeBaseUrl('7xnxuw.com1.z0.glb.clouddn.com', random_key); //生成图片的可访问url
                req.body.imgurl = url;
                next();
            }

        });
```

文档：
[微信上传和下载多媒体文档][1]
[微信 JS SDK 说明文档][2]
[七牛 fetch 接口说明文档][3]


  [1]: http://mp.weixin.qq.com/wiki/12/58bfcfabbd501c7cd77c19bd9cfa8354.html
  [2]: http://mp.weixin.qq.com/wiki/7/aaa137b55fb2e0456bf8dd9148dd613f.html#.E4.B8.8A.E4.BC.A0.E5.9B.BE.E7.89.87.E6.8E.A5.E5.8F.A3
  [3]: http://developer.qiniu.com/docs/v6/api/reference/rs/fetch.html