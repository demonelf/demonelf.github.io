---
title: Gentoo Linux 内核更新指南
id: 653
comment: false
categories:
  - arm
date: 2016-06-10 22:32:54
tags:
---

<span class="chapnum">1.  </span>简介

内核是Portage树中少数几个需要部分人工介入方可完成更新的包之一。Portage会为你下载并安装内核源码，但需要你手动编译新的内核，才能让更改生效。
<!-- more -->

这份指南是关于如何从一个内核版本更新到另一个版本的，然而，对希望切换到另一个内核包的用户同样有用。

本文使用<span class="code" dir="ltr">gentoo-sources</span>作为例子，然而，这里的操作适用于我们树中的其他内核包。

<a name="doc_chap2"></a><span class="chapnum">2.  </span>为什么更新内核？

一般而言，小的内核版本更新不会带来什么巨大的差别。更新内核有若干原因，包括使用最新驱动或某个最新特性，免受安全漏洞威胁，或仅仅是为了保持系统始终处于最新和健康的状态。

即使你选择不是每次有新的内核版本都去更新，我们也建议你时不时的更新到最新的内核。当新内核解决了某个安全问题时，则强烈建议你更新到这一版本。

<a name="doc_chap3"></a><span class="chapnum">3.  </span>通过Portage获取新的内核

更新内核源码和更新其他包一样：使用<span class="code" dir="ltr">emerge</span>工具。当在world更新列表中看到新的内核版本时，你或许希望做一次内核更新。例如：

<a name="doc_chap3_pre1"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 3.1: 新内核源码出现在更新列表

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">emerge -Dup world</span>
Calculating dependencies ...done!
[ebuild    NS ] sys-kernel/gentoo-sources-2.6.9-r2 [2.6.8-r5]
</pre>
</td>
</tr>
</tbody>
</table>
<table class="ncontent" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#bbffbb">

**注意: **上面输出中的"NS"标志意味着，新的内核将会安装到新的slot中，也就是说旧内核源码会保留下来，直到你手动移除它。

</td>
</tr>
</tbody>
</table>
你可以继续下去，执行更新，例如：

<a name="doc_chap3_pre2"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 3.2: 更新你的内核源码

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">emerge -u gentoo-sources</span>
</pre>
</td>
</tr>
</tbody>
</table>
这样，内核源码就会被安装到<span class="path" dir="ltr">/usr/src</span>的某个子目录中。对于上面的例子，新内核源码会安装在<span class="path" dir="ltr">/usr/src/linux-2.6.9-gentoo-r2</span>。

<a name="doc_chap4"></a><span class="chapnum">4.  </span>更新/usr/src/linux符号链接

Gentoo要求符号链接<span class="path" dir="ltr">/usr/src/linux</span>指向正在运行的内核的源代码。

当你emerge新内核源码时，Portage能自动更新这个链接。你需要做的是将<span class="code" dir="ltr">symlink</span>标志添加到<span class="path" dir="ltr">/etc/make.conf</span>中的USE变量中。

<a name="doc_chap4_pre1"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 4.1: /etc/make.conf中USE变量示例

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre><span class="code-comment">（添加关键字symlink）</span>
USE="<span class="code-input">symlink</span> x86 3dnow 3dnowex X aac aalib adns alsa apache2"
</pre>
</td>
</tr>
</tbody>
</table>
你也可以选择使用<span class="code" dir="ltr">app-admin/eselect</span>来修改该符号链接。

<a name="doc_chap4_pre2"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 4.2: 用eselect管理符号链接

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre><span class="code-comment">（如果还没有则安装eslect）</span>
# <span class="code-input">emerge eselect</span>
<span class="code-comment">（查看可用内核列表）</span>
# <span class="code-input">eselect kernel list</span>
Available kernel symlink targets:
  [1]   linux-2.6.9-gentoo-r1
  [2]   linux-2.6.9-gentoo-r2
<span class="code-comment">（选择正确的内核）</span>
# <span class="code-input">eselect kernel set 1</span>
</pre>
</td>
</tr>
</tbody>
</table>
要是你真的想要自己做，下面的例子说明如何将链接指向<span class="path" dir="ltr">linux-2.6.9-gentoo-r2</span>：

<a name="doc_chap4_pre3"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 4.3: 手动更新/usr/src/linux符号链接

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">cd /usr/src</span>
# <span class="code-input">ln -sfn linux-2.6.9-gentoo-r2 linux</span>
</pre>
</td>
</tr>
</tbody>
</table>

<a name="install"></a><a name="doc_chap5"></a><span class="chapnum">5.  </span>配置、编译并安装新的内核

对下面的每一种方式，你都应参考[Gentoo手册](http://www.gentoo.org/doc/zh_cn/handbook/)中关于<span class="emphasis">配置内核</span>和<span class="emphasis">配置引导程序</span>的指示。以下是所需操作的概述：

<a name="doc_chap5_sect2"></a>方式一：用Genkernel自动设置内核

如果你是genkernel用户，你只需重复执行第一次安装内核时所做的步骤就可以了。

正常运行genkernel就行了：

<a name="doc_chap5_pre1"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 5.1: 运行genkernel

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">genkernel all</span>
</pre>
</td>
</tr>
</tbody>
</table>
通过附加参数，你可以使用genkernel的其他功能。例如，如果你希望用<span class="code" dir="ltr">menuconfig</span>配置额外的内核选项，并自动更新grub引导程序配置，可以如下启动genkernel：

<a name="doc_chap5_pre2"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 5.2: 运行genkernel时附加常用参数

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">genkernel --menuconfig --bootloader=grub all</span>
</pre>
</td>
</tr>
</tbody>
</table>
更多详情，参看[Gentoo Linux Genkernel指南](http://www.gentoo.org/doc/en/genkernel.xml)，或者参考[Gentoo手册](http://www.gentoo.org/doc/zh_cn/handbook/)。许多选项可以在<span class="code" dir="ltr">genkernel</span>的配置文件<span class="path" dir="ltr">/etc/genkernel.conf</span>中指定。

<a name="doc_chap5_sect3"></a>方式二：手动配置

首先，使用内核代码树中的<span class="code" dir="ltr">menuconfig</span>工具：

<a name="doc_chap5_pre3"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 5.3: 运行menuconfig

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">cd /usr/src/linux</span>
# <span class="code-input">make menuconfig</span>
</pre>
</td>
</tr>
</tbody>
</table>
请选择你的硬件和操作环境所需的选项。更多关于内核配置的信息，参见[Gentoo手册](http://www.gentoo.org/doc/zh_cn/handbook/index.xml)中题为<span class="emphasis">配置内核</span>的章节。

接下来，编译你的内核并复制到启动分区中。同样，请参考[Gentoo手册](http://www.gentoo.org/doc/zh_cn/handbook/index.xml)中<span class="emphasis">配置引导程序</span>一章所列出的步骤。如果<span class="path" dir="ltr">/boot</span>是一个单独的分区，在复制编译好的内核前，确认它已挂载！否则，你就无法启动系统运行新的内核。

<a name="doc_chap5_pre4"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 5.4: 编译并安装新的内核

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">make &amp;&amp; make modules_install</span>
# <span class="code-input">mount /boot</span>
# <span class="code-input">cp arch/i386/boot/bzImage /boot/bzImage-2.6.9-gentoo-r2</span>
</pre>
</td>
</tr>
</tbody>
</table>
最后，你应该更新引导程序配置文件，增加新内核的条目（先不要删除旧的！），然后卸载<span class="path" dir="ltr">/boot</span>分区。同样，参阅[Gentoo手册](http://www.gentoo.org/doc/zh_cn/handbook/index.xml)，了解这个过程更详细的指示。

<a name="doc_chap6"></a><span class="chapnum">6.  </span>重新安装外部模块

如果你使用了不包含在内核代码树，而是由Portage中其他地方提供的内核模块（例如ALSA驱动，以及NVIDIA或ATI显示驱动），那么更新内核后，你需要重新安装这些模块。很简单，只需重新emerge涉及到的包即可。更多信息，参考[Gentoo手册](http://www.gentoo.org/doc/zh_cn/handbook/)中关于<span class="emphasis">配置内核</span>的章节。

我们为你提供了一个简易的工具（<span class="code" dir="ltr">sys-kernel/module-rebuild</span>），它能重新编译你安装的所有独立的（与<span class="path" dir="ltr">/usr/src/linux</span>的内核使用不同的ebuild）内核模块。它的用法非常直观。安装后，运行<span class="code" dir="ltr">module-rebuild populate</span>生成一个[数据库](http://lib.csdn.net/base/14 "MySQL知识库")，其中包含所有更新内核后需要重新编译的包的列表。当你完成更新并重新编译内核后，运行<span class="code" dir="ltr">module-rebuild rebuild</span>重新编译对应新内核的驱动。

更多信息，请不带参数运行<span class="code" dir="ltr">module-rebuild</span>，这会显示支持的命令列表。

<a name="doc_chap7"></a><span class="chapnum">7.  </span>重启到新的内核

接着，关闭所有应用程序并重启系统。如果上面的步骤没有做错，那么引导程序菜单中将会出现新内核的条目。选择新的内核并启动系统。

一切顺利的话，新内核成功启动，登录后你可以继续工作了。这样的话，更新就宣告完成了。

如果你犯了错误，新内核无法启动，那么重启系统，在引导程序中选择上次可以运行的内核。接着你可以重新[配置，编译并安装新内核](http://www.gentoo.org/doc/zh_cn/kernel-upgrade.xml#install)，对错误做出适当的修正。某些情况下，你甚至无需重启就可以进行这些操作，例如少安装了声卡驱动、网卡驱动等等。

<a name="doc_chap8"></a><span class="chapnum">8.  </span>运行多个内核

你可能已经注意到了，当安装新内核的源代码时，现有内核的源码没有被删除。这是有意为之的，这样你就可以很方便的在运行不同内核间切换。

在多个内核间切换非常简单。你只需保留<span class="path" dir="ltr">/usr/src/</span>中的内核源代码，并保留<span class="path" dir="ltr">/boot</span>分区中的二进制文件<span class="path" dir="ltr">bzImage</span>就可以了，后者会与引导程序配置中的一项相对应。每次启动时，你都有机会选择启动到哪个内核。

<a name="doc_chap9"></a><span class="chapnum">9.  </span>删除旧的内核

接着上一节，你或许对新内核感到满意，不再需要保留旧内核了。要想删除除了最新内核外的其他版本内核源码，你可以利用<span class="code" dir="ltr">emerge</span>中的<span class="emphasis">prune</span>选项。下面是针对<span class="code" dir="ltr">gentoo-sources</span>的例子：

<a name="doc_chap9_pre1"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 9.1: 删除旧版本

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">emerge -P gentoo-sources</span>
</pre>
</td>
</tr>
</tbody>
</table>
一般情况下，编译过程中产生的临时文件仍然会保留在<span class="path" dir="ltr">/usr/src</span>下的对应目录中。你可以安全的用<span class="code" dir="ltr">rm</span>删除这些文件。

你也可以安全的删除所有旧内核使用的模块。这能通过删除<span class="path" dir="ltr">/lib/modules/</span>目录下与删除的内核版本相应的子目录来完成。小心不要删除了还在使用的内核的模块！

最后，你可以挂载<span class="path" dir="ltr">/boot</span>分区，删除你刚才卸载的内核的<span class="path" dir="ltr">bzImage</span>文件。你还应该编辑引导程序的配置，删去对应已卸载内核的项。

<a name="doc_chap10"></a><span class="chapnum">10.  </span>高级：用你旧.config文件配置新内核

有时，配置新内核时重用旧内核的配置文件能够节省时间。需要注意的是，一般这是不安全的——每次版本更新都会带来很多改变，使得这种更新途径并不可靠。

唯一适用于这种方法的场合，是从一个Gentoo内核修订版升级到另一个。例如，从<span class="code" dir="ltr">gentoo-sources-2.6.9-r1</span>到<span class="code" dir="ltr">gentoo-sources-2.6.9-r2</span>的改变会非常微小，所以一般可以使用下面的方法。然而，这种方法不适用于本文中一直使用的例子，即从2.6.8更新到2.6.9。官方发行版本之间的改动太多，下面叙述的方法没有向用户提示足够的相关信息，这经常会导致用户因禁用了本不想禁用的选项而出现问题。

利用你旧有的<span class="path" dir="ltr">.config</span>文件，只需把它复制过来，并运行<span class="code" dir="ltr">make oldconfig</span>即可。下面的例子里，我们使用<span class="code" dir="ltr">gentoo-sources-2.6.9-r1</span>的配置文件，并用在<span class="code" dir="ltr">gentoo-sources-2.6.9-r2</span>中。

<a name="doc_chap10_pre1"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 10.1: 重用旧配置

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">cd /usr/src/linux-2.6.9-gentoo-r2</span>
# <span class="code-input">cp ../linux-2.6.9-gentoo-r1/.config .</span>
# <span class="code-input">make oldconfig</span>
</pre>
</td>
</tr>
</tbody>
</table>
<a name="doc_chap10_pre2"></a>
<table class="ntable" border="0" width="100%" cellspacing="0" cellpadding="0">
<tbody>
<tr>
<td bgcolor="#7a5ada">

代码 10.2: 对genkernel重用旧配置

</td>
</tr>
<tr>
<td dir="ltr" align="left" bgcolor="#eeeeff">
<pre># <span class="code-input">cd /etc/kernels</span>
# <span class="code-input">cp kernel-config-x86-2.6.9-gentoo-r1 kernel-config-x86-2.6.9-gentoo-r2</span>
# <span class="code-input">genkernel all</span>
</pre>
</td>
</tr>
</tbody>
</table>
这时，你需要回答若干个问题，以决定在两个版本之间改变的那些配置选项。完成之后，你就可以正常编译并安装内核，不用再进行<span class="code" dir="ltr">menuconfig</span>的配置过程。

一个更加安全的办法是，同样方法复制你的配置文件，接着运行<span class="code" dir="ltr">make menuconfig</span>。这能够上面提到的<span class="code" dir="ltr">make oldconfig</span>的问题，因为<span class="code" dir="ltr">make menuconfig</span>会在菜单中中显示这个旧配置文件中尽可能多的内容。现在你所需做的就是浏览每个菜单，寻找新的选项，删除了的选项等等。通过使用<span class="code" dir="ltr">menuconfig</span>，你可以了解所有改变的相关内容，可以更容易的查看新的选择和了解帮助信息。你甚至可以用这种方法来完成例如从2.6.8到2.6.9的更新，只需保证你仔细的查看了每个选项。完成之后，正常编译并安装内核。

<a name="doc_chap11"></a><span class="chapnum">11.  </span>更新内核后出现问题？

Linux内核发展迅速，版本更新带来的改变可能会引起一些问题，这是无法避免的。如果你在最新版本[Gentoo支持的内核](http://www.gentoo.org/doc/en/gentoo-kernel.xml#doc_chap2)中发现了什么问题，请一定报告给我们。
