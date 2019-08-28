---
title: PTN时钟同步技术及应用
id: 561
comment: false
categories:
  - arm
date: 2016-05-25 13:53:05
tags:
---

<span style="color:black; font-family:宋体; font-size:9pt">PTN Clock Synchronization Technology and Its Application
</span>
<!-- more -->

<span style="color:black; font-family:宋体; font-size:9pt">2010-06-03
</span>

<span style="color:black; font-family:宋体; font-size:9pt">      作者:李勤
</span>

<span style="color:black; font-family:宋体; font-size:9pt">摘要:时钟同步是分组传送网(PTN)需要考虑的重要问题之一。可以采用同步以太网、IEEE 1588v2、网络时间协议(NTP)等多种技术实现时钟同步。同步以太网标准的同步状态信息(SSM)算法存在时钟成环，以及难以对节点跟踪统计的问题。中兴通讯提出了一种扩展SSM算法可以改进时钟同步问题。在时间同步方面，由于NTP的精度还无法满足电信网的需求，仅采用1588v2又会带来收敛时间较慢、在网络负载较重时时间延迟精度容易受到影响等问题。中兴通讯提出了同步以太网基础的1588v2时间传递方案，对提高PTN网络中时间同步的精度起到了较好的作用。

关键字:分组传送网；同步以太网；时间同步；延迟
</span>

<span style="color:black; font-family:宋体; font-size:9pt">英文摘要:Clock synchronization is an important issue in Packet Transport Networking (PTN). Current clock synchronization technologies include synchronous Ethernet, IEEE 1588v2, and Network Time Protocol (NTP). However, challenges such as clock ring and difficulty tracing and counting nodes have arisen in Synchronous Ethernet standard Synchronization Status Message (SSM) algorithm. ZTE therefore proposes using an extended SSM algorithm. In time synchronization, the accuracy of NTP cannot meet the needs of telecommunication networks, and only using 1588v2 slows convergence time. The precision for time delay is easily affected when the network is heavily loaded. ZTE proposes a 1588v2 scheme based on synchronous Ethernet in order to effectively raise the precision of PTN time synchronization.

英文关键字:PTN; synchronous ethernet; time synchronization; delay
</span>

<span style="color:black; font-family:宋体; font-size:9pt">    当运营商对分组传送网(PTN)取代传统时分复用(TDM)传输网的需求日益明显时，如何解决时钟同步成为重要问题之一。对分组传送网的同步需求有两个方面：一是可以承载TDM业务并提供TDM业务时钟恢复的机制，使得TDM业务在穿越分组网络后仍满足一定的性能指标(如ITU-T G.823/G.824规范)；二是分组网络可以像TDM网络一样，提供高精度的网络参考时钟，满足网络节点(如基站)的同步需求。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
<span style="color:red">**1 同步技术
**<span style="color:black">    时钟同步包括：频率同步和时间同步。频率同步要求相同的时间间隔，时间同步要求时间的起始点相同和相同的时间间隔。
</span></span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
    无线技术不同制式对时钟的承载有不同的需求，GSM/WCDMA采用的是异步基站技术，只需要做频率同步，精度要求0.05 ppm，而TD-SCDMA/CDMA2000需要时间同步，TD- SCDMA的精度要求为±1.5 μs。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    从2004年开始，国际电信联盟电信标准部门(ITU-T)Q13/SG15开始逐步制订关于分组网同步技术的系列建议书，主要有：G.8261(定义总体需求)、G.8262(定义设备时钟的性能)、G.8264(主要定义体系结构和同步功能模块)。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    IEEE在2002年发布了IEEE 1588标准，该标准定义了一种精确时间同步协议(PTP)。IEEE 1588是针对局域网组播环境制订的标准，在电信网络的复杂环境下，应用将受到限制。因此在2008年又发布了IEEE 1588v2(以下简称1588v2)，该版本中增加了适应电信网络应用的技术特点[1-5]。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    因特网工程任务组(IETF)网络时间同步协议(NTP)实现了Internet上用户与时间服务器之间时间同步。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
<span style="color:red">**2 同步以太网技术
**<span style="color:black">    物理层同步技术在传统同步数字体系(SDH)网络中应用广泛。每个节点可从物理链路提取线路时钟或从外部同步接口获取时钟，从多个时钟源中进行时钟质量选择，使本地时钟锁定在质量最高的时钟源，并将锁定后的时钟传送到下游设备。通过逐级锁定，全网逐级同步到主参考时钟(PRC)被实现。对分组网络也可采取相似的技术，其原理如图1所示。
</span></span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN1.gif)<span style="color:black; font-family:宋体; font-size:9pt">
		</span>

<span style="color:red; font-family:宋体; font-size:9pt">2.1 同步以太网原理
<span style="color:black">    分组网络中的同步以太网技术是一种采用以太网链路码流恢复时钟的技术。以太网物理层编码采用4B/5B(FE)和8B/10B(GE)技术，平均每4个比特就要插入一个附加比特，这样在其所传输的数据码流中不会出现连续4个1或者4个0，可有效地包含时钟信息。在以太网源端接口上使用高精度的时钟发送数据，在接收端恢复并提取这个时钟，时钟性能可以保持高精度。
</span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
    同步以太网原理如图2所示。在图2中发送侧设备(节点A)将高精度时钟注入以太网的物理层芯片，物理层芯片用这个高精度的时钟将数据发送出去。接收侧的设备(B节点)的物理层芯片可以从数据码流中提取这个时钟。在这个过程中时钟的精度不会有损失，可以与源端保证精确的时钟同步。同步以太网传递时钟的机制与SDH网络基本相似，也是从以太网物理链路恢复时钟，因此从恢复的时钟质量不受链路业务流量影响，可提供与SDH/SONET网络相同的时钟树部署和时钟质量，完全满足G.823规定的定时接口指标。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN2.gif)<span style="color:black; font-family:宋体; font-size:9pt">
		</span>

<span style="color:red; font-family:宋体; font-size:9pt">2.2 同步以太网SSM算法
<span style="color:black">    同步状态信息(SSM)算法源于SDH的时钟同步控制，使用规则和时钟选择算法符合ITU-T G.781的规范。同步以太网的SSM控制继承了SDH网络特性，在传统时钟网的基础上通过增加以太网同步消息信道(ESMC)丰富了同步以太网的支持。G.8264里对其进行了描述。以太网同步消息信道是媒体访问控制(MAC)层的单向广播协议信道，用于在设备间传送同步状态信息SSM。设备根据ESMC报文的SSM信息选择最优的时钟源。
</span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
    虽然标准SSM算法能够很好地实现网络时钟的同步，但是它有两个不足之处：一是不能很好地处理同步时钟成环的问题。需要在工程上和时钟配置的时候特别注意，保证避免出现时钟成环的情况。二是时钟信号的衰减问题。随着同步链路数的增加，同步分配过程的噪声和温度变化所引起的漂移都会使定时基准信号的质量逐渐劣化，因此在同一个同步链路上实际的可同步网元的数目是受限的，而通过标准SSM难以对节点进行跟踪统计。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    中兴通讯PTN设备采用了改进的扩展SSM算法，在ESMC报文里使用两个类型-长度-取值(TLV)传递SSM信息。第一个TLV传递原SSM字节的信息为同步质量等级，遵循ITU－T标准；另外一个TLV用于路径保护。改进的算法具有如下优势：
</span>

*   <span style="color:black; font-family:宋体; font-size:9pt">从根本上防止了时钟成环。
</span>
*   <span style="color:black; font-family:宋体; font-size:9pt">当存在多条时钟路径时，自动选择最优(最短)路由。
</span>
*   <span style="color:black; font-family:宋体; font-size:9pt">只要存在到达主时钟的路由，网元就会跟踪主时钟，而不会进入自由振荡状态。
</span>
*   <span style="color:black; font-family:宋体; font-size:9pt">算法为低层分布式处理，因此各网元地位等同，操作简单。
</span>
*   <div><span style="color:black; font-family:宋体; font-size:9pt">标准的S1字节可以直接使用，不影响与其他厂家设备的对接。
</span></div>

<span style="color:black; font-family:宋体; font-size:9pt">
<span style="color:red">**3 时间同步技术**<span style="color:black">
    时间同步技术是频率同步的进一步发展。分组时间同步技术采用分组协议数据单元作为时钟或时间信息的载体，是实现主时钟与从时钟时间之间同步比较好的方式。其基本原理如图3所示。
</span></span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN3.gif)<span style="color:black; font-family:宋体; font-size:9pt">
				</span>

<span style="color:red; font-family:宋体; font-size:9pt">3.1 网络时间协议
<span style="color:black">    在IEEE 1588v2技术出现以前，在分组网络中用于时间同步的协议主要的有3种：时间协议、日时协议和网络时间协议(NTP)。NTP由纯软件实现，精度比较低。目前广泛使用的NTPv3可以达到10 ms左右的同步精度。IETF正在进行NTPv4的标准工作，支持IPv6和动态发现服务器，预计同步精度可达到10 μs级。NTP的稳定性和精度还不能满足电信网的高要求。
</span></span>

<span style="color:red; font-family:宋体; font-size:9pt">3.2 1588v2协议<span style="color:black">
					</span></span>

<span style="color:red; font-family:宋体; font-size:9pt">3.2.1 1588v2协议的实现原理
<span style="color:black">    1588v2是未来统一提供时间同步和频率同步的方法，能适合于不同传送平台的局间时频传送，既可以基于1588v2的时间戳以基于分组的时间传送(TOP)方式单向传递频率，也可使用IEEE 1588v2的协议实现时间同步，在PTN设备中得到广泛应用。
</span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
    1588v2时间同步的核心思想是采用主从时钟方式，对时间信息进行编码，利用网络的对称性和延时测量技术，通过报文消息的双向交互实现主从时间的同步。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    1588v2协议原理如图4所示。图中，Delay=(T2-T1+T4-T3)/2，Offset=(T2-T1-T4+T3)/2。
主时钟(Master)与从时钟(Slave)之间发送Sync、Follow_Up、Delay_Req、Delay_Resp消息。通过T1、T2、T3、T4这4个值，主从时种可计算出Master与Slave之间延迟(Delay)，以及Master与Slave的时间差(Offset)。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN4.gif)<span style="color:black; font-family:宋体; font-size:9pt">
				</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    同步消息类型有一般消息和事件消息。一般消息(例如Follow_Up)本身不进行时戳处理，它可以携带事件消息(如Sync)的准确发送或接收时间，还具有完成网络配置、管理，或PTP节点之间通信的功能。事件消息本身需要进行时戳处理，并可携带或不携带时戳。从时钟根据事件消息的时戳或由一般消息携带的时戳计算路径延迟和主从时钟之间的时间差。
</span>

<span style="color:red; font-family:宋体; font-size:9pt">3.2.2 时钟类型
<span style="color:black">    1588v2基于Ethernet/IPv4/v6/UDP等协议之上，共定义了3种基本时钟类型：普通时钟(OC)、边界时钟(BC)和透明时钟(TC)。
</span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
    普通时钟是单端口器件，可以作为主时钟或从时钟。一个同步域内只能有唯一的主时钟。主时钟的频率准确度和稳定性直接关系到整个同步网络的性能。一般可考虑PRC或同步于全球定位系统(GPS)。从时钟的性能决定时戳的精度以及Sync消息的速率。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    边界时钟是多端口器件，可连接多个普通时钟或透明时钟。边界时钟的多个端口中，有一个作为从端口，连接到主时钟或其他边界时钟的主端口，其余端口作为主端口连接从时钟或下一级边界时钟的从端口，或作为备份端口。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    透明时钟连接主时钟与从时钟，它对主从时钟之间交互的同步消息进行透明转发，并且计算同步消息(如Sync、Delay_Req)在本地的缓冲处理时间，并将该时间写入同步消息的CorrectionField字节块中。从时钟根据该字节中的值和同步消息的时戳值Delay和Offset实现同步。TC又可分为E2E TC和P2P TC。
</span>

<span style="color:red; font-family:宋体; font-size:9pt">3.2.3 1588v2协议的延迟
<span style="color:black">    延迟是影响1588v2精度的主要因素之一。延迟主要有时戳处理延迟、节点缓冲延迟和路径延迟。
</span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
    (1)时戳处理延迟
    1588v2的时戳处理由硬件完成，时戳处理单元的位置处于物理层与MAC层之间。如图5所示。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN5.gif)<span style="color:black; font-family:宋体; font-size:9pt">
				</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    硬件时戳处理可以补偿1588v2协议帧通过协议栈时消耗的时间，保证端口消息发送和接收时戳的精度。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    (2)节点缓冲与路径延迟
    1588v2定义两种透明时钟，用于节点缓冲延迟补偿：E2E TC和P2P TC。对于传输路径的补偿，有两种方式：时延请求反应方式和点对点时延方式。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    时延请求反应方式结合E2E TC使用。TC只需要在入口和出口处在报文上标记处理时戳，时间延迟补偿的计算全部由Slave完成。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    点对点时延方式结合P2P TC使用。TC参与端点间的时间延迟计算，每个端点分别与TC交互，并计算P2P之间的时间延迟。Slave利用计算结果计算延迟补偿。
</span>

<span style="color:red; font-family:宋体; font-size:9pt">3.2.4 1588v2协议在PTN上的实现
<span style="color:black">    1588v2的同步精度在实际网络部署中受到多方面因素的影响，复杂网络环境(如微波和交换网络的混合组网)的使用目前还在研究当中。在纯分组的测试网络中，1588v2可以达到100 ns级的精度，但是由于网络时延复杂性和1588v2的双向路径非对称性的不可控，导致单纯依赖1588v2协议和数理分析算法去适应网络环境，存在着难以预知的风险。例如在网络负荷较重时，由于单纯1588v2报文发包频率很高，在网络中1588v2报文容易受到业务报文的影响，对时间延迟精度产生很大的影响。而降低报文发包频率，又会导致时间收敛速度较慢。另外在实际工程中，需要对1588v2算法进行双向路径非对称性补偿。非对称性主要来源于光纤不对称。测量光纤不对称通常做法是采用昂贵的时间同步测试仪和示波器进行时间误差测量，再进行非对称性时延补偿。由于PTN接入节点数量多，工作量大且需要专业人员操作，而且时间同步测试仪和示波器等相关仪器工程人员携带不方便，难以普遍推广实施，导致1588v2在工程可实施性上存在争论。
</span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
    中兴通讯的PTN产品针对上述问题，提出了同步以太网基础的1588v2时间传递方案。方案核心思想是建立时钟和时间分离且高度可控的网络，排除了不可预知的风险。在同步以太网物理层稳定频率同步的基础上实施1588v2，有助于时间同步的快速收敛，而且可以降低1588v2报文发送频率，在网络负荷较重时，也不影响时间精度，使PTN时间同步具有更高可靠性和更高精度。为了解决PTN非对称性测量的工程问题，接入层PTN设备上集成了时间误差测量功能，迅速准确，不需要专业仪表，容易操作实施。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
<span style="color:red">**4 典型应用**<span style="color:black">
						</span></span></span>

<span style="color:red; font-family:宋体; font-size:9pt">4.1 同步以太网应用<span style="color:black">
    同步以太网的组网应用和SDH类似，支持环网和树状网组网，通常由无线网络控制器(RNC)提供时钟源，时钟信息通过同步以太网传送后到达各个基站，从而保持全网同步状态。在树状组网中，无时钟路由保护；在环网组网中，如果当前时钟路由发生故障，通过告警、SSM信息等相关网元可以从其他方向跟踪源时钟，从而实现时钟路由保护。同步以太网组网实例如图6所示。
</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN6.png)![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN7.png)<span style="color:black; font-family:宋体; font-size:9pt">
				</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    同步信息经过网元传递后抖动会增加，因此在网络部署中，设备如果能以最短路径跟踪时钟源，则可以获得较好的时钟质量。中兴通讯的PTN设备采用了改进的扩展SSM算法，在SSM信息中增加时钟经过的节点数，可以实现任何情况下网元以最短路径跟踪时钟源。
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    时钟跟踪实例如图7所示。网元C可以从B点或D点跟踪源A发出的时钟信息。从B点跟踪，时钟只经过一个节点，如果从D点跟踪，则经过了两个节点。为了使C点获得较高的时钟质量，中兴通讯的PTN设备会自动优选B点方向的时钟。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN8.gif)<span style="color:black; font-family:宋体; font-size:9pt">
				</span>

<span style="color:red; font-family:宋体; font-size:9pt">4.2 1588v2协议应用<span style="color:black">
					</span></span>

<span style="color:red; font-family:宋体; font-size:9pt">4.2.1 替代基站GPS<span style="color:black">
    1588v2典型组网应用之一是在移动接入网中替代基站GPS。TD-SCDMA和CDMA2000基站GPS天线在工程安装时需要120度净空，对环境要求较高。在室内地下等应用场景，GPS安装困难。由于GPS成本相对较高，故障率相对较高，如果PTN传送网可以为基站提供时间同步，替代GPS的功能或者作为GPS的备份使用，将会为移动网络提供更高的安全保障。
</span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
    基站GPS替代1588v2组网实例如图8所示。在PTN网络中，只需其中一个网元输入时间信息，例如通过1PPS+TOD接口从GPS接收时间信息。PTN网络通过1588v2协议将时间信息分发到其他网元，再通过以太网接口或其他接口到达基站，从而实现各基站之间的时间同步。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN9.gif)<span style="color:black; font-family:宋体; font-size:9pt">
				</span>

<span style="color:black; font-family:宋体; font-size:9pt">
    基站侧需要支持1588v2协议或者支持时间接口。如果基站支持1588v2协议，则PTN可工作在透明时钟方式；如不支持，PTN需要工作在边界时钟方式。
</span>

<span style="color:red; font-family:宋体; font-size:9pt">4.2.2 频率恢复
<span style="color:black">    1588v2的另外一个主要用途是以TOP方式进行频率恢复。在很多运营商现网环境中，很多网络是普通数据网络，不支持同步以太网。需要穿越该普通网络获取时钟频率时可使用1588v2。
</span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
    频率恢复1588v2组网实例如图9所示。当分组传送网络设备A与分组传送网络设备B的中间网络同为普通数据网络时，从A点穿越普通数据网络传递1588v2的Sync报文到网络出口B点；B点通过1588v2恢复出A点的时钟，恢复的时钟作为B点的参考源，然后再根据该参考源恢复业务时钟。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052516_0552_PTN10.gif)<span style="color:black; font-family:宋体; font-size:9pt">
				</span>

<span style="color:black; font-family:宋体; font-size:9pt">
<span style="color:red">**5 结束语
**<span style="color:black">    随着PTN的逐步引入，对PTN时钟同步技术的研究将更深入。中兴通讯提出了同步以太网扩展SSM算法，以及同步以太网基础上的1588v2方案，对提高PTN网络中时间同步的精度、降低工程实施难度起到积极的作用。可以预见，PTN时钟同步技术的应用将会在移动接入网、TDM业务、物联网实时数据采集、大客户专网等领域有广泛的应用。
</span></span></span>

<span style="color:black; font-family:宋体; font-size:9pt">
<span style="color:red">**6 参考文献
**<span style="color:black">[1] ITU-T G.8261.Timing and synchronization aspects in packet networks[S]. 2006.
[2] ITU-T G.8262.Timing characteristics of synchronous Ethernet equipment slave clock (EEC) [S]. 2007.
[3] ITU-T G.8264.Distribution of timing through packet networks[S]. 2008.
[4] IEEE 1588.IEEE standard for a precision clock synchronization protocol for networked measurement and control systems[S]. 2008.
[5] MEF 22\. Mobile backhaul implementation agreement phase1[S]. 2009.
</span></span></span>

<span style="color:black; font-family:宋体; font-size:9pt">收稿日期：2010-03-08
</span>

<span style="color:black; font-family:宋体; font-size:9pt">
李勤，北京邮电大学硕士毕业，现任中兴通讯承载网规划系统部PTN方案经理，主任工程师，主要研究方向为3G/LTE的PTN承载方案。
</span>
