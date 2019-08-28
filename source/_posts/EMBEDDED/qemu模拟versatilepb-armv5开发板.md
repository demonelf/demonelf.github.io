---
title: qemu模拟versatilepb-armv5开发板
id: 460
comment: false
categories:
  - arm
date: 2016-05-16 12:05:36
tags:
---

 

<span style="font-family:幼圆; font-size:12pt">想要模拟的环境：
</span>
<!-- more -->

<span style="font-family:幼圆; font-size:12pt">Linux version 2.6.31.8 (hanzhen@bogon) (gcc version 4.3.2 (sdk3.2rc1-ct-ng-1.4.1) ) #13 Wed Aug 5 16:04:02 CST 2015
</span>

<span style="font-family:幼圆; font-size:12pt">CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), cr=000539f7
</span>

<span style="font-family:幼圆; font-size:12pt">CPU: VIVT data cache, VIVT instruction cache
</span>

<span style="font-family:幼圆; font-size:12pt">Machine: Feroceon-KW
</span>

<span style="font-family:幼圆; font-size:12pt">Marvell Development Board (LSP Version KW_LSP_5.4.0_012)-- DB-98DX4122-48G  Soc: MV88F6281 Rev 3 BE
</span>

<span style="font-family:幼圆; font-size:12pt">编译选项可参考kirkwood_defconfig (Feroceon 88FR131)
</span>

<span style="font-family:幼圆; font-size:12pt">以上是公司用到的的环境，qemu没有这个开发板，
</span>

<span style="font-family:幼圆; font-size:12pt">下面用versatilepb替代。
</span>

1.  <span style="font-family:幼圆; font-size:12pt">安装QEMU
</span>

<span style="font-family:幼圆; font-size:12pt">#qemu-system-arm -version
</span>

<span style="font-family:幼圆; font-size:12pt">QEMU emulator version 2.5.1, Copyright (c) 2003-2008 Fabrice Bellard
</span>

<span style="font-family:幼圆; font-size:12pt">2) 虚拟开发板选择 
</span>

<span style="font-family:幼圆; font-size:12pt">http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0225d/index.html 
</span>

<span style="font-family:幼圆; font-size:12pt">有两个板子 ： 
</span>

<span style="font-family:幼圆; font-size:12pt">a) Versatile Application Baseboard for ARM926EJ-S 
</span>

<span style="font-family:幼圆; font-size:12pt">b) <span style="color:red">Versatile Platform Baseboard for ARM926EJ-S</span>
		</span>

<span style="font-family:幼圆; font-size:12pt">3）编译内核
</span>

<span style="font-size:12pt"><span style="font-family:幼圆">#tar</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">xvf</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">linux-2.6.34.14.tar.xz</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">#cd</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">linux-2.6.34.14</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">#make</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">CROSS_COMPILE=armeb-mv5sft-linux-gnueabi- ARCH=arm</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">versatile_defconfig</span><span style="font-family:Calibri">  </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">#make</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">CROSS_COMPILE=armeb-mv5sft-linux-gnueabi- ARCH=arm</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">menuconfig</span><span style="font-family:Calibri">  </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">进入图形配置界面将Kernel</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">Featurer中的Use</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">the</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">ARM</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">EABI</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">to</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">compile</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">the</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">kernel选上</span><span style="font-family:Calibri">  </span><span style="font-family:幼圆">
			</span></span>

<span style="font-family:幼圆; font-size:12pt">#</span>
		<span style="font-family:幼圆; font-size:12pt">make CROSS_COMPILE=armeb-mv5sft-linux-gnueabi- ARCH=arm all
</span>

<span style="font-size:12pt"><span style="font-family:幼圆">在arch/arm/boot/下会生成zImage文件，该文件就是后期制作kernel的bin文件用的kernel镜像文件。</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">测试：</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">qemu-system-arm -M versatilepb -kernel arch/arm/boot/zImage  -append "console=ttyAMA0" -nographic</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/05/051816_1109_qemuversati1.png)<span style="font-family:幼圆; font-size:12pt">
		</span>

<span style="font-family:幼圆; font-size:12pt">4）编译busybox
</span>

<span style="font-family:幼圆; font-size:12pt">#wget http://www.busybox.net/downloads/busybox-1.20.0.tar.bz2
</span>

<span style="font-family:幼圆; font-size:12pt">#tar -xvf xxxxx.tar.gz
</span>

<span style="font-size:12pt"><span style="font-family:幼圆">#tar</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">xvf</span><span style="font-family:Calibri">  </span><span style="font-family:幼圆">busybox-1.20.0.tar.bz2</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">#cd</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">busybox-1.20.0</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">#make</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">ARCH=arm</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">CROSS_COMPILE=armeb-mv5sft-linux-gnueabi- defconfig</span><span style="font-family:Calibri">  </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">将init/init.c</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">694</span><span style="font-family:Calibri">        </span><span style="font-family:幼圆">new_init_action(ASKFIRST,bb_default_login_shell,VC_2);</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">695</span><span style="font-family:Calibri">        </span><span style="font-family:幼圆">new_init_action(ASKFIRST,bb_default_login_shell,VC_3);</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">696</span><span style="font-family:Calibri">        </span><span style="font-family:幼圆">new_init_action(ASKFIRST,bb_default_login_shell,VC_4);</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">这三行注释掉</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">#make</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">menuconfig</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">进入图形配置界面</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">将</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">Busybox</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">Settings</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">–&gt;</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">Build</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">Options</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">–&gt;</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">Build</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">Busybox</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">as</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">a</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">static</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">binary勾上</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">Networking</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">Utilities</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">-&gt;</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">inetd去掉</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-family:幼圆; font-size:12pt">busybox setting－&gt;build options-&gt;<span style="color:#323e32; background-color:#917a5f">
			</span>cross compile prefix中写入arm-linux-
</span>

<span style="font-size:12pt"><span style="font-family:幼圆"># make ARCH=arm CROSS_COMPILE=arm-linux-</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">install
</span></span>

<span style="font-family:幼圆; font-size:12pt">完成后，在本目录会生成_install目录。
</span>

<span style="font-family:幼圆; font-size:12pt">#cd _install
</span>

<span style="font-family:幼圆; font-size:12pt">#mkdir proc sys dev etc etc/init.d
</span>

<span style="font-size:12pt"><span style="font-family:幼圆">#vim</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">etc/init.d/rcS
</span></span>

<span style="font-size:12pt"><span style="font-family:幼圆">添加内容</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

<span style="font-family:幼圆; font-size:12pt">#!/bin/sh
</span>

<span style="font-family:幼圆; font-size:12pt">mount -t proc none /proc
</span>

<span style="font-family:幼圆; font-size:12pt">mount -t sysfs none /sys
</span>

<span style="font-size:12pt"><span style="font-family:幼圆">/sbin/mdev</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">-s
</span></span>

<span style="font-family:幼圆; font-size:12pt">修改权限
</span>

<span style="font-size:12pt"><span style="font-family:幼圆">#chmod</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">777</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">etc/init.d/rcS
</span></span>

<span style="font-family:幼圆; font-size:12pt">#find . |cpio -o --format=newc &gt; ../rootfs.img
</span>

<span style="font-family:幼圆; font-size:12pt">#cd ..
</span>

<span style="font-size:12pt"><span style="font-family:幼圆">#gzip</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">-c</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">rootfs.img</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">&gt;</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">rootfs.img.gz
</span></span>

<span style="font-family:幼圆; font-size:12pt">测试：
</span>

<span style="font-family:幼圆; font-size:12pt">qemu-system-arm -M versatilepb -kernel /home/demonelf/vrrp/madwork/linux-2.6.31.8/arch/arm/boot/zImage -initrd rootfs.img -append "root=/dev/ram rdinit=/sbin/init console=ttyAMA0" -nographic
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/051816_1109_qemuversati2.png)<span style="font-family:幼圆; font-size:12pt">
		</span>

<span style="font-family:幼圆; font-size:12pt">5）编译uboot
</span>

<span style="font-family:幼圆; font-size:12pt">make CROSS_COMPILE=arm-linux- ARCH=arm versatilepb_config
</span>

<span style="font-family:幼圆; font-size:12pt">make CROSS_COMPILE=arm-linux- ARCH=arm all 

</span>

<span style="font-family:幼圆; font-size:12pt">.globl raise
</span>

<span style="font-family:幼圆; font-size:12pt">raise:
</span>

<span style="font-family:幼圆; font-size:12pt">    nop
</span>

<span style="font-family:幼圆; font-size:12pt">mov pc, lr
</span>

<span style="font-family:幼圆; font-size:12pt">6）启动qemu
</span>

<span style="font-family:幼圆; font-size:12pt">qemu-system-arm -M versatilepb -cpu arm926 -m 256M -kernel /home/demonelf/vrrp/madwork/linux-2.6.31.8/arch/arm/boot/zImage -nographic -append "console=ttyAMA0" 
</span>

<span style="font-size:12pt"><span style="font-family:幼圆">qemu-system-arm -M versatilepb -kernel /home/demonelf/vrrp/madwork/linux-2.6.31.8/arch/arm/boot/zImage -initrd rootfs.img.gz -append "root=/dev/ram rdinit=/sbin/init"</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆">
			</span></span>

参考资料：

Debian on an emulated ARM machine

[https://www.aurel32.net/info/debian_arm_qemu.php](https://www.aurel32.net/info/debian_arm_qemu.php)

从零使用qemu模拟器搭建arm运行环境

[http://blog.csdn.net/linyt/article/details/42504975](http://blog.csdn.net/linyt/article/details/42504975)

在 Gentoo Linux 下使用 crossdev 建立自己的 toolchain

[http://coldnew.github.io/blog/2015/05-18_f69644/](http://coldnew.github.io/blog/2015/05-18_f69644/)

用Qemu模拟vexpress-a9 （一） --- 搭建Linux kernel调试环境

[http://www.cnblogs.com/pengdonglin137/p/5023342.html](http://www.cnblogs.com/pengdonglin137/p/5023342.html)

qemu 模拟-arm-mini2440开发板-启动u-boot，kernel和nfs文件系统

[http://blog.csdn.net/zeroboundary/article/details/12657215](http://blog.csdn.net/zeroboundary/article/details/12657215)

qemu下u-boot+kernel+rootfs完整启动移植手册

http://wenku.baidu.com/view/c343f68bb9d528ea81c77912.html
