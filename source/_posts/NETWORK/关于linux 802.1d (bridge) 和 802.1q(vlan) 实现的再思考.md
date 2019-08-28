---
title: 关于linux 802.1d (bridge) 和 802.1q(vlan) 实现的再思考
categories:
  - NETWORK
date: 2017-12-07 09:53:03
tags:
---

​	linux bridge - (brctl)实现了ieee 802.1d协议，这个实现，应该是不能支持VLAN的功能。也就是说，这个实现，只能承载一个广播域，而不能承载多个广播域。当然，可以创建多个bridge device，每个bridge都对应不同的vlan，在bridge内部，包通过fdb表来转发，但是这个fdb表里面并没有vlan的信息。如果要在多个bridge device之间通信，比必须在bridge device上创建vlan interface，然后配置路由，这样可以实现不同bridge之间的转发。
​	linux vlan - (vconfig)实现了ieee 802.1q协议。802.1q本来应该是一个二层协议，但是linux的实现需要创建vlan interface,而且可以在vlan interface上配置ip地址。所以，这个interface可以放到路由表里面。一般来说，在这个interface上收到的包，会带这个interface配置的vlan id，而从这个interface发出去的包，会打上这个interface的vlan id.

​	举一个例子。一个盒子有6个物理interface, eth0,eth1,eth2,eth3,eth4,eth5,eth6.
​	bridge0 { eth0, eth1, eth2 }, vlan id 是2
​	bridge1 { eth3, eth4, eth5 }, vlan id 是3
​	eth0,eth1,eth2,eth3,eth4,eth5都在混杂模式，并且没有ip地址，它们是bridge的port.
​	创建vlan interface, bridge0.2, bridge1.3。在bridge0.2和bridge1.3上配置ip地址。vlan 2的机器，把bridge0.2的地址设置为缺省网关；vlan 3的机器，把bridge1.3设置为缺省网关。当有包要从vlan 2发往vlan 3是，它将送到bridge0.2，然后，通过路由，找到bridge1.3，然后由bridge1.3发出去。这个过程中，packet里面的vlan id会发生改变。
​	这个例子里面，要求从bridge port上收到的包都必须是打tag的，在bridge里面，并不能识别和处理tag，只有到三层的vlan interface才能识别并处理这些tag.
在bridge是还会运行STP协议来消除回环，进而实现了link一级的HA。STP，RSTP都是没有vlan的概念，而后来的PVST,PVST+，以及MSTP等，都能识别vlan，并且能消除一个vlan里面的回环。

关于Bridge，可以参考：http://www.linuxfoundation.org/en/Net:Bridge
关于Vlan,可以参考：http://www.candelatech.com/~greear/vlan.html
关于STP，可以参考：http://en.wikipedia.org/wiki/Spanning_tree_protocol

posted on 2011-03-23 18:04 flyonok