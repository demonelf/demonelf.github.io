---
title: PIM-SSM简介
id: 410
comment: false
categories:
  - arm
date: 2016-05-10 12:01:35
tags:
---

<span style="color:#252525; font-family:微软雅黑; font-size:12pt">源特定组播(SSM：Source Specific Multicast)是一种区别于传统组播的新的业务模型，它使用组播组地址和组播源地址同时来标识一个组播会话，而不是向传统的组播服务那样只使用组播组地址来标识一个组播会话。SSM保留了传统PIM-SM模式中的主机显示加入组播组的高效性，但是跳过了PIM-SM模式中的共享树和RP(Rendezvous Point，集合点)规程。在传统PIM-SM模式中，共享树和RP规程使用(*，G)组对来表示一个组播会话，其中(G)表示一个特定的IP组播组，而(*)表示发向组播组G的任何一个源。SSM直接建立由(S,G)标识的一个组播最短路径树(SPT：Shortest Path Tree)，其中(G)表示一个特定的IP组播组地址，而(S)表示发向组播组G的特定源的IP地址。SSM 的一个(S,G)对也被称为一个频道(Channel)，以区分传统PIM-SM组播中的任意源组播组(ASM：Any Source Multicast).
</span>
<!-- more -->

<span style="color:#252525; font-family:微软雅黑; font-size:12pt">　　因此,SSM特别适合于点到多点的组播服务，例如网络娱乐频道、网络新闻频道、网络体育频道等业务，但如果要求多点到多点组播服务则需要ASM模式。
</span>

<span style="color:#252525; font-family:微软雅黑; font-size:12pt">　　PIM-SSM是对传统PIM协议的扩展，使用SSM，用户能直接从组播源接收组播业务量，PIM－SSM利用PIM-SM的功能，在组播源和客户端之间，产生一个SPT树。但PIM-SSM在产生SPT树时，不需要汇聚点(RP)的帮助。 一个具有SSM功能的网络相对于传统的PIM-SM网路来说，具有非常突出的优越性。网络中不再需要汇聚点，也不再需要共享树或RP的映射，同时网络中也不再需要MSDP协议，以完成RP与RP之间的源发现。
</span>
