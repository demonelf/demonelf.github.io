---
title: PIM协议报文种类及功能
id: 377
comment: false
categories:
  - arm
date: 2016-05-06 18:41:07
tags:
---

<span style="color:#444444; font-family:微软雅黑; font-size:10pt"><span style="background-color:white">PIM是 Protocol Independent Multicast（协议无关组播）的简称，表示可以利用静</span>
<span style="background-color:white">态路由或者任意单播路由协议（包括 RIP、OSPF、IS-IS、BGP等）所生成的单播</span>
<span style="background-color:white">路由表为 IP组播提供路由。</span>
<!-- more -->

<span style="background-color:white">目前常用PIM为版本号2为版本。</span>

<span style="background-color:white">PIM的类型字段分别为0-8代表9种PIM报文类型。</span>

<span style="color:black"><span style="background-color:white">类型：</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">0：Hello报文                               用于建立邻居，并选择DR。</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">1：Register报文     （单播）                  ：组播源发送组播数据时，DR与RP之间，进行注册，形成S，G表项。</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">2：Register Stop报文       （单播）       ：RP向DR发送注册停止报文。</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">3：Join/Prune报文                       加入报文：组播组成员发送Report报文后，DR与RP之间，*，G表项的形成</span><span style="color:#444444">
<span style="color:black"><span style="background-color:white">                                                      剪枝报文：PIM-DM模式下，当组播路由器下没有相应的接收者，则组播路由会发出剪枝报文，清除S，G   表项。</span><span style="color:#444444">
<span style="color:black"><span style="background-color:white">                                                                        PIM-SM模式下，当组播路由器下有组播组的成员要离开组播组时，会向外发送Leave报文，到达DR后，由DR向RP发送剪枝报文，以清除相应的组播路由表项。</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">4：Bootstrap报文                     ：由BSR发出，两个作用：第一：用于C-BSR之间选举BSR。第二：汇总C-RP发出的通告报文，选举RP。</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">5：Assert报文                           ：当一个组播组接收者直连的组播路由器（DR）与上游两台组播路由器相连，并且，两台组播路由器发出相同的组播数据时，两台组播路由器会向所有的PIM路由器发出断言报文，并且从这两台组播路由器中选举出一台组播数据的转发者。</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">6：Graft报文                              :嫁接报文，用于PIM-DM模式下，针对剪枝报文，当组播路由器下，有组播数据的接收者时，组播路由器会向上行路由器发送嫁接报文，以便重新的形成SG表项。</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">7：Graft Reply报文                  ：嫁接回应报文，用于PIM-DM模式下，当上游组播路由器收到嫁接报文时，会回应一个嫁接回应报文，来确认嫁接的过程，如果组播路由发送的嫁接报文没有得到回应，则会一直发送嫁接报文。</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">8：C-RP Advertisement报文  （单播） ：C-RP通告报文，所有的C-RP向BSR发送通告报文，其中包括优先级和IP地址信息，以单播的形式发送，由BSR选举出RP。</span><span style="color:#444444">

<span style="color:black"><span style="background-color:white">PIM中如果把加入和剪枝报文分开的话，正好有十种消息，其中Hello报文，加入，剪枝报文，断言报文是DM和SM都要使用的报文</span><span style="color:#444444">

<span style="color:black; background-color:white">三种类型为 1 2 8 的单播报文为PIM-SM协议专用。其它信息是按多播方式发送，目的地址为224.0.0.13</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
