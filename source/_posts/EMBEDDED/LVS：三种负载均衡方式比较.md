---
title: LVS：三种负载均衡方式比较
id: 346
comment: false
categories:
  - arm
date: 2016-05-04 16:02:13
tags:
---

<span style="color:#555555; font-size:12pt"><span style="font-family:Verdana">1</span><span style="font-family:宋体">、什么是[</span><span style="color:#333333"><span style="font-family:Verdana; text-decoration:underline">LVS</span><span style="color:#555555"><span style="font-family:宋体">？</span><span style="font-family:Verdana">
					</span></span></span></span>
<!-- more -->

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　首先简单介绍一下</span><span style="font-family:Verdana">LVS (<a href="http://www.chinabyte.com/keyword/Linux/" target="_blank"><span style="color:#333333; text-decoration:underline">Linux</span>](http://www.chinabyte.com/keyword/LVS/) Virtual Server)</span><span style="font-family:宋体">到底是什么东西，其实它是一种集群</span><span style="font-family:Verdana">(Cluster)</span><span style="font-family:宋体">技术，采用</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">负载均衡技术和基于内容请求分发技术。调度器具有很好的吞吐率，将请求均衡地转移到不同的[<span style="color:#333333; text-decoration:underline">服务器</span>](http://server.chinabyte.com/)上执行，且调度器自动屏蔽掉服务器的故障，从而将一组服务器构成一个高性能的、高可用的虚拟服务器。整个服务器集群的结构对客户是透明的，而且无需修改客户端和服务器端的程序。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　为此，在设计时需要考虑系统的透明性、可伸缩性、高可用性和易管理性。一般来说，</span><span style="font-family:Verdana">LVS</span><span style="font-family:宋体">集</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　群采用三层结构，其体系结构如图所示：</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050416_0802_LVS1.jpg)<span style="color:#555555; font-family:Verdana; font-size:12pt">
		</span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">LVS</span><span style="font-family:宋体">集群的体系结构</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">2</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">LVS</span><span style="font-family:宋体">主要组成部分为：</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　负载调度器</span><span style="font-family:Verdana">(load balancer/[<span style="color:#333333"> <span style="text-decoration:underline">Director</span></span>](http://www.chinabyte.com/keyword/Director/))</span><span style="font-family:宋体">，它是整个集群对外面的前端机，负责将客户的请求发送到一组服务器上执行，而客户认为服务是来自一个</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">我们可称之为虚拟</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址</span><span style="font-family:Verdana">)</span><span style="font-family:宋体">上的。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　服务器池</span><span style="font-family:Verdana">(server pool/ Realserver)</span><span style="font-family:宋体">，是一组真正执行客户请求的服务器，执行的服务一般有</span><span style="font-family:Verdana">WEB</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">MAIL</span><span style="font-family:宋体">、[</span><span style="color:#333333"><span style="font-family:Verdana; text-decoration:underline">FTP</span><span style="color:#555555"><span style="font-family:宋体">和</span><span style="font-family:Verdana">DNS</span><span style="font-family:宋体">等。</span><span style="font-family:Verdana">
					</span></span></span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　共享<a href="http://storage.chinabyte.com/" target="_blank"><span style="color:#333333; text-decoration:underline">存储</span>](http://www.chinabyte.com/keyword/FTP/)</span><span style="font-family:Verdana">(shared storage)</span><span style="font-family:宋体">，它为服务器池提供一个共享的存储区，这样很容易使得服务器池拥有相同的内容，提供相同的服务。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">3</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">LVS</span><span style="font-family:宋体">负载均衡方式</span><span style="font-family:Verdana">:
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:Verdana">Virtual Server via Network[<span style="color:#333333"> <span style="text-decoration:underline">Address</span></span>](http://www.chinabyte.com/keyword/address/) Translation NAT(VS/NAT)
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/NAT</span><span style="font-family:宋体">是一种最简单的方式，所有的</span><span style="font-family:Verdana">RealServer</span><span style="font-family:宋体">只需要将自己的[<span style="color:#333333; text-decoration:underline">网关</span>](http://www.chinabyte.com/keyword/%E7%BD%91%E5%85%B3/)指向</span><span style="font-family:Verdana">Director</span><span style="font-family:宋体">即可。客户端可以是任意[<span style="color:#333333; text-decoration:underline">操作系统</span>](http://soft.chinabyte.com/os/)，但此方式下，一个</span><span style="font-family:Verdana">Director</span><span style="font-family:宋体">能够带动的</span><span style="font-family:Verdana">RealServer</span><span style="font-family:宋体">比较有限。在</span><span style="font-family:Verdana">VS/NAT</span><span style="font-family:宋体">的方式下，</span><span style="font-family:Verdana">Director</span><span style="font-family:宋体">也可以兼为一台</span><span style="font-family:Verdana">RealServer</span><span style="font-family:宋体">。</span><span style="font-family:Verdana">VS/NAT</span><span style="font-family:宋体">的体系结构如图所示。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050416_0802_LVS2.jpg)<span style="color:#555555; font-family:Verdana; font-size:12pt">
		</span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/NAT</span><span style="font-family:宋体">的体系结构</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:Verdana">Virtual Server via IP Tunneling(VS/TUN)
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">隧道</span><span style="font-family:Verdana">(IP tunneling)</span><span style="font-family:宋体">是将一个</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">报文[<span style="color:#333333; text-decoration:underline">封装</span>](http://www.chinabyte.com/keyword/%E5%B0%81%E8%A3%85/)在另一个</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">报文的技术，这可以使得目标为一个</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址的数据报文能被封装和转发到另一个</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址。</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">隧道技术亦称为</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">封装技术</span><span style="font-family:Verdana">(IP encapsulation)</span><span style="font-family:宋体">。</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">隧道主要用于移动主机和虚拟私有网络</span><span style="font-family:Verdana">(Virtual Private Network)</span><span style="font-family:宋体">，在其中隧道都是静态建立的，隧道一端有一个</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址，另一端也有唯一的</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址。它的连接调度和管理与</span><span style="font-family:Verdana">VS/NAT</span><span style="font-family:宋体">中的一样，只是它的报文转发方法不同。调度器根据各个服务器的负载情况，动态地选择一台服务器，将请求报文封装在另一个</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">报文中，再将封装后的</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">报文转发给选出的服务器</span><span style="font-family:Verdana">;</span><span style="font-family:宋体">服务器收到报文后，先将报文解封获得原来目标地址为</span><span style="font-family:Verdana"> VIP </span><span style="font-family:宋体">的报文，服务器发现</span><span style="font-family:Verdana">VIP</span><span style="font-family:宋体">地址被配置在本地的</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">隧道设备上，所以就处理这个请求，然后根据路由表将响应报文直接返回给客户。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050416_0802_LVS3.jpg)<span style="color:#555555; font-family:Verdana; font-size:12pt">
		</span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">的体系结构</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">的工作流程：</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050416_0802_LVS4.jpg)<span style="color:#555555; font-family:Verdana; font-size:12pt">
		</span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:Verdana">Virtual Server via Direct Routing(VS/DR)
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/DR</span><span style="font-family:宋体">方式是通过改写请求报文中的[</span><span style="color:#333333"><span style="font-family:Verdana; text-decoration:underline">MAC</span><span style="color:#555555"><span style="font-family:宋体">地址部分来实现的。</span><span style="font-family:Verdana">Director</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">RealServer</span><span style="font-family:宋体">必需在物理上有一个网卡通过不间断的<a href="http://www.chinabyte.com/keyword/%E5%B1%80%E5%9F%9F%E7%BD%91/" target="_blank"><span style="color:#333333; text-decoration:underline">局域网</span>](http://www.chinabyte.com/keyword/Mac/)相连。</span><span style="font-family:Verdana"> RealServer</span><span style="font-family:宋体">上绑定的</span><span style="font-family:Verdana">VIP</span><span style="font-family:宋体">配置在各自</span><span style="font-family:Verdana">Non-[<span style="color:#333333; text-decoration:underline">ARP</span>](http://www.chinabyte.com/keyword/ARP/)</span><span style="font-family:宋体">的网络设备上</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">如</span><span style="font-family:Verdana">lo</span><span style="font-family:宋体">或</span><span style="font-family:Verdana">tunl),Director</span><span style="font-family:宋体">的</span><span style="font-family:Verdana">VIP</span><span style="font-family:宋体">地址对外可见，而</span><span style="font-family:Verdana">RealServer</span><span style="font-family:宋体">的</span><span style="font-family:Verdana">VIP</span><span style="font-family:宋体">对外是不可见的。</span><span style="font-family:Verdana">RealServer</span><span style="font-family:宋体">的地址即可以是内部地址，也可以是真实地址。</span><span style="font-family:Verdana">
					</span></span></span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050416_0802_LVS5.jpg)<span style="color:#555555; font-family:Verdana; font-size:12pt">
		</span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/DR</span><span style="font-family:宋体">的体系结构</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/DR</span><span style="font-family:宋体">的工作流程</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/DR</span><span style="font-family:宋体">的工作流程如图所示：它的连接调度和管理与</span><span style="font-family:Verdana">VS/NAT</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">中的一样，它的报文转发方法又有不同，将报文直接路由给目标服务器。在</span><span style="font-family:Verdana">VS/DR</span><span style="font-family:宋体">中，调度器根据各个服务器的负载情况，动态地选择一台服务器，不修改也不封装</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">报文，而是将数据帧的</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">地址改为选出服务器的</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">地址，再将修改后的数据帧在与服务器组的局域网上发送。因为数据帧的</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">地址是选出的服务器，所以服务器肯定可以收到这个数据帧，从中可以获得该</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">报文。当服务器发现报文的目标地址</span><span style="font-family:Verdana">VIP</span><span style="font-family:宋体">是在本地的网络设备上，服务器处理这个报文，然后根据路由表将响应报文直接返回给客户。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050416_0802_LVS6.jpg)<span style="color:#555555; font-family:Verdana; font-size:12pt">
		</span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/DR</span><span style="font-family:宋体">的工作流程</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">4</span><span style="font-family:宋体">、三种负载均衡方式比较：</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:Verdana">Virtual Server via NAT
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/NAT </span><span style="font-family:宋体">的优点是服务器可以运行任何支持[</span><span style="color:#333333"><span style="font-family:Verdana; text-decoration:underline">TCP/IP</span><span style="color:#555555"><span style="font-family:宋体">的操作系统，它只需要一个</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址配置在调度器上，服务器组可以用私有的</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址。缺点是它的伸缩能力有限，当服务器结点数目升到</span><span style="font-family:Verdana">20</span><span style="font-family:宋体">时，调度器本身有可能成为系统的新瓶颈，因为在</span><span style="font-family:Verdana">VS/NAT</span><span style="font-family:宋体">中请求和响应报文都需要通过负载调度器。我们在</span><span style="font-family:Verdana">Pentium166<a href="http://www.chinabyte.com/keyword/%E5%A4%84%E7%90%86%E5%99%A8/" target="_blank"><span style="color:#333333"> </span>](http://www.chinabyte.com/keyword/TCP/IP/)</span><span style="font-family:宋体"><span style="text-decoration:underline">处理器</span>的主机上测得重写报文的平均延时为</span><span style="font-family:Verdana">60us</span><span style="font-family:宋体">，[<span style="color:#333333; text-decoration:underline">性能更高</span>](http://www.chinabyte.com/keyword/%E6%80%A7%E8%83%BD%E6%9B%B4%E9%AB%98/)的处理器上延时会短一些。假设</span><span style="font-family:Verdana">TCP</span><span style="font-family:宋体">报文的平均长度为</span><span style="font-family:Verdana">536 Bytes</span><span style="font-family:宋体">，则调度器的最大吞吐量为</span><span style="font-family:Verdana">8.93 MBytes/s. </span><span style="font-family:宋体">我们再假设每台服务器的吞吐量为</span><span style="font-family:Verdana">800KBytes/s</span><span style="font-family:宋体">，这样一个调度器可以带动</span><span style="font-family:Verdana">10</span><span style="font-family:宋体">台服务器。</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">注：这是很早以前测得的数据</span><span style="font-family:Verdana">)
</span></span></span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　基于</span><span style="font-family:Verdana"> VS/NAT</span><span style="font-family:宋体">的的集群系统可以适合许多服务器的性能要求。如果负载调度器成为系统新的瓶颈，可以有三种方法解决这个问题：混合方法、</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">和</span><span style="font-family:Verdana"> VS/DR</span><span style="font-family:宋体">。在</span><span style="font-family:Verdana">DNS</span><span style="font-family:宋体">混合集群系统中，有若干个</span><span style="font-family:Verdana">VS/NAT</span><span style="font-family:宋体">负调度器，每个负载调度器带自己的服务器集群，同时这些负载调度器又通过</span><span style="font-family:Verdana">RR-DNS</span><span style="font-family:宋体">组成简单的[<span style="color:#333333; text-decoration:underline">域名</span>](http://www.chinabyte.com/keyword/%E5%9F%9F%E5%90%8D/)。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　但</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">VS/DR</span><span style="font-family:宋体">是提高系统吞吐量的更好方法。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　对于那些将</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址或者端口号在报文数据中传送的网络服务，需要编写相应的应用[<span style="color:#333333; text-decoration:underline">模块</span>](http://www.chinabyte.com/keyword/%E6%A8%A1%E5%9D%97/)来转换报文数据中的</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址或者端口号。这会带来实现的工作量，同时应用模块检查报文的开销会降低系统的吞吐率。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:Verdana">Virtual Server via IP Tunneling
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　在</span><span style="font-family:Verdana">VS/TUN </span><span style="font-family:宋体">的集群系统中，负载调度器只将请求调度到不同的后端服务器，后端服务器将应答的数据直接返回给用户。这样，负载调度器就可以处理大量的请求，它甚至可以调度百台以上的服务器</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">同等规模的服务器</span><span style="font-family:Verdana">)</span><span style="font-family:宋体">，而它不会成为系统的瓶颈。即使负载调度器只有</span><span style="font-family:Verdana">100Mbps</span><span style="font-family:宋体">的全双工网卡，整个系统的最大吞吐量可超过</span><span style="font-family:Verdana"> 1Gbps</span><span style="font-family:宋体">。所以，</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">可以极大地增加负载调度器调度的服务器数量。</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">调度器可以调度上百台服务器，而它本身不会成为系统的瓶颈，可以用来构建高性能的超级服务器。</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">技术对服务器有要求，即所有的服务器必须支持</span><span style="font-family:Verdana">"IP Tunneling"</span><span style="font-family:宋体">或者</span><span style="font-family:Verdana">"IP Encapsulation"</span><span style="font-family:宋体">协议。目前，</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">的后端服务器主要运行</span><span style="font-family:Verdana">Linux</span><span style="font-family:宋体">操作系统，我们没对其他操作系统进行测试。因为</span><span style="font-family:Verdana">"IP Tunneling"</span><span style="font-family:宋体">正成为各个操作系统的标准协议，所以</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">应该会适用运行其他操作系统的后端服务器。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:Verdana">Virtual Server via Direct Routing
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　跟</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">方法一样，</span><span style="font-family:Verdana">VS/DR</span><span style="font-family:宋体">调度器只处理客户到服务器端的连接，响应数据可以直接从独立的网络路由返回给客户。这可以极大地提高</span><span style="font-family:Verdana">LVS</span><span style="font-family:宋体">集群系统的伸缩性。跟</span><span style="font-family:Verdana">VS/TUN</span><span style="font-family:宋体">相比，这种方法没有</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">隧道的开销，但是要求负载调度器与实际服务器都有一块网卡连在同一物理网段上，服务器网络设备</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">或者设备别名</span><span style="font-family:Verdana">)</span><span style="font-family:宋体">不作</span><span style="font-family:Verdana">ARP</span><span style="font-family:宋体">响应，或者能将报文重定向</span><span style="font-family:Verdana">(Redirect)</span><span style="font-family:宋体">到本地的</span><span style="font-family:Verdana">Socket</span><span style="font-family:宋体">端口上。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　三种</span><span style="font-family:Verdana">LVS</span><span style="font-family:宋体">负载均衡技术的优缺点归纳以下表：</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">VS/NATVS/TUNVS/DR
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　服务器操作系统任意支持隧道多数</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">支持</span><span style="font-family:Verdana">Non-arp)
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　服务器网络私有网络局域网</span><span style="font-family:Verdana">/</span><span style="font-family:宋体">广域网局域网</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　服务器数目</span><span style="font-family:Verdana">(100M</span><span style="font-family:宋体">网络</span><span style="font-family:Verdana">)10~20100</span><span style="font-family:宋体">大于</span><span style="font-family:Verdana">100
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　服务器网关负载均衡器自己的路由自己的路由</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　效率一般高最高</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　注：以上三种方法所能支持最大服务器数目的估计是假设调度器使用</span><span style="font-family:Verdana">100M</span><span style="font-family:宋体">网卡，调度器的硬件配置与后端服务器的硬件配置相同，而且是对一般</span><span style="font-family:Verdana">Web</span><span style="font-family:宋体">服务。使</span><span style="font-family:Verdana">
			</span><span style="font-family:宋体">用更高的硬件配置</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">如千兆网卡和更快的处理器</span><span style="font-family:Verdana">)</span><span style="font-family:宋体">作为调度器，调度器所能调度的服务器数量会相应增加。当应用不同时，服务器的数目也会相应地改变。所以，以上数据估计主要是为三种方法的伸缩性进行量化比较。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">5</span><span style="font-family:宋体">、负载均衡调度算法</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:宋体">最少的连接方式</span><span style="font-family:Verdana">(Least Connection)</span><span style="font-family:宋体">：传递新的连接给那些进行最少连接处理的服务器。当其中某个服务器发生第二到第</span><span style="font-family:Verdana">7 </span><span style="font-family:宋体">层的故障，</span><span style="font-family:Verdana">BIG-IP </span><span style="font-family:宋体">就把其从服务器队列中拿出，不参加下一次的用户请求的分配</span><span style="font-family:Verdana">, </span><span style="font-family:宋体">直到其恢复正常。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:宋体">最快模式</span><span style="font-family:Verdana">(Fastest)</span><span style="font-family:宋体">：传递连接给那些响应最快的服务器。当其中某个服务器发生第二到第</span><span style="font-family:Verdana">7 </span><span style="font-family:宋体">层的故障，</span><span style="font-family:Verdana">BIG-IP </span><span style="font-family:宋体">就把其从服务器队列中拿出，不参加下一次的用户请求的分配，直到其恢复正常。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:宋体">观察模式</span><span style="font-family:Verdana">(Observed)</span><span style="font-family:宋体">：连接数目和响应时间以这两项的最佳平衡为依据为新的请求选择服务器。当其中某个服务器发生第二到第</span><span style="font-family:Verdana">7 </span><span style="font-family:宋体">层的故障，</span><span style="font-family:Verdana">BIG-IP</span><span style="font-family:宋体">就把其从服务器队列中拿出，不参加下一次的用户请求的分配，直到其恢复正常。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:宋体">预测模式</span><span style="font-family:Verdana">(Predictive)</span><span style="font-family:宋体">：</span><span style="font-family:Verdana">BIG-IP</span><span style="font-family:宋体">利用收集到的服务器当前的性能指标，进行预测分析，选择一台服务器在下一个时间片内，其性能将达到最佳的服务器相应用户的请求。</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">被</span><span style="font-family:Verdana">BIG-IP </span><span style="font-family:宋体">进行检测</span><span style="font-family:Verdana">)
</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:宋体">动态性能分配</span><span style="font-family:Verdana">(Dynamic Ratio-APM):BIG-IP </span><span style="font-family:宋体">收集到的应用程序和[<span style="color:#333333; text-decoration:underline">应用服务</span>](http://www.chinabyte.com/keyword/%E5%BA%94%E7%94%A8%E6%9C%8D%E5%8A%A1/)器的各项性能参数，动态调整流量分配。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:宋体">动态服务器补充</span><span style="font-family:Verdana">(Dynamic Server Act.):</span><span style="font-family:宋体">当主服务器群中因故障导致数量减少时，动态地将备份服务器补充至主服务器群。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:宋体">服务质量</span><span style="font-family:Verdana">(QoS):</span><span style="font-family:宋体">按不同的优先级对数据流进行分配。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:宋体">服务类型</span><span style="font-family:Verdana">(ToS): </span><span style="font-family:宋体">按不同的服务类型</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">在</span><span style="font-family:Verdana">Type of Field</span><span style="font-family:宋体">中标识</span><span style="font-family:Verdana">)</span><span style="font-family:宋体">负载均衡对数据流进行分配。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#555555; font-size:12pt"><span style="font-family:宋体">　　</span><span style="font-family:微软雅黑">◆</span><span style="font-family:宋体">规则模式：针对不同的数据流设置导向规则，用户可自行。</span><span style="font-family:Verdana">
			</span></span>
