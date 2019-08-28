---
title: CCNP-冗余链路中的广播风暴、多帧复制、地址表的不稳定
id: 782
comment: false
categories:
  - arm
date: 2016-07-08 14:07:20
tags:
---

<span style="color:purple; font-size:12pt"><span style="font-family:Arial">**STP**</span><span style="font-family:宋体">**协议：**<span style="color:#666666">当网络中存在备份链路时，只允许主链路激活，如果主链路因故障而断开后，备用链路才会被打开。</span></span><span style="font-family:Arial">
			</span></span>

<!-- more -->
<span style="color:purple; font-size:12pt"><span style="font-family:宋体">**广播风暴：**<span style="color:#666666">在没有避免交换环路措施的情况下，每个交换机都无穷无尽的转发广播帧。广播流量破坏了正常的通信流，消耗了带宽和交换机的</span></span><span style="font-family:Arial">CPU</span><span style="color:#666666"><span style="font-family:宋体">资源，直至交换机死机或者关机才算结束。</span><span style="font-family:Arial">
				</span></span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">举例问答解释：</span><span style="font-family:Arial">
			</span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">交换机什么情况下产生广播？目标</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">在</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">表中不存在时。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">广播发送到哪些主机？和发送端位于同一广播域中的主机。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">什么是风暴？大量广播包在局部范围内不断地复制转发。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">为什么产生风暴？本质就是广播包的不正常地复制或产生，其中重要的一条就是一环路的存在。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">环路为什么会产生风暴？假设</span><span style="font-family:Arial">AB</span><span style="font-family:宋体">两点成环，位于同一交换机。</span><span style="font-family:Arial">A</span><span style="font-family:宋体">发出未知地址的广播包，</span><span style="font-family:Arial">B</span><span style="font-family:宋体">接收到后由于交换机中无此</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">，重新发起一个广播，此广播包又到达</span><span style="font-family:Arial">A</span><span style="font-family:宋体">，由于目标无法从</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">表中匹配，</span><span style="font-family:Arial">A</span><span style="font-family:宋体">会再次发一起个广播，这样不停循环下去，就产生了广播风暴。</span><span style="font-family:Arial">
			</span></span>

<span style="color:purple; font-size:12pt"><span style="font-family:宋体">**多帧复制：也叫重复帧传送，**<span style="color:#666666">单播的数据帧可能被多次复制传送到目的站点。很多协议都只需要每次传输一个拷贝。多帧复制会造成目的站点收到某个数据帧的多个副本，不但浪费了目的主机的资源，还会导致上层协议在处理这些数据帧时无法选择，严重时还可能导致不可恢复的错误。</span></span><span style="font-family:Arial">
			</span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">举例：![](http://www.madhex.com/wp-content/uploads/2016/07/070816_0608_CCNP1.jpg)</span><span style="font-family:Arial">
			</span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">当主机</span><span style="font-family:Arial">A</span><span style="font-family:宋体">发送一个给主机</span><span style="font-family:Arial">B</span><span style="font-family:宋体">的单播帧，此时交换机</span><span style="font-family:Arial">SW1</span><span style="font-family:宋体">的</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">地址表中如果没有主机Ｂ的条目，则会把这个单播帧从端口</span><span style="font-family:Arial">F0/1</span><span style="font-family:宋体">和</span><span style="font-family:Arial">F0/2</span><span style="font-family:宋体">泛洪出去。因此，交换机</span><span style="font-family:Arial">SW2</span><span style="font-family:宋体">就会从端口</span><span style="font-family:Arial">F0/1</span><span style="font-family:宋体">和</span><span style="font-family:Arial">F0/2</span><span style="font-family:宋体">分别收到</span><span style="font-family:Arial">2</span><span style="font-family:宋体">个发给主机</span><span style="font-family:Arial">B</span><span style="font-family:宋体">的单播帧，如果交换机</span><span style="font-family:Arial">SW2</span><span style="font-family:宋体">的</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">地址表中已经有了主机</span><span style="font-family:Arial">B</span><span style="font-family:宋体">的条目，它就会将这两个帧分别转发给主机</span><span style="font-family:Arial">B</span><span style="font-family:宋体">，这样主机</span><span style="font-family:Arial">B</span><span style="font-family:宋体">就收到了同一个帧的二份拷贝，于是形成了多帧复制。</span><span style="font-family:Arial">
			</span></span>

<span style="color:purple; font-size:12pt">**<span style="font-family:Arial">MAC</span><span style="font-family:宋体">地址表抖动：也就是</span><span style="font-family:Arial">MAC</span>**<span style="font-family:宋体">**地址表不稳定，**<span style="color:#666666">这是由于相同帧的拷贝在交换机的不同端口上被接收引起的。如果交换机将资源都消耗在复制不稳定的</span></span><span style="font-family:Arial">MAC</span><span style="color:#666666"><span style="font-family:宋体">地址表上，那么数据转发的功能就可能被消弱了。</span><span style="font-family:Arial">
				</span></span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">举例：![](http://www.madhex.com/wp-content/uploads/2016/07/070816_0608_CCNP2.jpg)</span><span style="font-family:Arial">
			</span></span>

<span style="color:#666666; font-size:12pt"><span style="font-family:宋体">当交换机</span><span style="font-family:Arial">SW2</span><span style="font-family:宋体">从端口</span><span style="font-family:Arial">F0/1</span><span style="font-family:宋体">收到主机</span><span style="font-family:Arial">A</span><span style="font-family:宋体">发出的单播帧时，它会将端口</span><span style="font-family:Arial">F0/1</span><span style="font-family:宋体">与主机</span><span style="font-family:Arial">A</span><span style="font-family:宋体">的对应关系写入</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">地址表；而当它随后又从端口</span><span style="font-family:Arial">F0/2</span><span style="font-family:宋体">收到主机</span><span style="font-family:Arial">A</span><span style="font-family:宋体">发出的单播帧时，会将</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">地址表中的主机</span><span style="font-family:Arial">A</span><span style="font-family:宋体">对应的端口改为</span><span style="font-family:Arial">F0/2</span><span style="font-family:宋体">，这就造成了</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">表的抖动。当主机</span><span style="font-family:Arial">B</span><span style="font-family:宋体">向主机</span><span style="font-family:Arial">A</span><span style="font-family:宋体">回复了一个单播帧后，同样的情况也会发生在交换机</span><span style="font-family:Arial">SW1</span><span style="font-family:宋体">中。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#666666; font-size:12pt">**<span style="font-family:宋体">感谢</span><span style="font-family:Arial">internet</span><span style="font-family:宋体">！</span>**<span style="font-family:Arial">
			</span></span>
