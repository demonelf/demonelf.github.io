---
title: linux-iptables nat设置路由转换
date: 2017-07-13 12:50:00
tags:
---
 

DNAT（Destination Network Address Translation,目的地址转换) 通常被叫做目的映射。而SNAT（Source Network Address Translation，源地址转换）通常被叫做源映射。

这是我们在设置[Linux](http://lib.csdn.net/base/linux "Linux知识库")网关或者防火墙时经常要用来的两种方式。以前对这两个都解释得不太清楚，现在我在这里解释一下。

首先，我们要了解一下IP包的结构，如下图所示：
![ipv4](http://blog.myhnet.cn/wp-content/uploads/2009/01/iphdr.gif)
在任何一个IP数据包中，都会有Source IP Address与Destination IP Address这两个字段，数据包所经过的路由器也是根据这两个字段是判定数据包是由什么地方发过来的，它要将数据包发到什么地方去。而iptables的DNAT与SNAT就是根据这个原理，对Source IP Address与Destination IP Address进行修改。

然后，我们再看看数据包在iptables中要经过的链（chain）：
![**netfilter_packet_flow**](http://blog.myhnet.cn/wp-content/uploads/2009/01/netfilter_packet_flow.png)

图中正菱形的区域是对数据包进行判定转发的地方。在这里，系统会根据IP数据包中的destination ip address中的IP地址对数据包进行分发。如果destination ip adress是本机地址，数据将会被转交给INPUT链。如果不是本机地址，则交给FORWARD链检测。
这也就是说，我们要做的DNAT要在进入这个菱形转发区域之前，也就是在PREROUTING链中做，比如我们要把访问202.103.96.112的访问转发到192.168.0.112上：

<code class="hljs lasso has-numbering">iptables -t nat -A PREROUTING -d 202.103.96.112 -j DNAT --to-destination 192.168.0.112</code>

这个转换过程当中，其实就是将已经达到这台[linux](http://lib.csdn.net/base/linux "Linux知识库")网关（防火墙）上的数据包上的destination ip address从202.103.96.112修改为192.168.0.112然后交给系统路由进行转发。

而SNAT自然是要在数据包流出这台机器之前的最后一个链也就是POSTROUTING链来进行操作

<code class="hljs lasso has-numbering">iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j SNAT --to-source 58.20.51.66</code>

这个语句就是告诉系统把即将要流出本机的数据的source ip address修改成为58.20.51.66。这样，数据包在达到目的机器以后，目的机器会将包返回到58.20.51.66也就是本机。如果不做这个操作，那么你的数据包在传递的过程中，reply的包肯定会丢失。

假如当前系统用的是ADSL/3G/4G动态拨号方式，那么每次拨号，出口IP都会改变，SNAT就会有局限性。

<code class="hljs lasso has-numbering">iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE</code>

重点在那个『 MASQUERADE 』！这个设定值就是『IP伪装成为封包出去(-o)的那块装置上的IP』！不管现在eth0的出口获得了怎样的动态ip，MASQUERADE会自动读取eth0现在的ip地址然后做SNAT出去，这样就实现了很好的动态SNAT地址转换。

补充：
这里防火墙要进行转发必须打开内核路由转发功能，即：

<code class="hljs avrasm has-numbering">
echo "1" > /proc/sys/net/ipv4/ip_forward //开启路由转发
sysctl -p //使能sysctl设置
输出：
net.ipv4.ip_forward = 1  //这里为1，开启转发成功。
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
......
......
</code> 

问题：

<code class="hljs avrasm has-numbering">echo "1" > /proc/sys/net/ipv4/ip_forward
cat /proc/sys/net/ipv4/ip_forward

[root@Coohx ~]# sysctl -p
net.ipv4.ip_forward = 0   //  应该为1！！！！
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1</code>

解决办法：

 <code class="hljs avrasm has-numbering">vim  /etc/sysctl.conf   
将  
        net.ipv4.ip_forward = 0  
改为 
        net.ipv4.ip_forward = 1
[root@Coohx ~]# sysctl -p
net.ipv4.ip_forward = 1  //  一直为1
......
......</code>

注：手动修改/proc/sys/net/ipv4/ip_forward 0为1 ，内核不允许 `"/proc/sys/net/ipv4/ip_forward" 警告: 此文件自读入后已发生变动！！！ 确实要写入吗 (y/n)?y "/proc/sys/net/ipv4/ip_forward" E667: 同步失败 请按 ENTER 或其它命令继续`