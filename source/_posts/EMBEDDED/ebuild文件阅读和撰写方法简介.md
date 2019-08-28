---
title: ebuild文件阅读和撰写方法简介
id: 1097
comment: false
categories:
  - arm
date: 2017-04-12 15:37:35
tags:
---

<span style="color:#333333; font-family:幼圆; font-size:7pt"><span style="background-color:white">ebuild文件是portage系统的一部分，它是一种采用bash脚本语法书写的脚本文件，当使用portage相关工具维护系统中的软件时，针对单个软件的下载、安装等动作会由对应的ebuild脚本完成</span>

<!-- more -->
<span style="background-color:white">关于ebuild文件，之前俺无任何撰写经验，偶尔会因需要了解下载地址或post-installation message等原因查阅相关ebuild文件，下午略略阅读了gentoo的官方文档，在此简略记录关于ebuild的阅读和撰写方法的相关内容。</span>

<span style="background-color:white">如前述，ebuild是采用bash语法书写的脚本文件，ebuild与portage系统的关系是典型的script与host的关系，其构架可类比"js与web客户端应用"，即host完成控制、协调、提供功能等任务，script使用host提供的功能、采用某种形式与host交互、提供定制化能力。当portage系统需要操作某个包时，它与对应ebuild文件的交互方式大体是：</span>

<span style="background-color:white">1、portage系统在运行ebuild脚本之前，对某些"特定名字的环境变量"（其后详述）赋值，当运行ebuild脚本时，脚本可读取这些环境变量，了解相关信息</span>
<span style="background-color:white">2、ebuild脚本对一些"特定名字的环境变量"（其后详述）赋值，描述（即告知portage系统）本包的相关信息</span>
<span style="background-color:white">3、ebuild脚本定义"特定名字的函数"（其后详述），实现相关子过程的接管和控制。在需要的时候，portage系统将调用ebuild中定义的这些函数完成相关操作</span>

<span style="background-color:white">一个典型的"包安装"过程如下图：</span>
![](http://www.madhex.com/wp-content/uploads/2017/04/041217_0737_ebuild1.png)
<span style="background-color:white">图中的框内函数由ebuild脚本定义，而框间的流程，由portage系统控制</span>

<span style="background-color:white">portage系统与ebuild交互的细节（ebuild格式、环境接口、函数接口、调用过程等）称为Package Manager Specification（PMS）。EAPI的值是pms的版本，由于各版本的pms可能在ebuild与portage系统的交互上存在不兼容性，因此，ebuild通过指定EAPI（由ebuild为EAPI赋值）的方式通知portage系统期望使用的pms版本。</span>

<span style="background-color:white">ebuild文件被推荐使用tab作为缩进符，行字符数小于80，采用utf8编码</span>

<span style="background-color:white">pms预定义的环境变量包括：</span>

<span style="background-color:white">只读变量（由portage系统赋值，描述当前包的信息，ebuild文件读取使用）：</span>
<span style="background-color:white">P：带版本号的包名</span>
<span style="background-color:white">PN：包名</span>
<span style="background-color:white">PV：版本号</span>
<span style="background-color:white">PR：revision</span>
<span style="background-color:white">PVR：版本号及revision</span>
<span style="background-color:white">PF：包全名</span>
<span style="background-color:white">A：包全部源文件</span>
<span style="background-color:white">CATEGORY：包类别</span>
<span style="background-color:white">FILESDIR：包portage目录中的files子目录全路径</span>
<span style="background-color:white">WORKDIR：build目录</span>
<span style="background-color:white">T：临时目录</span>
<span style="background-color:white">D：临时安装目录</span>
<span style="background-color:white">ROOT：根目录</span>
<span style="background-color:white">DISTDIR：包文件下载目录</span>

<span style="background-color:white">ebuild可写环境变量（由ebuild赋值，portage读取并获取相关包信息）：</span>
<span style="background-color:white">EAPI：ebuild期望使用的pms版本号</span>
<span style="background-color:white">DESCRIPTION：包描述</span>
<span style="background-color:white">HOMEPAGE：包主页</span>
<span style="background-color:white">SRC_URI：包所需文件下载路径，可以和use条件判断结合使用</span>
<span style="background-color:white">LICENSE：包license需求</span>
<span style="background-color:white">SLOT：包所在slot定义</span>
<span style="background-color:white">KEYWORDS：包支持keywords需求</span>
<span style="background-color:white">IUSE：包支持的所有use列表</span>
<span style="background-color:white">RESTRICT：feature需求列表</span>
<span style="background-color:white">DEPEND：包编译依赖</span>
<span style="background-color:white">RDEPEND：包执行依赖</span>
<span style="background-color:white">PDEPEND：包安装依赖</span>
<span style="background-color:white">S：临时编译路径</span>

<span style="background-color:white">ebuild可实现函数（ebuild定义，portage系统调用。详情请查阅手册）：</span>
<span style="background-color:white">pkg_pretend</span>
<span style="background-color:white">pkg_nofetch</span>
<span style="background-color:white">pkg_setup</span>
<span style="background-color:white">src_unpack</span>
<span style="background-color:white">src_prepare</span>
<span style="background-color:white">src_configure</span>
<span style="background-color:white">src_compile</span>
<span style="background-color:white">src_test</span>
<span style="background-color:white">src_install</span>
<span style="background-color:white">pkg_preinst</span>
<span style="background-color:white">pkg_postinst</span>
<span style="background-color:white">pkg_prerm</span>
<span style="background-color:white">pkg_postrm</span>
<span style="background-color:white">pkg_config</span>
<span style="background-color:white">pkg_info</span>

<span style="background-color:white">portage也提供了必要的功能函数供ebuild使用，如：</span>
<span style="background-color:white">1、enewgroup、enewuser操作users和groups</span>
<span style="background-color:white">2、elog、einfo、ewarn输出信息</span>
<span style="background-color:white">3、一组预定义的函数定义，组织完备后存储在portage/eclass目录下，可使用inherit函数导入eclass并使用其中函数</span>

<span style="background-color:white">草草介绍了下，侧重原理，省略细节。如果有撰写ebuild需求，应精读之前提到的官方文档：[http://devmanual.gentoo.org](http://devmanual.gentoo.org)
			</span></span>

<span style="font-family:幼圆; font-size:7pt">gentoo 编写 ebuild举例：
</span>

[<span style="font-family:幼圆; font-size:7pt">http://www.tuicool.com/articles/MVRz2a</span>](http://www.tuicool.com/articles/MVRz2a)<span style="font-family:幼圆; font-size:7pt">
		</span>
