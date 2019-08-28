---
title: VRRP负载均衡技术
id: 299
comment: false
categories:
  - arm
date: 2016-05-03 11:05:16
tags:
---

<span style="color:black; font-size:14pt">**<span style="font-family:Arial">VRRP</span><span style="font-family:宋体">负载均衡技术</span><span style="font-family:Arial">
				</span>**</span>
<!-- more -->

<span style="color:#996633; font-size:11pt">**<span style="font-family:Verdana">VRRP</span><span style="font-family:宋体">负载均衡技术</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:11pt">**<span style="font-family:宋体">一、</span><span style="font-family:Verdana">
				</span><span style="font-family:宋体">前言</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">在</span><span style="font-family:Verdana">VRRP</span><span style="font-family:宋体">（虚拟路由器冗余协议）标准协议模式中，只有</span><span style="font-family:Verdana">Master</span><span style="font-family:宋体">路由器可以转发报文，</span><span style="font-family:Verdana">Backup</span><span style="font-family:宋体">路由器处于监听状态，无法转发报文。虽然创建多个备份组可以实现多个路由器之间的负载分担，但是局域网内的主机需要设置不同的网关，增加了配置的复杂性。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">VRRP</span><span style="font-family:宋体">负载均衡模式</span><span style="font-family:Verdana">(</span><span style="font-family:宋体">下面简称在</span><span style="font-family:Verdana">VRRPE)</span><span style="font-family:宋体">提供的虚拟网关冗余备份功能基础上，增加了负载均衡功能</span><span style="font-family:Verdana">.</span><span style="font-family:宋体">实现同一个备份组里的</span><span style="font-family:Verdana">Master</span><span style="font-family:宋体">和</span><span style="font-family:Verdana">Backup</span><span style="font-family:宋体">路由器都转发报文。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050316_0342_VRRP1.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">图</span><span style="font-family:Verdana"> 1 VRRPE</span><span style="font-family:宋体">实现的负载均衡功能</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:11pt">**<span style="font-family:宋体">二、</span><span style="font-family:Verdana"> VRRPE</span><span style="font-family:宋体">技术介绍</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:10pt">**<span style="font-family:Verdana">2.1 VRRPE</span><span style="font-family:宋体">的基本工作原理</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">在一个备份组里将一个虚拟</span><span style="font-family:Verdana">IP</span><span style="font-family:宋体">地址与多个虚拟</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">地址对应，</span><span style="font-family:Verdana">VRRP</span><span style="font-family:宋体">备份组中的每个路由器都对应一个虚拟</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">地址，使得每个路由器都能转发流量。避免了</span><span style="font-family:Verdana">VRRP</span><span style="font-family:宋体">备份组中</span><span style="font-family:Verdana">Backup</span><span style="font-family:宋体">设备始终处于空闲状态、网络资源利用率不高的问题。如下图中，在下面以</span><span style="font-family:Verdana">10.1.1.1</span><span style="font-family:宋体">为网关的</span><span style="font-family:Verdana">PC</span><span style="font-family:宋体">，其获得的网关的</span><span style="font-family:Verdana">arp</span><span style="font-family:宋体">表项都对应不同的虚</span><span style="font-family:Verdana">MAC.</span><span style="font-family:宋体">：</span><span style="font-family:Verdana">host A</span><span style="font-family:宋体">对应</span><span style="font-family:Verdana">route A</span><span style="font-family:宋体">的虚</span><span style="font-family:Verdana">mac</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">host B</span><span style="font-family:宋体">对应</span><span style="font-family:Verdana">route B</span><span style="font-family:宋体">的虚</span><span style="font-family:Verdana">mac</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">host C</span><span style="font-family:宋体">对应</span><span style="font-family:Verdana">route C</span><span style="font-family:宋体">的虚</span><span style="font-family:Verdana">mac</span><span style="font-family:宋体">。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050316_0342_VRRP2.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">图</span><span style="font-family:Verdana"> 2 VRRPE</span><span style="font-family:宋体">的工作原理</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:Verdana">2.2 VRRPE</span><span style="font-family:宋体">中的基本概念</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">l AVF</span><span style="font-family:宋体">：虚拟转发器</span><span style="font-family:Verdana">(Active Virtual Forwarder)</span><span style="font-family:宋体">，作为</span><span style="font-family:Verdana">AVF</span><span style="font-family:宋体">负责转发目的</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">地址为虚拟</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">地址的流量；</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">l LVF</span><span style="font-family:宋体">：备用虚拟转发器</span><span style="font-family:Verdana">(Listening Virtual Forwarder)</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">LVF</span><span style="font-family:宋体">监视</span><span style="font-family:Verdana">AVF</span><span style="font-family:宋体">的状态，当</span><span style="font-family:Verdana">AVF</span><span style="font-family:宋体">出现故障时，</span><span style="font-family:Verdana">LVF</span><span style="font-family:宋体">将选举出优先级最高的虚拟转发器作为</span><span style="font-family:Verdana">AVF</span><span style="font-family:宋体">；</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">l VMAC</span><span style="font-family:宋体">：虚</span><span style="font-family:Verdana">Mac</span><span style="font-family:宋体">地址</span><span style="font-family:Verdana">(Virtual MAC Address)</span><span style="font-family:宋体">；</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">l VF Owner</span><span style="font-family:宋体">：虚拟转发器的拥有者（</span><span style="font-family:Verdana">Virtual Forwarder Owner</span><span style="font-family:宋体">）。</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">如图中：</span><span style="font-family:Verdana">Router A</span><span style="font-family:宋体">是</span><span style="font-family:Verdana">000f-e2ff-0041</span><span style="font-family:宋体">的</span><span style="font-family:Verdana">AVF</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">Router B</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">Router C</span><span style="font-family:宋体">是</span><span style="font-family:Verdana">000f-e2ff-0041</span><span style="font-family:宋体">的</span><span style="font-family:Verdana">LVF</span><span style="font-family:宋体">；</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050316_0342_VRRP3.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">图</span><span style="font-family:Verdana"> 3 VRRPE</span><span style="font-family:宋体">基本概念相关</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:Verdana">2.3 VRRPE</span><span style="font-family:宋体">的实现机制</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">流程一：同一备份组中的路由器之间选举</span><span style="font-family:Verdana">Master</span><span style="font-family:宋体">（选举方式和</span><span style="font-family:Verdana">VRRP</span><span style="font-family:宋体">的标准模式相同）</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050316_0342_VRRP4.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">流程二：</span><span style="font-family:Verdana">Backup</span><span style="font-family:宋体">设备发送</span><span style="font-family:Verdana">Request</span><span style="font-family:宋体">报文向</span><span style="font-family:Verdana">Master</span><span style="font-family:宋体">设备请求虚拟</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">，</span><span style="font-family:Verdana">Master</span><span style="font-family:宋体">设备通过</span><span style="font-family:Verdana">Replay</span><span style="font-family:宋体">报文给</span><span style="font-family:Verdana">Backup</span><span style="font-family:宋体">设备分配虚拟</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">地址。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050316_0342_VRRP5.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">流程三：</span><span style="font-family:Verdana">Master</span><span style="font-family:宋体">根据负载均衡算法为来自主机的</span><span style="font-family:Verdana">ARP/ND</span><span style="font-family:宋体">请求，应答不同的虚拟</span><span style="font-family:Verdana">MAC</span><span style="font-family:宋体">地址，从而实现流量在多个路由器之间分担。备份组中的</span><span style="font-family:Verdana">Backup</span><span style="font-family:宋体">路由器不会应答主机的</span><span style="font-family:Verdana">
			</span></span>

<span style="color:black; font-size:9pt"><span style="font-family:Verdana">ARP/ND</span><span style="font-family:宋体">请求。</span><span style="font-family:Verdana">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/050316_0342_VRRP6.jpg)<span style="color:black; font-family:Verdana; font-size:9pt">
		</span>

<span style="color:black; font-size:11pt">**<span style="font-family:宋体">三、</span><span style="font-family:Verdana">
				</span><span style="font-family:宋体">小结</span><span style="font-family:Verdana">
				</span>**</span>

<span style="color:black; font-size:9pt"><span style="font-family:宋体">本文介绍了</span><span style="font-family:Verdana">VRRP</span><span style="font-family:宋体">负载均衡模式的特点，以及其的工作原理和实现机制，我司的</span><span style="font-family:Verdana">v5</span><span style="font-family:宋体">平台的三层交换机</span><span style="font-family:Verdana">S12500</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">S9500E</span><span style="font-family:宋体">、</span><span style="font-family:Verdana">S5800</span><span style="font-family:宋体">均支持该特性，因其能实现同一个</span><span style="font-family:Verdana">vrrp</span><span style="font-family:宋体">组的负载均衡，在数据中心的接入侧有着广泛的应用场景。</span><span style="font-family:Verdana">
			</span></span>
