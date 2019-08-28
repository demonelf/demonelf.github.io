---
title: IGMP
id: 359
comment: false
categories:
  - arm
date: 2016-05-06 16:06:36
tags:
---

<span style="color:black; font-size:16pt"><span style="font-family:黑体">一、 </span><span style="font-family:Arial">**Internet **</span><span style="font-family:黑体">组管理协议
</span></span>
<!-- more -->

<span style="color:black"><span style="font-family:Times New Roman">IGMP </span><span style="font-family:宋体">是</span><span style="font-family:Times New Roman">Internet </span><span style="font-family:宋体">组管理协议</span><span style="font-family:Times New Roman">(Internet Group Management Protocol)</span><span style="font-family:宋体">的缩写。</span><span style="font-family:Times New Roman">IGMP </span><span style="font-family:宋体">在
</span></span>

<span style="color:black"><span style="font-family:Times New Roman">TCP/IP </span><span style="font-family:宋体">协议中的位置</span><span style="font-family:Times New Roman">:
</span></span>

<span style="color:black"><span style="font-family:宋体">应用层协议（</span><span style="font-family:Times New Roman">FTP,HTTP,SMTP</span><span style="font-family:宋体">）
</span></span>

<span style="color:black; font-family:Times New Roman">TCP UDP ICMP <span style="color:red">IGMP
</span></span>

<span style="color:black; font-family:Times New Roman">IP
</span>

<span style="color:black; font-family:Times New Roman">ARP RARP
</span>

<span style="color:black; font-family:Times New Roman">MAC
</span>

<span style="color:black; font-family:Times New Roman">PHY
</span>

<span style="color:black"><span style="font-family:宋体">在了解 </span><span style="font-family:Times New Roman">IGMP </span><span style="font-family:宋体">协议的之前，我们首先看看以太网对报文的处理方法。我们知道，目前使
</span></span>

<span style="color:black"><span style="font-family:宋体">用的以太网（</span><span style="font-family:Times New Roman">ethernet</span><span style="font-family:宋体">）有一个特点，当一个报文在一条线路上传输时，该线路上的所有主
</span></span>

<span style="color:black"><span style="font-family:宋体">机都能够接收到这个报文。只是当报文到达</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">层时，主机会检测这个报文是不是发送给
</span></span>

<span style="color:black"><span style="font-family:宋体">自己的，如果不是该报文就会被丢弃。常用的抓包软件</span><span style="font-family:Times New Roman">ethereal, sniffer </span><span style="font-family:宋体">都可以捕获当前物理
</span></span>

<span style="color:black; font-family:宋体">线路上的所有报文，不管该报文的目的地址是不是自己。以太网中有一种特殊的报文广播包
</span>

<span style="color:black"><span style="font-family:宋体">其目的</span><span style="font-family:Times New Roman">mac </span><span style="font-family:宋体">地址全为</span><span style="font-family:Times New Roman">0xff</span><span style="font-family:宋体">，所有的主机都必须接收。
</span></span>

<span style="color:black"><span style="font-family:宋体">说到 </span><span style="font-family:Times New Roman">IGMP </span><span style="font-family:宋体">不能不提"组播"的概念。假如现在一个主机想将一个数据包发给网络上的
</span></span>

<span style="color:black; font-family:宋体">若干主机，有什么方法可以做到呢？一个方法是采用广播包发送，这样网络上的所有主机都
</span>

<span style="color:black; font-family:宋体">能够接收到，另一种方式是将数据包复制若干份分别发给目的主机。这两个方法都存在问题：
</span>

<span style="color:black; font-family:宋体">方法一，广播的方法导致网络上所有的主机都能接收到，占用了网络上其他主机的资源。方
</span>

<span style="color:black; font-family:宋体">法二，由于所有目的主机接收的报文都是相同的，采用单播方式显然效率很低。为了解决上
</span>

<span style="color:black; font-family:宋体">面所述的问题，人们提出了"组播"的概念，控制一个报文发送给对该报文感兴趣的主机，
</span>

<span style="color:black"><span style="font-family:Times New Roman">IGMP </span><span style="font-family:宋体">就是组播管理协议。
</span></span>

<span style="color:black; font-family:宋体">我们来看一个简单的组播应用场景
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0806_IGMP1.jpg)<span style="font-family:宋体; font-size:12pt">
		</span>

<span style="color:black"><span style="font-family:Times New Roman">    PC</span><span style="font-family:宋体">，如何处理呢？首先</span><span style="font-family:Times New Roman">STB </span><span style="font-family:宋体">要发起一个连接请求，也就是</span><span style="color:red"><span style="font-family:Times New Roman">IGMP report </span><span style="color:black"><span style="font-family:宋体">报文，加入到电视直播的组播组中。同样当</span><span style="font-family:Times New Roman">STB </span><span style="font-family:宋体">要断开连接的时候就发送一个</span><span style="color:red"><span style="font-family:Times New Roman">IGMP leave </span><span style="color:black"><span style="font-family:宋体">报文。</span><span style="font-family:Times New Roman">Router </span><span style="font-family:宋体">也需要知道当前有哪些</span><span style="font-family:Times New Roman">STB </span><span style="font-family:宋体">加入了组播组，防止有的</span><span style="font-family:Times New Roman">STB </span><span style="font-family:宋体">异常掉线了，却依然占用系统资源。</span><span style="font-family:Times New Roman">Router </span><span style="font-family:宋体">周期性的发送</span><span style="color:red"><span style="font-family:Times New Roman">IGMP query </span><span style="color:black"><span style="font-family:宋体">报文查询组播组情况，</span><span style="font-family:Times New Roman">STB </span><span style="font-family:宋体">接到</span><span style="font-family:Times New Roman">query </span><span style="font-family:宋体">报文后发送</span><span style="font-family:Times New Roman">report</span><span style="font-family:宋体">消息到</span><span style="font-family:Times New Roman">router</span><span style="font-family:宋体">。当然还有一种报文就是</span><span style="color:red"><span style="font-family:Times New Roman">IGMP data</span><span style="color:black"><span style="font-family:宋体">，用来传输组播数据。这基本上就是</span><span style="font-family:Times New Roman">IGMP</span><span style="font-family:宋体">协议的基本流程了。
</span></span></span></span></span></span></span></span></span></span>

<span style="color:black; font-family:黑体; font-size:16pt">二、 组播实现
</span>

<span style="color:black; font-size:16pt"><span style="font-family:Times New Roman">**1\. IP **</span><span style="font-family:宋体">组播组与组播</span><span style="font-family:Times New Roman">**MAC
**</span></span>

<span style="color:black"><span style="font-family:宋体">二层组播</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">定义为：</span><span style="font-family:Times New Roman">01:00:5e:xx:xx:xx</span><span style="font-family:宋体">，其中</span><span style="font-family:Times New Roman">xx </span><span style="font-family:宋体">由三层的</span><span style="font-family:Times New Roman">IP </span><span style="font-family:宋体">组播组确定。三层地址：
</span></span>

<span style="color:black"><span style="font-family:宋体">组播流使用的</span><span style="font-family:Times New Roman">IP </span><span style="font-family:宋体">是</span><span style="font-family:Times New Roman">D </span><span style="font-family:宋体">类</span><span style="font-family:Times New Roman">IP </span><span style="font-family:宋体">地址（二进制</span><span style="font-family:Times New Roman">1110 </span><span style="font-family:宋体">开始），从</span><span style="font-family:Times New Roman">224.0.0.0</span><span style="font-family:宋体">～</span><span style="font-family:Times New Roman">239.255.255.255</span><span style="font-family:宋体">。由于
</span></span>

<span style="color:black"><span style="font-family:宋体">组播</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">地址是一个虚拟的地址，并不是真实网卡的</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">地址，那么网卡在发送报文是
</span></span>

<span style="color:black"><span style="font-family:宋体">二层</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">地址怎么确定呢？答案是采用地址映射的方法将三层</span><span style="font-family:Times New Roman">IP </span><span style="font-family:宋体">地址映射到</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">地址。
</span></span>

<span style="color:black; font-family:宋体">映射关系如下。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0806_IGMP2.jpg)<span style="font-family:宋体; font-size:12pt">
		</span>

<span style="color:black"><span style="font-family:宋体">从上面的映射关系可以看出 </span><span style="font-family:Times New Roman">IP </span><span style="font-family:宋体">地址的五个</span><span style="font-family:Times New Roman">bit </span><span style="font-family:宋体">无法映射到</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">层，因为</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">层的这五个
</span></span>

<span style="color:black"><span style="font-family:Times New Roman">bit </span><span style="font-family:宋体">已经确定。也就是说有</span><span style="font-family:Times New Roman">32 </span><span style="font-family:宋体">个</span><span style="font-family:Times New Roman">IP </span><span style="font-family:宋体">组播组会被映射为同一个</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">地址。
</span></span>

<span style="color:blue"><span style="font-family:宋体">（在这里不能不说一个面试常问的问题：一个网卡的 </span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">地址是</span><span style="font-family:Times New Roman">53:10:10:10:10:10</span><span style="font-family:宋体">，
</span></span>

<span style="color:blue"><span style="font-family:宋体">问这是一个合法的</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">地址吗？原因？）
</span></span>

<span style="color:black; font-size:16pt"><span style="font-family:Times New Roman">**2\. **</span><span style="font-family:宋体">报文格式：
</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0806_IGMP3.jpg)<span style="font-family:宋体; font-size:12pt">
		</span>

<span style="color:black"><span style="font-family:Times New Roman">IGMP </span><span style="font-family:宋体">报文封装在</span><span style="font-family:Times New Roman">IP </span><span style="font-family:宋体">层上，在</span><span style="font-family:Times New Roman">IP </span><span style="font-family:宋体">层的协议类型码是</span><span style="font-family:Times New Roman">0x02</span><span style="font-family:宋体">。</span><span style="font-family:Times New Roman">IGMPv2 </span><span style="font-family:宋体">有</span><span style="font-family:Times New Roman">report, query </span><span style="font-family:宋体">和
</span></span>

<span style="color:black"><span style="font-family:Times New Roman">leave </span><span style="font-family:宋体">有三种类型的报文，
</span></span>

<span style="color:black"><span style="font-family:Times New Roman">IGMP report</span><span style="font-family:宋体">：</span><span style="font-family:Times New Roman">type </span><span style="font-family:宋体">为</span><span style="font-family:Times New Roman">0x16(IGMPv2)</span><span style="font-family:宋体">或</span><span style="font-family:Times New Roman">0x12(IGMPv1)
</span></span>

<span style="color:black"><span style="font-family:Times New Roman">IGMP leave</span><span style="font-family:宋体">：</span><span style="font-family:Times New Roman">type </span><span style="font-family:宋体">为</span><span style="font-family:Times New Roman">0x17
</span></span>

<span style="color:black"><span style="font-family:Times New Roman">IGMP query</span><span style="font-family:宋体">：</span><span style="font-family:Times New Roman">type </span><span style="font-family:宋体">为</span><span style="font-family:Times New Roman">0x11</span><span style="font-family:宋体">，</span><span style="font-family:Times New Roman">query </span><span style="font-family:宋体">报文有两种情况，一种是针对特定组播组的查询，例
</span></span>

<span style="color:black"><span style="font-family:宋体">如</span><span style="font-family:Times New Roman">router </span><span style="font-family:宋体">要查询属于组播组</span><span style="font-family:Times New Roman">225.225.100.3 </span><span style="font-family:宋体">的所有成员，另一种是通用查询，查询所有主机
</span></span>

<span style="font-family:宋体">加入组播组的情况，两者的主要区别是在</span><span style="font-family:Times New Roman">Group Address </span><span style="font-family:宋体">上。
</span>

<span style="font-family:Times New Roman">IGMP data</span><span style="font-family:宋体">：与通常的报文相同，主要区别是</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">地址使用的是组播</span><span style="font-family:Times New Roman">MAC</span><span style="font-family:宋体">。
</span>

<span style="font-size:16pt"><span style="font-family:黑体">三、 </span><span style="font-family:Arial">**IGMP **</span><span style="font-family:黑体">协议的应用问题
</span></span>

<span style="font-family:Times New Roman; font-size:16pt">**1\. IGMP snooping
**</span>

<span style="font-family:宋体">首先我们来看这样一种情况，交换机的</span><span style="font-family:Times New Roman">A </span><span style="font-family:宋体">端口</span><span style="font-family:Times New Roman">(port)</span><span style="font-family:宋体">有一个组播包需要送到主机</span><span style="font-family:Times New Roman">D</span><span style="font-family:宋体">。通
</span>

<span style="font-family:宋体">常交换机会将这个报文</span><span style="font-family:Times New Roman">flood </span><span style="font-family:宋体">到每一个端口，确保报文能够送到主机</span><span style="font-family:Times New Roman">D</span><span style="font-family:宋体">。但这样处理存在问
</span>

<span style="font-family:宋体">题，主机</span><span style="font-family:Times New Roman">D </span><span style="font-family:宋体">挂在</span><span style="font-family:Times New Roman">port C </span><span style="font-family:宋体">上，</span><span style="font-family:Times New Roman">switch </span><span style="font-family:宋体">没有必要将报文发往每一个端口，占用其他端口的网络
</span>

<span style="font-family:宋体">资源，同时也占用</span><span style="font-family:Times New Roman">CPU </span><span style="font-family:宋体">的资源。</span><span style="font-family:Times New Roman">Linux </span><span style="font-family:宋体">源码中也没有对组播报文进行特殊处理，
</span>

<span style="font-family:Times New Roman">linux-2.4.33\net\bridge\br_input.c </span><span style="font-family:宋体">行</span><span style="font-family:Times New Roman">79 br_handle_frame_finish()
</span>

<span style="font-family:Times New Roman">if (dest[0] &amp; 1) {
</span>

<span style="font-family:Times New Roman">br_flood_forward(br, skb, !passedup);/*flood </span><span style="font-family:宋体">报文到其他端口</span><span style="font-family:Times New Roman">*/
</span>

<span style="font-family:Times New Roman">if (!passedup)
</span>

<span style="font-family:Times New Roman">br_pass_frame_up(br, skb);/*</span><span style="font-family:宋体">向</span><span style="font-family:Times New Roman">local IP stack </span><span style="font-family:宋体">发送数据</span><span style="font-family:Times New Roman">*/
</span>

<span style="font-family:Times New Roman">goto out;
</span>

<span style="font-family:Times New Roman">}
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0806_IGMP4.jpg)<span style="font-family:宋体; font-size:12pt">
		</span>

<span style="font-family:宋体">针对上面所说的问题，人们提出了</span><span style="font-family:Times New Roman">IGMP snooping </span><span style="font-family:宋体">技术，该技术的主要思想是侦听每一
</span>

<span style="font-family:宋体">个端口上的</span><span style="font-family:Times New Roman">IGMP </span><span style="font-family:宋体">报文，通过解析报文获得其组播地址，将组播地址与交换机的端口联系起
</span>

<span style="font-family:宋体">来。当关系建立后，就可以通过组播组查到目的</span><span style="font-family:Times New Roman">port</span><span style="font-family:宋体">，从而不需要</span><span style="font-family:Times New Roman">flood </span><span style="font-family:宋体">报文到每一个端口
</span>

<span style="font-family:宋体">上。
</span>

<span style="font-family:宋体">交换机的桥模块维护这样一张表，以组播组为索引，组播组下记录了属于该组播组的所
</span>

<span style="font-family:宋体">有端口。当一个组播报文从</span><span style="font-family:Times New Roman">A </span><span style="font-family:宋体">口送到交换机时，交换机从报文中获取组播组地址，然后从
</span>

<span style="font-family:宋体">表中找出该组播组，将报文直接发送到下属的</span><span style="font-family:Times New Roman">C </span><span style="font-family:宋体">端口。而</span><span style="font-family:Times New Roman">E</span><span style="font-family:宋体">，</span><span style="font-family:Times New Roman">F</span><span style="font-family:宋体">，</span><span style="font-family:Times New Roman">H </span><span style="font-family:宋体">端口不会有数据送到。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0806_IGMP5.jpg)<span style="font-family:宋体; font-size:12pt">
		</span>

<span style="font-family:宋体">组播索引表采用这样的管理，桥接收到一个 </span><span style="font-family:Times New Roman">IGMP report </span><span style="font-family:宋体">报文解析</span><span style="font-family:Times New Roman">report </span><span style="font-family:宋体">报文中的组播
</span>

<span style="font-family:宋体">组，创建组播索引，将</span><span style="font-family:Times New Roman">report </span><span style="font-family:宋体">报文的端口记录下来。当然当组播组已经存在了就不需要重新
</span>

<span style="font-family:宋体">创建组播索引了，只需要检查端口确认是否要添加端口。当桥收到一个</span><span style="font-family:Times New Roman">IGMP leave </span><span style="font-family:宋体">报文时，
</span>

<span style="font-family:宋体">根据报文中的组播地址和报文端口从表中找到要离开的端口，删除端口。
</span>

<span style="font-family:宋体">是不是经过这样处理就没有问题了呢？答案是否定的。假如交换机的 </span><span style="font-family:Times New Roman">C </span><span style="font-family:宋体">端口连接的不
</span>

<span style="font-family:宋体">是主机而是一个</span><span style="font-family:Times New Roman">HUB</span><span style="font-family:宋体">，</span><span style="font-family:Times New Roman">HUB </span><span style="font-family:宋体">下挂了两台主机，并且两台主机都加入了同一个组播组，也就
</span>

<span style="font-family:宋体">是说</span><span style="font-family:Times New Roman">C </span><span style="font-family:宋体">端口下有两台主机，当其中一台主机发送</span><span style="font-family:Times New Roman">IGMP leave </span><span style="font-family:宋体">后，会导致</span><span style="font-family:Times New Roman">C </span><span style="font-family:宋体">端口被删除，结
</span>

<span style="font-family:宋体">果另一台主机也无法接收到组播数据了。
</span>

<span style="font-family:宋体">基于端口的组播报文转发是有问题的，一个解决方法是基于</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">的组播转发，组播组
</span>

<span style="font-family:宋体">下面记录的不是</span><span style="font-family:Times New Roman">port </span><span style="font-family:宋体">而是</span><span style="font-family:Times New Roman">MAC</span><span style="font-family:宋体">。当组播组有报文时需要处理时，首先查找</span><span style="font-family:Times New Roman">MAC</span><span style="font-family:宋体">，然后从
</span>

<span style="font-family:宋体">桥中根据</span><span style="font-family:Times New Roman">MAC </span><span style="font-family:宋体">找到</span><span style="font-family:Times New Roman">port</span><span style="font-family:宋体">，最后将报文转发到该</span><span style="font-family:Times New Roman">port</span><span style="font-family:宋体">。
</span>

<span style="font-family:宋体">其实许多支持 </span><span style="font-family:Times New Roman">IGMP snooping </span><span style="font-family:宋体">的交换机中组播组</span><span style="font-family:Times New Roman">n </span><span style="font-family:宋体">的最大值是确定的，一般是</span><span style="font-family:Times New Roman">256</span><span style="font-family:宋体">，我
</span>

<span style="font-family:宋体">们可以让一台主机加入到</span><span style="font-family:Times New Roman">256 </span><span style="font-family:宋体">个组播组中，把所有的组播组资源占尽，后续的其他主机的组
</span>

<span style="font-family:宋体">播报文将无法得到处理。这也算是一种攻击吧。
</span>

<span style="font-family:Times New Roman; font-size:16pt">**2\. IGMP proxy
**</span>

<span style="font-family:宋体">简单一句话：设备的上行端口担任主机的角色发送</span><span style="font-family:Times New Roman">report </span><span style="font-family:宋体">和</span><span style="font-family:Times New Roman">leave </span><span style="font-family:宋体">报文，下行端口执行
</span>

<span style="font-family:宋体">路由器的角色发送</span><span style="font-family:Times New Roman">query </span><span style="font-family:宋体">报文。
</span>

<span style="font-size:16pt"><span style="font-family:Times New Roman">**3\. IGMP report/leave **</span><span style="font-family:宋体">报文
</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0806_IGMP6.jpg)<span style="font-family:宋体; font-size:12pt">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050616_0806_IGMP7.jpg)<span style="font-family:宋体; font-size:12pt">
		</span>
