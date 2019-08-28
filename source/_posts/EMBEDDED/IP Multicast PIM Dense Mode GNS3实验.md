---
title: 'IP Multicast: PIM Dense Mode GNS3实验'
id: 373
comment: false
categories:
  - arm
date: 2016-05-06 17:02:54
tags:
---

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">看一看组播数据包是如何从源到目的在组播网络中转发的。</span><span style="font-family:宋体">
			</span></span>
<!-- more -->

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">拓扑如前：</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast1.jpg)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">
R1,R2,R3</span><span style="font-family:宋体">组播网内运行</span><span style="font-family:宋体">EIGRP</span><span style="font-family:宋体">作为</span><span style="font-family:宋体">IGP</span><span style="font-family:宋体">。各个接口上启用</span><span style="font-family:宋体">ip pim dense-mode</span><span style="font-family:宋体">，并全局开启</span><span style="font-family:宋体">ip multicast-routing
</span><span style="font-family:宋体">在</span><span style="font-family:宋体">sender</span><span style="font-family:宋体">和</span><span style="font-family:宋体">receiver</span><span style="font-family:宋体">程序运行之前，看一下组播路由表。三台路由器几乎没有不同：</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast2.png)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">
</span><span style="font-family:宋体">因为还没有组播源，所以没有（</span><span style="font-family:宋体">S</span><span style="font-family:宋体">，</span><span style="font-family:宋体">G</span><span style="font-family:宋体">）表项。</span><span style="font-family:宋体">
			</span></span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">(*, 239.255.255.250)</span><span style="font-family:宋体">这个（</span><span style="font-family:宋体">*</span><span style="font-family:宋体">，</span><span style="font-family:宋体">G</span><span style="font-family:宋体">）表项还没有去详细研究，因为三个路由器都有接口和</span><span style="font-family:宋体">windows</span><span style="font-family:宋体">的</span><span style="font-family:宋体">adapter</span><span style="font-family:宋体">相连，而</span><span style="font-family:宋体">239.255.255.250</span><span style="font-family:宋体">又是</span><span style="font-family:宋体">SSDP</span><span style="font-family:宋体">（简单服务发现协议）的多播地址，所以这和</span><span style="font-family:宋体">windows</span><span style="font-family:宋体">有关，并且抓包也发现了</span><span style="font-family:宋体">adapter</span><span style="font-family:宋体">发了目的地址为</span><span style="font-family:宋体">239.255.255.250</span><span style="font-family:宋体">的</span><span style="font-family:宋体">IGMP membership report</span><span style="font-family:宋体">消息，本实验室暂不研究。</span><span style="font-family:宋体">
			</span></span>

<span style="color:red; font-size:10pt"><span style="font-family:宋体">(*, 224.0.1.40)</span><span style="font-family:宋体">这个（</span><span style="font-family:宋体">*</span><span style="font-family:宋体">，</span><span style="font-family:宋体">G</span><span style="font-family:宋体">）表项我也没从清楚为啥要存在，</span><span style="font-family:宋体">224.0.1.40</span><span style="font-family:宋体">是</span><span style="font-family:宋体">Cisco RP Discovery</span><span style="font-family:宋体">的组播地址，这个后面再研究吧。。。。（有个视频里说是</span><span style="font-family:宋体">PIM</span><span style="font-family:宋体">的，这个就有点扯了，</span><span style="font-family:宋体">PIM</span><span style="font-family:宋体">明明是</span><span style="font-family:宋体">224.0.0.13</span><span style="font-family:宋体">）</span><span style="color:#464646; font-family:宋体">
			</span></span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">一，先启动</span><span style="font-family:宋体">Receiver</span><span style="font-family:宋体">，后启动</span><span style="font-family:宋体">sender</span><span style="font-family:宋体">。</span><span style="font-family:宋体">
			</span></span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">1\. </span><span style="font-family:宋体">启动</span><span style="font-family:宋体">Receiver_2</span><span style="font-family:宋体">程序，此时</span><span style="font-family:宋体">R3</span><span style="font-family:宋体">的组播路由表多了一个（</span><span style="font-family:宋体">*</span><span style="font-family:宋体">，</span><span style="font-family:宋体">G</span><span style="font-family:宋体">）表项，其他路由器</span><span style="font-family:宋体">mroute</span><span style="font-family:宋体">不变：</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast3.png)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">
</span><span style="font-family:宋体">木有源，所有不会有（</span><span style="font-family:宋体">S</span><span style="font-family:宋体">，</span><span style="font-family:宋体">G</span><span style="font-family:宋体">）表项。</span><span style="font-family:宋体">
			</span></span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">2\. </span><span style="font-family:宋体">启动</span><span style="font-family:宋体">sender</span><span style="font-family:宋体">程序。</span><span style="font-family:宋体">
			</span></span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">R1</span><span style="font-family:宋体">的</span><span style="font-family:宋体">mroute</span><span style="font-family:宋体">：</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast4.png)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-family:宋体; font-size:10pt">
		</span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast5.jpg)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-family:宋体; font-size:10pt">
		</span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">有了（</span><span style="font-family:宋体">S</span><span style="font-family:宋体">，</span><span style="font-family:宋体">G</span><span style="font-family:宋体">）表项，组播数据流从</span><span style="font-family:宋体">Ethernet0/1</span><span style="font-family:宋体">进入的。出接口是</span><span style="font-family:宋体">0/0</span><span style="font-family:宋体">和</span><span style="font-family:宋体">0/2,</span><span style="font-family:宋体">然后</span><span style="font-family:宋体">0/2</span><span style="font-family:宋体">被修剪掉了，为啥</span><span style="font-family:宋体">R2</span><span style="font-family:宋体">会发送</span><span style="font-family:宋体">Prune</span><span style="font-family:宋体">消息给</span><span style="font-family:宋体">R1</span><span style="font-family:宋体">，从</span><span style="font-family:宋体">R2</span><span style="font-family:宋体">和</span><span style="font-family:宋体">R3</span><span style="font-family:宋体">上可以看。</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast6.jpg)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-family:宋体; font-size:10pt">
		</span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast7.jpg)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">
</span><span style="font-family:宋体">当从组播源到接收组成员由多条路径时，通过</span><span style="font-family:宋体">PIM</span><span style="font-family:宋体">的</span><span style="font-family:宋体">Assert</span><span style="font-family:宋体">消息，来决定走哪一条，就是比单播路由</span><span style="font-family:宋体">AD</span><span style="font-family:宋体">值和</span><span style="font-family:宋体">metric</span><span style="font-family:宋体">值，</span><span style="font-family:宋体">
			</span><span style="font-family:宋体">先选</span><span style="font-family:宋体">AD</span><span style="font-family:宋体">值低的，其次是</span><span style="font-family:宋体">Metric</span><span style="font-family:宋体">，最后是最高</span><span style="font-family:宋体">IP</span><span style="font-family:宋体">地址，落选的把自己的出口剪除。在此次竞选中</span><span style="font-family:宋体">R2</span><span style="font-family:宋体">输了，所以发了</span><span style="font-family:宋体">Prune</span><span style="font-family:宋体">消息给</span><span style="font-family:宋体">R1</span><span style="font-family:宋体">，裁剪掉了。</span><span style="font-family:宋体">
			</span></span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">R2</span><span style="font-family:宋体">：</span><span style="font-family:宋体">flag</span><span style="font-family:宋体">是</span><span style="font-family:宋体">P</span><span style="font-family:宋体">，代表</span><span style="font-family:宋体">Prune</span><span style="font-family:宋体">。</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast8.png)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">
R3</span><span style="font-family:宋体">：和</span><span style="font-family:宋体">R2</span><span style="font-family:宋体">的</span><span style="font-family:宋体">E0/1</span><span style="font-family:宋体">也是</span><span style="font-family:宋体">Prune</span><span style="font-family:宋体">的状态。</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast9.png)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">

</span><span style="font-family:宋体">二，先启动</span><span style="font-family:宋体">sender</span><span style="font-family:宋体">，后启动</span><span style="font-family:宋体">receiver</span><span style="font-family:宋体">。</span><span style="font-family:宋体">
			</span></span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">启动</span><span style="font-family:宋体">sender</span><span style="font-family:宋体">后，所有组播路由器对于此组播地址的（</span><span style="font-family:宋体">S</span><span style="font-family:宋体">，</span><span style="font-family:宋体">G</span><span style="font-family:宋体">）表项都是</span><span style="font-family:宋体">PT</span><span style="font-family:宋体">的状态，因为没有接收者。</span><span style="font-family:宋体">
			</span></span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">启动</span><span style="font-family:宋体">receiver_2</span><span style="font-family:宋体">后：</span><span style="font-family:宋体">
			</span></span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">R3</span><span style="font-family:宋体">发送</span><span style="font-family:宋体">Graft</span><span style="font-family:宋体">消息到</span><span style="font-family:宋体">R1</span><span style="font-family:宋体">，表明先前被</span><span style="font-family:宋体">Prune</span><span style="font-family:宋体">的接口要接收组播数据了，然后就会收到</span><span style="font-family:宋体">R1</span><span style="font-family:宋体">发过来的</span><span style="font-family:宋体">Graft-ACK</span><span style="font-family:宋体">确认。</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast10.jpg)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">
R1</span><span style="font-family:宋体">收到</span><span style="font-family:宋体">R3</span><span style="font-family:宋体">的</span><span style="font-family:宋体">Graft</span><span style="font-family:宋体">消息，有接收者接收组播数据了，即把</span><span style="font-family:宋体">PT</span><span style="font-family:宋体">状态改为</span><span style="font-family:宋体">T</span><span style="font-family:宋体">状态，发送</span><span style="font-family:宋体">graft-ACK</span><span style="font-family:宋体">给</span><span style="font-family:宋体">R3</span><span style="font-family:宋体">，并开始转发组播数据。</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast11.jpg)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-family:宋体; font-size:10pt">
		</span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0902_IPMulticast12.jpg)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">

</span><span style="font-family:宋体">简单的</span><span style="font-family:宋体">PIM-DM</span><span style="font-family:宋体">模式的数据转发就这样子了，其中有各种情况这里未予考虑。</span><span style="font-family:宋体">
			</span></span>
