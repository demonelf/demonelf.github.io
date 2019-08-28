---
title: Multicast testing with VLC media player step-step-guide
id: 401
comment: false
categories:
  - arm
date: 2016-05-09 10:32:56
tags:
---

[Multicast testing with VLC media player step-step-guide](http://www.anandnetwork.com/2011/11/multicast-testing-with-vlc-media-player.html)

HI STUDENT
<!-- more -->

Today I am doing one practical in which we are doing practical of dense-mode , same we can do the testing on sparse-mode , please go through it &amp; you will able to run the multicast application on your Gns , Please send your feedback so that I can post more innovative practical

BASIC SETUP

We HAVE TWO OPTIONS TO TEST MULTICAST WITH GNS3

1)ONE HOST MACHINE AND ONE VIRTUAL MACHINE

2)USE TWO VIRTUAL MACHINES

For Second Option You Need a Virtualization Software installed ,That Consumes Lot of Memory

SO firstly Start with a Simpler method

Method 1

STEP 1) First You Have to setup a Loopback Adaptor on your Host machine

This is Steps For Window 7 To setup Loopback

Goto to Command Prompt à Type **hdwwiz and Hit enter ..You will see Screen Like it**

[![](http://www.madhex.com/wp-content/uploads/2016/05/050916_0232_Multicastte1.gif)](http://lh3.ggpht.com/-eymqBbTwQiE/TrwP4l9w5XI/AAAAAAAAANc/bJwG7hk-zlQ/s1600-h/clip_image002%25255B3%25255D.gif)

**Click Next then select Install the hardware that I manually select from a list (Advanced)**.  _And _**Next** to continue** then on new window**_Scroll down_ the list and _Select_ **Network Adapters** then _Click_** Nextà**_Click_** Microsoft** and _Select_ **Microsoft Loopback Adapter and Press Next to Continue**

**Now Your Loopback Interface is setup .You Have Reboot Your Laptop/PC to get it working on GNS3.**

**Here is Our LoopBack**

[![](http://www.madhex.com/wp-content/uploads/2016/05/050916_0232_Multicastte2.gif)](http://lh5.ggpht.com/-yQHmWhYC02o/TrwQA69tsaI/AAAAAAAAANs/BQ3tGBXZl7A/s1600-h/clip_image004%25255B3%25255D.gif)

**2<sup>nd</sup> things that we have to Setup is Our Virtual Machine .We will Be using "Qemu" for it .It is Provided with GNS3 Package**

[http://downloads.sourceforge.net/gns-3/Multicast.zip?download](http://downloads.sourceforge.net/gns-3/Multicast.zip?download)

**This Lab Package is made by GNS3 Officals …We only Need the Image File in Package.**

**Download the Package ,Extract it ,You will se a "IMAGES " Folder and You Will FOUND a File "multicast.img" in it. This is Actually a small linux OS which provided on GNS3 offcial blog to TEST multicasting.Now How to Setup it with GNS3**

**OPEN GNS3 =&gt;EDIT =&gt;PREFRENCE=&gt;QEMU**

**IN QEMU WINDOW GO TO "QemuHost" TAB**

[![](http://www.madhex.com/wp-content/uploads/2016/05/050916_0232_Multicastte3.gif)](http://lh3.ggpht.com/-wjkMEy5sdfk/TrwQKqS0kwI/AAAAAAAAAN8/u_egfT6MYos/s1600-h/clip_image006%25255B3%25255D.gif)

**IN IDENTIFIER PUT ANY NAME .**

**IN BINARY IMAGE FIELD GIVE THE PATH OF YOUR "multicast.img"**

**Also You can Increase/decrase the RAM …**

**Then Click on Save ,Click Ok and We Done**

**Now We are ready …Lets start GNS3 and Bulid a Multicast Testing lab**

**Drag the Cloud =&gt; Go to Configure =&gt;Cloud Name (C1) =&gt;Select the Microsoft Loopback Adaptor and click Add.**

**NOTE :You Have to RUN GNS3 As ADMINSTRATOR**

**ALSO DRAG A QEMU HOST**

**OUR TOPOLOGY LOOK LIKE THIS**

[![](http://www.madhex.com/wp-content/uploads/2016/05/050916_0232_Multicastte4.gif)](http://lh4.ggpht.com/-YbWsyeSEPaY/TrwQO7SQtjI/AAAAAAAAAOM/fxpQT7hz0VU/s1600-h/clip_image008%25255B3%25255D.gif)

**LoopBack Adaptor IP =&gt; 192.168.1.10**

**GATEWAY =&gt; 192.168.1.1**

**QEMU HOST IP =&gt; 192.168.100.10**

**GATEWAY =&gt; 192.168.100.1**

**WHEN YOU START Qemu HOST ,It Will start Linux OS ..it takes time ,about 5 minuts.**

**Router Config**

**!**

**version 12.4**

**service timestamps debug datetime msec**

**service timestamps log datetime msec**

**no service password-encryption**

**!**

**hostname Router**

**!**

**boot-start-marker**

**boot-end-marker**

**!**

**!**

**no aaa new-model**

**ip cef**

**!**

**!**

**!**

**!**

**ip multicast-routing**

**!**

**multilink bundle-name authenticated**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**!**

**interface FastEthernet0/0**

**no ip address**

**shutdown**

**duplex half**

**!**

**interface Ethernet1/0**

**ip address 192.168.1.1 255.255.255.0**

**ip pim dense-mode**

**ip igmp static-group 224.1.1.1**

**duplex half**

**!**

**interface Ethernet1/1**

**ip address 192.168.100.1 255.255.255.0**

**ip pim dense-mode**

**ip igmp static-group 224.1.1.1**

**duplex half**

**!**

**interface Ethernet1/2**

**no ip address**

**shutdown**

**duplex half**

**!**

**interface Ethernet1/3**

**no ip address**

**shutdown**

**duplex half**

**!**

**interface Ethernet1/4**

**no ip address**

**shutdown**

**duplex half**

**!**

**interface Ethernet1/5**

**no ip address**

**shutdown**

**duplex half**

**!**

**interface Ethernet1/6**

**no ip address**

**shutdown**

**duplex half**

**!**

**interface Ethernet1/7**

**no ip address**

**shutdown**

**duplex half**

**!**

**no ip http server**

**no ip http secure-server**

**!**

**!**

**!**

**logging alarm informational**

**!**

**!**

**!**

**!**

**!**

**!**

**control-plane**

**!**

**!**

**!**

**!**

**!**

**!**

**gatekeeper**

**shutdown**

**!**

**!**

**line con 0**

**stopbits 1**

**line aux 0**

**line vty 0 4**

**!**

**!**

**End**

**Now Go to Our Linux Machine …Open terminal**

**Type**

**chmod 777 start.sh (to give it execute permission)**

**Then ./start.sh (Execute Script)**

[![](http://www.madhex.com/wp-content/uploads/2016/05/050916_0232_Multicastte5.gif)](http://lh4.ggpht.com/-KmIm-Xy6Oaw/TrwQbKA34KI/AAAAAAAAAOc/rC1bgN_bDz8/s1600-h/clip_image010%25255B3%25255D.gif)

**It will start VLC PLAYER**
