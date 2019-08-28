---
title: 补丁(patch)的制作与应用
id: 516
comment: false
categories:
  - arm
date: 2016-05-18 19:14:23
tags:
---

1.  <div style="background: white;">

如果hack了开源代码，为了方便分享（如提交Bug）或自己留存使用，一般都要制作一个补丁（Patch）。在从源码安装软件时，也难免要应用些别人做好的补丁。本文介绍如何制作和应用补丁。<sup>[[1]](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#cite_note-0)</sup>
<!-- more -->

&nbsp;
<table>
<tbody>
<tr>
<td>**目录**

·         [1 命令简介](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#.E5.91.BD.E4.BB.A4.E7.AE.80.E4.BB.8B)

o    [1.1 diff](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#diff)

o    [1.2 patch](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#patch)

o    [1.3 应用](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#.E5.BA.94.E7.94.A8)

·         [2 patch文件构成](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#patch.E6.96.87.E4.BB.B6.E6.9E.84.E6.88.90)

·         [3 实例分析](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#.E5.AE.9E.E4.BE.8B.E5.88.86.E6.9E.90)

o    [3.1 单文件补丁](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#.E5.8D.95.E6.96.87.E4.BB.B6.E8.A1.A5.E4.B8.81)

o    [3.2 文件夹补丁](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#.E6.96.87.E4.BB.B6.E5.A4.B9.E8.A1.A5.E4.B8.81)

·         [4 参考资料](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#.E5.8F.82.E8.80.83.E8.B5.84.E6.96.99)</td>
</tr>
</tbody>
</table>
**命令简介**

用到的两个命令是diff和patch。

**diff**

**diff**可以比较两个东西，并可同时记录下二者的区别。制作补丁时的一般用法和常见选项为：

diff 【选项】 源文件（夹） 目的文件（夹）

**-r**

递归。设置后diff会将两个不同版本源代码目录中的所有对应文件全部都进行一次比较，包括子目录文件。

**-N**

选项确保补丁文件将正确地处理已经创建或删除文件的情况。

**-u**

输出每个修改前后的3行，也可以用-u5等指定输出更多上下文。

**-E, -b, -w, -B, --strip-trailing-cr**

忽略各种空白，可参见文档，按需选用。

**patch**

**patch**的作用则是将diff记录的结果（即补丁）应用到相应文件（夹）上。最常见的用法为：

patch -pNUM &lt;patchfile&gt;

**-p Num**

忽略几层文件夹，随后详解。

**-E**

选项说明如果发现了空文件，那么就删除它

**-R**

取消打过的补丁。

为了解释 _-p_ 参数，需要看看如下patch文件片段：

--- old/modules/pcitable       Mon Sep 27 11:03:56 1999

+++ new/modules/pcitable       Tue Dec 19 20:05:41 2000

如果使用参数 **-p0**，那就表示从当前目录找一个叫做old的文件夹，再在它下面寻找 _modules/pcitable_ 文件来执行patch操作。
而如果使用参数 **-p1**，那就表示忽略第一层目录（即不管old），从当前目录寻找 _modules_ 的文件夹，再在它下面找pcitable。

**应用**

利用以上命令，处理单个文件补丁的方法：

_# __产生补丁_

**diff** -uN from-file to-file **&gt;**to-file.patch

&nbsp;

_# __打补丁_

**patch** -p0 **&lt;** to-file.patch

&nbsp;

_# __取消补丁_

**patch** -RE -p0 **&lt;** to-file.patch

对整个文件夹打补丁的情况：

_# __产生补丁_

**diff** -uNr  from-docu  to-docu  **&gt;**to-docu.patch

&nbsp;

_# __打补丁_

**cd** to-docu

**patch** -p1 **&lt;** to-docu.patch

&nbsp;

_# __取消补丁_

**patch** -R -p1 **&lt;**to-docu.patch

另外，使用版本控制工具时，可以直接用_svn diff_或_git diff_生成补丁文件。

值得一提的是，由于应用补丁时的目标代码和生成补丁时的代码未必相同，打补丁操作可能失败。补丁失败的文件会以.rej结尾，下面命令可以找出所有rej文件：

find . -name '*.rej'

**patch****文件构成**

补丁文件里到底存储了哪些信息呢？看看这个例子：

--- test0       2006-08-18 09:12:01.000000000 +0800

+++ test1       2006-08-18 09:13:09.000000000 +0800

@@ -1,3 +1,4 @@

+222222

111111

-111111

+222222

111111

**补丁头**

补丁头是分别由---/+++开头的两行，用来表示要打补丁的文件。---开头表示旧文件，+++开头表示新文件。

**一个补丁文件中的多个补丁**

一个补丁文件中可能包含以---/+++开头的很多节，每一节用来打一个补丁。所以在一个补丁文件中可以包含好多个补丁。

**块**

块是补丁中要修改的地方。它通常由一部分不用修改的东西开始和结束。他们只是用来表示要修改的位置。他们通常以@@开始，结束于另一个块的开始或者一个新的补丁头。

**块的缩进**

块会缩进一列，而这一列是用来表示这一行是要增加还是要删除的。

**块的第一列**

+号表示这一行是要加上的。-号表示这一行是要删除的。没有加号也没有减号表示这里只是引用的而不需要修改。

**实例分析**

**单文件补丁**

设当前目录有文件 **test0**：

111111

111111

111111

和文件**test1**：

222222

111111

222222

111111

使用diff创建补丁**test1.patch**

**diff** -uN test0 test1 **&gt;** test1.patch

因为是单个文件，故不需要 -r 选项。此命令得到如下补丁：

--- test0       2006-08-18 09:12:01.000000000 +0800

+++ test1       2006-08-18 09:13:09.000000000 +0800

@@ -1,3 +1,4 @@

+222222

111111

-111111

+222222

111111

要应用补丁，只需：

$ **patch** -p0 **&lt;** test1.patch

patching **file** test0

此时test0就和test1一样了。

如果要取消补丁做出的更改，恢复旧版本：

$ **patch** -RE -p0 **&lt;** test1.patch

patching **file** test0

**文件夹补丁**

设有如下环境：

--prj0/

test0

prj0name

--prj1/

test1

prj1name

_prj0/prj0name_内容为如下三行：

--------

prj0/prj0name

--------

_prj1/prj1name_内容为如下三行：

--------

prj1/prj1name

--------

用 _diff -uNr_ 创建补丁，

**diff** -uNr prj0 prj1 **&gt;** prj1.patch

得到的patch文件为：

diff -uNr prj0/prj0name prj1/prj0name

--- prj0/prj0name       2006-08-18 09:25:11.000000000 +0800

+++ prj1/prj0name       1970-01-01 08:00:00.000000000 +0800

@@ -1,3 +0,0 @@

---------

-prj0/prj0name

---------

diff -uNr prj0/prj1name prj1/prj1name

--- prj0/prj1name       1970-01-01 08:00:00.000000000 +0800

+++ prj1/prj1name       2006-08-18 09:26:36.000000000 +0800

@@ -0,0 +1,3 @@

+---------

+prj1/prj1name

+---------

diff -uNr prj0/test0 prj1/test0

--- prj0/test0  2006-08-18 09:23:53.000000000 +0800

+++ prj1/test0  1970-01-01 08:00:00.000000000 +0800

@@ -1,3 +0,0 @@

-111111

-111111

-111111

diff -uNr prj0/test1 prj1/test1

--- prj0/test1  1970-01-01 08:00:00.000000000 +0800

+++ prj1/test1  2006-08-18 09:26:00.000000000 +0800

@@ -0,0 +1,4 @@

+222222

+111111

+222222

+111111

如果要应用此补丁，则：

$ **ls**

prj0  prj1  prj1.patch

$ **cd** prj0

$ **patch** -p1 **&lt;** ..**/**prj1.patch

patching **file** prj0name

patching **file** prj1name

patching **file** test0

patching **file** test1

此时可用[ls](http://linux-wiki.cn/wiki/Ls)看到打补丁后的结果：

$ **ls**

prj1name  test1

类似的，如果要回滚补丁操作：

$ **patch** -R -p1 **&lt;** ..**/**prj1.patch

patching **file** prj0name

patching **file** prj1name

patching **file** test0

patching **file** test1

$ **ls**

prj0name  test0

**参考资料**

    1.  [↑](http://linux-wiki.cn/wiki/zh-hans/%E8%A1%A5%E4%B8%81(patch)%E7%9A%84%E5%88%B6%E4%BD%9C%E4%B8%8E%E5%BA%94%E7%94%A8#cite_ref-0)[Linux下patch的制作和应用](http://www.cublog.cn/u/21948/showart_157145.html)
<span style="color: #333333; font-size: 12pt;"><span style="color: #2153b0;"><span style="color: #333333; font-family: Tahoma;">
</span></span></span>

</div>
