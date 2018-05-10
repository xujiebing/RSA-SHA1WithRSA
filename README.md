## iOS SHA1WithRSA加签验签

这篇文章主要介绍一点关于SHA1WithRSA的干货以及本人在开发的过程中遇到的坑

[干货下载链接](https://github.com/xujiebing/RSA-SHA1WithRSA)



关于RSA相关介绍、对称加密与非对称加密、公私钥、加密解密以及加签验签请自行[百度](https://www.baidu.com)

### 本人在项目中遇到的问题：

##### 问题一：App加签之后的数据在服务端无法验签

问题描述：本人在项目中对使用的AFNetworking，并拦截了`BWTAFHTTPRequestSerializer`中的`requestBySerializingRequest:withParameters:error:`方法，将请求的包体转成json字符串进行加签，然后将加签信息作为签名放在请求头中上传到服务器，服务器验签失败

解决过程：开始怀疑是算法出了问题，网上查找资料，发现算法跟我项目中的基本是一致的，后来又是查找资料也没有解决。后来在断点调试中发现`requestBySerializingRequest:withParameters:error:`

中的query(AFNetworking中将包体转成json字符串，即query)变量与包体转成的json字符串不一样，于是瞬间豁然开朗，问题解决，over。

问题分析：

首先，我们先回忆一下加签验签的过程：

我们将A字符串用私钥加签，得到sign字符串；然后用公钥、A字符串和sign进行验签。说到这里大家应该明白了query变量和包体的json字符串不一样为什么会导致服务端验签不通过了。

项目中是将包体转成json字符串，使用到了MJExtension中的方法，转换出来的字符串不知道为什么多出了`n`和空格，这就导致我们加签的明文和服务端验签的明文(明文为query比变量)不一致(哪怕是多出一个空格也不行)，导致服务端验签失败。

问题找到了，怎么解决就不再啰嗦了。

