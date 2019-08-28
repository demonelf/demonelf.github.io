---
title: IEEE1588精密网络同步协议（PTP）-v2.0协议浅析
id: 438
comment: false
categories:
  - arm
date: 2016-05-11 12:50:33
tags:
---

**1 ** **引言**

以太网技术由于其开放性好、价格低廉和使用方便等特点，已经广泛应用于电信级别的网络中，以太网的数据传输速度也从早期的10M提高到100M，GE，10GE。40GE，100GE正式产品也于2009年推出。
<!-- more -->

以太网技术是"即插即用"的，也就是将以太网终端接到IP网络上就可以随时使用其提供的业务。但是，只有"同步的"的IP网络才是一个真正的电信级网络，才能够为IP网络传送各种实时业务与数据业务的多重播放业务提供保障。目前，电信级网络对时间同步要求十分严格，对于一个全国范围的IP网络来说，骨干网络时延一般要求控制在50ms之内，现行的互联网网络时间协议NTP（Network Time Protocol），简单网络时间协议SNTP（Simple Network Time Protocol）等不能达到所要求的同步精度或收敛速度。基于以太网的时分复用通道仿真技术（TDM over Ethernet）作为一种过渡技术，具有一定的以太网时钟同步概念，可以部分解决现有终端设备用于以太网的无缝连接问题。IEEE 1588标准则特别适合于以太网，可以在一个地域分散的IP网络中实现微秒级高精度的时钟同步。本文重点介绍IEEE 1588技术及其测试实现。

**　　2  IEEE 1588PTP介绍**

IEEE 1588PTP协议借鉴了NTP技术，具有容易配置、快速收敛以及对网络带宽和资源消耗少等特点。IEEE1588标准的全称是"网络测量和控制系统的精密时钟同步协议标准（IEEE 1588 Precision Clock Synchronization Protocol）"，简称PTP（Precision Timing Protocol），它的主要原理是通过一个同步信号周期性的对网络中所有节点的时钟进行校正同步，可以使基于以太网的分布式系统达到精确同步，IEEE 1588PTP时钟同步技术也可以应用于任何组播网络中。

IEEE 1588将整个网络内的时钟分为两种，即普通时钟（Ordinary Clock，OC）和边界时钟（Boundary Clock，BC），只有一个PTP通信端口的时钟是普通时钟，有一个以上PTP通信端口的时钟是边界时钟，每个PTP端口提供独立的PTP通信。其中，边界时钟通常用在确定性较差的网络设备（如交换机和路由器）上。从通信关系上又可把时钟分为主时钟和从时钟，理论上任何时钟都能实现主时钟和从时钟的功能，但一个PTP通信子网内只能有一个主时钟。整个系统中的最优时钟为最高级时钟GMC（Grandmaster Clock），有着最好的稳定性、精确性、确定性等。根据各节点上时钟的精度和级别以及UTC（通用协调时间）的可追溯性等特性，由最佳主时钟算法（Best Master Clock）来自动选择各子网内的主时钟；在只有一个子网的系统中，主时钟就是最高级时钟GMC。每个系统只有一个GMC，且每个子网内只有一个主时钟，从时钟与主时钟保持同步。图1所示的是一个典型的主时钟、从时钟关系示意。

[![](http://www.madhex.com/wp-content/uploads/2016/05/051116_0450_IEEE15881.gif)](http://photo.blog.sina.com.cn/showpic.html)

图1  主时钟、从时钟关系示意图

同步的基本原理包括时间发出和接收时间信息的记录，并且对每一条信息增加一个"时间戳"。有了时间记录，接收端就可以计算出自己在网络中的时钟误差和延时。为了管理这些信息，PTP协议定义了4种多点传送的报文类型和管理报文，包括同步报文（Sync），跟随报文（Follow_up），延迟请求报文（Delay_Req），延迟应答报文（Delay_Resp）。这些报文的交互顺序如图2所示。收到的信息回应是与时钟当前的状态有关的。同步报文是从主时钟周期性发出的(一般为每两秒一次)，它包含了主时钟算法所需的时钟属性。总的来说同步报文包含了一个时间戳，精确地描述了数据包发出的预计时间。

[![](http://www.madhex.com/wp-content/uploads/2016/05/051116_0450_IEEE15882.gif)](http://photo.blog.sina.com.cn/showpic.html)

图2  PTP报文与交换顺序

由于同步报文包含的是预计的发出时间而不是真实的发出时间，所以Sync报文的真实发出时间被测量后在随后的Follow_Up报文中发出。Sync报文的接收方记录下真实的接收时间。使用Follow_Up报文中的真实发出时间和接收方的真实接收时间，可以计算出从属时钟与主时钟之间的时差，并据此更正从属时钟的时间。但是此时计算出的时差包含了网络传输造成的延时，所以使用Delay_Req报文来定义网络的传输延时。

Delay_Req报文在Sync报文收到后由从属时钟发出。与Sync报文一样，发送方记录准确的发送时间，接收方记录准确的接收时间。准确的接收时间包含在Delay_Resp报文中，从而计算出网络延时和时钟误差。同步的精确度与时间戳和时间信息紧密相关。纯软件的方案可以达到毫秒的精度，软硬件结合的方案可以达到微秒的精度。
PTP协议基于同步数据包被传播和接收时的最精确的匹配时间，每个从时钟通过与主时钟交换同步报文而与主时钟达到同步。这个同步过程分为漂移测量阶段和偏移测量与延迟测量阶段。

第一阶段修正主时钟与从时钟之间的时间偏差，称为漂移测量。如图3所示，在修正漂移量的过程中，主时钟按照定义的间隔时间（缺省是2s）周期性地向相应的从时钟发出惟一的同步报文。这个同步报文包括该报文离开主时钟的时间估计值。主时钟测量传递的准确时间T0 K，从时钟测量接收的准确时间T1 K。之后主时钟发出第二条报文——跟随报文（Follow_up Message），此报文与同步报文相关联，且包含同步报文放到PTP通信路径上的更为精确的估计值。这样，对传递和接收的测量与标准时间戳的传播可以分离开来。从时钟根据同步报文和跟随报文中的信息来计算偏移量，然后按照这个偏移量来修正从时钟的时间，如果在传输路径中没有延迟，那么两个时钟就会同步。

[![](http://www.madhex.com/wp-content/uploads/2016/05/051116_0450_IEEE15883.gif)](http://photo.blog.sina.com.cn/showpic.html)

图3  PTP时钟漂移测量计算

为了提高修正精度，可以把主时钟到从时钟的报文传输延迟等待时间考虑进来，即延迟测量，这是同步过程的第二个阶段（见图4）。

[![](http://www.madhex.com/wp-content/uploads/2016/05/051116_0450_IEEE15884.gif)](http://photo.blog.sina.com.cn/showpic.html)

图4  PTP时钟延迟和偏移计算

从时钟向主时钟发出一个"延迟请求"数据报文，在这个过程中决定该报文传递准确时间T2。主时钟对接收数据包打上一个时间戳，然后在"延迟响应"数据包中把接收时间戳B送回到从时钟。根据传递时间戳B和主时钟提供的接收时间戳D，从时钟计算与主时钟之间的延迟时间。与偏移测量不同，延迟测量是不规则进行的，其测量间隔时间（缺省值是4~60s之间的随机值）比偏移值测量间隔时间要大。这样使得网络尤其是设备终端的负荷不会太大。采用这种同步过程，可以消减PTP协议栈中的时间波动和主从时钟间的等待时间。从图4右边可以看到延迟时间D 和偏移时间数值O的计算方法。

IEEE 1588目前的版本是v2.2，主要应用于相对本地化、网络化的系统，内部组件相对稳定，其优点是标准非常具有代表性，并且是开放式的。由于它的开放性，特别适合于以太网的网络环境。与其他常用于Ethernet TCP/IP网络的同步协议如SNTP或NTP相比，主要区别是PTP是针对更稳定和更安全的网络环境设计的，所以更为简单，占用的网络和计算资源也更少。NTP协议是针对于广泛分散在互联网上的各个独立系统的时间同步协议。GPS(基于卫星的全球定位系统)也是针对于分散广泛且各自独立的系统。PTP定义的网络结构可以使自身达到很高的精度，与SNTP和NTP相反，时间戳更容易在硬件上实现，并且不局限于应用层，这使得PTP可以达到微秒以内的精度。此外，PTP模块化的设计也使它很容易适应低端设备。

IEEE1588标准所定义的精确网络同步协议实现了网络中的高度同步，使得在分配控制工作时无需再进行专门的同步通信，从而达到了通信时间模式与应用程序执行时间模式分开的效果。

由于高精度的同步工作，使以太网技术所固有的数据传输时间波动降低到可以接受的，不影响控制精度的范围。

**　　3  IXIA IEEE 1588PTP测试方案**

美国IXIA公司目前提供最为完整的城域以太网功能、性能、一致性测试解决方案，并且最先在2~7层统一IP测试平台实现了IEEE 1588PTP时钟同步技术方案。关于IXIA 的城域以太网测试解决方案在以前有过详细介绍，在这里对相应的技术点和对应IXIA应用程序做一总结（见表1）。

[![](http://www.madhex.com/wp-content/uploads/2016/05/051116_0450_IEEE15885.gif)](http://photo.blog.sina.com.cn/showpic.html)

表1  IXIA城域以太网测试方案及对应程序

图5是典型的IEEE 1588PTP测试场景，IXIA测试端口可以仿真普通时钟并处于主模式，被测设备，比如以太网交换机处于边界时钟状态，验证其对各种时钟报文的处理能力与实现；另一种测试情况是IXIA端口仿真边界时钟并处于从属模式，这时候被测设备处于主模式，验证被测设备在主时钟模式下的处理机制。IXIA端口都有PTP协议栈，可以对PTP时钟信息做灵活的配置。

[![](http://www.madhex.com/wp-content/uploads/2016/05/051116_0450_IEEE15886.gif)](http://photo.blog.sina.com.cn/showpic.html)

图5  IEEE 1588典型测试场景

IXIA IEEE 1588PTP测试方案所支持的特性包括：支持目前最为流行的IEEE 1588 2.2版本；支持两步时钟配置；一个物理端口可以同时产生PTP流量和非PTP流量；一个物理端口一个时钟信号设置，时钟可以手动设置为主模式或者从模式；可以以柱状图显示从时钟对应于主时钟的偏移量；IXIA IxExplorer内置的实时协议分析解码软件可以对PTP报文直接进行编辑或者解码。在测试过程中可以实时显示各种详细的PTP统计信息，统计信息见表2。

[![](http://www.madhex.com/wp-content/uploads/2016/05/051116_0450_IEEE15887.gif)](http://photo.blog.sina.com.cn/showpic.html)

表2  IXIA IEEE 1588PTP测试统计信息

IXIA IEEE 1588PTP方案还可以实现负面测试（Negative Testing），可以根据需要设定发送Sync报文中Follow-up报文的比例，观察丢弃掉的Follow-up报文对被测设备的影响；在Follow-up报文中增加错误数据包，验证被测设备的处理与检测能力；发送包括抖动与偏移的带有时间戳的数据包迫使Sync报文失败，检验被测设备的处理机制。图6所示为PTP时钟配制界面。

[![](http://www.madhex.com/wp-content/uploads/2016/05/051116_0450_IEEE15888.gif)](http://photo.blog.sina.com.cn/showpic.html)

图6  PTP时钟配置界面

**　　4 ** **结束语**

根据最新的信息公告，IXIA 被eWeek授予年度十大产品奖之一，被Frost &amp; Sullivan授予2008全球三重播放综合测试和监测设备的年度市场领先奖，被Test &amp; Measurement World授予三个最佳测试奖，以及被Internet Telephony授予年度产品奖，被如此众多令人尊敬有技术影响力组织机构的认可，进一步证明了IXIA正在推动测试、测量和业务认证市场的进步和战略创新，在城域以太网网技术方面，IXIA同样保持领先的地位，推出了业界第一个100G高速以太网测试加速系统，第一个在统一2~7层IP测试平台上推出了IEEE 1588PTP 精密时钟同步协议测试技术，IXIA这些技术创新和技术的领导地位，都为全面的IP测试提供了可靠保证。

转自：[http://www.21ic.com/app/test/200903/34492.htm](http://www.21ic.com/app/test/200903/34492.htm)<object id="reader" width="630" height="500" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" align="middle"><param value="window" name="wmode" /><param value="true" name="allowfullscreen" /><param name="allowscriptaccess" value="always" /><param value="http://wenku.baidu.com/static/flash/apireader.swf?docurl=http://wenku.baidu.com/play&amp;docid=0dc65843866fb84ae55c8d0d&amp;title=PTP%E5%8F%8A1588%E5%8D%8F%E8%AE%AE%E4%BB%8B%E7%BB%8D&amp;doctype=ppt&amp;fpn=5&amp;npn=5&amp;readertype=external&amp;catal=0&amp;cdnurl=http://txt.wenku.baidu.com/play" name="movie" /><embed width="630" align="middle" height="500" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" name="reader" src="http://wenku.baidu.com/static/flash/apireader.swf?docurl=http://wenku.baidu.com/play&amp;docid=0dc65843866fb84ae55c8d0d&amp;title=PTP%E5%8F%8A1588%E5%8D%8F%E8%AE%AE%E4%BB%8B%E7%BB%8D&amp;doctype=ppt&amp;fpn=5&amp;npn=5&amp;readertype=external&amp;catal=0&amp;cdnurl=http://txt.wenku.baidu.com/play" wmode="window" allowscriptaccess="always" bgcolor="#FFFFFF" ver="9.0.0" allowfullscreen="allowfullscreen" /></object><object id="reader" width="630" height="500" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" align="middle"><param value="window" name="wmode" /><param value="true" name="allowfullscreen" /><param name="allowscriptaccess" value="always" /><param value="http://wenku.baidu.com/static/flash/apireader.swf?docurl=http://wenku.baidu.com/play&amp;docid=5a603ef8f705cc17552709bd&amp;title=1588V2%E5%8D%8F%E8%AE%AE%E4%BB%8B%E7%BB%8D&amp;doctype=ppt&amp;fpn=5&amp;npn=5&amp;readertype=external&amp;catal=0&amp;cdnurl=http://txt.wenku.baidu.com/play" name="movie" /><embed width="630" align="middle" height="500" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" name="reader" src="http://wenku.baidu.com/static/flash/apireader.swf?docurl=http://wenku.baidu.com/play&amp;docid=5a603ef8f705cc17552709bd&amp;title=1588V2%E5%8D%8F%E8%AE%AE%E4%BB%8B%E7%BB%8D&amp;doctype=ppt&amp;fpn=5&amp;npn=5&amp;readertype=external&amp;catal=0&amp;cdnurl=http://txt.wenku.baidu.com/play" wmode="window" allowscriptaccess="always" bgcolor="#FFFFFF" ver="9.0.0" allowfullscreen="allowfullscreen" /></object> <object id="reader" width="630" height="500" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" align="middle"><param value="window" name="wmode" /><param value="true" name="allowfullscreen" /><param name="allowscriptaccess" value="always" /><param value="http://wenku.baidu.com/static/flash/apireader.swf?docurl=http://wenku.baidu.com/play&amp;docid=e2126d8083d049649b66580d&amp;title=IEEE_1588%E5%8D%8F%E8%AE%AE%E5%9F%BA%E7%A1%80ppt%E7%89%88&amp;doctype=ppt&amp;fpn=5&amp;npn=5&amp;readertype=external&amp;catal=0&amp;cdnurl=http://txt.wenku.baidu.com/play" name="movie" /><embed width="630" align="middle" height="500" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" name="reader" src="http://wenku.baidu.com/static/flash/apireader.swf?docurl=http://wenku.baidu.com/play&amp;docid=e2126d8083d049649b66580d&amp;title=IEEE_1588%E5%8D%8F%E8%AE%AE%E5%9F%BA%E7%A1%80ppt%E7%89%88&amp;doctype=ppt&amp;fpn=5&amp;npn=5&amp;readertype=external&amp;catal=0&amp;cdnurl=http://txt.wenku.baidu.com/play" wmode="window" allowscriptaccess="always" bgcolor="#FFFFFF" ver="9.0.0" allowfullscreen="allowfullscreen" /></object> <iframe class="preview-iframe" src="http://download.csdn.net/source/preview/4481810/934d8c09ebfe9352649f4fa015401fe9" width="738" height="523" frameborder="0" scrolling="no"></iframe>
