---
title: Gentoo+GDB+Qemu调试Linux-0.11的代码
id: 535
comment: false
categories:
  - arm
date: 2016-05-24 18:19:20
tags:
---

![](http://www.madhex.com/wp-content/uploads/2016/05/052416_1019_GentooGDBQe1.png)

<!-- more -->
<span style="font-family: 宋体; font-size: 12pt;"><span style="color: #666666;"><span style="background-color: white;">1.下载内核源码和根文件系统镜像</span>
<span style="background-color: white;">http://oldlinux.org/Linux.old/bochs/linux-0.11-devel-040809.zip</span>

<span style="background-color: white;">Linux-0.11内核源码的改进版，可以在gcc-4.72下顺利编译通过，原生代码只能在gcc-1.4下编译：</span>
<span style="background-color: white;">https://github.com/yuanxinyu/Linux-0.11</span>

<span style="background-color: white;">2.编译Linux-0.11</span>
<span style="background-color: white;">解压Linux-0.11-master.zip，进入Linux-0.11-master目录中，直接执行make就可以编译内核</span>

<span style="background-color: white;">会生成2个文件，一个是内核Image， 一个是内核符号文件tools/system。</span>

<span style="background-color: white;">3.qemu启动虚拟机</span>
<span style="background-color: white;">提取出linux-0.11-devel-040809.zip中的hdc-0.11.img，</span>
<span style="background-color: white;">按下面命令执行：</span>
<span style="background-color: white;">/*pc-bios是qemu源码目录中文件，包含bios文件，vgabios文件和keymap */</span>
<span style="background-color: white;">./qemu-system-x86_64  -m 16M -L ./pc-bios/ -boot a -fda Image -hda hdc-0.11.img -vnc :0 -s -S</span></span></span>

<span style="font-family: 宋体; font-size: 12pt;"><span style="color: #666666;">gentoo
./qemu-system-i386 -m 16M -boot a -fda Image -hda hdc-0.11.img

<span style="background-color: white;">4.在另外一个控制台中，执行</span>
<span style="background-color: white;">#gdb system</span>
<span style="background-color: white;">(gdb)target remote localhost:1234 //连接gdbserer</span>
<span style="background-color: white;">(gdb)directory ./Linux-0.11-master //设置源码目录</span>
<span style="background-color: white;">(gdb)set architecture i8086 //设置成i8086模式，用来调试16位实模式代码</span>
<span style="background-color: white;">(gdb)set disassembly-flavor intel    //讲汇编显示成INTEL格式，好看一些</span>
<span style="background-color: white;">(gdb)b *0x7c00 //在地址0x7c00处打断点，因为系统加电后，BIOS会把MBR中的代码加载到内  存中的0x7c00的位置，并从0x7c00处开始执行bootsect.s的代码</span>

<span style="background-color: white;">(gdb)c </span>
<span style="background-color: white;">(gdb)x /16b 0x7df0 //观察0x7DFE和0x7DFF的值是否为0x55，0xAA</span>
<span style="background-color: white;">(gdb)layout split //显示汇编窗口和源码窗口</span>
<span style="background-color: white;">(gdb)b main //main函数下断点</span>

<span style="background-color: white;"> ![](http://www.madhex.com/wp-content/uploads/2016/05/052416_1019_GentooGDBQe2.png)</span>
</span>
</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052416_1019_GentooGDBQe3.png)<span style="font-family: 宋体; font-size: 12pt;">
</span>

<span style="color: #666666; font-family: 宋体; font-size: 12pt;">
<span style="background-color: white;">参考资料：</span>
<span style="background-color: white;">http://wwssllabcd.github.io/blog/2012/08/03/compile-linux011/</span>
<span style="background-color: white;">http://oldlinux.org/index_cn.html</span>
<span style="background-color: white;">http://blog.csdn.net/zhangjs0322/article/details/10152279</span></span>
