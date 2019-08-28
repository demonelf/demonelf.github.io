---
title: SO_TIMESTAMP - 《Unix网络编程》中未提及的Socket选项
id: 569
comment: false
categories:
  - arm
date: 2016-05-26 11:37:11
tags:
---

<span style="color:#555555; font-family:宋体; font-size:10pt">在setsockopt函数中常用Socket选项对socket进行一些必要的设置，使socket可以按我们预期的特性去工作。    
</span>
<!-- more -->

<span style="color:#555555; font-family:宋体; font-size:10pt">    SO_TIMESTAMP，一个Socket选项，在权威著作《Unix网络编程》中未提及到，即使在google上也难找到其详细解释与用法。然而在开源代码ptpv2d-rc1中用到了这个socket选项，那么它到底是用来做什么的呢。
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">    分析过linux-2.6.32内核源码后，发现通过设置此选项，我们可以让内核协议栈在接受到一个网络帧时为其打上时间戳，并将此时间戳作为一笔附加数据，与网络帧数据一起递交到上层协议。
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">    netif_receive_skb()，linux内核协议栈中的关键函数，通常在网卡驱动程序poll函数（RX中断处理函数会调度poll函数，详情参考最新内核机制NAPI）的最后一步调用，占们用来处理网络帧，并将网络帧递交至上层协议，而netif_receive_skb函数第一件要做的事就是调用net_timestamp，为当前收到的网络帧打时间戳（net_timestamp函数里会判断是否已经使能了网络时间戳功能，即netstamp_need），并将此时间戳作为一笔SCM_TIMESTAMP类型的附加数据插入sk_buff（即cmsg）。    
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">    上层代码如果要获取内核协议栈为网络帧打的时间戳，就需要拿到附加数据，很显然，我们要拿的是SCM_TIMESTAMP类型的附加数据。 
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">    我们要在收到的报文中遍历附加数据（可能有很多笔附加数据），可以使用CMSG_FIRSTHDR()与CMSG_NXTHDR()宏在附加数据对象中进行遍历，if(cmsg-&gt;cmsg_level == SOL_SOCKET &amp;&amp; cmsg-&gt;cmsg_type == SCM_TIMESTAMP)条件一旦成立，就表明已经找到了SCM_TIMESTAMP类型的附加数据，那就是之前内核协议栈为这一帧网络报文打上的时间戳，也就是收到此网络报文的时间。    
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">这个特性在PTP协议中非常有用，要做网络时间同步，必须有办法知道网络报文收到的时间，如果没有硬件时间戳（精密PHY），上层应用程序就需要使用此特性获取网络帧收到时的时间戳，或者自己编写内核模块代码接入底层协议栈，加盖软件时间戳。
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">分为几个部分阐述
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">1、linux时间系统
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">2、网卡工作原理
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">3、socket编程里的硬件时间戳选项
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">4、网络硬时间戳是什么时候打？在哪儿打的？
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">**<a name="t0"/>一、linux时间系统
**</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">陈莉君《深入分析linux内核源码》一篇很不错的文章：<a href="http://www.eefocus.com/article/09-06/74890s.html" target="_blank">linux时间系统</a>
		</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">linux有两个时钟源，分别是RTC和OS时钟。
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">RTC独立于操作系统，由电池供电，即使系统断电它也能维护自己的时钟。LINUX系统启动时从其中获得时间初始值。
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">OS时钟从可编程计数器（如intel的8524）获得时钟。如图1所示的输出脉冲是OS时钟工作的基础，因为是由它产生时钟中断的。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052616_0337_SOTIMESTAMP1.png)<span style="color:#555555; font-family:宋体; font-size:10pt">
		</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">图1 8524工作示意图
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052616_0337_SOTIMESTAMP2.png)<span style="color:#555555; font-family:宋体; font-size:10pt">
		</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">图1 时钟机制
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">**<a name="t1"/>二、网卡工作原理 
**</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">发送数据时，网卡首先侦听介质上是否有载波（载波由电压指示），如果有，则认为其他站点正在传送信息，继续侦听介质。一旦通信介质在一定时间段内（称为帧间缝隙IFG=9.6微秒）是安静的，即没有被其他站点占用，则开始进行帧数据发送，同时继续侦听通信介质，以检测冲突。在发送数据期间。 
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">如果检测到冲突，则立即停止该次发送，并向介质发送一个"阻塞"信号，告知其他站点已经发生冲突，从而丢弃那些可能一直在接收的受到损坏的帧数据，并等待一段随机时间（CSMA/CD确定等待时间的算法是二进制指数退避算法）。在等待一段随机时间后，再进行新的发送。如果重传多次后（大于16次）仍发生冲突，就放弃发送。 
</span>

<span style="color:#555555; font-family:宋体; font-size:10pt">接收时，网卡浏览介质上传输的每个帧，如果其长度小于64字节，则认为是冲突碎片。如果接收到的帧不是冲突碎片且目的地址是本地地址，则对帧进行完整性校验，如果帧长度大于1518字节（称为超长帧，可能由错误的LAN驱动程序或干扰造成）或未能通过CRC校验，则认为该帧发生了畸变。通过校验的帧被认为是有效的，网卡将它接收下来进行本地处理。
</span>

<a href="http://blog.sina.com.cn/s/blog_501dcd710100y2wp.html" target="_blank"><span style="font-family:宋体; font-size:10pt">linux网卡驱动程序框架</span></a><span style="color:#555555; font-family:宋体; font-size:10pt">
		</span>

<span style="color:#333333">**<span style="font-family:宋体; font-size:10pt">三、</span><span style="font-family:Arial; font-size:10pt">socket</span><span style="font-family:宋体; font-size:10pt">编程里的硬件时间戳选项</span><span style="font-family:Arial; font-size:18pt">
				</span>**</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">参考文章：[<span style="color:#336699; background-color:#f0f0f0; text-decoration:underline">硬件时间戳</span>](http://blog.sina.com.cn/s/blog_6348a13d0100ntme.html)</span><span style="font-family:Arial; background-color:#f0f0f0; text-decoration:underline">socket</span><span style="color:#336699"><span style="font-family:宋体; background-color:#f0f0f0; text-decoration:underline">选项解析</span><span style="font-family:Arial"><span style="background-color:#f0f0f0; text-decoration:underline">
					</span><span style="color:#333333">
					</span></span></span></span>

<span style="color:#494949; font-family:宋体; font-size:10pt">The existing interfaces for getting network packages time stamped are:
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">* SO_TIMESTAMP
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  Generate time stamp for each incoming packet using the (not necessarily
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  monotonous!) system time. Result is returned via recv_msg() in a
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  control message as timeval_r(usec resolution).
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">* SO_TIMESTAMPNS
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  Same time stamping mechanism as SO_TIMESTAMP, but returns result as
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  timespec (nsec resolution).
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">* IP_MULTICAST_LOOP + SO_TIMESTAMP[NS]
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  Only for multicasts: approximate send time stamp by receiving the looped
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  packet and using its receive time stamp.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">The following interface complements the existing ones: receive time
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">stamps can be generated and returned for arbitrary packets and much
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">closer to the point where the packet is really sent. Time stamps can
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">be generated in software (as before) or in hardware (if the hardware
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">has such a feature).
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SO_TIMESTAMPING:
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">Instructs the socket layer which kind of information is wanted. The
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">parameter is an integer with some of the following bits set. Setting
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">other bits is an error and doesn't change the current state.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_TX_HARDWARE:  try to obtain send time stamp in hardware
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_TX_SOFTWARE:  if SOF_TIMESTAMPING_TX_HARDWARE is off or
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">                               fails, then do it in software
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_RX_HARDWARE:  return the original, unmodified time stamp
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">                               as generated by the hardware
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_RX_SOFTWARE:  if SOF_TIMESTAMPING_RX_HARDWARE is off or
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">                               fails, then do it in software
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_RAW_HARDWARE: return original raw hardware time stamp
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_SYS_HARDWARE: return hardware time stamp transformed to
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">                               the system time base
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_SOFTWARE:     return system time stamp generated in
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">                               software
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_TX/RX determine how time stamps are generated.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_RAW/SYS determine how they are reported in the
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">following control message:
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">struct scm_timestamping {
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> struct timespec systime;
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> struct timespec hwtimetrans;
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> struct timespec hwtimeraw;
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">};
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">recvmsg() can be used to get this control message for regular incoming
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">packets. For send time stamps the outgoing packet is looped back to
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">the socket's error queue with the send time stamp(s) attached. It can
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">be received with recvmsg(flags=MSG_ERRQUEUE). The call returns the
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">original outgoing packet data including all headers preprended down to
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">and including the link layer, the scm_timestamping control message and
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">a sock_extended_err control message with ee_errno==ENOMSG and
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">ee_origin==SO_EE_ORIGIN_TIMESTAMPING. A socket with such a pending
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">bounced packet is ready for reading as far as select() is concerned.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">If the outgoing packet has to be fragmented, then only the first
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">fragment is time stamped and returned to the sending socket.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">All three values correspond to the same event in time, but were
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">generated in different ways. Each of these values may be empty (= all
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">zero), in which case no such value was available. If the application
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">is not interested in some of these values, they can be left blank to
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">avoid the potential overhead of calculating them.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">systime is the value of the system time at that moment. This
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">corresponds to the value also returned via SO_TIMESTAMP[NS]. If the
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">time stamp was generated by hardware, then this field is
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">empty. Otherwise it is filled in if SOF_TIMESTAMPING_SOFTWARE is
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">set.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">hwtimeraw is the original hardware time stamp. Filled in if
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SOF_TIMESTAMPING_RAW_HARDWARE is set. No assumptions about its
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">relation to system time should be made.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">hwtimetrans is the hardware time stamp transformed so that it
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">corresponds as good as possible to system time. This correlation is
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">not perfect; as a consequence, sorting packets received via different
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">NICs by their hwtimetrans may differ from the order in which they were
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">received. hwtimetrans may be non-monotonic even for the same NIC.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">Filled in if SOF_TIMESTAMPING_SYS_HARDWARE is set. Requires support
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">by the network device and will be empty without that support.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SIOCSHWTSTAMP:
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">Hardware time stamping must also be initialized for each device driver
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">that is expected to do hardware time stamping. The parameter is defined in
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">/include/linux/net_tstamp.h as:
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">struct hwtstamp_config {
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> int flags; 
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> int tx_type; 
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> int rx_filter; 
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">};
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">Desired behavior is passed into the kernel and to a specific device by
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">calling ioctl(SIOCSHWTSTAMP) with a pointer to a struct ifreq whose
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">ifr_data points to a struct hwtstamp_config. The tx_type and
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">rx_filter are hints to the driver what it is expected to do. If
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">the requested fine-grained filtering for incoming packets is not
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">supported, the driver may time stamp more than just the requested types
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">of packets.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">A driver which supports hardware time stamping shall update the struct
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">with the actual, possibly more permissive configuration. If the
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">requested packets cannot be time stamped, then nothing should be
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">changed and ERANGE shall be returned (in contrast to EINVAL, which
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">indicates that SIOCSHWTSTAMP is not supported at all).
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">Only a processes with admin rights may change the configuration. User
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">space is responsible to ensure that multiple processes don't interfere
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">with each other and that the settings are reset.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">enum {
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> HWTSTAMP_TX_OFF,
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> HWTSTAMP_TX_ON,
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">};
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">enum {
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> HWTSTAMP_FILTER_NONE,
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> HWTSTAMP_FILTER_ALL,
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> HWTSTAMP_FILTER_SOME,
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> HWTSTAMP_FILTER_PTP_V1_L4_EVENT,
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">};
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">DEVICE IMPLEMENTATION
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">A driver which supports hardware time stamping must support the
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">SIOCSHWTSTAMP ioctl and update the supplied struct hwtstamp_config with
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">the actual values as described in the section on SIOCSHWTSTAMP.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">Time stamps for received packets must be stored in the skb. To get a pointer
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">to the shared time stamp structure of the skb call skb_hwtstamps(). Then
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">set the time stamps in the structure:
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">struct skb_shared_hwtstamps {
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> ktime_t hwtstamp;
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt"> ktime_t syststamp;
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">};
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">Time stamps for outgoing packets are to be generated as follows:
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">- **In hard_start_xmit(), check if skb_tx(skb)-&gt;hardware is set no-zero.
**</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">**  If yes, then the driver is expected to do hardware time stamping.**
		</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">- If this is possible for the skb and requested, then declare
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  that the driver is doing the time stamping by setting the field
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  skb_tx(skb)-&gt;in_progress non-zero. You might want to keep a pointer
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  to the associated skb for the next step and not free the skb. A driver
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  not supporting hardware time stamping doesn't do that. A driver must
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  never touch sk_buff::tstamp! It is used to store software generated
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  time stamps by the network subsystem.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">- As soon as the driver has sent the packet and/or obtained a
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  hardware time stamp for it, it passes the time stamp back by
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  calling skb_hwtstamp_tx() with the original skb, the raw
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  hardware time stamp. skb_hwtstamp_tx() clones the original skb and
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  adds the timestamps, therefore the original skb has to be freed now.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  If obtaining the hardware time stamp somehow fails, then the driver
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  should not fall back to software time stamping. The rationale is that
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  this would occur at a later time in the processing pipeline than other
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  software time stamping and therefore could lead to unexpected deltas
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  between time stamps.
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">- If the driver did not call set skb_tx(skb)-&gt;in_progress, then
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  dev_hard_start_xmit() checks whether software time stamping
</span>

<span style="color:#494949; font-family:宋体; font-size:10pt">  is wanted as fallback and potentially generates the time stamp.
</span>

<span style="color:#333333; font-size:10pt">**<span style="font-family:宋体">四、</span><span style="font-family:Arial"> linux</span><span style="font-family:宋体">如何获取高精度时间</span>**<span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-family:宋体; font-size:10pt">在linux下通常可用的精度最高的时间接口是gettimeofday，它返回一个[<span style="color:#004276; text-decoration:underline">timeval结构</span>](http://nathanxu.blog.51cto.com/50836/56663)，其精度为us，即10-6 秒，大多数情况这个精度已经够用了。不过有时为了更高的精度，比如纳秒级的时间精度，我们需求探索Linux为我们提供的时间调用。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">首先介绍struct timespec结构，这个结构体有两个成员，一个是秒，一个是纳秒。
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">在librt库中，提供了高精度的时间函数，分别是：
</span>

<span style="color:#333333; font-family:Courier New; font-size:12pt">long clock_gettime(clockid_t ,struct timespec*)
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">获取特定时钟的时间，时间通过fp结构传回，目前定义了6种时钟，分别是
</span>

<span style="color:#333333; font-size:12pt"><span style="font-family:Courier New">CLOCK_REALTIME               </span><span style="font-family:宋体">系统当前时间，从</span><span style="font-family:Courier New">1970</span><span style="font-family:宋体">年</span><span style="font-family:Courier New">1.1</span><span style="font-family:宋体">日算起</span><span style="font-family:Courier New">
			</span></span>

<span style="color:#333333; font-size:12pt"><span style="font-family:Courier New">CLOCK_MONOTONIC              </span><span style="font-family:宋体">系统的启动时间，不能被设置</span><span style="font-family:Courier New">
			</span></span>

<span style="color:#333333; font-size:12pt"><span style="font-family:Courier New">CLOCK_PROCESS_CPUTIME_ID     </span><span style="font-family:宋体">进程运行时间</span><span style="font-family:Courier New">
			</span></span>

<span style="color:#333333; font-size:12pt"><span style="font-family:Courier New">CLOCK_THREAD_CPUTIME_ID      </span><span style="font-family:宋体">线程运行时间</span><span style="font-family:Courier New">
			</span></span>

<span style="color:#333333; font-size:12pt"><span style="font-family:Courier New">CLOCK_REALTIME_HR            CLOCK_REALTIME</span><span style="font-family:宋体">的高精度版本</span><span style="font-family:Courier New">
			</span></span>

<span style="color:#333333; font-size:12pt"><span style="font-family:Courier New">CLOCK_MONOTONIC_HR           CLOCK_MONOTONIC</span><span style="font-family:宋体">的高精度版本</span><span style="font-family:Courier New">
			</span></span>

<span style="color:#333333; font-family:宋体; font-size:10pt">获取特定时钟的时间精度：
</span>

<span style="color:#333333; font-family:Courier New; font-size:12pt">long clock_getres(clockid_t )           
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">设置特定时钟的时间：
</span>

<span style="color:#333333; font-family:Courier New; font-size:12pt">long clock_settime(clockid_t ,struct timespec*)                   
</span>

<span style="color:#333333; font-family:宋体; font-size:10pt">休眠time中指定的时间，如果遇到信号中断而提前返回，则由left_time返回剩余的时间：
</span>

<span style="color:#333333; font-family:Courier New; font-size:12pt">long clock_nanosleep(clockid_t ,int flag,timespec* time,timespec* left_time)    
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">**五、硬时间戳模块的物理实现**</span><span style="font-family:Arial">
			</span></span>

[<span style="color:#336699; font-size:10pt; text-decoration:underline"><span style="font-family:宋体">基于硬件时间戳的</span><span style="font-family:Arial">IEEE1588</span><span style="font-family:宋体">时间同步技术的一种实现方法</span></span>](http://wenku.baidu.com/link?url=W7knlls1lVHtA4-ufDz4xWn6znjD2VNX1ES0aVsoWo4M73V8dhbrHO2-PBUnJgeGDQYz95SUG5EELg7_9WyXi7ISfvysg8XFe4h0HGX5N5m)<span style="color:#333333; font-family:Arial; font-size:10pt">
		</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">本地时间戳模块的计数器的工作频率越高，本地</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">时间戳的分辨率就越高。但在实际的工程中，这个频率受</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">FPGA</span><span style="font-family:宋体">器件本身的性能和本地晶振的限制，不可能无限制的</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">提高，否则不仅不能提高同步性能，甚至还会因为系统达</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">不到这个频率而无法正常工作。进而影响开发进度和开发</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">成本。本文采用</span><span style="font-family:Arial">FPGA</span><span style="font-family:宋体">设计硬件时间戳模块，在</span><span style="font-family:Arial">MAC</span><span style="font-family:宋体">和</span><span style="font-family:Arial">PHY
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">之间的</span><span style="font-family:Arial">GMlI</span><span style="font-family:宋体">接口处打时间戳，也就是图</span><span style="font-family:Arial">6</span><span style="font-family:宋体">所示的</span><span style="font-family:Arial">C</span><span style="font-family:宋体">点，图</span><span style="font-family:Arial">7
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">为硬件时间戳模块框图。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">50Mhz</span><span style="font-family:宋体">晶振接入</span><span style="font-family:Arial">FPGA</span><span style="font-family:宋体">，经过</span><span style="font-family:Arial">FPGA</span><span style="font-family:宋体">内部的</span><span style="font-family:Arial">DCM</span><span style="font-family:宋体">倍频至</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">1OOMhz</span><span style="font-family:宋体">作为本地时间计数器的</span><span style="font-family:Arial">It,-t~~</span><span style="font-family:宋体">信号</span><span style="font-family:Arial">clk</span><span style="font-family:宋体">。在每个</span><span style="font-family:Arial">clk</span><span style="font-family:宋体">的</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">上升沿累加，每次累加值为</span><span style="font-family:Arial">1 Ons</span><span style="font-family:宋体">，也就是本地时间戳的分</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">辨率是</span><span style="font-family:Arial">1 Ons</span><span style="font-family:宋体">。开始上电时，时间戳模块需要初始时间，由</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">CPU</span><span style="font-family:宋体">发出更新时间的命令并将要更新的时间写入更新时间</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">寄存器，时间戳模块就能更新本地时间，然后在此基础上</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">开始累加。当</span><span style="font-family:Arial">CPU</span><span style="font-family:宋体">发出调整本地时间命令时，时间戳模块</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">通过读取时间偏差调整寄存器来更新本地时间以同步于主</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">时钟。该时间戳模块按照</span><span style="font-family:Arial">IEEE1 588</span><span style="font-family:宋体">的标准时间格式输出本</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">地时间供需要时间戳的模块使用。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:宋体">拓展文献</span><span style="font-family:Arial">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">1.[</span><span style="color:#336699"><span style="text-decoration:underline"><span style="font-family:宋体">基于</span><span style="font-family:Arial">IEEE1588</span><span style="font-family:宋体">协议的时间戳的生成与分析</span></span><span style="color:#333333; font-family:Arial">
				</span></span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">2.<a href="http://www.linuxidc.com/Linux/2012-02/53374.htm" target="_blank"/></span><span style="color:#336699"><span style="text-decoration:underline"><span style="font-family:宋体">浅谈时间函数</span><span style="font-family:Arial">gettimeofday</span><span style="font-family:宋体">的成本</span></span><span style="color:#333333; font-family:Arial">
				</span></span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">3\. <a href="http://blog.chinaunix.net/uid-127037-id-2919505.html" target="_blank"><span style="color:#336699; text-decoration:underline">linux 2.6</span>](http://wenku.baidu.com/link?url=MlUag6NhaBAAl30w4-SFjWftYQRs9lwcCiA59tmgSXDMRU2xDWdRkvSlg2kfMTYvvtAjZfT7SMz85t0FxMHZFHBA8p8IlOoBl6JVttmFYi_)</span><span style="font-family:宋体; text-decoration:underline">的网络时间戳</span><span style="font-family:Arial">
			</span></span>
