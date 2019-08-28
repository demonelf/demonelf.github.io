---
title: MQTT学习笔记——MQTT协议体验 Mosquitto安装和使用
date: 2017-07-12 17:48:27
tags:
---
**0 前言**

     [MQTT](http://mqtt.org/)是IBM开发的一个即时通讯协议。MQTT是面向M2M和物联网的连接协议，采用轻量级发布和订阅消息传输机制。[Mosquitto](http://mosquitto.org/)是一款实现了 MQTT v3.1 协议的开源消息代理软件，提供轻量级的，支持发布/订阅的的消息推送模式，使设备对设备之间的短消息通信简单易用。

     若初次接触MQTT协议，可先理解以下概念：

 【MQTT协议特点】——相比于RESTful架构的物联网系统，MQTT协议借助消息推送功能，可以更好地实现远程控制。

 【MQTT协议角色】——在RESTful架构的物联网系统，包含两个角色客户端和服务器端，而在MQTT协议中包括发布者，代理器（服务器）和订阅者。

 【MQTT协议消息】——MQTT中的消息可理解为发布者和订阅者交换的内容（负载），这些消息包含具体的内容，可以被订阅者使用。

 【MQTT协议主题】——MQTT中的主题可理解为相同类型或相似类型的消息集合。

 **1 安装和使用注意点**

 **1.1 安装**

     截止2015年12月，最新版本为mosquitto-1.4.5

 # 下载源代码包

 wget [http://mosquitto.org/files/source/mosquitto-1.4.5.tar.gz](http://mosquitto.org/files/source/mosquitto-1.4.5.tar.gz)

 # 解压

 tar zxfv mosquitto-1.4.5.tar.gz

 # 进入目录

 cd mosquitto-1.4.5

 # 编译

 make

 # 安装

 sudo make install

 **1.2 安装注意点**

 【1】编译找不到openssl/ssl.h

     【解决方法】——安装openssl

 sudo apt-get install libssl-dev

 【2】编译过程找不到ares.h

 sudo apt-get install libc-ares-dev

 【3】编译过程找不到uuid/uuid.h

 sudo apt-get install uuid-dev

 【4】使用过程中找不到libmosquitto.so.1

 error while loading shared libraries: libmosquitto.so.1: cannot open shared object file: No such file or directory

     【解决方法】——修改libmosquitto.so位置

 # 创建链接

 sudo ln -s /usr/local/lib/libmosquitto.so.1 /usr/lib/libmosquitto.so.1

 # 更新动态链接库

 sudo ldconfig

 【5】make: g++：命令未找到  

     【解决方法】

     安装g++编译器

 sudo apt-get install g++

 **2 简单测试**

     一个完整的MQTT示例包括一个代理器，一个发布者和一个订阅者。测试分为以下几个步骤：

 【1】启动服务mosquitto。

 【2】订阅者通过mosquitto_sub订阅指定主题的消息。

 【3】发布者通过mosquitto_pub发布指定主题的消息。

 【4】代理服务器把该主题的消息推送到订阅者。

 【测试说明】

     测试环境：ubuntu 14.04 虚拟机

     在本例中，发布者、代理和订阅者均为localhsot，但是在实际的情况下三种并不是同一个设备，在mosquitto中可通过-h(--host)设置主机名称(hostname)。为了实现这个简单的测试案例，需要在linux中打开三个控制台，分别代表代理服务器、发布者和订阅者。

 ![](http://img.blog.csdn.net/20140913162434656?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQveHVrYWk4NzExMDU=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

 ![](file:///C:/Users/dell/AppData/Local/YNote/Data/xukai19871105@126.com/0934e2c55689448d97f0338200f68b94/%E5%8F%91%E5%B8%83%E8%AE%A2%E9%98%85%E6%A8%A1%E5%9E%8B.png)

 图1 示例

 **2.1 启动代理服务**

 mosquitto -v

     【-v】打印更多的调试信息

 **2.2 订阅主题**

 mosquitto_sub -v -t sensor

     【-t】指定主题，此处为sensor

     【-v】打印更多的调试信息

 **2.3 发布内容**

 mosquitto_pub -t sensor  -m 12

     【-t】指定主题

     【-m】指定消息内容

 **2.4 运行结果**

     当发布者推送消息之后，订阅者获得以下内容

 sensor 12

     而代理服务器控制台中会出现——连接、消息发布和心跳等调试信息。通过代理服务器的调试输出可以对MQTT协议的相关过程有所了解。

 ![](http://img.blog.csdn.net/20140913162654067?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQveHVrYWk4NzExMDU=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

 图2 代理服务器调试输出

 **3 总结**

     通过[Mosquitto](http://mosquitto.org/)实现MQTT协议代理器(服务器)，为今后的MQTT协议应用做准备。本文并没有分析MQTT协议的种种细节，但是希望通过一个简单的例子把MQTT协议“使用起来”，通过使用过程来理解MQTT协议，在过程中关注细节收集疑问，再阅读MQTT协议具体内容，这样学习起来就不至于枯燥乏味（即使MQTT协议只有40多页，但是初次阅读我还是没能理解其内涵，只能怪自己智商太低，学术不精。）

 **4 参考资料**

 【1】[Mosquitto简要教程（安装/使用/测试）](http://blog.csdn.net/shagoo/article/details/7910598)

 【2】[解决编译过程中找不到ares.h的问题](http://www.cnblogs.com/xiaoerhei/p/3777157.html)

 【3】[解决使用过程中找不到libmosquitto.so.1的问题](http://www.cnblogs.com/fuxiuyuan/archive/2012/05/12/2497649.html)