---
title: Keil、uVision、RealView、MDK、Keil C51之间的区别比较
id: 485
comment: false
categories:
  - arm
date: 2016-05-17 07:57:17
tags:
---

![](http://www.madhex.com/wp-content/uploads/2016/05/051616_2357_KeiluVision1.png)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>
<!-- more -->

<span style="color:black; font-size:9pt"><span style="font-family:宋体">我们要区别的概念：</span><span style="font-family:Verdana">**KEIL uVision**</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">**KEIL MDK**</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">**KEIL For ARM**</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">**RealView MDK**</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">**KEIL C51**</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">**KEIL C166**</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">**KEIL C251**
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">从接触</span><span style="font-family:Verdana">MCS-51</span><span style="font-family:宋体">单片机开始，我们就知道有一个叫</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">的软件。在开发单片机时，使用的是</span><span style="font-family:Verdana">C</span><span style="font-family:宋体">语言或者汇编语言，我们知道，这两种语言都不能直接烧写到单片机里面，执不执行暂且不说，光是代码的体积，就足以撑破整个单片机。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">所以，我们需要一个软件，把</span><span style="font-family:Verdana">C</span><span style="font-family:宋体">语言或者汇编语言编译生成单片机可执行的二进制代码，而且它的体积也非常的小，足够存放在单片机的存储器里面。</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">公司（现在是</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">公司的一个公司）的软件恰好可以提供这样的功能，并且它还有很多优点，比如工程易于管理，自动加载启动代码，集编辑、编译、仿真一体，调试功能强大等等。因此，不管是初学单片机的爱好者，还是经验丰富的工程师，都非常喜欢使用这些软件。</span><span style="font-family:Verdana"> 
</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">但是，即使熟练使用了</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">软件，有些概念我们还是不容易理清，常常混淆。</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">uVision</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">RealView</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">MDK</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">KEIL C51</span><span style="font-family:宋体">，它们到底有什么区别，又有什么联系？下面我们就做一个详细的分析。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/051616_2357_KeiluVision2.png)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:#4c33e5"><span style="font-family:Verdana; font-size:12pt">**KEIL**</span><span style="color:black; font-size:9pt"><span style="font-family:宋体">是**公司的名称**，有时候也指</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">公司的所有软件开发工具，目前</span><span style="font-family:Verdana">2005</span><span style="font-family:宋体">年</span><span style="font-family:Verdana">Keil</span><span style="font-family:宋体">由</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">公司收购，成为</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">的公司之一。</span><span style="font-family:Verdana">
				</span></span></span>

<span style="color:#4c33e5"><span style="font-family:Verdana; font-size:12pt">**uVision**</span><span style="color:black; font-size:9pt"><span style="font-family:宋体">是</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">公司开发的一个**集成开发环境**（</span><span style="font-family:Verdana">IDE</span><span style="font-family:宋体">），和</span><span style="font-family:Verdana">Eclipse</span><span style="font-family:宋体">类似。它包括工程管理，源代码编辑，编译设</span><span style="font-family:Verdana">uVision</span><span style="font-family:宋体">置，下载调试和模拟仿真等功能，</span><span style="font-family:Verdana">uVision</span><span style="font-family:宋体">有</span><span style="font-family:Verdana">uVision2</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">uVision3</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">uVision4</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">uVision5</span><span style="font-family:宋体">四个版本，目前最新的版本是</span><span style="font-family:Verdana">uVision5</span><span style="font-family:宋体">。它提供一个环境，让开发者易于操作，并不提供能具体的编译和下载功能，需要软件开发者添加。</span><span style="font-family:Verdana">uVisionu</span><span style="font-family:宋体">通用于</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">的开发工具中，例如</span><span style="font-family:Verdana">MDK</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">PK51</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">PK166</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">DK251</span><span style="font-family:宋体">等。</span><span style="font-family:Verdana">
				</span></span></span>

<span style="color:#4c33e5"><span style="font-family:Verdana; font-size:12pt">**RealView**</span><span style="color:black; font-size:9pt"><span style="font-family:宋体">是**一系列开发工具集合的称呼**，简称</span><span style="font-family:Verdana">RV</span><span style="font-family:宋体">，包括有</span><span style="font-family:Verdana">RVD</span><span style="font-family:宋体">（</span><span style="font-family:Verdana">RealView Debugger</span><span style="font-family:宋体">），</span><span style="font-family:Verdana">RVI</span><span style="font-family:宋体">（</span><span style="font-family:Verdana">RealView ICE</span><span style="font-family:宋体">），</span><span style="font-family:Verdana">RVT</span><span style="font-family:宋体">（</span><span style="font-family:Verdana">RealView Trace</span><span style="font-family:宋体">），</span><span style="font-family:Verdana">RVDS</span><span style="font-family:宋体">（</span><span style="font-family:Verdana">RealView Development Suite</span><span style="font-family:宋体">），</span><span style="font-family:Verdana">RV MDK</span><span style="font-family:宋体">（</span><span style="font-family:Verdana">RealView Microcontroller Development Kit</span><span style="font-family:宋体">）这些产品。这些都是为了让客户容易记住，采取的一个宣传策略。</span><span style="font-family:Verdana">
				</span></span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/051616_2357_KeiluVision3.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">举个例子说，[<span style="color:#0f758e; text-decoration:underline">米尔科技</span>](http://www.myir-tech.com/)是一家主营优质</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">工控板的企业，其产品系列由工控板（开发板）、单板机和核心板组成，虽然本来可以都叫工控板，但是为了让客户清晰了解产品的功能，进行选型，所以就分为</span><span style="font-family:Verdana">3</span><span style="font-family:宋体">个系列。不过</span><span style="font-family:Verdana">2009</span><span style="font-family:宋体">年</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">又宣布停止使用</span><span style="font-family:Verdana">Realview</span><span style="font-family:宋体">品牌，所以目前</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">就剩下了</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">两个品牌了。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:#4c33e5"><span style="font-family:Verdana; font-size:12pt">**MDK**</span><span style="color:black; font-size:9pt"><span style="font-family:宋体">（</span><span style="font-family:Verdana">Microcontroller Development Kit</span><span style="font-family:宋体">），也称</span><span style="font-family:Verdana">**MDK-ARM**</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">**KEIL MDK**</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">**RealView MDK**</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">**KEIL For ARM**</span><span style="font-family:宋体">，都是同一个东西。</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">公司现在统一使用</span><span style="font-family:Verdana">MDK-ARM</span><span style="font-family:宋体">的称呼，</span><span style="font-family:Verdana">MDK</span><span style="font-family:宋体">的设备数据库中有很多厂商的芯片，是专为微控制器开发的工具，为满足基于</span><span style="font-family:Verdana">MCU</span><span style="font-family:宋体">进行嵌入式软件开发的工程师需求而设计，支持</span><span style="font-family:Verdana">ARM7</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">ARM9</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">Cortex-M4/M3/M1</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">Cortex-R0/R3/R4</span><span style="font-family:宋体">等</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">微控制器内核。</span><span style="font-family:Verdana">
				</span></span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/051616_2357_KeiluVision4.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:#4c33e5"><span style="font-family:Verdana; font-size:12pt">**KEIL C51**</span><span style="color:black; font-size:9pt"><span style="font-family:宋体">，亦即</span><span style="font-family:Verdana">**PK51**</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">公司开发的基于</span><span style="font-family:Verdana">uVision IDE</span><span style="font-family:宋体">，支持绝大部分</span><span style="font-family:Verdana">8051</span><span style="font-family:宋体">内核的微控制器开发工具。</span><span style="font-family:Verdana">
				</span></span></span>

<span style="color:#4c33e5"><span style="font-family:Verdana; font-size:12pt">**KEIL C166**</span><span style="color:black; font-size:9pt"><span style="font-family:宋体">，亦即</span><span style="font-family:Verdana">**PK166**</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">公司开发的基于</span><span style="font-family:Verdana">uVision IDE</span><span style="font-family:宋体">，支持绝大部分</span><span style="font-family:Verdana">XC16x</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">C16x</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">ST10</span><span style="font-family:宋体">系列的微控制器开发工具。</span><span style="font-family:Verdana">
				</span></span></span>

<span style="color:#4c33e5"><span style="font-family:Verdana; font-size:12pt">**KEIL C251**</span><span style="color:black; font-size:9pt"><span style="font-family:宋体">，亦即</span><span style="font-family:Verdana">**DK251**</span><span style="font-family:宋体">，是</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">公司开发的基于</span><span style="font-family:Verdana">uVision IDE</span><span style="font-family:宋体">，支持绝大部分基于</span><span style="font-family:Verdana">251</span><span style="font-family:宋体">核的微控制器的开发工具。</span><span style="font-family:Verdana">
				</span></span></span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">总结来说，</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">公司目前有四款独立的嵌入式软件开发工具，即</span><span style="font-family:Verdana">MDK</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">KEIL C51</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">KEIL C166</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">KEIL C251</span><span style="font-family:宋体">，它们都是</span><span style="font-family:Verdana">KEIL</span><span style="font-family:宋体">公司品牌下的产品，都基于</span><span style="font-family:Verdana">uVision</span><span style="font-family:宋体">集成开发环境，其中</span><span style="font-family:Verdana">MDK</span><span style="font-family:宋体">是</span><span style="font-family:Verdana">RealView</span><span style="font-family:宋体">系列中的一员。</span><span style="font-family:Verdana"> 
</span></span>

*   <div style="background: white">[<span style="color:#0f758e; font-size:9pt; text-decoration:underline"><span style="font-family:Verdana">Keil MDK-ARM</span><span style="font-family:宋体">开发工具介绍</span></span>](http://www.myir-tech.com/product/mdk-arm.htm)<span style="color:black; font-family:Verdana; font-size:9pt">
				</span></div>
*   <div style="background: white">[<span style="color:#0f758e; font-size:9pt; text-decoration:underline"><span style="font-family:Verdana">Keil MDK-ARM uVision5</span><span style="font-family:宋体">最新下载</span></span>](http://www.myir-tech.com/download.asp?nid=25)<span style="color:black; font-family:Verdana; font-size:9pt"> <span style="color:#e53333">new!<span style="color:black">
						</span></span></span></div>
*   <div style="background: white">[<span style="color:#0f758e; font-size:9pt; text-decoration:underline"><span style="font-family:Verdana">Keil C51</span><span style="font-family:宋体">开发工具介绍</span></span>](http://www.myir-tech.com/product/c51.htm)<span style="color:black; font-family:Verdana; font-size:9pt">
				</span></div>
*   <div style="background: white">[<span style="color:#0f758e; font-size:9pt; text-decoration:underline"><span style="font-family:Verdana">Keil C51</span><span style="font-family:宋体">最新下载</span></span>](http://www.myir-tech.com/download.asp?nid=26)<span style="color:black; font-family:Verdana; font-size:9pt"> <span style="color:#e53333">new!<span style="color:black">
						</span></span></span></div>

    <span style="color:black; font-size:9pt"><span style="font-family:Verdana">
</span><span style="font-family:宋体">本文来自[<span style="color:#0f758e; text-decoration:underline">米尔</span>](http://www.myir-tech.com/)科技，原文地址：</span><span style="font-family:Verdana"> [<span style="color:#0f758e; text-decoration:underline">http://www.myir-tech.com/resource/512.asp</span>](http://www.myir-tech.com/resource/512.asp)</span><span style="font-family:宋体">，转载请注明出处。</span><span style="font-family:Verdana">
					</span></span>
