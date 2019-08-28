---
title: U-boot源码整体框架
id: 983
comment: false
categories:
  - arm
date: 2016-11-29 11:07:33
tags:
---

1.  <div style="background: #4f81bd">
<!-- more -->

    # <span style="font-family:幼圆">U-boot源码整体框架
</span>
</div>

    <span style="color:black; font-family:幼圆"><span style="font-size:10pt">源码解压以后，我们可以看到以下的文件和文件夹：</span><span style="color:#666666; font-size:12pt">

    					</span></span>
<div><table style="border-collapse:collapse" border="0"><colgroup><col style="width:104px"/><col style="width:98px"/><col style="width:353px"/></colgroup><tbody valign="top"><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  solid black 1.0pt; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="color:red; font-size:12pt">**<span style="font-family:Arial"> </span><span style="font-family:幼圆">cpu</span>**</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  solid black 1.0pt; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">与处理器相关的文件。每个子目录中都包括cpu.c和interrupt.c、start.S、u-boot.lds。
</span>

<span style="font-family:幼圆; font-size:12pt">**cpu.c**初始化CPU、设置指令Cache和数据Cache等
</span>

<span style="font-family:幼圆; font-size:12pt">**interrupt.c**设置系统的各种中断和异常
</span>

<span style="font-family:幼圆; font-size:12pt"><span style="color:red">**start.S**</span>是U-boot启动时执行的第一个文件，它主要做最早其的系统初始化，代码重定向和设置系统堆栈，为进入U-boot第二阶段的C程序奠定基础
</span>

<span style="font-family:幼圆; font-size:12pt"><span style="color:red">**u-boot.lds**</span>链接脚本文件，对于代码的最后组装非常重要</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="color:red; font-size:12pt">**<span style="font-family:Arial"> </span><span style="font-family:幼圆">board</span>**</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">已经支持的所有开发板相关文件，其中包含<span style="color:red">SDRAM初始化代码、Flash底层驱动、板级初始化文件</span>。
</span>

<span style="font-family:幼圆; font-size:12pt">其中的<span style="color:red">**config.mk**</span>文件定义了<span style="color:red">TEXT_BASE</span>，也就是代码在内存的其实地址，非常重要。</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="color:red; font-size:12pt">**<span style="font-family:Arial"> </span><span style="font-family:幼圆">common</span>**</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">与处理器体系结构无关的通用代码，U-boot的命令解析代码/common/command.c、所有命令的上层代码<span style="color:red">**cmd_*.c**</span>、U-boot环境变量处理代码env_*.c、等都位于该目录下</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="color:red; font-family:幼圆; font-size:12pt">**drivers**</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">包含几乎所有外围芯片的驱动，<span style="color:red">网卡</span>、USB、串口、LCD、Nand Flash等等</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆"><span style="font-size:10pt">disk</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆; font-size:12pt"><span style="color:red">**fs**</span>
									</span>

<span style="color:red; font-family:幼圆; font-size:12pt">**net**</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">支持的CPU无关的重要子系统：
</span>

<span style="font-family:幼圆; font-size:12pt">磁盘驱动的分区处理代码
</span>

<span style="font-family:幼圆; font-size:12pt">文件系统：FAT、JFFS2、EXT2等
</span>

<span style="font-family:幼圆; font-size:12pt">网络协议：NFS、TFTP、RARP、DHCP等等</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="color:red; font-family:幼圆; font-size:12pt">**include**</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">头文件，包括各<span style="color:red">CPU的寄存器定义</span>，文件系统、网络等等
</span>

<span style="font-family:幼圆; font-size:12pt"><span style="color:red">configs子目录</span>下的文件是与目标板相关的配置头文件</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:10pt">doc</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">U-Boot的说明文档，在修改配置文件的时候可能用得上</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  none; border-right:  solid black 1.0pt">

    <span style="color:red; font-family:幼圆; font-size:12pt">**lib_arm**</span>
</td><td rowspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">处理器体系相关的初始化文件
</span>

<span style="font-family:幼圆; font-size:12pt">比较重要的是其中的<span style="color:red">board.c</span>文件，几乎是U-boot的所有架构第二阶段代码入口函数和相关初始化函数存放的地方。</span>
</td></tr><tr><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  none">

    <span style="font-family:幼圆"><span style="font-size:10pt">lib_avr32</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">lib_blackfin</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">lib_generic</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">lib_i386</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">lib_m68k</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆; font-size:10pt">lib_microblaze</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆"><span style="font-size:10pt">lib_mips lib_nios</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">lib_nios2</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">lib_ppc</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">lib_sh</span><span style="font-size:12pt">
										</span></span>

<span style="color:black; font-family:幼圆; font-size:10pt">lib_sparc</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:Arial; font-size:10pt"> </span><span style="font-family:幼圆"><span style="font-size:10pt">api</span><span style="font-size:12pt">
										</span></span>

<span style="color:black; font-family:幼圆; font-size:10pt">examples</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">外部扩展应用程序的API和范例</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆"><span style="font-size:10pt">nand_spl</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">onenand_ipl</span><span style="font-size:12pt">
										</span></span>

<span style="color:black; font-family:幼圆; font-size:10pt">post</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">一些特殊构架需要的启动代码和上电自检程序代码</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="color:black; font-family:幼圆; font-size:10pt">libfdt</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">支持平坦设备树(flattened device trees)的库文件</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="color:black; font-family:幼圆; font-size:10pt">tools</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">编译S-Record或U-Boot映像等相关工具，制作bootm引导的内核映像文件工具<span style="color:red">mkimage</span>源码就在此</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt"><span style="color:red">**Makefile**</span>
									</span>

<span style="font-family:幼圆"><span style="font-size:10pt">MAKEALL</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">config.mk</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">rules.mk</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆; font-size:10pt">mkconfig</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">控制整个编译过程的主<span style="color:red">Makefile</span>文件和规则文件</span>
</td></tr><tr><td colspan="2" style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆"><span style="font-size:10pt">CHANGELOG</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">CHANGELOG-before-U-Boot-1.1.5</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">COPYING</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">CREDITS</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">MAINTAINERS</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆; font-size:10pt">README</span>
</td><td style="padding-left: 1px; padding-right: 1px; border-top:  none; border-left:  none; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆; font-size:12pt">一些介绍性的文档、版权说明</span>
</td></tr></tbody></table></div>

    <span style="color:black; font-family:幼圆; font-size:10pt; background-color:white">标为<span style="color:red">红色<span style="color:black">的是移植时比较重要的文件或文件夹。
</span></span></span>

2.  <div style="background: #4f81bd">

    # <span style="font-family:幼圆">U-boot代码的大致执行流程（以S3C24x0为例）
</span>
</div>

    <span style="font-family:幼圆; font-size:12pt">从链接脚本文件u-boot.lds中可以找到代码的起始：
</span>
<div><table style="border-collapse:collapse" border="0"><colgroup><col style="width:553px"/></colgroup><tbody valign="top"><tr><td style="padding-top: 4px; padding-left: 4px; padding-bottom: 4px; padding-right: 4px; border-top:  solid black 1.0pt; border-left:  solid black 1.0pt; border-bottom:  solid black 1.0pt; border-right:  solid black 1.0pt">

    <span style="font-family:幼圆"><span style="font-size:10pt">OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">OUTPUT_ARCH(arm)</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="color:red; font-size:10pt">ENTRY(_start)</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">SECTIONS</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆"><span style="font-size:10pt">{</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:Arial; font-size:10pt">       </span><span style="font-family:幼圆"><span style="font-size:10pt">. = 0x00000000;</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:Arial; font-size:10pt">       </span><span style="font-family:幼圆"><span style="font-size:10pt">. = ALIGN(4);</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:Arial; font-size:10pt">       </span><span style="font-family:幼圆"><span style="font-size:10pt">.text :</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:Arial; font-size:10pt">       </span><span style="font-family:幼圆"><span style="font-size:10pt">{</span><span style="font-size:12pt">
										</span></span>

<span style="color:red; font-size:10pt"><span style="font-family:Arial">              </span><span style="font-family:幼圆">cpu/arm920t/start.o</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">(.text)</span></span><span style="font-family:幼圆; font-size:12pt">
									</span>

<span style="font-family:Arial; font-size:10pt">              </span><span style="font-family:幼圆"><span style="font-size:10pt">*(.text)</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:Arial; font-size:10pt">       </span><span style="font-family:幼圆"><span style="font-size:10pt">}</span><span style="font-size:12pt">
										</span></span>

<span style="font-family:幼圆; font-size:10pt">…...</span>
</td></tr></tbody></table></div>

    <span style="font-family:幼圆; font-size:12pt">从中知道程序的入口点是_start，定位于cpu/arm920t /start.S（即u-boot启动的第一阶段）。
</span>

3.  <div style="background: #4f81bd">

    # <span style="font-family:幼圆">U-boot版本相关
</span>
</div>

    <span style="font-family:幼圆">1、版本号变化：
</span>

<span style="font-family:幼圆">2008年8月及以前
</span>

<span style="font-family:幼圆">按版本号命名：u-boot-1.3.4.tar.bz2(2008年8月更新)
</span>

<span style="font-family:幼圆">2008年8月以后均按日期命名。
</span>

<span style="font-family:幼圆">目前最新版本：u-boot-2011.06.tar.bz2（2011年6月更新）
</span>

<span style="font-family:幼圆">2、目录结构变化：
</span>

<span style="font-family:幼圆">u-boot目录结构主要经历过2次变化，u-boot版本第一次从u-boot-1.3.2开始发生变化，主要增加了api的内容；变化最大的是第二次，从2010.6版本开始。
</span>

<span style="font-family:幼圆">u-boot-2010.03及以前版本
</span>

<span style="font-family:幼圆">├──api                存放uboot提供的接口函数
</span>

<span style="font-family:幼圆">├──board              根据不同开发板定制的代码，代码也不少
</span>

<span style="font-family:幼圆">├──common             通用的代码，涵盖各个方面，已命令行处理为主
</span>

<span style="font-family:幼圆">├──cpu                与体系结构相关的代码，uboot的重头戏
</span>

<span style="font-family:幼圆">├──disk                磁盘分区相关代码
</span>

<span style="font-family:幼圆">├──doc                文档，一堆README开头的文件
</span>

<span style="font-family:幼圆">├──drivers            驱动，很丰富，每种类型的设备驱动占用一个子目录
</span>

<span style="font-family:幼圆">├──examples           示例程序
</span>

<span style="font-family:幼圆">├──fs                 文件系统，支持嵌入式开发板常见的文件系统
</span>

<span style="font-family:幼圆">├──include            头文件，已通用的头文件为主
</span>

<span style="font-family:幼圆">├──lib_【arch】        与体系结构相关的通用库文件
</span>

<span style="font-family:幼圆">├──nand_spl           NAND存储器相关代码
</span>

<span style="font-family:幼圆">├──net                网络相关代码，小型的协议栈
</span>

<span style="font-family:幼圆">├──onenand_ipl
</span>

<span style="font-family:幼圆">├──post               加电自检程序
</span>

<span style="font-family:幼圆">└──tools              辅助程序，用于编译和检查uboot目标文件
</span>

<span style="font-family:幼圆">从u-boot-2010.06版本开始把体系结构相关的内容合并，<span style="color:red; background-color:yellow">原先的cpu与lib_arch内容全部纳入arch中，并且其中增加inlcude文件夹；分离出通用库文件lib</span>。
</span>

<span style="font-family:幼圆">u-boot-2010.06及以后版本
</span>

<span style="font-family:幼圆">├──api                存放uboot提供的接口函数
</span>

<span style="font-family:幼圆">├──arch               与体系结构相关的代码，uboot的重头戏
</span>

<span style="font-family:幼圆">├──board              根据不同开发板定制的代码，代码也不少
</span>

<span style="font-family:幼圆">├──common             通用的代码，涵盖各个方面，已命令行处理为主
</span>

<span style="font-family:幼圆">├──disk                磁盘分区相关代码
</span>

<span style="font-family:幼圆">├──doc                文档，一堆README开头的文件
</span>

<span style="font-family:幼圆">├──drivers            驱动，很丰富，每种类型的设备驱动占用一个子目录
</span>

<span style="font-family:幼圆">├──examples           示例程序
</span>

<span style="font-family:幼圆">├──fs                 文件系统，支持嵌入式开发板常见的文件系统
</span>

<span style="font-family:幼圆">├──include            头文件，已通用的头文件为主
</span>

<span style="font-family:幼圆">├──lib                通用库文件
</span>

<span style="font-family:幼圆">├──nand_spl           NAND存储器相关代码
</span>

<span style="font-family:幼圆">├──net                网络相关代码，小型的协议栈
</span>

<span style="font-family:幼圆">├──onenand_ipl
</span>

<span style="font-family:幼圆">├──post               加电自检程序
</span>

<span style="font-family:幼圆">└──tools              辅助程序，用于编译和检查uboot目标文件
</span>

<span style="font-family:幼圆">3、移植工作涉及的目录情况
</span>

<span style="font-family:幼圆">从uboot代码根目录，可以看出其已经非常庞大，功能也很丰富。
</span>

<span style="font-family:幼圆">移植工作最主要的是看对应的处理器和开发板代码，2010.06版本以后处理器相关的代码集中在arch、board目录。(以前版本主要在cpu和board目录)
</span>

<span style="font-family:幼圆">先看一下arch目录：
</span>

<span style="font-family:幼圆">arch
</span>

<span style="font-family:幼圆">├──arm
</span>

<span style="font-family:幼圆">├──avr32
</span>

<span style="font-family:幼圆">├──blackfin
</span>

<span style="font-family:幼圆">├──i386
</span>

<span style="font-family:幼圆">├──m68k
</span>

<span style="font-family:幼圆">├──microblaze
</span>

<span style="font-family:幼圆">├──mips
</span>

<span style="font-family:幼圆">├──nios2
</span>

<span style="font-family:幼圆">├──powerpc
</span>

<span style="font-family:幼圆">├──sh
</span>

<span style="font-family:幼圆">└──sparc
</span>

<span style="font-family:幼圆">arch目录内容比以前的版本干净，每个子目录代表一个处理器类型，子目录名称就是处理器的类型名称。
</span>

<span style="font-family:幼圆">我们移植的是mips的处理器，所以参考一下arch/mips目录：
</span>

<span style="font-family:幼圆">arch/mips
</span>

<span style="font-family:幼圆">├──cpu
</span>

<span style="font-family:幼圆">├──include
</span>

<span style="font-family:幼圆">└──lib
</span>

<span style="font-family:幼圆">arch/mips目录下有三个目录，其他的处理器目录下也是这个结构：
</span>

<span style="font-family:幼圆">cpu子目录对应一种处理器的不同产品型号或者系列;
</span>

<span style="font-family:幼圆">include子目录是处理器用到的头文件；
</span>

<span style="font-family:幼圆">lib目录对应用到处理器公用的代码；
</span>

<span style="font-family:幼圆">下面看看cpu下的内容，arch/mips/cpu目录下的内容：
</span>

<span style="font-family:幼圆">arch/mips/cpu
</span>

<span style="font-family:幼圆">├──asc_serial.c
</span>

<span style="font-family:幼圆">├──asc_serial.h
</span>

<span style="font-family:幼圆">├──au1x00_eth.c
</span>

<span style="font-family:幼圆">├──au1x00_serial.c
</span>

<span style="font-family:幼圆">├──au1x00_usb_ohci.c
</span>

<span style="font-family:幼圆">├──au1x00_usb_ohci.h
</span>

<span style="font-family:幼圆">├──cache.S
</span>

<span style="font-family:幼圆">├──config.mk
</span>

<span style="font-family:幼圆">├──cpu.c
</span>

<span style="font-family:幼圆">├──incaip_clock.c
</span>

<span style="font-family:幼圆">├──incaip_wdt.S
</span>

<span style="font-family:幼圆">├──interrupts.c
</span>

<span style="font-family:幼圆">├──Makefile
</span>

<span style="font-family:幼圆">└──start.S          整个uboot代码入口点
</span>

<span style="font-family:幼圆">目前最新版本(2011.6版本开始)中cpu目录中建立mips32目录，把incaip和au1x00也分类放在不同的目录中。
</span>

<span style="font-family:幼圆">u-boot.lds是ld程序也就是连接器的脚本文件，这个文件描述了如何连接目标文件，ld程序会根据这个文件的指示按照需求把不同的目标文件连接在一起生成供烧写到开发板的程序。
</span>

<span style="font-family:幼圆">该文件放在board对应的目录中。
</span>

<span style="font-family:幼圆">4、移植u-boot的版本选择情况
</span>

<span style="font-family:幼圆">由于u-boot的各版本没有重大变化，各版本移植起来基本相同，也正因为如此，大多数版本均有人移植过，主要是arm体系结构的。
</span>

<span style="font-family:幼圆">如cortex A8使用 u-boot-1.3.4；cortex M3 上u-boot-1.1.6、u-boot-1.2.0等均有人移植过。
</span>

<span style="font-family:幼圆">考虑到我们目前的编译器较新，编译旧版本u-boot时会出现错误，警告也很多；新版本的u-boot目录结构也较清晰，因此选用较新版本的u-boot。
</span>

<span style="font-family:幼圆">最新版本（2011.06）Makefile中没有mips的部分，不知道为什么。（2011.03版本中同样也是）
</span>

<span style="font-family:幼圆">u-boot-2010.12的Makefile没有问题，编译incaip通过，没有任何警告和错误，因此最终选择u-boot-2010.12作为我们的移植版本。
</span>
