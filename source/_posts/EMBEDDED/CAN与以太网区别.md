---
title: CAN与以太网区别
id: 901
comment: false
categories:
  - arm
date: 2016-09-06 09:24:19
tags:
---

<span style="font-family:幼圆; font-size:12pt">工业以太网与CAN总线的比较(2008-07-19 20:49:20)
</span>

<!-- more -->
<span style="font-family:幼圆; font-size:12pt">2008-07-23 10:45
</span>
<div><table style="border-collapse:collapse" border="0"><colgroup><col style="width:560px"/></colgroup><tbody valign="top"><tr><td vAlign="middle" style="padding-top: 1px; padding-left: 1px; padding-bottom: 1px; padding-right: 1px">

<span style="font-family:幼圆; font-size:12pt">1\. 工业以太网的优势及存在问题
</span>

<span style="font-family:幼圆; font-size:12pt">(1)优势
</span>

<span style="font-family:幼圆; font-size:12pt">基于TCP / IP的以太网是一种标准开放式的网络,由其组成的系统兼容性和互操作性好,资源共享能力强,可以很容易的实现将控制现场的数据与信息系统上的资源共享;数据的传输距离长、传输速率高;易与Internet连接,低成本、易组网,与计算机、服务器的接口十分方便,受到了广泛的技术支持。
</span>

<span style="font-family:幼圆; font-size:12pt">(2)存在问题
</span>

<span style="font-family:幼圆; font-size:12pt">以太网采用的是带有冲突检测的载波侦听多路访问协议(CSMA /CD) ,无法保证数据传输的实时性要求,是一种非确定性的网络系统; 安全可靠性问题,以太网采用超时重发机制,单点的故障容易扩散,造成整个网络系统的瘫痪;对工业环境的适应能力问题,目前工业以太网的鲁棒性和抗干扰能力等都是值得关注的问题,很难适应环境恶劣的工业现场;本质安全问题,在存在易燃、易爆、有毒等环境的工业现场必须要采用安全防爆技术;总线供电问题。在环境恶劣危险场合,总线供电具有十分重要的意义。
</span>

<span style="font-family:幼圆; font-size:12pt">2\. CAN现场总线的特点及局限性
</span>

<span style="font-family:幼圆; font-size:12pt">(1)特点
</span>

<span style="font-family:幼圆; font-size:12pt">CAN现场总线的数据通信具有突出的可靠性、实时性和灵活性。主要表现在CAN为多主方式工作; CAN总线的节点分成不同的优先级;采用非破坏仲裁技术;报文采用短帧结构,数据出错率极低;节点在错误严重的情况下可自动关闭输出。
</span>

<span style="font-family:幼圆; font-size:12pt">(2)局限性
</span>

<span style="font-family:幼圆; font-size:12pt">CAN现场总线作为一种面向工业底层控制的通信网络,其局限性也是显而易见的。首先,它不能与Internet互连,不能实现远程信息共享。其次,它不易与上位控制机直接接口,现有的CAN接口卡与以太网网卡相比大都价格昂贵。还有, CAN现场总线无论是其通信距离还是通信速率都无法和以太网相比。
</span>

<span style="font-family:幼圆; font-size:12pt">3\. 工业以太网和CAN现场总线的网络协议规范比较
</span>

<span style="font-family:幼圆; font-size:12pt">工业以太网和CAN现场总线的网络协议规范都遵循ISO /OSI参考模型的基本层次结构。工业以太网采用IEEE802参考模型,相当于OSI模型的最低两层,即物理层和数据链路层,其中数据链路层包含介质访问控制子层(MAC)和逻辑链路控制子层(LLC) 。CAN现场总线的ISO /OSI参考模型也是分为两层,并与工业以太网的分层结构完全相同,但是二者在各层的物理实现及通信机理上却有很大的差别。
</span>

<span style="font-family:幼圆; font-size:12pt">工业以太网和CAN现场总线的各层在具体网络协议实现上的分析比较如下表所示。
<table style="border-collapse:collapse" border="0"><colgroup><col style="width:111px"/><col style="width:144px"/><col style="width:147px"/><col style="width:130px"/></colgroup><tbody valign="top"><tr><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  outset 0.75pt; border-left:  outset 0.75pt; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt"> </td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  outset 0.75pt; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt"><p><span style="font-family:幼圆; font-size:12pt">工业以太网</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  outset 0.75pt; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">CAN现场总线</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  outset 0.75pt; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt"> </td></tr><tr><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  outset 0.75pt; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">物
理
层</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">传输介质</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">TP5类线、屏蔽双绞线、同轴电缆、光纤、无线传输等</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">屏蔽双绞线、同轴电缆、光纤、无线传输等</span>
</td></tr><tr><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  outset 0.75pt; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">编码</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">同步 NRZ、曼彻斯特编码</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">异步 NRZ</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt"> </td></tr><tr><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  outset 0.75pt; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">插件</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">RJ45、AUI、BNC</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">各种防护等级的工业级插件</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt"> </td></tr><tr><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  outset 0.75pt; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">总线供电和本质安全</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">无</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">有</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt"> </td></tr><tr><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  outset 0.75pt; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">传输速率</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">10M、100M等</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">5 kbps～1Mbps</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt"> </td></tr><tr><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  outset 0.75pt; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">数
据
链
路
层</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">介质访问控制子层</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">介质访问方式采用 CSMA/CD （载波监听多路访问/冲突检测），工业以太网很难满足工业网络通信的实时性和确定性的要求,在网络负载很重的情况下可能出现网络瘫痪的情况。</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">负责报文分帧、仲裁、应答、错误检测和标定。采用非破坏总线仲裁技术及短帧传送数据,能够满足工业控制的实时性和确定性的要求,而且在网络负载很重的情况下也不会出现网络瘫痪的情况。</span>
</td></tr><tr><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  outset 0.75pt; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">逻辑链路控制子层</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">组帧、处理传输差错、调整帧流速。</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt">

<span style="font-family:幼圆; font-size:12pt">报文滤波、过载通知及恢复管理。</span>
</td><td vAlign="middle" style="padding-left: 7px; padding-right: 7px; border-top:  none; border-left:  none; border-bottom:  outset 0.75pt; border-right:  outset 0.75pt"> </td></tr></tbody></table></span></p></td></tr></tbody></table></div>
