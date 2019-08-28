---
title: make Image uImage与zImage的区别
id: 478
comment: false
categories:
  - arm
date: 2016-05-16 17:13:38
tags:
---

<span style="color:#656e6a; font-size:10pt"><span style="font-family:宋体">内核编译（</span><span style="font-family:Arial">make</span><span style="font-family:宋体">）之后会生成两个文件，一个</span><span style="font-family:Arial">Image</span><span style="font-family:宋体">，一个</span><span style="font-family:Arial">zImage</span><span style="font-family:宋体">，其中</span><span style="font-family:Arial">Image</span><span style="font-family:宋体">为内核映像文件，而</span><span style="font-family:Arial">zImage</span><span style="font-family:宋体">为内核的一种映像压缩文件，</span><span style="font-family:Arial">Image</span><span style="font-family:宋体">大约为</span><span style="font-family:Arial">4M</span><span style="font-family:宋体">，而</span><span style="font-family:Arial">zImage</span><span style="font-family:宋体">不到</span><span style="font-family:Arial">2M</span><span style="font-family:宋体">。</span><span style="font-family:Arial">
			</span></span>
<!-- more -->

<span style="color:#656e6a; font-size:10pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">那么</span><span style="font-family:Arial">uImage</span><span style="font-family:宋体">又是什么的？它是</span><span style="font-family:Arial">uboot</span><span style="font-family:宋体">专用的映像文件，它是在</span><span style="font-family:Arial">zImage</span><span style="font-family:宋体">之前加上一个长度为</span><span style="font-family:Arial">64</span><span style="font-family:宋体">字节的</span><span style="font-family:Arial">"</span><span style="font-family:宋体">头</span><span style="font-family:Arial">"</span><span style="font-family:宋体">，说明这个内核的版本、加载位置、生成时间、大小等信息；其</span><span style="font-family:Arial">0x40</span><span style="font-family:宋体">之后与</span><span style="font-family:Arial">zImage</span><span style="font-family:宋体">没区别。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#656e6a; font-size:10pt"><span style="font-family:Arial">     </span><span style="font-family:宋体">如</span><span style="font-family:Arial">
			</span><span style="font-family:宋体">何生成</span><span style="font-family:Arial">uImage</span><span style="font-family:宋体">文件？首先在</span><span style="font-family:Arial">uboot</span><span style="font-family:宋体">的</span><span style="font-family:Arial">/tools</span><span style="font-family:宋体">目录下寻找</span><span style="font-family:Arial">mkimage</span><span style="font-family:宋体">文件，把其</span><span style="font-family:Arial">copy</span><span style="font-family:宋体">到系统</span><span style="font-family:Arial">/usr/local/bin</span><span style="font-family:宋体">目录下，这样就</span><span style="font-family:Arial">
			</span><span style="font-family:宋体">完成制作工具。然后在内核目录下运行</span><span style="font-family:Arial">make uImage</span><span style="font-family:宋体">，如果成功，便可以在</span><span style="font-family:Arial">arch/arm/boot/</span><span style="font-family:宋体">目录下发现</span><span style="font-family:Arial">uImage</span><span style="font-family:宋体">文件，其大小比</span><span style="font-family:Arial"> zImage</span><span style="font-family:宋体">多</span><span style="font-family:Arial">64</span><span style="font-family:宋体">个字节。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#656e6a; font-size:10pt"><span style="font-family:宋体">其实就是一个自动跟手动的区别</span><span style="font-family:Arial">,</span><span style="font-family:宋体">有了</span><span style="font-family:Arial">uImage</span><span style="font-family:宋体">头部的描述</span><span style="font-family:Arial">,u-boot</span><span style="font-family:宋体">就知道对应</span><span style="font-family:Arial">Image</span><span style="font-family:宋体">的信息</span><span style="font-family:Arial">,</span><span style="font-family:宋体">如果没有头部则需要自己手动去搞那些参数。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#656e6a; font-size:10pt"><span style="font-family:Arial">U-boot</span><span style="font-family:宋体">的</span><span style="font-family:Arial">U</span><span style="font-family:宋体">是</span><span style="font-family:Arial">"</span><span style="font-family:宋体">通用</span><span style="font-family:Arial">"</span><span style="font-family:宋体">的意思。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#656e6a; font-size:10pt"><span style="font-family:Arial">zImage </span><span style="font-family:宋体">是</span><span style="font-family:Arial">ARM Linux</span><span style="font-family:宋体">常用的一种压缩映像文件，</span><span style="font-family:Arial">uImage</span><span style="font-family:宋体">是</span><span style="font-family:Arial">U-boot</span><span style="font-family:宋体">专用的映像文件，它是在</span><span style="font-family:Arial">zImage</span><span style="font-family:宋体">之前加上一个长度为</span><span style="font-family:Arial">0x40</span><span style="font-family:宋体">的</span><span style="font-family:Arial">"</span><span style="font-family:宋体">头</span><span style="font-family:Arial">"</span><span style="font-family:宋体">，说明</span><span style="font-family:Arial">
			</span><span style="font-family:宋体">这个映像文件的类型、加载位置、生成时间、大小等信息。换句话说，如果直接从</span><span style="font-family:Arial">uImage</span><span style="font-family:宋体">的</span><span style="font-family:Arial">0x40</span><span style="font-family:宋体">位置开始执行，</span><span style="font-family:Arial">zImage</span><span style="font-family:宋体">和</span><span style="font-family:Arial">uImage</span><span style="font-family:宋体">没有任何区</span><span style="font-family:Arial">
			</span><span style="font-family:宋体">别。另外，</span><span style="font-family:Arial">Linux2.4</span><span style="font-family:宋体">内核不支持</span><span style="font-family:Arial">uImage</span><span style="font-family:宋体">，</span><span style="font-family:Arial">Linux2.6</span><span style="font-family:宋体">内核加入了很多对嵌入式系统的支持，但是</span><span style="font-family:Arial">uImage</span><span style="font-family:宋体">的生成也需要设置。</span><span style="font-family:Arial">
			</span></span>
