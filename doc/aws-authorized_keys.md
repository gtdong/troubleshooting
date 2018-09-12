
## aws的ec2实例authorized_keys丢失的solution

### aws官方solution

https://docs.aws.amazon.com/zh_cn/AWSEC2/latest/UserGuide/ec2-key-pairs.html#replacing-lost-key-pair

aws官方给的solution可谓是非常详细了，但是我在把已经损坏的数据卷挂载到临时实例上时，报错了:

![image](https://github.com/gtdong/linuxtroubleshooting/blob/master/images/WechatIMG159.jpeg)

根据提示信息显示: 数据卷的超级块有问题，让我们用dmesg | tail查看详细信息。好的，那我们执行这条命令看看。

![image](https://github.com/gtdong/linuxtroubleshooting/blob/master/images/WechatIMG160.jpeg)

提示信息又来了: 此文件系统的UUID重复了，那么到底和什么重复了呢？我们查看一下/etc/fstab的挂载信息：

![image](https://github.com/gtdong/linuxtroubleshooting/blob/master/images/WechatIMG162.jpeg)

果然，原来和我们临时实例的系统盘的UUID重复了。那我们再挂载时加上 -o nouuid ,以忽略UUID的形式挂载。

![image](https://github.com/gtdong/linuxtroubleshooting/blob/master/images/WechatIMG161.jpeg)
哈哈，成功啦！

下一步把数据卷卸载，挂载到之前的实例上。成功！
