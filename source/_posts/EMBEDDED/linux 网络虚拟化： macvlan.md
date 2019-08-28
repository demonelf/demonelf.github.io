---
title: linux 网络虚拟化： macvlan
id: 1102
comment: false
categories:
  - arm
date: 2017-05-18 13:22:34
tags:
---

<span style="color:#222222; font-size:18pt">**<span style="font-family:Arial">macvlan </span><span style="font-family:宋体">简介</span><span style="font-family:Arial">
				</span>**</span>
<!-- more -->

<span style="color:#222222; font-size:12pt"><span style="font-family:Arial">macvlan </span><span style="font-family:宋体">是</span><span style="font-family:Arial"> linux kernel </span><span style="font-family:宋体">比较新的特性，可以通过以下方法判断当前系统是否支持：</span><span style="font-family:Arial">
			</span></span>

<span style="color:#555555; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">$ <span style="color:black">modprobe macvlan
</span></span>

<span style="color:#555555; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">$ <span style="color:black">lsmod | grep macvlan
</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">  macvlan    <span style="color:#008800">19046<span style="color:black">
					<span style="color:#008800">0<span style="color:black">
						</span></span></span></span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">如果第一个命令报错，或者第二个命令没有返回，则说明当前系统不支持</span><span style="font-family:Arial"> macvlan</span><span style="font-family:宋体">，需要升级系统或者升级内核。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:Arial">macvlan </span><span style="font-family:宋体">允许你在主机的一个网络接口上配置多个虚拟的网络接口，这些网络</span><span style="font-family:Arial"> interface </span><span style="font-family:宋体">有自己独立的</span><span style="font-family:Arial"> mac </span><span style="font-family:宋体">地址，也可以配置上</span><span style="font-family:Arial"> ip </span><span style="font-family:宋体">地址进行通信。</span><span style="font-family:Arial">macvlan </span><span style="font-family:宋体">下的虚拟机或者容器网络和主机在同一个网段中，共享同一个广播域。</span><span style="font-family:Arial">macvlan </span><span style="font-family:宋体">和</span><span style="font-family:Arial"> bridge </span><span style="font-family:宋体">比较相似，但因为它省去了</span><span style="font-family:Arial"> bridge </span><span style="font-family:宋体">的存在，所以配置和调试起来比较简单，而且效率也相对高。除此之外，</span><span style="font-family:Arial">macvlan </span><span style="font-family:宋体">自身也完美支持</span><span style="font-family:Arial"> VLAN</span><span style="font-family:宋体">。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">如果希望容器或者虚拟机放在主机相同的网络中，享受已经存在网络栈的各种优势，可以考虑</span><span style="font-family:Arial"> macvlan</span><span style="font-family:宋体">。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:18pt">**<span style="font-family:宋体">各个</span><span style="font-family:Arial"> linux </span><span style="font-family:宋体">发行版对</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">的支持</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:#222222; font-size:12pt"><span style="font-family:Arial">macvlan </span><span style="font-family:宋体">对</span><span style="font-family:Arial">kernel </span><span style="font-family:宋体">版本依赖：</span><span style="font-family:Arial">Linux kernel v3.9–3.19 and 4.0+</span><span style="font-family:宋体">。几个重要发行版支持情况：</span><span style="font-family:Arial">
			</span></span>

*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">ubuntu</span><span style="font-family:宋体">：</span><span style="font-family:Arial">&gt;= saucy(13.10)
</span></span></div>
*   <div style="background: white"><span style="color:#222222; font-family:Arial; font-size:12pt">RHEL(Red Hat Enterprise Linux): &gt;= 7.0(3.10.0)
</span></div>
*   <div style="background: white"><span style="color:#222222; font-family:Arial; font-size:12pt">Fedora: &gt;=19(3.9)
</span></div>
*   <div style="background: white"><span style="color:#222222; font-family:Arial; font-size:12pt">Debian: &gt;=8(3.16)
</span></div>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">各个发行版的</span><span style="font-family:Arial"> kernel </span><span style="font-family:宋体">都可以自行手动升级，具体操作可以参考官方提供的文档。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">以上版本信息参考了这些资料：</span><span style="font-family:Arial">
			</span></span>

*   <div style="background: white">[<span style="color:#555555; font-family:Arial; font-size:12pt; text-decoration:underline">List of ubuntu versions with corresponding linux kernel version</span>](http://askubuntu.com/questions/517136/list-of-ubuntu-versions-with-corresponding-linux-kernel-version)<span style="color:#222222; font-family:Arial; font-size:12pt">
				</span></div>
*   <div style="background: white">[<span style="color:#555555; font-family:Arial; font-size:12pt; text-decoration:underline">Red Hat Enterprise Linux Release Dates</span>](https://access.redhat.com/articles/3078)<span style="color:#222222; font-family:Arial; font-size:12pt">
				</span></div>

<span style="color:#222222; font-size:18pt">**<span style="font-family:宋体">四种模式</span><span style="font-family:Arial">
				</span>**</span>

*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">private mode</span><span style="font-family:宋体">：过滤掉所有来自其他</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口的报文，因此不同</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口之间无法互相通信</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">vepa(Virtual Ethernet Port Aggregator) mode</span><span style="font-family:宋体">：</span><span style="font-family:Arial">
					</span><span style="font-family:宋体">需要主接口连接的交换机支持</span><span style="font-family:Arial"> VEPA/802.1Qbg </span><span style="font-family:宋体">特性。所有发送出去的报文都会经过交换机，交换机作为再发送到对应的目标地址（即使目标地址就是主机上的其他</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口），也就是</span><span style="font-family:Arial"> hairpin mode </span><span style="font-family:宋体">模式，这个模式用在交互机上需要做过滤、统计等功能的场景。</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">bridge mode</span><span style="font-family:宋体">：通过虚拟的交换机讲主接口的所有</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口连接在一起，这样的话，不同</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口之间能够直接通信，不需要将报文发送到主机之外。这个模式下，主机外是看不到主机上</span><span style="font-family:Arial"> macvlan interface </span><span style="font-family:宋体">之间通信的报文的。</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">passthru mode</span><span style="font-family:宋体">：暂时没有搞清楚这个模式要解决的问题</span><span style="font-family:Arial">
					</span></span></div>

<span style="color:#222222; font-size:12pt"><span style="font-family:Arial">VEPA </span><span style="font-family:宋体">和</span><span style="font-family:Arial"> passthru </span><span style="font-family:宋体">模式下，两个</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口之间的通信会经过主接口两次：第一次是发出的时候，第二次是返回的时候。这样会影响物理接口的宽带，也限制了不同</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口之间通信的速度。如果多个</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口之间通信比较频繁，对于性能的影响会比较明显。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:Arial">private </span><span style="font-family:宋体">模式下，所有的</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口都不能互相通信，对性能影响最小。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:Arial">bridge </span><span style="font-family:宋体">模式下，数据报文是通过内存直接转发的，因此效率会高一些，但是会造成</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">额外的计算量。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:Arial">**NOTE**</span><span style="font-family:宋体">：如果要手动分配</span><span style="font-family:Arial"> mac </span><span style="font-family:宋体">地址，请注意本地的</span><span style="font-family:Arial"> mac </span><span style="font-family:宋体">地址最高位字节的低位第二个</span><span style="font-family:Arial"> bit </span><span style="font-family:宋体">必须是</span><span style="font-family:Arial"> 1</span><span style="font-family:宋体">。比如</span><span style="font-family:Arial"> </span><span style="font-family:Courier New; background-color:#f2f2f2">02:xx:xx:xx:xx:xx</span><span style="font-family:宋体">。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:18pt">**<span style="font-family:宋体">实验</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">为了方便演示，我们会创建出来两个</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口，分别放到不同的</span><span style="font-family:Arial"> [<span style="color:#555555; text-decoration:underline">network namespace</span>](http://cizixs.com/2017/02/10/network-virtualization-network-namespace) </span><span style="font-family:宋体">里。整个实验的网络拓扑结构如下：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2017/05/051817_0522_linuxma1.png)<span style="color:#222222; font-family:Arial; font-size:12pt">
		</span>

[<span style="color:#555555; font-family:宋体; font-size:12pt; text-decoration:underline">图片来源</span>](http://hicu.be/docker-networking-macvlan-bridge-mode-configuration)<span style="color:#222222; font-family:Arial; font-size:12pt">
		</span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">首先还是创建两个</span><span style="font-family:Arial"> network namespace</span><span style="font-family:宋体">：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#888888"># ip netns add net1<span style="color:black">
				</span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#888888"># ip netns add net2<span style="color:black">
				</span></span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">然后创建</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口</span><span style="font-family:Arial">:
</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># ip link add link enp0s8 mac1 type macvlan<span style="color:black">
				</span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># ip link<span style="color:black">
				</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">23<span style="color:black">: mac1@enp0s8: &lt;BROADCAST,MULTICAST&gt; mtu <span style="color:#008800">1500<span style="color:black"> qdisc noop state DOWN mode DEFAULT
</span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">    link/ether e2:<span style="color:#008800">80<span style="color:black">:<span style="color:#008800">1<span style="color:black">c:ba:<span style="color:#008800">59<span style="color:black">:<span style="color:#008800">9<span style="color:black">c brd ff:ff:ff:ff:ff:ff
</span></span></span></span></span></span></span></span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">创建的格式为</span><span style="font-family:Arial"> </span><span style="font-family:Courier New; background-color:#f2f2f2">ip link add link &lt;PARENT&gt; &lt;NAME&gt; type macvlan</span><span style="font-family:宋体">，其中</span><span style="font-family:Arial"> </span><span style="font-family:Courier New; background-color:#f2f2f2">&lt;PARENT&gt;</span><span style="font-family:Arial"> </span><span style="font-family:宋体">是</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口的父</span><span style="font-family:Arial"> interface </span><span style="font-family:宋体">名称，</span><span style="font-family:Courier New; background-color:#f2f2f2">&lt;NAME&gt;</span><span style="font-family:Arial"> </span><span style="font-family:宋体">是新建的</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口的名称，这个名字可以任意取。使用</span><span style="font-family:Arial"> </span><span style="font-family:Courier New; background-color:#f2f2f2">ip link</span><span style="font-family:Arial"> </span><span style="font-family:宋体">可以看到我们刚创建的</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口，除了它自己的名字之外，后面还跟着父接口的名字。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">下面就是把创建的</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">放到</span><span style="font-family:Arial"> network namespace </span><span style="font-family:宋体">中，配置好</span><span style="font-family:Arial"> ip </span><span style="font-family:宋体">地址，然后启用它：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># ip link set mac1@enp0s8 netns net1<span style="color:black">
				</span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">Cannot find device <span style="color:#880000">"mac1@enp0s8"<span style="color:black">
				</span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># ip link set mac1 netns net1<span style="color:black">
				</span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># ip netns exec net1 ip link<span style="color:black">
				</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">23<span style="color:black">: mac1@if3: &lt;BROADCAST,MULTICAST&gt; mtu <span style="color:#008800">1500<span style="color:black"> qdisc noop state DOWN mode DEFAULT
</span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">    link/ether e2:<span style="color:#008800">80<span style="color:black">:<span style="color:#008800">1<span style="color:black">c:ba:<span style="color:#008800">59<span style="color:black">:<span style="color:#008800">9<span style="color:black">c brd ff:ff:ff:ff:ff:ff
</span></span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># ip netns exec net1 ip link set mac1 name eth0<span style="color:black">
				</span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># ip netns exec net1 ip link<span style="color:black">
				</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">23<span style="color:black">: eth0@if3: &lt;BROADCAST,MULTICAST&gt; mtu <span style="color:#008800">1500<span style="color:black"> qdisc noop state DOWN mode DEFAULT
</span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">    link/ether e2:<span style="color:#008800">80<span style="color:black">:<span style="color:#008800">1<span style="color:black">c:ba:<span style="color:#008800">59<span style="color:black">:<span style="color:#008800">9<span style="color:black">c brd ff:ff:ff:ff:ff:ff
</span></span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># ip netns exec net1 ip addr add <span style="color:#008800">192.168.8.120<span style="color:#880000">/<span style="color:#008800">24<span style="color:#880000"> dev eth0<span style="color:black">
								</span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># ip netns exec net1 ip link set eth0 up<span style="color:black">
				</span></span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">同理可以配置另外一个</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">接口，可以测试两个</span><span style="font-family:Arial"> ip </span><span style="font-family:宋体">的连通性：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># docker exec <span style="color:#008800">1444<span style="color:#880000"> ping -c <span style="color:#008800">3<span style="color:#880000">
								<span style="color:#008800">192.168.8.120<span style="color:black">
									</span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">PING <span style="color:#008800">192.168.8.120<span style="color:black">
					**(**<span style="color:#008800">192.168.8.120<span style="color:black">**)**: <span style="color:#008800">56<span style="color:black"> data bytes
</span></span></span></span></span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">64<span style="color:black"> bytes from <span style="color:#008800">192.168.8.120<span style="color:black">: <span style="color:teal">seq<span style="color:black">**=**<span style="color:#008800">0<span style="color:black">
										<span style="color:teal">ttl<span style="color:black">**=**<span style="color:#008800">64<span style="color:black">
														<span style="color:#0086b3">time<span style="color:black">**=**<span style="color:#008800">0.130<span style="color:black"> ms
</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">64<span style="color:black"> bytes from <span style="color:#008800">192.168.8.120<span style="color:black">: <span style="color:teal">seq<span style="color:black">**=**<span style="color:#008800">1<span style="color:black">
										<span style="color:teal">ttl<span style="color:black">**=**<span style="color:#008800">64<span style="color:black">
														<span style="color:#0086b3">time<span style="color:black">**=**<span style="color:#008800">0.099<span style="color:black"> ms
</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">64<span style="color:black"> bytes from <span style="color:#008800">192.168.8.120<span style="color:black">: <span style="color:teal">seq<span style="color:black">**=**<span style="color:#008800">2<span style="color:black">
										<span style="color:teal">ttl<span style="color:black">**=**<span style="color:#008800">64<span style="color:black">
														<span style="color:#0086b3">time<span style="color:black">**=**<span style="color:#008800">0.083<span style="color:black"> ms
</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">--- <span style="color:#008800">192.168.8.120<span style="color:black"> ping statistics ---
</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">3<span style="color:black"> packets transmitted, <span style="color:#008800">3<span style="color:black"> packets received, <span style="color:#008800">0<span style="color:black">% packet loss
</span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">round-trip min/avg/max **=**
			<span style="color:#008800">0.083<span style="color:black">/<span style="color:#008800">0.104<span style="color:black">/<span style="color:#008800">0.130<span style="color:black"> ms
</span></span></span></span></span></span></span>

<span style="color:#222222; font-size:18pt">**<span style="font-family:宋体">在</span><span style="font-family:Arial"> docker </span><span style="font-family:宋体">中的使用</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:#222222; font-size:12pt"><span style="font-family:Arial">docker1.12 </span><span style="font-family:宋体">版本也正式支持了</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">和</span><span style="font-family:Arial"> ipvlan </span><span style="font-family:宋体">网络模式。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:13pt">**<span style="font-family:宋体">创建</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">网络</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">管理</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">和其他类型的网络类似，通过</span><span style="font-family:Arial"> </span><span style="font-family:Courier New; background-color:#f2f2f2">docker network</span><span style="font-family:Arial"> </span><span style="font-family:宋体">子命令就能实现。创建</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">网络的时候，需要知道主机的网段和网关地址，虚拟网络要依附的物理网卡。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]# docker network **create** -**d** macvlan <span style="color:#888888">--subnet**=**192.168.8.0/24 --gateway**=**192.168.8.1 -o parent**=**enp0s8 mcv<span style="color:black">
				</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">9<span style="color:black">fad35e54a2f53c9314626f89cf8a705799ed382ddac01c865be1f4d04fdcb8f
</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]# docker network ls
</span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">NETWORK **ID**
			**NAME**                DRIVER              **SCOPE**
		</span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">e06b6e00dd3b        bridge              bridge              <span style="color:#0086b3">**local**
			</span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">823<span style="color:black">b7bb07c41        host                host                <span style="color:#0086b3">**local**
				</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">9<span style="color:black">fad35e54a2f        mcv                 macvlan             <span style="color:#0086b3">**local**
				</span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">dc7c667aca19        **none**
			<span style="color:#008800">null<span style="color:black">
					<span style="color:#0086b3">**local**<span style="color:black">
						</span></span></span></span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">选项说明：</span><span style="font-family:Arial">
			</span></span>

*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">subnet</span><span style="font-family:宋体">：网络</span><span style="font-family:Arial"> CIDR </span><span style="font-family:宋体">地址</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">gateway</span><span style="font-family:宋体">：网关地址</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">aux-address</span><span style="font-family:宋体">：不要分配给容器的</span><span style="font-family:Arial"> ip </span><span style="font-family:宋体">地址。字典，以</span><span style="font-family:Arial"> key=value </span><span style="font-family:宋体">对出现</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">ip-range</span><span style="font-family:宋体">：指定具体的</span><span style="font-family:Arial"> ip </span><span style="font-family:宋体">分配区间，也是</span><span style="font-family:Arial"> CIDR </span><span style="font-family:宋体">格式，必须是</span><span style="font-family:Arial"> subnet </span><span style="font-family:宋体">指定范围的子集</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">opt(o)</span><span style="font-family:宋体">：和</span><span style="font-family:Arial"> macvlan driver </span><span style="font-family:宋体">相关的选项，以</span><span style="font-family:Arial"> key=value </span><span style="font-family:宋体">的格式出现</span><span style="font-family:Arial">
					</span></span></div>

        *   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">parent=eth0: </span><span style="font-family:宋体">指定</span><span style="font-family:Arial"> parent interface
</span></span></div>
    *   <div style="background: white"><span style="color:#222222; font-size:12pt"><span style="font-family:Arial">macvlan_mode</span><span style="font-family:宋体">：</span><span style="font-family:Arial">macvlan </span><span style="font-family:宋体">模式，默认是</span><span style="font-family:Arial"> bridge
</span></span></div>

<span style="color:#222222; font-size:13pt">**<span style="font-family:宋体">运行容器</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">创建好网络之后，我们就可以使用刚创建的网络运行两个容器，测试网络的连通性。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># docker run --net**=**mac192 -d --rm alpine top<span style="color:black">
				</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">5e950<span style="color:black">cf86cda7b4e6fc4bd869834943edacaaf969051293021c75330bbc18b53
</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># docker run --net**=**mac192 -d --rm alpine top<span style="color:black">
				</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">9067<span style="color:black">c54aac79e65b3193a137e95a180a7e5cc4a2845cc664f53c17a244be3853
</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># docker ps<span style="color:black">
				</span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
</span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">9067<span style="color:black">c54aac79        alpine              <span style="color:#880000">"top"<span style="color:black">
						<span style="color:#008800">7<span style="color:black"> seconds ago       Up <span style="color:#008800">6<span style="color:black"> seconds                            sharp_hodgkin
</span></span></span></span></span></span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">5e950<span style="color:black">cf86cda        alpine              <span style="color:#880000">"top"<span style="color:black">
						<span style="color:#008800">8<span style="color:black"> seconds ago       Up <span style="color:#008800">7<span style="color:black"> seconds                            peaceful_chandrasekhar
</span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># docker exec <span style="color:#008800">906<span style="color:#880000"> ip addr<span style="color:black">
						</span></span></span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">1<span style="color:black">: lo: &lt;LOOPBACK,UP,LOWER_UP&gt; mtu <span style="color:#008800">65536<span style="color:black"> qdisc noqueue state UNKNOWN
</span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">    link/loopback <span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black"> brd <span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black">:<span style="color:#008800">00<span style="color:black">
																										</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">    inet <span style="color:#008800">127.0.0.1<span style="color:black">/<span style="color:#008800">8<span style="color:black"> scope host lo
</span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">       valid_lft forever preferred_lft forever
</span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">    inet6 ::<span style="color:#008800">1<span style="color:black">/<span style="color:#008800">128<span style="color:black"> scope host
</span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">       valid_lft forever preferred_lft forever
</span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">16<span style="color:black">: eth0@if3: &lt;BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN&gt; mtu <span style="color:#008800">1500<span style="color:black"> qdisc noqueue state UNKNOWN
</span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">    link/ether <span style="color:#008800">02<span style="color:black">:<span style="color:#008800">42<span style="color:black">:c0:a8:<span style="color:#008800">08<span style="color:black">:<span style="color:#008800">03<span style="color:black"> brd ff:ff:ff:ff:ff:ff
</span></span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">    inet <span style="color:#008800">192.168.8.3<span style="color:black">/<span style="color:#008800">24<span style="color:black"> scope global eth0
</span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">       valid_lft forever preferred_lft forever
</span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">    inet6 fe80::<span style="color:#008800">42<span style="color:black">:c0ff:fea8:<span style="color:#008800">803<span style="color:black">/<span style="color:#008800">64<span style="color:black"> scope link
</span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">       valid_lft forever preferred_lft forever
</span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># docker exec <span style="color:#008800">5e9<span style="color:#880000"> ping -c <span style="color:#008800">3<span style="color:#880000">
								<span style="color:#008800">192.168.8.3<span style="color:black">
									</span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">PING <span style="color:#008800">192.168.8.3<span style="color:black">
					**(**<span style="color:#008800">192.168.8.3<span style="color:black">**)**: <span style="color:#008800">56<span style="color:black"> data bytes
</span></span></span></span></span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">64<span style="color:black"> bytes from <span style="color:#008800">192.168.8.3<span style="color:black">: <span style="color:teal">seq<span style="color:black">**=**<span style="color:#008800">0<span style="color:black">
										<span style="color:teal">ttl<span style="color:black">**=**<span style="color:#008800">64<span style="color:black">
														<span style="color:#0086b3">time<span style="color:black">**=**<span style="color:#008800">0.226<span style="color:black"> ms
</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">64<span style="color:black"> bytes from <span style="color:#008800">192.168.8.3<span style="color:black">: <span style="color:teal">seq<span style="color:black">**=**<span style="color:#008800">1<span style="color:black">
										<span style="color:teal">ttl<span style="color:black">**=**<span style="color:#008800">64<span style="color:black">
														<span style="color:#0086b3">time<span style="color:black">**=**<span style="color:#008800">0.076<span style="color:black"> ms
</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">64<span style="color:black"> bytes from <span style="color:#008800">192.168.8.3<span style="color:black">: <span style="color:teal">seq<span style="color:black">**=**<span style="color:#008800">2<span style="color:black">
										<span style="color:teal">ttl<span style="color:black">**=**<span style="color:#008800">64<span style="color:black">
														<span style="color:#0086b3">time<span style="color:black">**=**<span style="color:#008800">0.095<span style="color:black"> ms
</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">--- <span style="color:#008800">192.168.8.3<span style="color:black"> ping statistics ---
</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">3<span style="color:black"> packets transmitted, <span style="color:#008800">3<span style="color:black"> packets received, <span style="color:#008800">0<span style="color:black">% packet loss
</span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">round-trip min/avg/max **=**
			<span style="color:#008800">0.076<span style="color:black">/<span style="color:#008800">0.132<span style="color:black">/<span style="color:#008800">0.226<span style="color:black"> ms
</span></span></span></span></span></span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">需要注意的是，从容器中是无法访问所在主机地址的：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">**[**root@localhost ~]<span style="color:#880000"># docker exec <span style="color:#008800">5e9<span style="color:#880000"> ping -c <span style="color:#008800">3<span style="color:#880000">
								<span style="color:#008800">192.168.8.110<span style="color:black">
									</span></span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">PING <span style="color:#008800">192.168.8.110<span style="color:black">
					**(**<span style="color:#008800">192.168.8.110<span style="color:black">**)**: <span style="color:#008800">56<span style="color:black"> data bytes
</span></span></span></span></span></span></span>

<span style="color:black; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">--- <span style="color:#008800">192.168.8.110<span style="color:black"> ping statistics ---
</span></span></span>

<span style="color:#008800; font-family:Courier New; font-size:12pt; background-color:#f0f0f0">3<span style="color:black"> packets transmitted, <span style="color:#008800">0<span style="color:black"> packets received, <span style="color:#008800">100<span style="color:black">% packet loss
</span></span></span></span></span></span>

<span style="color:#222222; font-size:12pt"><span style="font-family:宋体">这是</span><span style="font-family:Arial"> macvlan </span><span style="font-family:宋体">的特性，目的是为了更好地实现网络的隔离，和</span><span style="font-family:Arial"> docker </span><span style="font-family:宋体">无关。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:18pt">**<span style="font-family:宋体">参考资料</span><span style="font-family:Arial">
				</span>**</span>

*   <div style="background: white">[<span style="color:#555555; font-family:Arial; font-size:12pt; text-decoration:underline">Macvlan and IPvlan basics</span>](https://sreeninet.wordpress.com/2016/05/29/macvlan-and-ipvlan/)<span style="color:#222222; font-family:Arial; font-size:12pt">
				</span></div>
*   <div style="background: white">[<span style="color:#555555; font-family:Arial; font-size:12pt; text-decoration:underline">docker docs: Getting started with macvlan network driver</span>](https://docs.docker.com/engine/userguide/networking/get-started-macvlan/)<span style="color:#222222; font-family:Arial; font-size:12pt">
				</span></div>
*   <div style="background: white">[<span style="color:#555555; font-family:Arial; font-size:12pt; text-decoration:underline">bridge vs macvlan</span>](http://hicu.be/bridge-vs-macvlan)<span style="color:#222222; font-family:Arial; font-size:12pt">
				</span></div>

[<span style="color:#555555; font-family:Arial; font-size:12pt; background-color:white"><span style="text-decoration:underline">comments powered by</span> Disqus</span>](http://disqus.com/)
