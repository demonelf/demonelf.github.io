---
title: PIM-DM协议在linux下的实现方式和工作流程
id: 375
comment: false
categories:
  - arm
date: 2016-05-06 17:45:44
tags:
---

<span style="color:black"><span style="font-size:13pt"><span style="font-family:Arial">PIM-DM</span><span style="font-family:宋体">协议只需要从内核接收</span><span style="font-family:Arial">cache-miss</span><span style="font-family:宋体">消息。</span></span><span style="font-family:Arial; font-size:10pt">
			</span></span>
<!-- more -->

<span style="color:black"><span style="font-size:13pt"><span style="font-family:宋体">二、</span><span style="font-family:Arial">SPT</span><span style="font-family:宋体">创建过程</span></span><span style="font-family:Arial; font-size:10pt">
			</span></span>

<span style="color:black"><span style="font-size:13pt"><span style="font-family:Arial">1\. linux</span><span style="font-family:宋体">内核协议栈收到组播源</span><span style="font-family:Arial">S</span><span style="font-family:宋体">的组播报文后检查</span><span style="font-family:Arial">MFC</span><span style="font-family:宋体">表项中是否存在该组播的转发表项，如果没有，内核将生成一条</span><span style="font-family:Arial">cache-miss</span><span style="font-family:宋体">消息上送给接收</span><span style="font-family:Arial">igmp</span><span style="font-family:宋体">管理报文的应用层程序（例如</span><span style="font-family:Arial">PIM-DM</span><span style="font-family:宋体">）。</span></span><span style="font-family:Arial; font-size:10pt">
			</span></span>

<span style="color:black"><span style="font-size:13pt"><span style="font-family:Arial">2.PIM-DM</span><span style="font-family:宋体">的</span><span style="font-family:Arial">igmp</span><span style="font-family:宋体">管理报文</span><span style="font-family:Arial">socket</span><span style="font-family:宋体">收到来自内核的</span><span style="font-family:Arial">cache-miss</span><span style="font-family:宋体">消息后，解包得到组播报文的内容，并通过一系列的计算，随后下发</span><span style="font-family:Arial">MFC</span><span style="font-family:宋体">创建命令到内核，创建组播</span><span style="font-family:Arial">S</span><span style="font-family:宋体">的</span><span style="font-family:Arial">(S,G)</span><span style="font-family:宋体">路由表项。</span></span><span style="font-family:Arial; font-size:10pt">
			</span></span>

<span style="color:black"><span style="font-size:13pt"><span style="font-family:Arial">3.</span><span style="font-family:宋体">生成的</span><span style="font-family:Arial">(S,G)</span><span style="font-family:宋体">转发表项出接口默认选择除入口以外的所有</span><span style="font-family:Arial">PIM-DM</span><span style="font-family:宋体">路由口，这样组播报文就会从入口外的所有其他路由接口转发出去。</span></span><span style="font-family:Arial; font-size:10pt">
			</span></span>

<span style="color:black"><span style="font-size:13pt"><span style="font-family:Arial">4.</span><span style="font-family:宋体">各个收到组播报文的</span><span style="font-family:Arial">PIM-DM</span><span style="font-family:宋体">级联路由也会创建相应</span><span style="font-family:Arial">(S,G)</span><span style="font-family:宋体">表项，将入口以外的</span><span style="font-family:Arial">PIM-DM</span><span style="font-family:宋体">路由接口加入到表项出口和</span><span style="font-family:Arial">pruned</span><span style="font-family:宋体">口，并创建对应的剪枝定时器。</span></span><span style="font-family:Arial; font-size:10pt">
			</span></span>

<span style="color:black"><span style="font-size:13pt"><span style="font-family:Arial">5.</span><span style="font-family:宋体">剪枝定时器到期前，组播报文会向所有</span><span style="font-family:Arial">PIM-DM</span><span style="font-family:宋体">路由和接口转发。剪枝定时器到期后，级联路由上的</span><span style="font-family:Arial">(S,G)</span><span style="font-family:宋体">表项中剪枝接口会从出口中删除，这样一来报文就无法转发了。</span></span><span style="font-family:Arial; font-size:10pt">
			</span></span>

<span style="color:black"><span style="font-size:13pt"><span style="font-family:Arial">6.PIM-DM</span><span style="font-family:宋体">路由在加入</span><span style="font-family:Arial">-</span><span style="font-family:宋体">剪枝保持定时器到期后会重新发起剪枝过程。以维护</span><span style="font-family:Arial">SPT</span><span style="font-family:宋体">树。</span></span><span style="font-family:Arial; font-size:10pt">
			</span></span>

<span style="color:black"><span style="font-size:13pt"><span style="font-family:Arial">7.</span><span style="font-family:宋体">级联路由在收到组播接收者的加入请求后会将接口者对应的路由口加入</span><span style="font-family:Arial">(S,G)</span><span style="font-family:宋体">转发表的出口和</span><span style="font-family:Arial">pruned</span><span style="font-family:宋体">口中，并同时向上联路由发送</span><span style="font-family:Arial">graft(</span><span style="font-family:宋体">嫁接报文</span><span style="font-family:Arial">)</span><span style="font-family:宋体">通告接收者信息，上联路由收到</span><span style="font-family:Arial">graft</span><span style="font-family:宋体">报文后会将报文接收端口加入到</span><span style="font-family:Arial">(S,G)</span><span style="font-family:宋体">转发表的出口和</span><span style="font-family:Arial">pruned</span><span style="font-family:宋体">口中，后面级联的路由同上。</span><span style="font-family:Arial">
				</span><span style="font-family:宋体">一直到源路由收到此嫁接报文，整条链路上的</span><span style="font-family:Arial">SPT</span><span style="font-family:宋体">树通过嫁接操作又完整了。</span></span><span style="font-family:Arial; font-size:10pt">
			</span></span>

<span style="color:black"><span style="font-size:13pt"><span style="font-family:宋体">综上：</span><span style="font-family:Arial">
				</span><span style="font-family:宋体">以上就是</span><span style="font-family:Arial">PIM-DM</span><span style="font-family:宋体">，密集模式的整个处理过程，总结一下就是：源路由向所有路由通告：我把这个组播都给你们先，你们不要的话和我说下哈。</span><span style="font-family:Arial">  </span><span style="font-family:宋体">然后需要的路由就保持沉默，不需要的路由就告知源路由：这个组播我不需要，不要给我发了。</span><span style="font-family:Arial">
				</span><span style="font-family:宋体">过了一段时间，源路由怕其他的路由器有信息更新，于是又问了一次</span></span><span style="font-family:Arial"><span style="font-size:13pt">... ... and so on.</span><span style="font-size:10pt">
				</span></span></span>
