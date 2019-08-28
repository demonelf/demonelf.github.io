---
title: Linux 内核编译 —— make localmodconfig 简化内核配置流程  
categories:
  - null
date: 2017-11-08 14:50:07
tags:
---

简介：
前些天才知道， Linux 2.6.32 开始引入了一个 make localmodconfig 用于简化 kernel 的配置。 
刚刚找了一下这个方面的资料，分享一下。


Most people uses the kernel shipped by distros - and that's good. But some people like to compile their own kernels from kernel.org, or maybe they like following the Linux development and want to try it. Configuring your own kernel, however, has become a very difficult and tedious task - there're too many options, and some times userspace software will stop working if you don't enable some key option. You can use a standard distro .config file, but it takes too much time to compile all the options it enables.

To make the process of configuration easier, a new build target has been added: make localmodconfig. It runs "lsmod" to find all the modules loaded on the current running system. It will read all the Makefiles to map which CONFIG enables a module. It will read the Kconfig files to find the dependencies and selects that may be needed to support a CONFIG. Finally, it reads the .config file and removes any module "=m" that is not needed to enable the currently loaded modules. With this tool, you can strip a distro .config of all the unuseful drivers that are not needed in our machine, and it will take much less time to build the kernel. There's an additional "make localyesconfig" target, in case you don't want to use modules and/or initrds.

以上内容摘自：Kernel Newbies。
大概意思是说， make localmodconfig 会执行 lsmod 命令查看当前系统中加载了哪些模块 (Modules)， 并最后将原来的 .config 中不需要的模块去掉，仅保留前面 lsmod 出来的这些模块，从而简化了内核的配置过程。 



这样做确实方便了很多，但是也有个缺点：该方法仅能使编译出的内核支持当前内核已经加载的模块。
因为该方法使用的是 lsmod 的结果，如果有的模块当前没有加载，那么就不会编到新的内核中。
例如，我有的时候需要制作 squashfs ， 因此在当前的内核中，将 squashfs 编译成了模块。 当使用 make localmodconfig 来配置 Kernel 的时候，如果当前系统中没有加载这个模块， 那么新编出来的内核中就不会将 squashfs 编译成模块，在新的内核中就没办法使用这个模块了。


所以建议在使用 make localmodconfig 之前，首先折腾一下系统，插个优盘，开开摄像头之类， 以便让内核加载上平时使用时候所需要的模块；执行 make localmodconfig 之后，再执行一下 make menuconfig 来手动检查一下， 是否还有其他模块需要手动选择。

这样，内核的编译可以分成如下几个步骤来进行：

1. 下载解压内核源码：http://www.kernel.org， 

2. 折腾一下系统，让它将合适的 module 都加载上。

3. 执行 make localmodconfig 精减不需要的模块。

4. 执行 make menuconfig ，检查一下是否有自己需要的模块没有选上。

5. 执行 make 进行编译

6. 执行 make modules_install 安装模块

7. 执行 make install 安装内核

8. 编辑 /boot/grub/grub.conf 或者 /boot/grub/menu.lst 添加新的引导菜单。

9. 重启并以新的内核启动。

   OK, that's all.

Author:yangyingchao, 2010-09-13