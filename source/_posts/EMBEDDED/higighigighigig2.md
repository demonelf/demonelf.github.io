---
title: HiGig/HiGig+/HiGig2
id: 858
comment: false
categories:
  - arm
date: 2016-08-04 11:42:58
tags:
---

<span style="font-family:宋体">  </span><span style="font-family:幼圆">  HiGig(通常称为HiGigTM)是<span style="color:blue">Broadcom公司的私有串行总线互联方案</span>，于2001年推出，主要用于Broadcom公司StrataXGS系列芯片(如BCM5670/BCM5690等)之间的互联(也可以跟支持HiGig协议的NPU或ASIC连接)，既可用于板内连接，也可通过背板走线形式实现跨板连接。
</span>
<!-- more -->

<span style="font-family:幼圆">HiGig总线是在以太网协议的基础上发展而来的，它在以太网二层报文中插入HiGig头，形成HiGig报文，通过HiGig头部携带的控制信息，来实现芯片端口的<span style="color:blue">镜像、聚合、QOS</span>等功能。
</span>

[![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH1.jpg)](http://blog.c114.net/batch.download.php?aid=14001)<span style="color:black; font-family:幼圆">
		</span>

<span style="font-family:宋体">   </span><span style="font-family:幼圆"> 如上图所示<span style="color:blue">，将以太网二层报文的8Byte前导码和4个字节帧间隙(共12个字节帧间隙)替换成12个字节的HiGig报文头，这样，HiGig报文只有8个字节帧间隙，没有前导码</span>。
</span>

<span style="font-family:幼圆"><span style="color:blue">HiGig接口支持的最大速率为10Gbps</span>(<span style="color:blue">共4对SerDes通道</span>，每通道最大支持3.125Gbps，因为经过了8B/10B变换，所以有效带宽为2.5Gbps)，物理层电气特性如<span style="background-color:aqua">XAUI</span>端口相同(详见IEEE802.3ae clause 47)。
</span>

<span style="font-family:幼圆">Broadcom公司在其StrataXGS II系列产品上(如BCM5675/BCM5695等)推出了HiGig+总线，<span style="color:blue">HiGig+只是在HiGig的基础了做了细微改进，将端口支持的最大速率从10Gbps提高到12Gbps</span>(每个通道的最大速率从3.125Gbps提高到3.75Gbps),至于协议部分，没有做任何更改，与HiGig完全一样，所以对HiGig接口完全兼容。
</span>

<span style="font-family:幼圆">隨着通信技术的发展，HiGig/HiGig+总线也暴露出了其自身的局限线，在对更高端的网络市场应用中显得力不从心，主要表现在以下几个方面：
</span>

<span style="font-family:宋体">   </span><span style="font-family:幼圆"> 1).地址空间和服务种类有限，满足不了更高级系统应用；
</span>

<span style="font-family:宋体">   </span><span style="font-family:幼圆"> 2).头部结构不够灵活，满足不了未来技术发展；
</span>

<span style="font-family:宋体">   </span><span style="font-family:幼圆"> 3).对流控和负载均衡技术支持不足。
</span>

<span style="font-family:幼圆">在此背景下，Broadcom公司于2005年在其<span style="color:red">StrataXGS III</span>系列产品(如BCM56580/ BCM56700/BCM56800等)上推出了<span style="color:red">HiGig2</span>总线，HiGig2总线在HiGig+总线的基础上，对端口速率和传输协议都进行了更改。
</span>

<span style="color:blue; font-family:幼圆">HiGig/HiGig+报文头为12个字节，而HiGig2报文头部增加到<span style="color:red">16个字节<span style="color:blue">，使得HiGig2报文可以携带更多的信息来决定报文的处理方式，如镜像、重定向、流控和负载均衡等</span>。如下图所示：</span>
		</span>

<span style="font-family:宋体">     </span><span style="font-family:幼圆">
			[![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH2.jpg)](http://blog.c114.net/batch.download.php?aid=14002)
		</span>

<span style="font-family:宋体">   </span><span style="font-family:幼圆"> 说完HiGig/HiGig+/HiGig2后，不得不顺便说下另外一种非主流的HiGig类协议HiGig-Lite。由于<span style="color:blue">HiGig-Lite不能与HiGig/HiGig+/HiGig2兼容，所以其只在很小范围内有使用(只局限在BCM5601x/BCM5620x/BCM5622x/BCM5371x几个系列芯片上)</span>。<span style="color:red">HiGig-Lite端口只支持2.5Gbps速率</span>，报文帧结构同XGMII类似。
</span>

<span style="font-family:幼圆"> HiGig-Lite协议不像HiGig/HiGig+/HiGig2那样将报文的前导码和部分帧间隙替换成HiGig/HiGig+/HiGig2头部，以求变换后的报文传输效率不变，而是保持原以太报文的前导码和帧间隙不变，只是在<span style="color:blue">以太报文的前导码和目的MAC地址之间插入了一个16字节的HiGig-Lite报文头</span>，如下图所示：
</span>

[![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH3.jpg)](http://blog.c114.net/batch.download.php?aid=14003)<span style="font-family:幼圆">
		</span>

## <span style="font-family:幼圆">HIGIG
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH4.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">Higig（XAUI）接口有4个通道，higig header中byte0使用lane0传输，byte1使用lane1，byte2使用lane2，byte3使用lane3，byte4使用lane0，依次类推。
</span>

<span style="font-family:幼圆">Higig header主要包括：START_OF_FRAME (SOF)、DST_MODID、SRC_MODID、HDR_EXT_LENGTH、VID_HIGH、VID_LOW、VID_LOW、 SRC_MODID、SRC_PORT_TGID、DST_PORT、DST_MODID 、HDR_TYPE。其中HDR_TYPE决定HDR_TYPE之后4byte的格式。
</span>

<span style="font-family:幼圆">HDR_TYPE：00 = Overlay 1 (default)，提供mirroring/trunking信息
</span>

<span style="font-family:幼圆">01 = Overlay 2 (classification tag)，提供分类、过滤处理。
</span>

## <span style="font-family:幼圆">HIGIG2
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH5.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">HIGIG2 PACKET HEADER
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH6.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">Higig2 Packet Header： 中包括， FRC和PPD。
</span>

<span style="font-family:幼圆">1）K.SOP (0xFB): control character will always be aligned with Lane 0.即分隔符
</span>

<span style="font-family:幼圆">2）K.EOP (0xFD): control character will be aligned depending on the length of HG_Payload
</span>

<span style="font-family:幼圆">3）HG_Payload: will carry the Ethernet frame starting from the MACDA field
</span>

<span style="font-family:幼圆">4）Fabric Routing Control (FRC)，占用7个字节。FRC中比较有用的是：
</span>

<span style="font-family:幼圆">MCST（多播还是单播）、
</span>

<span style="font-family:幼圆">TC [3:0]（用于qos）、
</span>

<span style="font-family:幼圆">DST_MODID [7:0] /MGID [15:8] （目的mode id）、
</span>

<span style="font-family:幼圆">DST_PID [7:0] /MGID [7:0]（目的端口id）、
</span>

<span style="font-family:幼圆">SRC_MODID [7:0]（源mode id）、
</span>

<span style="font-family:幼圆">SRC_PID [7:0]（源端口id）、
</span>

<span style="font-family:幼圆">PPD_TYPE（Packet Processing Descriptor Type）
</span>

<span style="font-family:幼圆">5）Packet Processing Descriptor (PPD)，占用8个字节。主要是根据FRC中的PPD_TYPE决定PPD的结构
</span>

<span style="font-family:幼圆">000: PPD Overlay1
</span>

<span style="font-family:幼圆">001: PPD Overlay2
</span>

<span style="font-family:幼圆">010~111: Reserved。
</span>

<span style="font-family:幼圆">6) HG_CRC32: will cover the bytes starting from the K.SOP to the last byte of the HG_Payload for packet error protection. 
</span>

## <span style="font-family:幼圆">HIGIG2 MESSAGES
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH7.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">Higig2 messages占用16byte。
</span>

<span style="font-family:幼圆">K.SOM:分隔符
</span>

<span style="font-family:幼圆">HG_CRC8：crc校验，从K.SOM到最后一个HG_Message。
</span>

<span style="font-family:幼圆">Higig2 messages可以出现在higig2数据包中，也可以独立成包。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH8.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">Higig2 messages包括MSG_TYPE（message类型）、FWD_TYPE
</span>

<span style="font-family:幼圆">MSG_TYPE
</span>

<span style="font-family:幼圆">000000: Flow Control
</span>

<span style="font-family:幼圆">FWD_TYPE：
</span>

<span style="font-family:幼圆">00: Link Level
</span>

<span style="font-family:幼圆">Higig2能够兼容HiGig+，而HiGig+不能兼容higig2.
</span>

<span style="font-family:幼圆">在支持higig2和higig+的结构，结构图如下
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH9.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">Combo MAC能够区分higig2 header和higig+ header.
</span>

<span style="font-family:幼圆">Translation shim负责转换为higig+ header。
</span>

<span style="font-family:幼圆">Common HiGig+ Fabric Processing Core负责处理路由方案。
</span>

## <span style="font-family:幼圆">HIGIG-LITE
</span>

<span style="font-family:幼圆">HIGIG-LITE header 位于<span style="color:blue">以太报文的前导码和目的MAC地址之间，占用16byte，HIGIG-LITE</span>由两部组成：8byte的FRC和8byte的PPD。
</span>

<span style="font-family:幼圆">HIGIG-LITE堆叠协议与基于HIGIG、HIGIG2的StrataXGS设备是不能兼容的，只有基于HIGIG-LITE的设备之间可以堆叠。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH10.png)<span style="font-family:幼圆">
		</span>

## <span style="font-family:幼圆">功能描述
</span>

<span style="font-family:幼圆">每个交换设备都有唯一的一个mode id，用于转发数据包。Frabric设备没有mode id，因为他们只适用于扩展系统，而不是边沿设备，它只是需要通过mode id定位到相应的端口。
</span>

<span style="font-family:幼圆">Mode id的数量是有限的，原来一个端口对应一个mode id，后来由于支持了重新映射功能，可以有多个端口对应一个mode id，通过端口数来区别。
</span>

<span style="font-family:幼圆">   当一个数据包需要通过higig口传递时，入口交换设备需要header域添加合适的信息，fabric设备和其他交换设备需要分析header中的opcode，来获知数据包的类型（CPU、broadcast、multicast、known unicast）。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH11.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">Opcode=0：cpu控制报文。在大多数情况是发送给cpu的报文。
</span>

<span style="font-family:幼圆">Opcode=1：known unicast packet。入口交换查找2层/3层 table，找到一个匹配的。在mode header中，dst_modid 、dst_port 制定了最后的出口。中间的Fabric、交换设备根据MH中内容来转化数据包，在目的mode，通过dst_port来发送到对应的端口上。不需要转发表。
</span>

<span style="font-family:幼圆">The ingress switch device will set opcode==1 for the following conditions:
</span>

<span style="font-family:幼圆">1\. Matching L2 entry
</span>

<span style="font-family:幼圆">2\. Matching L3 entry
</span>

<span style="font-family:幼圆">3\. FP match action==redirect
</span>

<span style="font-family:幼圆">Opcode=2：用于广播，或者是在table中没有找到匹配的单播。Fabric、switch设备会将报文发到MH中制定的vlan中的其他成员。
</span>

<span style="font-family:幼圆">Opcode=3：KNOWN L2 MULTICAST PACKETS。入口交换查找L2/L2MC table，找到一个匹配的。在mode header中，dst_modid 、dst_port 指定了多播组id，中间的Fabric、交换设备根据MH中多播组id在L2/L2MC table查找，确定最后目的端口号。
</span>

<span style="font-family:幼圆">Opcode=4：KNOWN L3 MULTICAST PACKETS。入口交换查找L3/L3MC table，找到一个匹配的entry，在mode header中，dst_modid 、dst_port指定了IPMC group ID, 中间的Fabric、交换设备将定位L3/L3MC table，使用MH中IPMC group ID，确定最后目的端口号。
</span>

<span style="font-family:幼圆">Opcode=5、6、7：无效的操作。
</span>

## <span style="font-family:幼圆">端口镜像
</span>

<span style="font-family:幼圆">在StrataXGS I/II，端口镜像到镜像端口端、报文发送到目的端口，需要module header中的mirror, mirror_done,  mirror_only确定。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH12.png)<span style="font-family:幼圆">
		</span>

### <span style="font-family:幼圆">STRATAXGS <span style="color:red">I</span> MIRRORING (BCM5670)
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH13.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">(mirror, mirror_done, mirror_only)==(100)表示报文需要映像和交换。如果交换端口和镜像端口为同一个端口，那么只需要发送一个报文；如果不是同一个端口，需分别发送一个报文。无论是发送到交换端口还是镜像端口，报文module header域都不需要改变。
</span>

<span style="font-family:幼圆">上图中MTP为镜像端口，B为交换端口
</span>

### <span style="font-family:幼圆">STRATAXGS<span style="color:red"> II</span> INGRESS MIRRORING (BCM5675)
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH14.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">上图中MTP为镜像端口，B为交换端口。
</span>

<span style="font-family:幼圆">如果映像端口与交换端口不是同一个端口，会发送两个数据包，两个端口各一个。
</span>

<span style="font-family:幼圆">(mirror, mirror_done, mirror_only)==(110)表示报文只映射不交换
</span>

<span style="font-family:幼圆">(mirror, mirror_done, mirror_only)==(101)表示报文值交换不映射
</span>

### <span style="font-family:幼圆">STRATAXGS III INGRESS MIRRORING (BCM56500)
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH15.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">交换设备在经过higig会建立会有3份数据包拷贝： Switch copy、Ingress mirror copy 、Egress mirror copy
</span>

<span style="font-family:幼圆">发送switch copy时，header会是MH.opcode==1 (known unicast), dst_modid, dst_port, mirror=0。
</span>

<span style="font-family:幼圆">发送mirror copy时，header会是MH.opcode==1 (known unicast), dst_modid, dst_port, mirror=1。
</span>

<span style="font-family:幼圆">对于ingress mirror copy，报文是没有经过修改的原始报文。
</span>

### <span style="font-family:幼圆">2.5G HIGIG 模式
</span>

<span style="font-family:幼圆">在2.5G higig模式下，<span style="color:red">只是用一个通道XAUI lane (0)，XAUI lane (1-3)没有使用</span>。只有基于XAUI 的端口才支持2.5G higig模式
</span>

# <span style="font-family:幼圆">56146功能
</span>

### <span style="font-family:幼圆">56146简介
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH16.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">该款芯片有24个FE口，4个1G/2.5G口。
</span>

<span style="font-family:幼圆">56146支持的交换功能：L2交换、l2多播、vlan、Double VLAN Tagging、VLAN Range-Based Double Tagging、端口过滤、速率风暴控制、生成树、链路汇聚、镜像、L3路由、IP多播、CFP、QOS、端口安全、DoS、Cpu协议包处理、堆叠、MIB等。
</span>

<span style="font-family:幼圆">56146支持Ethernet/IEEE 802.3包长为64-1522B，jumbo数据最大为12KB，支持16K的mac地址学习，支持1K的2层多播组，支持4k vlan，链路汇聚支持128个trunk，每个端口有8个CoS队列，堆叠支持128个module，
</span>

<span style="font-family:幼圆">56146的交换能力达到12.4Gps，<span style="color:red">24个FE口支持10M/100M，使用的接口是S3MII</span>，BCM56146有2个HyperCores，每个HyperCores可以设置2个1G/2.5G port，所以有<span style="color:red">4个1G/2.5G端口</span>，<span style="color:red">当设置为1G时</span>，支持10/100/1000M full/half-duplex, 1000Base-X (fiber), 100Base-FX mode (fiber)模式，<span style="color:red">使用SGMII接口</span>，当设置为2.5G时，支持HiGig-Lite或overclocked-Ethernet模式。
</span>

<span style="font-family:幼圆">Cpu对56146的访问主要使用pcie接口。Port-based rate control with 8 Kbps granularity。
</span>

<span style="font-family:幼圆">主要包括的表是：
</span>

<span style="font-family:幼圆">1）<span style="color:red">端口表（Port Table）</span>：每个端口在表中有一条目，记录l2学习、没用的端口、vlan处理、任务优先级等。
</span>

<span style="font-family:幼圆">2）<span style="color:red">基于mac的vlan表</span>（MAC-Based VLAN Table）：能容纳24K的mac地址，是基于源mac的vlan表，这个表与vlan转换表协同工作。
</span>

<span style="font-family:幼圆">3）<span style="color:red">Vlan转换表（VLAN Translation table）</span>：入口、出口分别2K，用于客户vlan与服务提供商vlan之间转换，与基于mac的vlan表协同工作。
</span>

<span style="font-family:幼圆">4）<span style="color:red">基于协议的vlan表</span>（Protocol-Based VLAN Table ）：每个端口16个。
</span>

<span style="font-family:幼圆">5）<span style="color:red">Vlan表</span>（VLAN Table）：容纳4K个vlan，显示每个vlan的端口和生成树组。
</span>

<span style="font-family:幼圆">6）<span style="color:red">生成树组表</span>（Spanning Tree Group Table）：容纳256个生成树组，显示每个生成树组中每个端口的生成树状态。
</span>

<span style="font-family:幼圆">7）<span style="color:red">mac地址表</span>（MAC Address Table）：容纳16K个mac地址，包括学习到的mac和编写的mac，表示目的端口和其mac地址属性（源、目的丢弃、阻塞、优先级、镜像等）
</span>

<span style="font-family:幼圆">8）<span style="color:red">保留mac地址表</span>（Reserved MAC Address Table）：包括64个条目，存储保留的mac地址。
</span>

<span style="font-family:幼圆">9）<span style="color:red">mac阻塞表</span>（MAC Block Table）：容纳32组。出口处的阻塞、洪泛的源mac地址组。
</span>

<span style="font-family:幼圆">10）<span style="color:red">2层多播表</span>（Layer 2 Multicast Table）：容纳1K组。存储2层多播组。
</span>

<span style="font-family:幼圆">11）<span style="color:red">链路汇聚组表</span>（Link Aggregation Group Table）：容纳128组。表示链路汇聚组端口成员与hash选择条件的关系。
</span>

<span style="font-family:幼圆">12）<span style="color:red">基于IP子网的vlan表</span>（IP Subnet-Based VLAN Table）：容纳256个子网。
</span>

<span style="font-family:幼圆">13）<span style="color:red">DSCP表（DSCP Table）</span>：容纳1920个条目。重新映射入口、出口DSCP到新的DSCP和优先级
</span>

<span style="font-family:幼圆">14）<span style="color:red">3层主机路由表</span>（Layer 3 Host Route Table）：容纳512个IPV4主机，或256个IPV6主机。
</span>

<span style="font-family:幼圆">15）<span style="color:red">3层最长前向匹配路由表</span>（Layer 3 LPM Route Table）：64 IPv4 路由或32个IPv6 路由
</span>

<span style="font-family:幼圆">16）<span style="color:red">3层IP组播表</span>（Layer 3 IP Multicast Table）：容纳64组。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH17.png)<span style="font-family:幼圆">
		</span>

# <span style="font-family:幼圆">56140系列交换芯片功能
</span>

<span style="font-family:幼圆">56140系列芯片主要包括包括：
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH18.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">他们符合StrataXGS</span><span style="font-family:Calibri">®</span><span style="font-family:幼圆"> IV switching family
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH19.png)<span style="font-family:幼圆">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH20.png)<span style="font-family:幼圆">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH21.png)<span style="font-family:幼圆">
		</span>

### <span style="font-family:幼圆">Pipeline Blocks
</span>

<span style="font-family:幼圆">1）Intelligent Parser：包括full parser 和HiGig+/HiGig2 parser。Full parser主要是分析入口处的数据包中前128字节的。Higig parser主要是分析HiGig+/HiGig2 header信息。
</span>

<span style="font-family:幼圆">2）Security Engine：主要提供Early discard detection、Control Denial-of-Service, DoS, attack detection、Flow-based mirroring、Flow-rate metering。
</span>

<span style="font-family:幼圆">3）L2 Switching：执行vlan、权限任务，寻找转发包的目的mac地址、源mac地址学习，包括VLAN type select、VLAN look-up、L2 unicast look-up、L2 multicast look-up。
</span>

<span style="font-family:幼圆">4）L3 Routing：支持3层的ip协议。执行单播、多播数据包的源ip地址、目的ip地址查找。包括：L3 unicast look-up、L3 multicast look-up、Longest prefix match、Look-up switch logic、 Strict and loose uRPF checks。
</span>

<span style="font-family:幼圆">5）ContentAware Processing：支持快速过滤处理、ACL、differentiated services、QoS。要分析这些内容：MACDA, MACSA, DIP, SIP, TCP, several others等等。
</span>

<span style="font-family:幼圆">6）Buffer Management：提供cos、带宽保障、带宽限制、metering mechanisms。
</span>

<span style="font-family:幼圆">7）Modification：数据包的修改可能是由于VLAN Translation、L3 routed packet modification等原因。
</span>

### <span style="font-family:幼圆">Memory Management Unit
</span>

<span style="font-family:幼圆">内存系统主要有CBP和transaction queue (XQ)组成，主要是管理cell buffer，设备支持1.5M cell buffer poll（CBP）。对于buffer的管理方式主要是：Ingress backpressure (IBP)、Head-of-line (HOL) prevention、 Ingress rate shaping, PAUSE metering
</span>

<span style="font-family:幼圆">a) <span style="color:red">IBP</span>主要用于<span style="color:red">入端口</span>，缓解端口拥塞;尽可能减少数据包的丢失。 在Ingress Ports上有效管理buffer资源;<span style="color:black; font-size:28pt">
			</span>基于每端口设置IBP产生门限值与IBP消除门限；当到达的数据包数量满足达到门限，发送Pause帧;     当达到的数据包数量低于IBP的消除门限，停发Pause帧;
</span>

<span style="font-family:幼圆">b) <span style="color:red">HOL</span>主要用于<span style="color:red">出端口和cos</span>。
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">当多个端口或多个流向一个端口发送数据包时有可能会产生阻塞，会引起输入端口到其它端口数据包的丢失,此种情况即为HOL(Head-of-Line Blocking，线路头阻塞)。
</span></div>
*   <div style="text-align: justify"><span style="font-family:幼圆">通过设置HOL门限值，当进入的数据包达到该门限,不再允许新的数据包进入Egress队列,在MMU丢弃这些数据包。HOL预防机制通过丢弃数据包达到目的; 与PAUSE Metering, Ingress Backpressure不同。
</span></div>
*   <div style="text-align: justify"><span style="font-family:幼圆">提供两种HOL预防机制：Cell-base。设置每个端口所用memory大小; Packet-based。设置每个端口输出队列的包的最大个数.
</span></div>

<span style="font-family:幼圆">c) <span style="color:red">PAUSE Metering</span>：主要是为<span style="color:red">入口</span>提供实现入口速率整形。他会追踪每个入端口的带宽，当超过限制时，会发送PAUSE message。
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">每个端口有独立的漏桶，用于限制带宽与流量整形。
</span></div>
*   <div style="text-align: justify"><span style="font-family:幼圆">如下所示,每T_REFRESH(7.8125 ms)周期从BUCKET中取出REFRESHCOUNT 个token (每token=0.5bit);
</span></div>
*   <div style="text-align: justify"><span style="font-family:幼圆">初始化是漏桶bit值为0(令牌为full)，当进入一个packets 时，相当于往BUCKET注入相应的token,每周期取出REFRESHCOUNT ；当进入的包大于PAUSE_THD 时，PAUSE帧产生;这就是PAUSE Metering功能，用于IBP机制;
</span></div>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH22.png)<span style="font-family:幼圆">
		</span>

### <span style="font-family:幼圆">Search Engines
</span>

<span style="font-family:幼圆">支持Hash search engine、CAM search engine。
</span>

<span style="font-family:幼圆">Hash search engine (HSE)主要用在L2 MAC table (for look-up and learning), L3 host table (for IPv4 and IPv6 look-ups), MAC VLAN, IPMC searches (s,g) and (*,g), Ingress VLAN translation, and egress VLAN translation中。
</span>

<span style="font-family:幼圆">CAM search engine (CSE)主要是在使用ContentAware engine时，被Default routing/policy routing/ingress ACL或HiGig ACL触发。
</span>

### <span style="font-family:幼圆">ContentAware Processor (CAP)
</span>

<span style="font-family:幼圆">所谓ContentAware就是对packet的内容进行智能匹配的技术。主要是为ACL, DSCP, QoS等提供支持。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH23.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">这5个部分分别是<span style="color:blue">智能协议识别选择器、CAM查找引擎、策略引擎、meter和统计引擎、动作裁决引擎</span>。在ingress端口，智能协议识别选择器对进来的包的前128bit按照协议字段进行选择和标记，CAM查找引擎按照用户给的key匹配协议选择器的内容，如果找到了，就执行策略引擎的动作，并可以实验meter和统计引擎进行限速、标记颜色和统计。
</span>

### <span style="font-family:幼圆">MEF Policing
</span>

<span style="font-family:幼圆">Meter用于监控传输带宽。SrTCM、TrTCM、modified TrTCM是meter的三种方案。有待定信息速率(CIR)和额外信息速率（EIR），他们有一定扩展范围，分别是<span style="color:red">CBS和EBS</span>
		</span>

<span style="font-family:幼圆">- 当进入包数量在CBS之内时，报文标识为Green，可被转发的报文;
</span>

<span style="font-family:幼圆">- 当进入包数量超出CBS但在EBS之内,超出CBS部分的包标识为YELLOW, YELLOW 包不保证可发,可应用丢弃/转发操作;
</span>

<span style="font-family:幼圆">- 当进入的包数量超出EBS,超出EBS的包标识为RED,不会得到令牌转发;
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH24.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">Committed Information Rate (CIR) 
</span>

<span style="font-family:幼圆">Committed Burst Size<span style="color:red"> (CBS)</span>
		</span>

<span style="font-family:幼圆">Excess Information Rate (EIR)
</span>

<span style="font-family:幼圆">Excess Burst Size <span style="color:red">(EBS)
</span></span>

### <span style="font-family:幼圆">CPU Management Interface Controller (CMIC)
</span>

<span style="font-family:幼圆">CPU通过PCI接口与芯片的CMIC模块连接，并与芯片交互数据；通过PCIe接口，提供两种交互数据的机制：
</span>

<span style="font-family:幼圆">    - DMA 通道;用于交互大量数据块，比如收发数据包,CPU获取芯片的内存表数据;
</span>

<span style="font-family:幼圆">    - MESSAGING MECHANISM(消息机制)；用于交互小数据块，比如CPU读写芯片寄存器，读写内存表;
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH25.png)<span style="font-family:幼圆">
		</span>

### <span style="font-family:幼圆">Packet Flow
</span>

<span style="font-family:幼圆">1）2层入口数据包流
</span>

<span style="font-family:幼圆">数据包到达入口处时，会被分析，从数据包取出相关的内容，进行CAP处理，然后，判断数据包是否已经加了tag还是没有加tag。对于没有加tag的数据包，需要从VLAN_XLATE table、 Subnet-based table、 Protocol-based table、 Port-based table (default)中指定vlan id。对于已经加tag的，可以从数据包中获得vlan id。通过vlan查找表，可以知道数据包是否属于这个vlan，如果属于这个vlan，将进行STP、vlan端口bitmap、PFM (port filtering mode)处理，如果这个数据包的vlan是无效的，将丢弃该数据包。
</span>

<span style="font-family:幼圆">随后，开始了学习阶段。查看该数据的源mac地址和vlan id是否已经在L2 table中，如果有，说明已经学习过了，如果没有，学习的方法取决于CPU Managed Learning (CML)的设置，是通过硬件学习，还是传给cpu，还是丢弃。
</span>

<span style="font-family:幼圆">下一阶段是目的mac地址查找。如果在L2_USER_ENTRY中找到，数据包的目的地址要基于BPDU设置。如果BPDU设置为0，数据包将根据目的module、目的端口进行转发；如果BPDU设置为，数据将被丢弃、或拷贝给cpu、或洪泛到vlan中。如果在L2_USER_ENTRY中没有找到，但在L2_ENTRY table中找到了，将会转发到DST_MODID 、DST_PORT/TGID。否则，则洪泛到整个vlan中。
</span>

<span style="font-family:幼圆">当数据包是多播包时，经过的路径与单播包一样。当多播包在L2_ENTRY中找到，L2_ENTRY的索引将用来确定L2MC table的索引。L2MC table用于映射出端口，当PFM为0时，将洪泛到整个vlan中，当PFM为1是，将转发给L2MC table中指定的端口。
</span>

<span style="font-family:幼圆">对于多播包，经过的路径与单播包一样，只是在学习之后，将报文转发给该vlan的所有成员。
</span>

<span style="font-family:幼圆">2）3层入口数据包流
</span>

<span style="font-family:幼圆">如果查目的MAC地址表的时候发现L3bit置位了，就进入到L3转发流程。L3交换可以实现跨VLAN转发，而且它的转发依据不是根据目的MAC地址，而是根据目的IP。L3转发的流程是：
</span>

<span style="font-family:幼圆">首先对L3头部进行校验，校验和错的包直接丢弃；然后进行原IP地址查找，如果主机路由表中没有找到，会上报给CPU，CPU会进行相应的处理，并更新接口表；
</span>

<span style="font-family:幼圆">下一步进行目的IP地址查找，如果主机路由表中没有找到，就会在子网路由表中进行查找，在子网路由表中进行最长子网匹配的查找算法，如果在子网路由表中还没有找到，也送给CPU进行处理，如果在主机路由表或子网路由表中找到了，就会得到下一跳的指针。如果ECMP使能的话，会得到ECMP的指针和ECMP的个数，从而根据hash算法得到一个下一跳指针。下一条表项中包含了下一跳的MAC地址和接口表的索引。在包转发出去的时候，用下一跳的MAC地址替换掉包的目的MAC地址。用接口表中的MAC地址和VLAN替换掉包的原MAC地址和VLAN。
</span>

### <span style="font-family:幼圆">L2 功能介绍
</span>

<span style="font-family:幼圆">主要包括：
</span>

<span style="font-family:微软雅黑">•</span><span style="font-family:幼圆"> "Learning" （mac地址学习）
</span>

<span style="font-family:微软雅黑">•</span><span style="font-family:幼圆"> "L2 Address Aging" （2层地址老化）
</span>

<span style="font-family:微软雅黑">•</span><span style="font-family:幼圆"> "L2 Address Learning Limits" （2层地址学习限制）
</span>

<span style="font-family:微软雅黑">•</span><span style="font-family:幼圆"> "L2 Multicast" （2层多播）
</span>

<span style="font-family:微软雅黑">•</span><span style="font-family:幼圆"> "L2 User Entry" （2层用户登记）
</span>

<span style="font-family:微软雅黑">•</span><span style="font-family:幼圆"> "L2 Port Bridge" （2层端口桥）
</span>

<span style="font-family:微软雅黑">•</span><span style="font-family:幼圆"> "Spanning Tree" （生成树）
</span>

1.  <div style="text-align: justify"><span style="font-family:幼圆">Learning
</span></div>

<span style="font-family:幼圆">L2_ENTRY表中包含三种不同的类型：
</span>

<span style="font-family:幼圆">VLAN-based bridging (basic), 
</span>

<span style="font-family:幼圆">single-VLAN cross connect, 
</span>

<span style="font-family:幼圆">and double-VLAN cross connect.
</span>

<span style="font-family:幼圆">当CPU managed Learning (CML)模式设置时，硬件mac地址学习使能。通过CML_FLAGS_NEW和CML_FLAGS_MOVE控制CML，CML_FLAGS_NEW用来控制数据包中mac地址不认识的情况，CML_FLAGS_MOVE用来控制入口的数据包的mac地址与2层表中记录的该端口mac地址不相同的情况。有四种处理方式：HW学习包、pending学习、拷贝给cpu、丢弃。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH26.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">L2_MOD_FIFO有128条记录，用于向cpu通知L2_ENTRY 表发生了变化，L2_MOD_FIFO表中存储了L2_ENTRY表的改变。
</span>

<span style="font-family:幼圆">2）L2 Address Aging
</span>

<span style="font-family:幼圆">通过L2_AGE_TIMER寄存器来使能老化，和设置老化时间。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH27.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">3）L2 Address Learning Limits
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">设置每端口/每LAG，每VLAN与每芯片地址学习限制：
</span></div>

<span style="font-family:幼圆">    - 每芯片地址学习限制与当前学习的MAC数量统计
</span>

<span style="font-family:幼圆">    - 28个端口,每端口可设学习限制，当前学习的MAC统计；
</span>

<span style="font-family:幼圆">    - 128 个LAG，每LAG可设学习限制，当前学习MAC统计；
</span>

<span style="font-family:幼圆">    - 4095 VLAN，每VLAN可设学习限制，当前学习MAC统计；
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">支持使能地址限制Check功能：
</span></div>

<span style="font-family:幼圆">    数据包分别经过system limit，port/LAG limit, VLAN limit逐级检查，如限制门限达到，丢掉该数据包；也可选送CPU；
</span>

<span style="font-family:幼圆">4）L2 Multicast
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">支持三种PFM模式 (port filtering modes)：
</span></div>
*   <div style="text-align: justify"><span style="font-family:幼圆">PFM A, 所有组播包在VLAN域内广播；
</span></div>
*   <div style="text-align: justify"><span style="font-family:幼圆">PFM B, 已知组播转发至组播表的pbmp端口;未知组播则在VLAN域内广播;
</span></div>
*   <div style="text-align: justify"><span style="font-family:幼圆">PFM C,已知组播转发至组播表的pbmp端口;未知组播则丢弃;
</span></div>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH28.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">5）L2 User Entry 
</span>

<span style="font-family:幼圆">L2_USER_ENTRY表包含64条表项，关键值是MAC_DA 、VLAN_ID。
</span>

<span style="font-family:幼圆">6）L2 Port Bridge
</span>

<span style="font-family:幼圆">允许收发包是同一个端口。典型的应用是Wireless Access Point (WAP)。同一个端口可以对应多个mac。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH29.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">7）Spanning Tree
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">完全支持IEEE 802.1D(STP),IEEE 802.1s(MSTP), IEEE 802.1W(RSTP):
</span></div>

<span style="font-family:幼圆">    - 支持端口状态设置: disable, blocking, listening, learning , forwarding;
</span>

<span style="font-family:幼圆">    - 以上的2层功能，支持生成树必要的条件:学习,老化与MAC地址表的批量删除;
</span>

<span style="font-family:幼圆">    - 支持256 生成树表项。
</span>

### <span style="font-family:幼圆">VLAN
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH30.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">Internal VLAN ID获取
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">提供并根据以下排列优先顺序的几种表用于获取Internal VLAN ID:
</span></div>

        *   <div style="text-align: justify"><span style="font-family:幼圆">VLAN Translation。以数据包的Inner/Outer VID为索引；每端口可选设置时能;
</span></div>
    *   <div style="text-align: justify"><span style="font-family:幼圆">MAC-Based。以数据包的源MAC地址为索引；每端口可选设置时能；
</span></div>
    *   <div style="text-align: justify"><span style="font-family:幼圆">Subnet-Based。以数据包的源IP为索引；每端口可选设置时能；
</span></div>
    *   <div style="text-align: justify"><span style="font-family:幼圆">Protocol-Based。以数据包的协议类型( ETHNET_TYPE )为索引；每端口可选设置时能；
</span></div>
    *   <div style="text-align: justify"><span style="font-family:幼圆">Port-Based。以端口配置的默认VLANID作为Internal VLAN；
</span></div>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH31.png)<span style="font-family:幼圆">
		</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">对于Untagged与single priority-tagged packet ，查找的类型表以及优先顺序为MAC-Based - &gt; Subnet-Based -&gt;  Protocol-Based -&gt;Port-Base;
</span></div>
*   <div style="text-align: justify"><span style="font-family:幼圆">对tagged packet,查找顺序为 VLAN Translation -&gt; MAC-Based - &gt; Subnet-Based -&gt;  Protocol-Based -&gt;Port-Base;
</span></div>

<span style="font-family:幼圆">Ingress VLAN Action
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">查表结果，对数据包执行以下的VID转换规则：
</span></div>

<span style="font-family:幼圆">     - Add Internal OVID/IVID
</span>

<span style="font-family:幼圆">    - Replace incoming OVID/IVID with internal   OVID/IVID
</span>

<span style="font-family:幼圆">    - Delete incoming OVID/IVID
</span>

<span style="font-family:幼圆">    - Do not modify
</span>

<span style="font-family:幼圆">    使用VLAN_XLATE表
</span>

<span style="font-family:幼圆">Egress VLAN Action
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">在出口端，根据OutVid/InnerVid 查找Egress VLAN Translation, 执行以下相应操作(根据untagged与tagged包类型):
</span></div>

<span style="font-family:幼圆">     - Add OVID/IVID
</span>

<span style="font-family:幼圆">    - Replace OVID/IVID with internal/outgoing OVID/IVID
</span>

<span style="font-family:幼圆">    - Delete OVID/IVID
</span>

<span style="font-family:幼圆">    - Do not modify
</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">通过EGR_VLAN表配置，对数据包进行强制剥离外层VID;用于Double-tagged模式;
</span></div>

<span style="font-family:幼圆">**VLAN Range Checking**
		</span>

*   <div style="text-align: justify"><span style="font-family:幼圆">支持128个VLAN Range表。通过Range表的配置，将某段范围的userVID替换成一个OVID，节省VLAN表与其他资源VLAN Transparent表项的资源；
</span></div>
*   <div style="text-align: justify"><span style="font-family:幼圆">VLAN Range执行优于Ingress VLAN Translation;
</span></div>

<span style="font-family:幼圆">VLAN tag操作流程
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0342_HiGigHiGigH32.png)<span style="font-family:幼圆">
		</span>

<span style="font-family:幼圆">转：http://blog.chinaunix.net/uid-11140746-id-3712645.html</span>
