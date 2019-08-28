---
title: gentoo+qemu+nfs模拟arm环境
id: 504
comment: false
categories:
  - arm
date: 2016-05-18 08:41:38
tags:
---

![](http://www.madhex.com/wp-content/uploads/2016/05/051816_0054_gentooqemun1.png)

<!-- more -->
<span style="font-family:幼圆; font-size:12pt">想完全模拟公司交换机的环境还真不容易。
</span>

<span style="font-family:幼圆; font-size:12pt">下面给出在gentoo上利用qemu 实现nfs挂载busybox
</span>

<span style="font-family:幼圆; font-size:12pt">我尽量给出版本信息，因为不同版本直接是否能成功!
</span>

<span style="font-family:幼圆; font-size:12pt">ARM linux qemu仿真运行环境 (NFS启动)
</span>

<span style="font-family:幼圆; font-size:12pt">注:我的gentoo内核是通过genkernel all全配置的，
</span>

<span style="font-family:幼圆; font-size:12pt">如果您是自己定制还需看官方手册增加相应的内核配置
</span>

<span style="font-family:幼圆; font-size:12pt">1)Host中安装nfs
</span>

<span style="font-family:幼圆; font-size:12pt">#emerge  net-fs/nfs-utils -av
</span>

<span style="font-family:幼圆; font-size:12pt">[ebuild   R    ] net-fs/nfs-utils-1.3.1-r5::gentoo  USE="ipv6 libmount nfsidmap nfsv4 tcpd uuid -caps -kerberos -nfsdcld -nfsv41 (-selinux)"
</span>

<span style="font-family:幼圆; font-size:12pt">这个版本nfs默认协议是version 3 所以下面启动qemu是注意添加版本信息
</span>

<span style="font-family:幼圆; font-size:12pt">2)配置nfs
</span>

<span style="font-family:幼圆; font-size:12pt"># mkdir -p /srv/nfs/
</span>

<span style="font-family:幼圆; font-size:12pt">编辑/etc/exports文件，增加如下内容:
</span>

<span style="font-family:幼圆; font-size:12pt">/srv/nfs 192.168.42.0/24(rw,sync,no_root_squash,no_subtree_check)
</span>

<span style="font-family:幼圆; font-size:12pt">3)把制作的rootfs文件系统的目录拷贝的nfs目录下（以普通用户qinyu身份执行）
</span>

<span style="font-family:幼圆; font-size:12pt"># cp -rf ~/mkrtfs/rootfs /srv/nfs/
</span>

<span style="font-family:幼圆; font-size:12pt">#sudo chmod 777 /srv/nfs -R
</span>

<span style="font-family:幼圆; font-size:12pt"># sudo chown -R qinyu:qinyu /srv/nfs     如果root身份执行，请修改nfs root目录权限 我就是用的root 省得麻烦
</span>

<span style="font-family:幼圆; font-size:12pt">4)启动nfs-server
</span>

<span style="font-family:幼圆; font-size:12pt">#sudo exportfs -av
</span>

<span style="font-family:幼圆; font-size:12pt">#sudo systemctl start rpcbind.service
</span>

<span style="font-family:幼圆; font-size:12pt">#sudo systemctl start nfs-server.service
</span>

<span style="font-family:幼圆; font-size:12pt">测试nfs export是否成功（以root身份执行）
</span>

<span style="font-family:幼圆; font-size:12pt"># mkdir ~/nfs_test
</span>

<span style="font-family:幼圆; font-size:12pt"># mount localhost:/srv/nfs ~/nfs_
</span>

<span style="font-family:幼圆; font-size:12pt"># umount ~/nfs_test
</span>

<span style="font-family:幼圆; font-size:12pt">5)给qemu添加网卡
</span>

<span style="font-family:幼圆; font-size:12pt">sudo emerge sys-apps/usermode-utilities -av
</span>

<span style="font-family:幼圆; font-size:12pt">sudo tunctl -u $USER -t tap0
</span>

<span style="font-family:幼圆; font-size:12pt">sudo ifconfig tap0 192.168.42.1
</span>

<span style="font-family:幼圆; font-size:12pt">6）启动测试
</span>

<span style="font-family:幼圆; font-size:12pt">添加qemu-ifup文件，内容为：
</span>

<span style="font-family:幼圆; font-size:12pt">#!/bin/sh
</span>

<span style="font-family:幼圆; font-size:12pt">echo "Executing /etc/qemu-ifup"
</span>

<span style="font-family:幼圆; font-size:12pt">sudo ifconfig tap0 192.168.42.1
</span>

<span style="font-family:幼圆; font-size:12pt">我的测试命令：
</span>

<span style="font-family:幼圆; font-size:12pt">sudo qemu-system-arm -M versatilepb -m 128M -kernel /home/demonelf/vrrp/madwork/linux-2.6.31.8/arch/arm/boot/zImage -append "root=/dev/nfs nfsroot=192.168.42.1:/home/demonelf/vrrp/madwork/busybox-1.20.0/_install,nfsvers=3 rw ip=192.168.42.250::192.168.42.1:255.255.255.0::eth0:off init=/sbin/init console=ttyAMA0" -net nic,vlan=0 -net tap,vlan=0,ifname=tap0,script=./qemu-ifup,downscript=no -nographic
</span>

<span style="font-family:幼圆; font-size:12pt">#qemu-system-arm -version
</span>

<span style="font-family:幼圆; font-size:12pt">QEMU emulator version 2.5.1, Copyright (c) 2003-2008 Fabrice Bellard
</span>

<span style="font-family:幼圆; font-size:12pt">如果启动出现
</span>

<span style="color:#242729; font-family:幼圆; font-size:12pt"><span style="background-color:#eff0f1">Warning: unable to open an initial console.</span>
		</span>

<span style="font-family:幼圆; font-size:12pt">在dev下执行
</span>

<span style="color:#242729; font-family:幼圆; font-size:12pt; background-color:#eff0f1">mknod -m 622 console c 5 1
</span>

<span style="font-family:幼圆; font-size:12pt"><span style="color:#242729; background-color:#eff0f1">mknod -m 622 tty0 c 4 0</span>
		</span>
