---
title: CISCO组播RPF逆向路径转发实验原理
id: 426
comment: false
categories:
  - arm
date: 2016-05-10 15:46:41
tags:
---

<span style="color:#333333; font-family:宋体; font-size:10pt">RPF,reverse path forwarding.
</span>

<!-- more -->
<span style="color:#333333; font-family:宋体; font-size:10pt">是组播转发的一个重要基础。只有当RPF检测成功以后，组播流量才能正确的在网络中进行转发。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">当在baidu或者google里面查询关键字 "CISCO RPF检测机制和工作原理",我们会轻易得到下面的原理：  www.2cto.com  
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">RPF检查的原理：[<span style="text-decoration:underline">路由器</span>](http://www.2cto.com/net/router/)在单播路由表中查找源地址以确定数据包到达的接口是否位于返回信源的的反向路径上，如果是则RPF检查成功，如果不是则标记"RPF失败丢弃"并丢弃数据包。简单来说就是根据去的数据路由表项来检查回来的包，确定去回在一线上。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">作用：对于多播，能防止环路（多播RPF检查是默认开启且不能关闭的）；对于单播，能防止IP欺骗攻击（需要手工配置RPF检查）
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">就这么简单的一句话，其实我看了很多次都没有真正理解其中的意义在于哪里。cisco也有一个专门的ppt来讲解这个问题，但是最后我还是很模糊。不知所云，但是我记住了一个概念，组播流量来的方向或者接口，在本台路由器上面show ip route x.x.x.x回去的单播路由表必须也要一致，否则的话就是RPF失败，然后把组播流量丢弃。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">今天从同事那里找了一个实验，做完以后，我发现RPF也不是那么神秘，下面就是实验过程，我们可以一起来验证一下是不是上面我理解的：
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">
![](http://www.madhex.com/wp-content/uploads/2016/05/051016_0746_CISCORPF1.jpg)

</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">在该拓扑图中，R1-R4分别按照拓扑图中的标示，配置接口IP地址，并且在每一台路由器上面使能ip multicast-routing,然后在每个接口下面配置ip pim sparse-mode.
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">R2的F0/0作为rp 候选和bsr 候选。  www.2cto.com  
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">这个时候，整个网络的单播和组播部分就已经齐活了。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">组播的配置很简单，就几条命令，该拓扑图的配置如果有疑问可以参考附件，这里就不用多的篇幅去说如何配置组播了。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">这个时候，在R4上面起一个loopback接口作为模拟连接组播客户端（接收方）的接口，在接口下面使能命令ip igmp join 224.1.1.1.
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">
![](http://www.madhex.com/wp-content/uploads/2016/05/051016_0746_CISCORPF2.jpg)

</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">然后R4的loopback0接口就会向RP发送(*,G)的join报文进行加入.
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">然后再从R1路由器上面ping 224.1.1.1,来模拟R1作为组播源在发送224.1.1.1的组播数据。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">
![](http://www.madhex.com/wp-content/uploads/2016/05/051016_0746_CISCORPF3.jpg)

</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">这里可以看到。R1去ping224.1.1.1是通的，因为R1是组播源，会发送(S,G)注册到RP,然后R4是组播客户端，会发(*,G)到rp,然后rp把S回应给R4,最后建立SPT（最短路径树)，R4从R1那里获得组播流量。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">好了，重点在于RPF是如何工作的。前面看了网上查的原理。这里用实验来证明。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">在拓扑图中，从R1到R4其实是又两条工作路径的。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">R2和R3之间，以太口相互连接，串口也相互连接。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">整网启用ospf，这个时候根据ospf最短路径优先，肯定是走的cost小的，所以从R4到R1，走的都是以太接口。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">
![](http://www.madhex.com/wp-content/uploads/2016/05/051016_0746_CISCORPF4.jpg)

</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">实验这里就开始了，假如在R3的f1/0接口下面，no ip pim sparse-mode,那么组播流量会从棕色的路径发送给R3,但是在R3上面回去的路由是红色的线路，这个时候RPF检测就失败了，因为接收组播流量的接口和回去的单播路由的接口不是同一个接口。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">在R3上面，我们可以看到：  www.2cto.com  
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">本来以前在R3上面没有再接口f1/0删除命令ip pim sparse-mode之前：
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">R3#show ip rpf 1.1.1.1
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">RPF information for ? (1.1.1.1)
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">RPF interface: FastEthernet1/0
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">RPF neighbor: ? (3.1.1.1)
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">RPF route/mask: 1.1.1.0/24
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">RPF type: unicast (ospf 1)
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">RPF recursion count: 0
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">Doing distance-preferred lookups across tables
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">当删除以后，再去看看rpf的检测：
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">R3#show ip rpf 1.1.1.1
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">RPF information for ? (1.1.1.1) failed, no route exists
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">原因在于，因为R3在f1/0移除了pim协议，所以和对端f1/0建立不起来邻居，自然组播流量不会经过以太口进行转发，R3只有从s2/0收到组播流量，但是，在R3上面的路由表由于是ospf会选择最短的路径，所以回去的时候走的是以太口，路径不匹配，丢包...
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">R3#show ip route 1.1.1.1  www.2cto.com  
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">Routing entry for 1.1.1.0/24
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">Known via "ospf 1", distance 110, metric 2, type intra area
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">Last update from 3.1.1.1 on FastEthernet1/0, 00:04:10 ago
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">Routing Descriptor Blocks:
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">* 3.1.1.1, from 3.1.1.1, 00:04:10 ago, via FastEthernet1/0
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">Route metric is 2, traffic share count is 1
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">在RPF的源检测标准中，只能有一个输入接口，选举方法如下：
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">lower AD&amp;gt;longest match&amp;gt;lower metric&amp;gt;higher ip
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">作者 hny2000
</span>
