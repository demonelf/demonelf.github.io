---
title: chroot到arm交换机的文件系统上
id: 450
comment: false
categories:
  - arm
date: 2016-05-12 18:42:30
tags:
---

哈

![](http://www.madhex.com/wp-content/uploads/2016/05/051216_1044_chrootarm1.png)

真实板子上：

<!-- more -->
![](http://www.madhex.com/wp-content/uploads/2016/05/051216_1044_chrootarm2.png)

不过发现chroot的方式缺点还是很大的，例如内核，网卡等环境都是真实机子上的。

郁闷啊一下子给这2.6内核的文件系统 上个4.1的内核，还真是各种不兼容。
