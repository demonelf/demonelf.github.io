---
title: 'ARM内核全解析，从ARM7,ARM9到Cortex-A7,A8,A9,A12,A15到Cortex-A53,A57'
id: 813
comment: false
categories:
  - arm
date: 2016-07-13 10:34:04
tags:
---

<span style="color:black; font-size:9pt"><span style="font-family:宋体">前不久</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">正式宣布推出新款</span><span style="font-family:Verdana">ARMv8</span><span style="font-family:宋体">架构的</span><span style="font-family:Verdana">Cortex-A50</span><span style="font-family:宋体">处理器系列产品，以此来扩大</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">在高性能与低功耗领域的领先地位，进一步抢占移动终端市场份额。</span><span style="font-family:Verdana">Cortex-A50</span><span style="font-family:宋体">是继</span><span style="font-family:Verdana">Cortex-A15</span><span style="font-family:宋体">之后的又一重量级产品，将会直接影响到主流</span><span style="font-family:Verdana">PC</span><span style="font-family:宋体">市场的占有率。围绕该话题，我们今天不妨总结一下近几年来手机端较为主流的</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">处理器。</span><span style="font-family:Verdana">
			</span></span>

<!-- more -->
![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM71.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">
			</span><span style="font-family:宋体">以由高到低的方式来看，</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">处理器大体上可以排序为：</span><span style="color:#337fe5">**<span style="font-family:Verdana">Cortex-A57</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">Cortex-A53</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">Cortex-A15</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">Cortex-A12</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">Cortex-A9</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">Cortex-A8</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">Cortex-A7</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">Cortex-A5</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">ARM11</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">ARM9</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">ARM7</span>**<span style="font-family:宋体">**处理器**<span style="color:black">，再往低的部分手机产品中基本已经不再使用，这里就不再介绍。</span></span><span style="font-family:Verdana">
				</span></span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM72.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">ARM </span><span style="font-family:宋体">处理器架构发展</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● Cortex-A57</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">A53</span><span style="font-family:宋体">处理器</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> Cortex-A53</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">Cortex-A57</span><span style="font-family:宋体">两款处理器属于</span><span style="font-family:Verdana">Cortex-A50</span><span style="font-family:宋体">系列，首次采用</span><span style="font-family:Verdana">64</span><span style="font-family:宋体">位</span><span style="font-family:Verdana">ARMv8</span><span style="font-family:宋体">架构，意义重大，这也是</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">最近刚刚发布的两款产品。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM73.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体; background-color:white">　　</span><span style="font-family:Verdana; background-color:white"> Cortex-A57</span><span style="font-family:宋体; background-color:white">是</span><span style="font-family:Verdana; background-color:white">ARM</span><span style="font-family:宋体; background-color:white">最先进、性能最高的应用处理器，号称可在同样的功耗水平下达到当今顶级智能手机性能的三倍；而</span><span style="font-family:Verdana; background-color:white">Cortex-A53</span><span style="font-family:宋体; background-color:white">是世界上能效最高、面积最小的</span><span style="font-family:Verdana; background-color:white">64</span><span style="font-family:宋体; background-color:white">位处理器，同等性能下能效是当今高端智能手机的三倍。这两款处理器还可整合为</span><span style="font-family:Verdana; background-color:white">ARM big.LITTLE</span><span style="font-family:宋体; background-color:white">（大小核心伴侣）处理器架构，根据运算需求在两者间进行切换，以结合高性能与高功耗效率的特点，两个处理器是独立运作的。</span></span><span style="font-family:宋体; font-size:12pt">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM74.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM75.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> </span><span style="font-family:宋体">应用案例：预计于</span><span style="font-family:Verdana">2014</span><span style="font-family:宋体">年推出。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● Cortex-A15</span><span style="font-family:宋体">处理器架构解析</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM Cortex-A15</span><span style="font-family:宋体">处理器隶属于</span><span style="font-family:Verdana">Cortex-A</span><span style="font-family:宋体">系列，基于</span><span style="font-family:Verdana">ARMv7-A</span><span style="font-family:宋体">架构，是业界迄今为止性能最高且可授予许可的处理器。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM76.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> Cortex-A15 MPCore</span><span style="font-family:宋体">处理器具有无序超标量管道，带有紧密耦合的低延迟</span><span style="font-family:Verdana">2</span><span style="font-family:宋体">级高速缓存，该高速缓存的大小最高可达</span><span style="font-family:Verdana">4MB</span><span style="font-family:宋体">。浮点和</span><span style="font-family:Verdana">NEON</span><span style="font-family:宋体">媒体性能方面的其他改进使设备能够为消费者提供下一代用户体验，并为</span><span style="font-family:Verdana"> Web </span><span style="font-family:宋体">基础结构应用提供高性能计算。</span><span style="font-family:Verdana">Cortex-A15</span><span style="font-family:宋体">处理器可以应用在智能手机、平板电脑、移动计算、高端数字家电、服务器和无线基础结构等设备上。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM77.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体; background-color:white">　　</span><span style="font-family:Verdana; background-color:white">
			</span><span style="font-family:宋体; background-color:white">理论上，</span><span style="font-family:Verdana; background-color:white">Cortex-A15 MPCore</span><span style="font-family:宋体; background-color:white">处理器的移动配置所能提供的性能是当前的高级智能手机性能的五倍还多。在高级基础结构应用中，</span><span style="font-family:Verdana; background-color:white">Cortex-A15 </span><span style="font-family:宋体; background-color:white">的运行速度最高可达</span><span style="font-family:Verdana; background-color:white">2.5GHz</span><span style="font-family:宋体; background-color:white">，这将支持在不断降低功耗、散热和成本预算方面实现高度可伸缩的解决方案。</span></span><span style="font-family:宋体; font-size:12pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">
			</span><span style="font-family:宋体">应用案例：三星</span><span style="font-family:Verdana">Exynos 5250</span><span style="font-family:宋体">。三星</span><span style="font-family:Verdana">Exynos 5250</span><span style="font-family:宋体">芯片是首款</span><span style="font-family:Verdana">A15</span><span style="font-family:宋体">芯片，应用在了最近发布的</span><span style="font-family:Verdana">Chromebook</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">Nexus 10</span><span style="font-family:宋体">平板电脑上面。</span><span style="font-family:Verdana">Exynos 5250</span><span style="font-family:宋体">的频率是</span><span style="font-family:Verdana">1.7GHz</span><span style="font-family:宋体">，采用</span><span style="font-family:Verdana">32</span><span style="font-family:宋体">纳米的</span><span style="font-family:Verdana">HKMG</span><span style="font-family:宋体">工艺，配备了</span><span style="font-family:Verdana">Mali-604 GPU</span><span style="font-family:宋体">，性能强大。另外据传三星下一代</span><span style="font-family:Verdana">Galaxy S4</span><span style="font-family:宋体">将会搭载四核版的</span><span style="font-family:Verdana">Exynos 5450</span><span style="font-family:宋体">芯片组，同样应用</span><span style="font-family:Verdana">Cortex-A15</span><span style="font-family:宋体">内核。另外</span><span style="font-family:Verdana">NVIDIA Tegra 4</span><span style="font-family:宋体">会采用</span><span style="font-family:Verdana">A15</span><span style="font-family:宋体">内核。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● Cortex-A12</span><span style="font-family:宋体">处理器架构解析</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">2013</span><span style="font-family:宋体">中旬，</span><span style="font-family:Verdana">ARM </span><span style="font-family:宋体">发布了全新的</span><span style="font-family:Verdana">Cortex-A12</span><span style="font-family:宋体">处理器，在相同功耗下，</span><span style="font-family:Verdana">Cortex-A12</span><span style="font-family:宋体">的性能上比</span><span style="font-family:Verdana">Cortex-A9</span><span style="font-family:宋体">提升了</span><span style="font-family:Verdana">40%</span><span style="font-family:宋体">，同时尺寸上也同样减小了</span><span style="font-family:Verdana">30%</span><span style="font-family:宋体">。</span><span style="font-family:Verdana">Cortex-A12</span><span style="font-family:宋体">也同样能够支持</span><span style="font-family:Verdana">big.LITTLE</span><span style="font-family:宋体">技术，可以搭配</span><span style="font-family:Verdana">Cortex-A7</span><span style="font-family:宋体">处理器进一步提升处理器的效能。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM78.png)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">Cortex-A12</span><span style="font-family:宋体">架构图</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana; background-color:white">ARM</span><span style="font-family:宋体; background-color:white">表示</span><span style="font-family:Verdana; background-color:white">Cortex-A12</span><span style="font-family:宋体; background-color:white">处理器未来将应用于大量的智能手机以及平板产品，但更加侧重于中端产品。同时</span><span style="font-family:Verdana; background-color:white">ARM</span><span style="font-family:宋体; background-color:white">也预计在</span><span style="font-family:Verdana; background-color:white">2015</span><span style="font-family:宋体; background-color:white">年，这些中端产品在数量上将远超过旗舰级别的智能手机及与平板。</span></span><span style="font-family:宋体; font-size:12pt">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM79.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">
</span><span style="font-family:宋体; background-color:white">搭载</span><span style="font-family:Verdana; background-color:white">Cortex-A12</span><span style="font-family:宋体; background-color:white">处理器的中端机在未来也将是非常有特点的产品，因为</span><span style="font-family:Verdana; background-color:white">Cortex-A12</span><span style="font-family:宋体; background-color:white">能够支持虚拟化、</span><span style="font-family:Verdana; background-color:white">AMD TrustZone</span><span style="font-family:宋体; background-color:white">技术，以及最大</span><span style="font-family:Verdana; background-color:white">1TB</span><span style="font-family:宋体; background-color:white">的机身存储。这也就意味着未来搭载这一处理器的智能手机完全可以作为所谓的</span><span style="font-family:Verdana; background-color:white">BYOD</span><span style="font-family:宋体; background-color:white">（</span><span style="font-family:Verdana; background-color:white">Bring Your Own Device</span><span style="font-family:宋体; background-color:white">）设备使用，换句话说就是在作为自用手机的同时，还可以用作商务手机存储商务内容。</span></span><span style="font-family:宋体; font-size:12pt">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM710.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">Mali-V500</span><span style="font-family:宋体">架构图</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体; background-color:white">同时</span><span style="font-family:Verdana; background-color:white">Cortex-A12</span><span style="font-family:宋体; background-color:white">也搭载了全新的</span><span style="font-family:Verdana; background-color:white">Mali-T622</span><span style="font-family:宋体; background-color:white">绘图芯片与</span><span style="font-family:Verdana; background-color:white">Mali-V500</span><span style="font-family:宋体; background-color:white">视频编解码</span><span style="font-family:Verdana; background-color:white">IP</span><span style="font-family:宋体; background-color:white">解决方案，同样也是以节能为目标。这样看来，定位中端市场，低功耗小尺寸，</span><span style="font-family:Verdana; background-color:white">Cortex-A12</span><span style="font-family:宋体; background-color:white">最终必然会取代</span><span style="font-family:Verdana; background-color:white">Cortex-A9</span><span style="font-family:宋体; background-color:white">。据悉，</span><span style="font-family:Verdana; background-color:white">Cortex-A12</span><span style="font-family:宋体; background-color:white">将于</span><span style="font-family:Verdana; background-color:white">2014</span><span style="font-family:宋体; background-color:white">年投放市场，到时候我们也许会迎来中端市场的一次改变。</span></span><span style="font-family:宋体; font-size:12pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">应用案例：</span><span style="font-family:Verdana">2014</span><span style="font-family:宋体">年发布。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● Cortex-A9</span><span style="font-family:宋体">处理器架构解析</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM Cortex-A9</span><span style="font-family:宋体">处理器隶属于</span><span style="font-family:Verdana">Cortex-A</span><span style="font-family:宋体">系列，基于</span><span style="font-family:Verdana">ARMv7-A</span><span style="font-family:宋体">架构，目前我们能见到的四核处理器大多都是属于</span><span style="font-family:Verdana">Cortex-A9</span><span style="font-family:宋体">系列。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM711.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> Cortex-A9 </span><span style="font-family:宋体">处理器的设计旨在打造最先进的、高效率的、长度动态可变的、多指令执行超标量体系结构，提供采用乱序猜测方式执行的</span><span style="font-family:Verdana"> 8 </span><span style="font-family:宋体">阶段管道处理器，凭借范围广泛的消费类、网络、企业和移动应用中的前沿产品所需的功能，它可以提供史无前例的高性能和高能效。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM712.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> Cortex-A9 </span><span style="font-family:宋体">微体系结构既可用于可伸缩的多核处理器（</span><span style="font-family:Verdana">Cortex-A9 MPCore</span><span style="font-family:宋体">多核处理器），也可用于更传统的处理器（</span><span style="font-family:Verdana">Cortex-A9</span><span style="font-family:宋体">单核处理器）。可伸缩的多核处理器和单核处理器支持</span><span style="font-family:Verdana"> 16</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">32 </span><span style="font-family:宋体">或</span><span style="font-family:Verdana"> 64KB 4 </span><span style="font-family:宋体">路关联的</span><span style="font-family:Verdana"> L1 </span><span style="font-family:宋体">高速缓存配置，对于可选的</span><span style="font-family:Verdana"> L2 </span><span style="font-family:宋体">高速缓存控制器，最多支持</span><span style="font-family:Verdana"> 8MB </span><span style="font-family:宋体">的</span><span style="font-family:Verdana"> L2 </span><span style="font-family:宋体">高速缓存配置，它们具有极高的灵活性，均适用于特定应用领域和市场。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM713.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> </span><span style="font-family:宋体">应用案例：德州仪器</span><span style="font-family:Verdana">OMAP 4430/4460</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">Tegra 2</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">Tegra 3</span><span style="font-family:宋体">、新岸线</span><span style="font-family:Verdana">NS115</span><span style="font-family:宋体">、瑞芯微</span><span style="font-family:Verdana">RK3066</span><span style="font-family:宋体">、联发科</span><span style="font-family:Verdana">MT6577</span><span style="font-family:宋体">、三星</span><span style="font-family:Verdana"> Exynos 4210</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">4412</span><span style="font-family:宋体">、华为</span><span style="font-family:Verdana">K3V2</span><span style="font-family:宋体">等。另外高通</span><span style="font-family:Verdana">APQ8064</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">MSM8960</span><span style="font-family:宋体">、苹果</span><span style="font-family:Verdana">A6</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">A6X</span><span style="font-family:宋体">等都可以看做是在</span><span style="font-family:Verdana">A9</span><span style="font-family:宋体">架构基础上的改良版本。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● Cortex-A8</span><span style="font-family:宋体">处理器架构解析</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM Cortex-A8</span><span style="font-family:宋体">处理器隶属于</span><span style="font-family:Verdana">Cortex-A</span><span style="font-family:宋体">系列，基于</span><span style="font-family:Verdana">ARMv7-A</span><span style="font-family:宋体">架构，是我们目前使用的单核手机中最为常见的产品。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM714.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM Cortex-A8</span><span style="font-family:宋体">处理器是首款基于</span><span style="font-family:Verdana">ARMv7</span><span style="font-family:宋体">体系结构的产品，能够将速度从</span><span style="font-family:Verdana">600MHz</span><span style="font-family:宋体">提高到</span><span style="font-family:Verdana">1GHz</span><span style="font-family:宋体">以上。</span><span style="font-family:Verdana">Cortex-A8</span><span style="font-family:宋体">处理器可以满足需要在</span><span style="font-family:Verdana">300mW</span><span style="font-family:宋体">以下运行的移动设备的功率优化要求；以及需要</span><span style="font-family:Verdana">2000 Dhrystone MIPS</span><span style="font-family:宋体">的消费类应用领域的性能优化要求。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM715.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> Cortex-A8 </span><span style="font-family:宋体">高性能处理器目前已经非常成熟，从高端特色手机到上网本、</span><span style="font-family:Verdana">DTV</span><span style="font-family:宋体">、打印机和汽车信息娱乐，</span><span style="font-family:Verdana">Cortex-A8</span><span style="font-family:宋体">处理器都提供了可靠的高性能解决方案。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> </span><span style="font-family:宋体">应用案例：[</span><span style="color:#0f758e"><span style="font-family:Verdana; text-decoration:underline">MYS-S5PV210</span><span style="font-family:宋体"><span style="text-decoration:underline">开发板</span><span style="color:black">、</span></span><span style="font-family:Verdana">TI OMAP3</span><span style="color:black"><span style="font-family:宋体">系列、苹果</span><span style="font-family:Verdana">A4</span><span style="font-family:宋体">处理器（</span><span style="font-family:Verdana">iPhone 4</span><span style="font-family:宋体">）、三星</span><span style="font-family:Verdana">S5PC110</span><span style="font-family:宋体">（三星</span><span style="font-family:Verdana">I9000</span><span style="font-family:宋体">）、瑞芯微</span><span style="font-family:Verdana">RK2918</span><span style="font-family:宋体">、联发科</span><span style="font-family:Verdana">MT6575</span><span style="font-family:宋体">等。另外，高通的</span><span style="font-family:Verdana">MSM8255</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">MSM7230</span><span style="font-family:宋体">等也可看做是</span><span style="font-family:Verdana">A8</span><span style="font-family:宋体">的衍生版本。</span><span style="font-family:Verdana">
					</span></span></span></span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● Cortex-A7</span><span style="font-family:宋体">处理器架构解析</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM Cortex-A7</span><span style="font-family:宋体">处理器隶属于</span><span style="font-family:Verdana">Cortex-A</span><span style="font-family:宋体">系列，基于</span><span style="font-family:Verdana">ARMv7-A</span><span style="font-family:宋体">架构，它的特点是在保证性能的基础上提供了出色的低功耗表现。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM716.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> Cortex-A7</span><span style="font-family:宋体">处理器的体系结构和功能集与</span><span style="font-family:Verdana">Cortex-A15 </span><span style="font-family:宋体">处理器完全相同，不同这处在于，</span><span style="font-family:Verdana">Cortex-A7 </span><span style="font-family:宋体">处理器的微体系结构侧重于提供最佳能效，因此这两种处理器可在</span><span style="font-family:Verdana">big.LITTLE</span><span style="font-family:宋体">（大小核大小核心伴侣结构）配置中协同工作，从而提供高性能与超低功耗的终极组合。单个</span><span style="font-family:Verdana">Cortex-A7</span><span style="font-family:宋体">处理器的能源效率是</span><span style="font-family:Verdana">ARM Cortex-A8</span><span style="font-family:宋体">处理器的</span><span style="font-family:Verdana">5</span><span style="font-family:宋体">倍，性能提升</span><span style="font-family:Verdana">50%</span><span style="font-family:宋体">，而尺寸仅为后者的五分之一。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM717.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">
			</span><span style="font-family:宋体">作为独立处理器，</span><span style="font-family:Verdana">Cortex-A7</span><span style="font-family:宋体">可以使</span><span style="font-family:Verdana">2013-2014</span><span style="font-family:宋体">年期间低于</span><span style="font-family:Verdana">100</span><span style="font-family:宋体">美元价格点的入门级智能手机与</span><span style="font-family:Verdana">2010 </span><span style="font-family:宋体">年</span><span style="font-family:Verdana">500</span><span style="font-family:宋体">美元的高端智能手机相媲美。这些入门级智能手机在发展中世界将重新定义连接和</span><span style="font-family:Verdana">Internet</span><span style="font-family:宋体">使用。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM718.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> </span><span style="font-family:宋体">应用案例：全志</span><span style="font-family:Verdana">Cortex-A7</span><span style="font-family:宋体">四核平板芯片，联发科刚刚发布的</span><span style="font-family:Verdana">MT6589</span><span style="font-family:宋体">。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● Cortex-A5</span><span style="font-family:宋体">处理器架构解析</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体; background-color:white">　　</span><span style="font-family:Verdana; background-color:white"> ARM Cortex-A5</span><span style="font-family:宋体; background-color:white">处理器隶属于</span><span style="font-family:Verdana; background-color:white">Cortex-A</span><span style="font-family:宋体; background-color:white">系列，基于</span><span style="font-family:Verdana; background-color:white">ARMv7-A</span><span style="font-family:宋体; background-color:white">架构，它是能效最高、成本最低的处理器。</span></span><span style="font-family:宋体; font-size:12pt">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM719.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> Cortex-A5</span><span style="font-family:宋体">处理器可为现有</span><span style="font-family:Verdana">ARM9</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">ARM11</span><span style="font-family:宋体">处理器设计提供很有价值的迁移途径，它可以获得比</span><span style="font-family:Verdana">ARM1176JZ-S</span><span style="font-family:宋体">更好的性能，比</span><span style="font-family:Verdana">ARM926EJ-S</span><span style="font-family:宋体">更好的功效和能效。另外，</span><span style="font-family:Verdana">Cortex-A5</span><span style="font-family:宋体">处理器不仅在指令以及功能方面与更高性能的</span><span style="font-family:Verdana">Cortex-A8</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">Cortex-A9</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">Cortex-A15</span><span style="font-family:宋体">处理器完全兼容，同时还保持与经典</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">处理器（包括</span><span style="font-family:Verdana">ARM926EJ-S</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">ARM1176JZ-S</span><span style="font-family:宋体">和</span><span style="font-family:Verdana"> ARM7TDMI</span><span style="font-family:宋体">）的向后应用程序兼容性。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM720.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> </span><span style="font-family:宋体">应用案例：高通</span><span style="font-family:Verdana">MSM7227A/7627A</span><span style="font-family:宋体">（新渴望</span><span style="font-family:Verdana">V</span><span style="font-family:宋体">、摩托罗拉</span><span style="font-family:Verdana">XT615</span><span style="font-family:宋体">、诺基亚</span><span style="font-family:Verdana">610</span><span style="font-family:宋体">、中兴</span><span style="font-family:Verdana">V889D</span><span style="font-family:宋体">、摩托罗拉</span><span style="font-family:Verdana">DEFY XT</span><span style="font-family:宋体">等）、高通</span><span style="font-family:Verdana">MSM8225/8625</span><span style="font-family:宋体">（小辣椒双核版、华为</span><span style="font-family:Verdana">U8825D</span><span style="font-family:宋体">、天语</span><span style="font-family:Verdana"> W806+</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">innos D9</span><span style="font-family:宋体">、酷派</span><span style="font-family:Verdana">7266</span><span style="font-family:宋体">等）、米尔</span><span style="font-family:Verdana"> <a href="http://www.myir-tech.com/product/myd-sama5d3x.htm" target="_blank"><span style="color:#0f758e; text-decoration:underline">MYD-SAMA5D3X</span>](http://www.myir-tech.com/product/mys-s5pv210.htm)</span><span style="font-family:宋体"><span style="text-decoration:underline">系列开发板</span>（</span><span style="font-family:Verdana">MYD-SAMA5D31</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">MYD-SAMA5D33</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">MYD-SAMA5D34</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">MYD-SAMA5D35</span><span style="font-family:宋体">）。</span><span style="font-family:Verdana">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM721.jpg)](http://www.myir-tech.com/product/myd-sama5d3x.htm)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

[<span style="color:#0f758e; font-size:9pt; text-decoration:underline"><span style="font-family:Verdana">MYD-SAMA5D3X</span><span style="font-family:宋体">开发板</span></span>](http://www.myir-tech.com/product/myd-sama5d3x.htm)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● ARM11</span><span style="font-family:宋体">系列处理器架构解析</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM11</span><span style="font-family:宋体">系列包括了</span><span style="font-family:Verdana">ARM11MPCore</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">ARM1176</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">ARM1156</span><span style="font-family:宋体">处理器、</span><span style="font-family:Verdana">ARM1136</span><span style="font-family:宋体">处理器，它们是基于</span><span style="font-family:Verdana">ARMv6</span><span style="font-family:宋体">架构，分别针对不同应用领域。</span><span style="font-family:Verdana">ARM1156</span><span style="font-family:宋体">处理器主要应用在高可靠性和实时嵌入式应用领域，与手机关联不大，此处略去介绍。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM722.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM11 MPCore</span><span style="font-family:宋体">使用多核处理器结构，可实现从</span><span style="font-family:Verdana">1</span><span style="font-family:宋体">个内核到</span><span style="font-family:Verdana">4</span><span style="font-family:宋体">个内核的多核可扩展性，从而使具有单个宏的简单系统设计可以集成高达单个内核的</span><span style="font-family:Verdana">4</span><span style="font-family:宋体">倍的性能。</span><span style="font-family:Verdana">Cortex-A5</span><span style="font-family:宋体">处理器是</span><span style="font-family:Verdana">ARM11MPCore</span><span style="font-family:宋体">的相关后续产品。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体; background-color:white">　　</span><span style="font-family:Verdana; background-color:white"> ARM1176</span><span style="font-family:宋体; background-color:white">处理器主要应用在智能手机、数字电视和电子阅读器中，在这些领域得到广泛部署，它可提供媒体和浏览器功能、安全计算环境，在低成本设计的情况下性能高达</span><span style="font-family:Verdana; background-color:white">1GHz</span><span style="font-family:宋体; background-color:white">。</span></span><span style="font-family:宋体; font-size:12pt">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM723.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM1136</span><span style="font-family:宋体">处理器包含带媒体扩展的</span><span style="font-family:Verdana">ARMv6 </span><span style="font-family:宋体">指令集、</span><span style="font-family:Verdana">Thumb</span><span style="font-family:宋体">代码压缩技术以及可选的浮点协处理器。</span><span style="font-family:Verdana">ARM1136</span><span style="font-family:宋体">是一个成熟的内核，作为一种应用处理器广泛部署在手机和消费类应用场合中。在采用</span><span style="font-family:Verdana"> 90G</span><span style="font-family:宋体">工艺时性能可达到</span><span style="font-family:Verdana">600MHz</span><span style="font-family:宋体">以上，在面积为</span><span style="font-family:Verdana">2</span><span style="font-family:宋体">平方毫米且采用</span><span style="font-family:Verdana">65</span><span style="font-family:宋体">纳米工艺时可达到</span><span style="font-family:Verdana">1GHz</span><span style="font-family:宋体">。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM724.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">
			</span><span style="font-family:宋体">应用案例：高通</span><span style="font-family:Verdana">MSM7225</span><span style="font-family:宋体">（</span><span style="font-family:Verdana">HTC G8</span><span style="font-family:宋体">）、</span><span style="font-family:Verdana">MSM7227</span><span style="font-family:宋体">（</span><span style="font-family:Verdana">HTC G6</span><span style="font-family:宋体">、三星</span><span style="font-family:Verdana">S5830</span><span style="font-family:宋体">、索尼爱立信</span><span style="font-family:Verdana">X8</span><span style="font-family:宋体">等）、</span><span style="font-family:Verdana">Tegra APX 2500</span><span style="font-family:宋体">、博通</span><span style="font-family:Verdana">BCM2727</span><span style="font-family:宋体">（诺基亚</span><span style="font-family:Verdana">N8</span><span style="font-family:宋体">）、博通</span><span style="font-family:Verdana">BCM2763</span><span style="font-family:宋体">（诺基亚</span><span style="font-family:Verdana">PureView 808</span><span style="font-family:宋体">）、</span><span style="font-family:Verdana"> Telechip 8902</span><span style="font-family:宋体">（平板电脑）。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● ARM9</span><span style="font-family:宋体">系列和</span><span style="font-family:Verdana">ARM7</span><span style="font-family:宋体">系列处理器架构解析</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM9</span><span style="font-family:宋体">系列处理器系列包括</span><span style="font-family:Verdana">ARM926EJ-S</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">ARM946E-S</span><span style="font-family:宋体">和</span><span style="font-family:Verdana"> ARM968E-S</span><span style="font-family:宋体">处理器。其中前两者主要针对嵌入式实时应用，我们这里就主要针对</span><span style="font-family:Verdana">ARM926EJ-S</span><span style="font-family:宋体">进行介绍。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM725.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM926EJ-S</span><span style="font-family:宋体">基于</span><span style="font-family:Verdana">ARMv5TE</span><span style="font-family:宋体">架构，作为入门级处理器，它支持各种操作系统，如</span><span style="font-family:Verdana">Linux</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">Windows CE</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">Symbian</span><span style="font-family:宋体">。</span><span style="font-family:Verdana">ARM926EJ-S </span><span style="font-family:宋体">处理器已授权于全球</span><span style="font-family:Verdana">100</span><span style="font-family:宋体">多家硅片供应商，并不断在众多产品和应用中得到成功部署，应用广泛。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> </span><span style="font-family:宋体">应用案例：</span><span style="font-family:Verdana">TI OMAP 1710</span><span style="font-family:宋体">。诺基亚</span><span style="font-family:Verdana">N73</span><span style="font-family:宋体">、诺基亚</span><span style="font-family:Verdana">E65</span><span style="font-family:宋体">、三星</span><span style="font-family:Verdana">SGH-i600</span><span style="font-family:宋体">等手机采用的都是该处理器，以及包括米尔科技的</span><span style="font-family:Verdana"> [<span style="color:#0f758e; text-decoration:underline">MYS-SAM9X5</span>](http://www.myir-tech.com/product/myd-sam9x5.htm) </span><span style="font-family:宋体">系列工控开发板。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM726.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

[<span style="color:#0f758e; font-size:9pt; text-decoration:underline"><span style="font-family:Verdana">ARM9 </span><span style="font-family:宋体">开发板</span></span>](http://www.myir-tech.com/product/myd-sam9x5.htm)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● ARM7</span><span style="font-family:宋体">系列处理器</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana"> ARM7</span><span style="font-family:宋体">系列处理器系列包括</span><span style="font-family:Verdana">ARM7TDMI-S</span><span style="font-family:宋体">（</span><span style="font-family:Verdana">ARMv4T</span><span style="font-family:宋体">架构）和</span><span style="font-family:Verdana">ARM7EJ-S</span><span style="font-family:宋体">（</span><span style="font-family:Verdana">ARMv5TEJ</span><span style="font-family:宋体">架构），最早在</span><span style="font-family:Verdana">1994</span><span style="font-family:宋体">推出，相对上面产品来说已经显旧。虽然现在</span><span style="font-family:Verdana">ARM7</span><span style="font-family:宋体">处理器系列仍用于某些简单的</span><span style="font-family:Verdana">32</span><span style="font-family:宋体">位设备，但是更新的嵌入式设计正在越来越多地使用最新的</span><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">处理器，这些处理器在技术上比</span><span style="font-family:Verdana">ARM 7</span><span style="font-family:宋体">系列有了显著改进。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/07/071316_0234_ARMARM727.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">　　</span><span style="font-family:Verdana">
			</span><span style="font-family:宋体">作为目前较旧的一个系列，</span><span style="font-family:Verdana">ARM7</span><span style="font-family:宋体">处理器已经不建议继续在新品中使用。它究竟有多老呢？上面的</span><span style="font-family:Verdana">Apple eMate 300</span><span style="font-family:宋体">使用的就是一款</span><span style="font-family:Verdana">25MHz</span><span style="font-family:宋体">的</span><span style="font-family:Verdana">ARM7</span><span style="font-family:宋体">处理器，够古老了吧？</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt">**<span style="font-family:Verdana">● </span><span style="font-family:宋体">相关文章</span><span style="font-family:Verdana">
				</span>**</span>

[<span style="color:#0f758e; font-size:9pt; text-decoration:underline"><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">最新开发工具</span><span style="font-family:Verdana">DS-5</span><span style="font-family:宋体">到底是什么？有什么用？</span></span>](http://www.myir-tech.com/resource/449.asp)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

[<span style="color:#0f758e; font-size:9pt; text-decoration:underline"><span style="font-family:Verdana">ARM</span><span style="font-family:宋体">处理器体系架构详细说明</span></span>](http://www.myir-tech.com/resource/436.asp)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

[<span style="color:#0f758e; font-size:9pt; text-decoration:underline"><span style="font-family:Verdana">ARM </span><span style="font-family:宋体">开发工具</span><span style="font-family:Verdana"> DS-5 RVDS MDK-ARM </span><span style="font-family:宋体">比较区别和选择</span></span>](http://www.myir-tech.com/resource/493.asp)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">
</span><span style="font-family:宋体">本文来自[<span style="color:#0f758e; text-decoration:underline">米尔</span>](http://www.myir-tech.com/)科技，原文地址：</span><span style="font-family:Verdana"> [<span style="color:#0f758e; text-decoration:underline">http://www.myir-tech.com/resource/448.asp</span>](http://www.myir-tech.com/resource/448.asp)</span><span style="font-family:宋体">，转载请注明出处。</span><span style="font-family:Verdana">
			</span></span>
