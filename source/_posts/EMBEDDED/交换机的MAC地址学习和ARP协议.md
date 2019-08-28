---
title: 交换机的MAC地址学习和ARP协议
id: 784
comment: false
categories:
  - arm
date: 2016-07-08 14:11:12
tags:
---

<span style="font-family:幼圆; font-size:14pt">1\. 首先我们来看看交换机，swith（交换机）
</span>

<!-- more -->
<span style="font-family:幼圆; font-size:14pt">今天就先讲讲交换机和网桥的区别。这两个设备都工作在第2层
</span>

<span style="font-family:幼圆; font-size:14pt">主要区别是，交换机的转发速度较快，是硬件的转发，端口数比较多
</span>

<span style="font-family:幼圆; font-size:14pt">下面直接来看交换机的学习功能 , 也就是交换机的MAC地址学习. 下面我们设想一个模型，有A，B，C，D这四台PC接在一台交换机上, 首先交换机最初加电时它里面的MAC地址表为空，也就是还没学习，在学习的最初状态. 首先，比如A发给D一个数据, 这个时候交换机首先在连接A那台PC的端口上学习到A的MAC地址，并且把这个MAC地址记录到交换机里的MAC地址表里, 但是这个时候交换机并不知道D是在哪，因为MAC表里还没有D的MAC. 这个时候怎么办呢？交换机会复制多份这个数据(多帧复制)，向交换机的所有端口都转发这个数据（除A接的那个端口外），这个称为泛洪，flooding 。当B和C接到这个数据时，首先检查目的地址，发现不是发给我的，那么就丢弃这个帧 . 当D接到这个帧时，发现这是发给自己的，然后D便会发给A数据，这个时候交换机在D的接口又学习到了D的MAC地址 , 这个时候交换机学习到了两条MAC地址。
</span>

<span style="font-family:幼圆; font-size:14pt">2\. 下面继续讲ARP协议
</span>

<span style="font-family:幼圆; font-size:14pt">当数据包到网络层的时候，这个时候会继续向下层数据链路层封装，这个时候要找寻目的的MAC地址. 因为在第2层，也就是交换机工作的那层是不不知道什么叫IP地址呢，交换机始终是靠MAC地址找寻的 .
</span>

<span style="font-family:幼圆; font-size:14pt">列举：
</span>

<span style="font-family:幼圆; font-size:14pt">还是那个开始的那个模型，当A发数据给D。这个时候，在网络层只知道D的IP地址，那么怎么获取D的MAC地址，从而让交换机把数据发送到D的MAC地址呢？这个时候A便会发送arp，，注意一点，交换机本身是不会主动发送ARP的。那么在ARP这个报文里包含了啥东东呢？ARP报文里有源MAC地址，（也就是A的MAC地址），源IP地址，目的IP地址（也就是D的IP地址），目的MAC地址这个时候为全F，，因为这个arp是一个广播嘛。全F的MAC地址就是一个广播，因为这个时候A不知道D的mac地址，所以要发送一个广播，通知全部的PC，找寻D的MAC地址 ，怎么发送给全部同网段的PC呢？就是靠全F的mac地址。也叫flooding，我说了泛洪只是一个形象的比喻书法。当D接到这个ARP请求后，发现是找自己的，那么就返回一条ARP回应给A，告诉自己的MAC地址 ，全F的MAC地址就是广播。这个时候A的arp表便记录了D的ip地址和mac地址的对应关系。这样便顺利的发送给了D这台机子的物理地址，mac。交换机的学习是交换机自己多帧复制，不是靠广播实现，ARP是PC发送ARP广播。在A的arp表项里会记录D的ip和mac的对应关系，这个arp表在ms的系统里好像是15分钟刷新一次。</span>
