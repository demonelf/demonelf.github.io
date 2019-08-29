[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343221Y0-0.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

作为差不多和cloudflare一道被国内的站长们认识的Incapsula，其提供的免费CDN加速服务一直可以正常使用，且有多个CDN节点可供选择。而cloudflare提供的免费CDN服务虽然不错，但是不知道是不是因为国内用户用太多了还是其他什么原因，现在用起来总会有各种问题。

Incapsula最早部落是在三年前介绍的，现在之所以要再次分享一下Incapsula的免费CDN申请使用教程，一来是给不是很了解Incapsula的朋友一个简单普及，Incapsula的CDN其实有不少的高级用法；二来是Incapsula最近推出的香港CDN节点，很必要来体验不同的CDN节点在国内连接速度快慢。

根据部落自己的统计，Incapsula可供查询的CDN节点共有60多个，主要是分布在美国、爱尔兰、日本、中国香港等地区，由于Incapsula的CDN服务是全球服务网络，因此只要有一个节点缓存了我们的网站，就可以在其它CDN节点上访问了。明白了这一点，我们就可以指定自己的CDN节点为日本或者香港。

一般来说，网站放在亚太地区的话国内用户访问会感觉比美国主机要快一些，本篇文章就来对比一下Incapsula的日本、香港和美国CDN节点在国内的访问连接速度状况。Incapsula以前免费CDN套餐月流量为50GB，刚刚去官网查看了一下发现免费CDN套餐现以已经没有明确说明多少月流量限制。

看了一下Incapsula的付费套餐也都没有月流量限制，区别主要是在防护攻击、CDN高级功能等方面，所以目前姑且认为Incapsula提供免费CDN服务没有流量限制，但是只是基本的CDN加速，应该在CDN资源利用方面作了限制。（部落刚刚狂刷新自己测试博客，有遇到一次超出资源配额提示，由此推测Incapsula在访问连接方面作了人为限制）

**Incapsula免费CDN服务申请使用:日本、香港、美国CDN加速效果测评**

**一、Incapsula免费CDN申请使用**

1、Incapsula官网：

1、官方网站：http://www.incapsula.com/

2、进入Incapsula官网，直接注册一个账号，然后登录到Incapsula管理后台，添加一个你想要使用CDN加速的网站。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/13432220Q-1.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

3、等Incapsula检测你的域名的DNS通过后，就可以点击下一步了。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343221338-2.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

4、然后Incapsula就会给出A记录和CNAME记录。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343221947-3.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

5、你需要到你的域名DNS管理处，将域名的@的A记录修改为Incapsula给你的IP（一般有两个），域名的www的记录修改为Incapsula给你的CNAME记录。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/13432240O-4.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

6、完成了以上操作后，就可以点击完成设置，Incapsula检测到你的域名的DNS更新成功后，你就可以在Incapsula查处和管理你的CDN了。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343221501-5.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

**二、Incapsula CDN管理面板使用**

1、这是Incapsula CDN的管理后台，主要是可以查看CDN流量统计、安全、CDN性能、管理日志等（点击放大）。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/134322CA-6.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

2、在Incapsula的设置当中，你可以查看CDN的源服务器IP地址，如果你的服务器IP有变动，就可以在这里直接修改。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343223B8-7.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

3、Incapsula还支持设置带www和不带www的域名跳转（利用这个功能，你不再需要在Htaccess中设置301跳转了）、是否显示推广广告、网站原DNS和CDN的DNS记录详情等，点击放大：

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343225M6-8.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

4、Incapsula有一个登录保护功能，这个功能对于那些有用户账号系统登录页面的网站来说，将可以有效地保护好账号的安全。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343226036-9.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

5、添加你想要使用Incapsula登录保护的页面的URL，然后用户在访问这个页面时需要授权了。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/134322OK-10.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

6、Incapsula还提供了CDN缓存模式可供选择：关闭、标准和进阶模式。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/13432225T-11.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

7、Incapsula还会通过对JS、CSS、Html等静态文件压缩，以达到加快页面加载的速度，你可以有选择性地关闭它们。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343222357-12.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

8、Incapsula还会有一些高级的CDN缓存设置，比如Http头的no-cache、Max-age、Last Modified等协议，你都可以在Incapsula中选择是否遵循。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343225952-13.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

**三、Incapsula设置日本、香港CDN节点**

1、Incapsula的CDN节点分布在香港、东京、新加坡、阿姆斯特丹、伦敦、阿什本、san jose、洛杉矶、特拉维夫、阿什维尔等地区，其中香港、东京是我们国内连接速度最快的主机机房位置。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343225512-14.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

2、一般来说我们会选择Incapsula香港或者日本的CDN节点作为我们网站的加速的CDN，而要做到这一点，我们只需要知道CDN的节点服务器IP就可以了。Incapsula所有的CDN节点IP地址可以在这里找到：http://bgp.he.net/AS19551#_prefixes

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343225D1-15.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

3、想要设置Incapsula日本、香港CDN节点，先要保证参考上面的方法操作，网站已经成功接入了Incapsula的CDN，然后再到你的域名DNS管理处，将原来的CNAME记录删除，把@和www等记录全部改为A记录，记录值是Incapsula的CDN节点的IP地址。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343222359-16.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

4、由于Incapsula的CDN节点有非常多的IP地址，我们可以多设置几个A记录。等DNS生效后，我们就能看到自己的网站访问到的Incapsula CDN节点已经变成了日本或者香港了。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343221S2-17.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

**四、Incapsula日本、香港、美国CDN加速效果比较**

1、默认的我们在Incapsula添加自己的网站加速时，系统分给我们的是美国的Incapsula CDN加速节点，通过站长工具测试发现Incapsula的美国CDN服务器在国内连接状态还算不错，比较少丢包，Ping值一般在270-300之间。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343225354-18.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

2、Incapsula日本和香港的Ping情况差不多，丢包比较少，响应时间也差不多。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343224P7-19.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

3、这是晚上测试Incapsula香港CDN节点的响应时间，平均在200左右。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343222421-20.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

4、这是白天测试Incapsula香港CDN节点的响应时间，平均在170左右。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343221916-21.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

5、Incapsula日本和香港的Ping测试结果显然不是很让满意，按照以往的经验日本和香港的Ping响应时间一般是在70以下。用路由追踪工具查看了一下国内连接Incapsula日本和香港的线路走势，电信用户是绕道日本后再到香港的。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/134322G24-22.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

6、联通用户访问也是一样，先到日本，再到香港。

[![Incapsula免费CDN服务申请使用及加速效果测评](http://www.aspku.com/uploads/allimg/150128/1343225G0-23.gif "Incapsula免费CDN服务申请使用及加速效果测评")](http://www.aspku.com/yunying/jingyan/47681.html)

**五、Incapsula日本香港免费CDN使用小结**

1、Incapsula与Cloudflare比较起来，可以不用修改NS，采用CNAME记录的方式就可以接入到CDN，方便不少。Incapsula 每个节点一个ip，未使用anycast技术，因此方便了我们根据自己

的需要来设置CDN节点的IP地址。

2、不过，从测试的结果来看，Incapsula日本香港免费CDN节点国内并不是直连，基本上都是绕道到美国或者日本，所以也就看到了日本和香港的Incapsula CDN使用效果差不多，有些美国线路情况比较好的CDN节点速度也很快。
