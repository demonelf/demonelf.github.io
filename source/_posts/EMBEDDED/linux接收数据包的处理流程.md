---
title: linux接收数据包的处理流程
id: 954
comment: false
categories:
  - arm
date: 2016-10-13 10:06:37
tags:
---

1\. 硬件收到数据，驱动取出数据，通过netif_rx把数据放到queue-&gt;input_pkt_queue中，

     并产生NET_RX_SOFTIRQ软中断。
<!-- more -->

2\. 在启动内核时，通过open_softirq(NET_RX_SOFTIRQ, net_rx_action);

     注册了软中断回调函数net_rx_action。

3\. net_rx_action判断是否queue-&gt;input_pkt_queue是否有数据，如果有再通过process_backlog

    调用netif_receive_skb处理。

4\. netif_receive_skb通过ptype_base判断数据类型，再调用对应的fun(arp_rcv|ip_rcv)

5\. ip_rcv做IP头检查，再调用ip_route_input设置数据包的路由。

    调用dst_input

    如果是本地包则调用ip_local_deliver

    如果是转发包则调用ip_forward

6\. 在ip_local_deliver中，

    例如，如果是ping包，则调用icmp_rcv把数据放到sk-&gt;sk_receive_queue

7\. socket 通过中断到内核的

   sys_socketcall-&gt;Sys_read-&gt;Sock_read-&gt;sock_recvmsg-&gt;inet_recvmsg-&gt;

   udp_recvmsg-&gt;skb_recv_datagram从sk-&gt;sk_receive_queue把数据取出来。

再来个图让你更清晰：<span style="color:red">收包示例</span>

![](http://www.madhex.com/wp-content/uploads/2017/01/012417_0612_linux1.png)

    这里值得总结一下。

    当IP报文从软中断上来的时候，

则必须从ptype_base[]数组中找到对应函数，目前内核中与IP有关的只有3个，

一个是ip_packet_type，另一个是arp_packet_type，最后是rarp_packet_type。

    如果是ip报文，当执行到ip_local_deliver_finish时，

则应该从inet_protos[]数组中找到对应函数，里面包含ICMP、UDP、TCP等上层协议的处理函数。

这2个数组极易造成混淆，因为都有一个回调函数。在经历这么多函数的研究，读者可能都有点晕了。

一个比较好的记忆方法是：对于前一个，其回调函数是func，处理packet，后一个回调函数是handler，处理协议。

以上为收包流程，收包的时候，利用中断直接定位到s3c_dm9000_recv

但大家还需思考下发包的时候是如果定位到s3c_dm9000_send函数的呢？

![](http://www.madhex.com/wp-content/uploads/2017/01/012417_0612_linux2.jpg)

![](http://www.madhex.com/wp-content/uploads/2017/01/012417_0612_linux3.jpg)
