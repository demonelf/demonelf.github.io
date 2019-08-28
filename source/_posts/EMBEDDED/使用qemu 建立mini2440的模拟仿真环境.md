---
title: 使用qemu 建立mini2440的模拟仿真环境
id: 890
comment: false
categories:
  - arm
date: 2016-08-14 09:42:16
tags:
---

http://www.cnblogs.com/jinmu190/archive/2011/03/21/1990698.html
1\. 首先下载qemu for mini2440
<!-- more -->

git clone git://repo.or.cz/qemu/mini2440.git  qemu

如果感觉速度慢，直接打包下载

http://repo.or.cz/w/qemu/mini2440.git/snapshot/HEAD.tar.gz

解压后，今日源代码的主目录中，
```
#  ./configure --target-list=arm-softmmu
#  make -j4
```

2\. 下载u-boot for mini2440

git clone  git://repo.or.cz/w/u-boot-openmoko/mini2440.git  uboot

或者打包下载

http://repo.or.cz/w/u-boot-openmoko/mini2440.git/snapshot/HEAD.tar.gz

（注意 采用打包下载的时候这几个包的文件名可能相同，注意区分）解压后，配置Makefile文件，打开Makefile文件，CROSS_COMPILE变量赋值，即自己所使用的交叉编译工具链，比如我的是arm-none-linux-gnueabi-，保存退出，输入

```
  #make distclean
  #make mini2440_config
  #make -j4
```
稍等两分钟，即在当前目录下生成名为 u-boot.bin 的文件，注意如果想在之后使用u-boot 的nfs下载文件功能，需要修改代码中的一部分，将net/nfs.c文件中的

NFS_TIMEOUT = 2UL 修改为 NFS_TIMEOUT = 20000UL 否则会造成nfs文件下载失败，如果不使用nfs下载功能，不改也可。

3\. 下载 linux kernel for mini2440

（下载步骤略去）

进入源码目录

> make mini2440_defconfig ARCH=arm
> make -j4 ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- uImage

之后会在arch/arm/boot/目录下生成uImage 文件，将此文件复制到qemu目录下的mini2440文件夹下，并将mini2440文件夹中的mini2440_start.sh作如下修改

将 kernel 一行改为-kernel "$base/uImage" \,回到上层目录后运行
>  sh mini2440/mini2440_start.sh

这时应该看到qemu启动后进入了u-boot界面下，输入命令
>   bootm

就会看到linux内核启动的画面，但此时还没有根文件系统，我们稍候介绍采用nfs挂在根文件系统

4\. 假设你用的操作系统为ubuntu，首先安装 nfs服务器

> sudo apt-get install nfs-kernel-server

之后修改/etc/exports文件，添加如下一行

/home/username/nfs *(rw,sync,no_root_squash)

....................注意  /home/username/nfs 为你所要共享的目录

输入命令
>   sudo /etc/init.d/nfs-kernel-server restart

启动 nfs服务

测试 nfs服务是否成功启动

>  sudo mkdir /mnt/nfs
>  
>  sudo mount -t nfs localhost:/home/username/nfs /mnt/nfs

查看/mnt/nfs文件是否于/home/username/nfs 中相同，若一样 ，OK

5\. 将mini2440目录下的mini2440_start.sh修改为
```
 #!/bin/sh
 sudo  ../arm-softmmu/qemu-system-arm \
　　	-M mini2440　　
　 	 -kernel mini2440/uImage  -serial stdio  \
 　	 -net nic,vlan=0 
      -net tap,vlan=0,ifname=tap0,script=./qemu- ifup,downscript=./qemu-ifdown \
　　  -show-cursor \
　　  -usb -usbdevice keyboard -usbdevice mouse
```
在建立两个脚本,分别为qemu-ifup, qemu-ifdown

qemu-ifup 脚本

```
 #!/bin/sh
 echo "Excuting qemu-ifup"
 ifconfig $1 10.0.0.1
```

qemu-ifdown脚本
```
#!/bin/sh
echo "Close tap!"
sudo ifconfig $1 10.0.0.1 down
```

6\. 当这些都配置好后，我们即可使用nfs根文件系统了

这里我们的根文件系统为 /home/username/nfs

在qemu的目录中输入
> ./mini2440/mini2440_start.sh

u-boot启动成功后输入设置linux kernel的引导参数
```
set bootargs noinitrd root=/dev/nfs rw nfsroot=10.0.0.1:/home/lizhao/ARM-pro/nfs/rootfs ip=10.0.0.10:10.0.0.1::255.255.255.0 console=ttySAC0,115200
```
再输入命令

bootm

OK ！ kernel就开始加载了，文件系统挂在成功后，就可以进行各种仿真工作了，下面是我挂载的由友善之臂提供的mini2440的qtopia文件系统的截图：

![](http://www.madhex.com/wp-content/uploads/2016/08/2011032312545311.png)

![](http://www.madhex.com/wp-content/uploads/2016/08/2011032312552581.png)

友善之臂提供的qtopia文件系统在挂载时会初始化网卡，但我们是由nfs挂载的文件系统，这会导致nfs连接中断，挂载失败，所以用nfs挂载之前需要把网卡的初始化过程取消，对应的文件是/etc/init.d/if-config，只需把该文件内容清空即可。Enjoy yourself!

目前，我打算让GPE环境在这仿真环境中跑起来，目前还没有成功，正在尝试中。
