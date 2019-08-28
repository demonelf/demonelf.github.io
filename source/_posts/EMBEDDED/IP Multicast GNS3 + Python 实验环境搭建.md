---
title: 'IP Multicast: GNS3 + Python 实验环境搭建'
id: 382
comment: false
categories:
  - arm
date: 2016-05-06 18:48:22
tags:
---

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">试着搭建了一个实验环境：</span><span style="font-family:宋体">GNS3</span><span style="font-family:宋体">作为组播传输网络，</span><span style="font-family:宋体">Python socket</span><span style="font-family:宋体">编程实现组播服务器和客户端应用。</span><span style="font-family:宋体">
			</span></span>
<!-- more -->

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">拓扑如下：</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_1053_IPMulticast1.jpg)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">

<span style="color:red">**Python_Multicast_Server**</span></span><span style="font-family:宋体">**：**</span><span style="font-family:宋体">
			</span></span>

<span style="color:#464646; font-family:宋体; font-size:10pt">#!/usr/bin/env python
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">SENDERIP = '192.168.1.10'
SENDERPORT = 1501
MYPORT = 1234
MYGROUP = '224.1.1.1'
MYTTL = 255 # Increase to reach other networks
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">import time
import struct
import socket
def sender():
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM,socket.IPPROTO_UDP)
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">    s.bind((SENDERIP,SENDERPORT))
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">    # Set Time-to-live (optional)
    ttl_bin = struct.pack([<span style="color:#41684d; text-decoration:underline">'@i'</span>](mailto:), MYTTL)
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">    s.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, ttl_bin)
    status = s.setsockopt(socket.IPPROTO_IP,
        socket.IP_ADD_MEMBERSHIP,
        socket.inet_aton(MYGROUP) + socket.inet_aton(SENDERIP))
    while True:
        data = 'cisco'
        s.sendto(data + '\0', (MYGROUP, MYPORT))
        time.sleep(10)
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">if __name__ == "__main__":
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">    sender()
</span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">每隔</span><span style="font-family:宋体">10</span><span style="font-family:宋体">秒往组播地址</span><span style="font-family:宋体">224.1.1.1</span><span style="font-family:宋体">发送</span><span style="font-family:宋体">cisco</span><span style="font-family:宋体">字符串。</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_1053_IPMulticast2.jpg)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-family:宋体; font-size:10pt">
		</span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">组播拓扑配置了</span><span style="font-family:宋体">IGP</span><span style="font-family:宋体">和</span><span style="font-family:宋体">PIM DM
</span></span>

<span style="color:red; font-family:宋体; font-size:10pt">**Python_Multicast_Receiver:**<span style="color:#464646">
			</span></span>

<span style="color:#464646; font-family:宋体; font-size:10pt">SENDERIP = '192.168.247.1'
MYPORT = 1234
MYGROUP = '224.1.1.1'
MYTTL = 1 # Increase to reach other networks
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">import time
import struct
import socket
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">
SENDERIP = '192.168.247.1'
SENDERPORT = 1501
MYPORT = 1234
MYGROUP = '224.1.1.1'
MYTTL = 1 # Increase to reach other networks
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">def receiver():
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">    #create a UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)
    #allow multiple sockets to use the same PORT number
    sock.setsockopt(socket.SOL_SOCKET,socket.SO_REUSEADDR,1)
    #Bind to the port that we know will receive multicast data
    sock.bind((SENDERIP,MYPORT))
    #tell the kernel that we are a multicast socket
    sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, 255)
    #Tell the kernel that we want to add ourselves to a multicast group
    #The address for the multicast group is the third param
    status = sock.setsockopt(socket.IPPROTO_IP,
        socket.IP_ADD_MEMBERSHIP,
        socket.inet_aton(MYGROUP) + socket.inet_aton(SENDERIP));
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">    sock.setblocking(0)
    ts = time.time()
    while 1:
        try:
            data, addr = sock.recvfrom(1024)
        except socket.error, e:
            pass
        else:
            print "Receive data!"
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">            print "TIME:" , ts
            print "FROM: ", addr
            print "DATA: ", data
if __name__ == "__main__":
</span>

<span style="color:#464646; font-family:宋体; font-size:10pt">    receiver()
</span>

<span style="color:#464646; font-size:10pt"><span style="font-family:宋体">成功收到：后面可以开始分析</span><span style="font-family:宋体">IGMP</span><span style="font-family:宋体">，</span><span style="font-family:宋体">PIM</span><span style="font-family:宋体">啦</span><span style="font-family:宋体">
			</span></span>

[![](http://www.madhex.com/wp-content/uploads/2016/05/050616_1053_IPMulticast3.png)](http://photo.blog.sina.com.cn/showpic.html)<span style="color:#464646; font-family:宋体; font-size:10pt">
		</span>
