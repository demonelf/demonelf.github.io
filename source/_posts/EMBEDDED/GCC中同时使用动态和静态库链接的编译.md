---
title: GCC中同时使用动态和静态库链接的编译
id: 428
comment: false
categories:
  - arm
date: 2016-05-11 10:56:50
tags:
---

<span style="font-size:12pt"><span style="color:black"><span style="font-family:Arial; background-color:white"> </span><span style="font-family:宋体; background-color:white">如何同时同时使用动态和静态库链接，在</span><span style="font-family:Arial; background-color:white">GCC</span><span style="font-family:宋体; background-color:white">指令参数中具体参数如下：</span><span style="font-family:Arial"><span style="background-color:white"> </span>
<span style="background-color:white">    </span></span><span style="font-family:宋体; background-color:white">－</span><span style="font-family:Arial"><span style="background-color:white">Wl,-Bstatic -L/usr/local/sqlite-arm-linux/.libs -lsqlite -Wl,-Bdynamic -L/usr/local/arm/3.3.2/lib </span>
<span style="background-color:white">  </span>
<span style="background-color:white"> </span></span><span style="font-family:宋体; background-color:white">具体用途解释：</span><span style="font-family:Arial; background-color:white">sqlite</span><span style="font-family:宋体; background-color:white">库静态连接，其它库动态连接。</span><span style="font-family:Arial"><span style="background-color:white"> </span>
</span><span style="font-family:宋体; background-color:white">－</span><span style="font-family:Arial; background-color:white">Wl,-Bstatic </span><span style="font-family:宋体; background-color:white">与</span><span style="font-family:Arial; background-color:white">-Wl,-Bdynamic</span><span style="font-family:宋体; background-color:white">参数，从字面意义上可以理解，有静态和动态的意思，但是具体的真正规则在查找了</span><span style="font-family:Arial; background-color:white">GCC</span><span style="font-family:宋体; background-color:white">的原版手册上有说明。</span><span style="font-family:Arial"><span style="background-color:white"> </span>
<span style="background-color:white">  </span>
</span><span style="font-family:宋体; background-color:white">原文：</span><span style="font-family:Arial"><span style="background-color:white"> </span>
<span style="background-color:white">Note - if the linker is being invoked indirectly, via a compiler driver (eg gcc) then all the linker command line options should be prefixed by -Wl, (or whatever is appropriate for the particular compiler driver) like this: </span>
</span></span><span style="font-family:宋体">
			</span></span>

<!-- more -->
[<span style="color:blue; font-family:Arial; font-size:12pt; text-decoration:underline">?</span>](http://my.oschina.net/liangzi1210/blog/172913)<span style="color:black; font-family:Arial; font-size:12pt">
		</span>
<div><table style="border-collapse:collapse" border="0"><colgroup><col style="width:36px"/><col style="width:651px"/></colgroup><tbody valign="top"><tr><td vAlign="middle">

<span style="font-family:宋体; font-size:12pt">1</span>
</td><td vAlign="middle">

<span style="font-family:宋体; font-size:12pt">gcc -Wl,--startgroup foo.o bar.o -Wl,--endgroup</span>
</td></tr></tbody></table></div>

<span style="color:black"><span style="font-size:12pt"><span style="font-family:Arial"><span style="background-color:white">   </span>
<span style="background-color:white">This is important, because otherwise the compiler driver program may silently drop the linker options, resulting in a bad link. </span>

</span><span style="font-family:宋体; background-color:white">实际上主要针对隐式应用</span><span style="font-family:Arial; background-color:white">LINKER</span><span style="font-family:宋体; background-color:white">的参数，用</span><span style="font-family:Arial; background-color:white">"-Wl</span><span style="font-family:宋体; background-color:white">，</span><span style="font-family:Arial; background-color:white">"</span><span style="font-family:宋体; background-color:white">来标识，</span><span style="font-family:Arial; background-color:white">,"--startgroup foo.o bar.o -Wl,--endgroup"</span><span style="font-family:宋体; background-color:white">表示一组，</span><span style="font-family:Arial; background-color:white">,-Bstatic -Bdynamic </span><span style="font-family:宋体; background-color:white">作为关键字与－</span><span style="font-family:Arial; background-color:white">WL,</span><span style="font-family:宋体; background-color:white">不可分，在</span><span style="font-family:Arial; background-color:white">GCC</span><span style="font-family:宋体; background-color:white">连接库时，默认链接是动态链接，现在用上面的指令限制在链接</span><span style="font-family:Arial; background-color:white">sqlite</span><span style="font-family:宋体; background-color:white">库时采用静态链接。</span></span><span style="font-family:Arial"><span style="font-size:12pt"><span style="background-color:white"> </span>
</span><span style="font-size:10pt; background-color:white"> </span><span style="font-size:12pt"><span style="background-color:white"> </span>
<span style="background-color:white">-Bstatic </span></span></span><span style="font-size:12pt"><span style="font-family:宋体; background-color:white">还有三个写法：</span><span style="font-family:Arial; background-color:white"> -dn</span><span style="font-family:宋体; background-color:white">和</span><span style="font-family:Arial; background-color:white">-non_shared </span><span style="font-family:宋体; background-color:white">和</span><span style="font-family:Arial"><span style="background-color:white">-static </span>

</span></span></span><span style="font-family:宋体; font-size:12pt">
		</span>

<span style="color:black; font-size:12pt"><span style="font-family:Arial">-Bdynamic </span><span style="font-family:宋体">还有两个写法：</span><span style="font-family:Arial">-dy </span><span style="font-family:宋体">和</span><span style="font-family:Arial">-call_shared
</span></span>

<span style="font-size:12pt"><span style="color:black"><span style="font-family:宋体; background-color:white">上面参数</span><span style="font-family:Arial; background-color:white">"-L/usr/local/sqlite-arm-linux/.libs "</span><span style="font-family:宋体; background-color:white">放不放在</span><span style="font-family:Arial; background-color:white">-Wl,...</span><span style="font-family:宋体; background-color:white">之间无所谓，因为它只是提供了</span><span style="font-family:Arial; background-color:white">sqlite</span><span style="font-family:宋体; background-color:white">动静态库的位置。可以改成下面的参数形式，更直观。</span><span style="font-family:Arial"><span style="background-color:white"> </span>
</span></span><span style="font-family:宋体">
			</span></span>

[<span style="color:blue; font-family:Arial; font-size:12pt; text-decoration:underline">?</span>](http://my.oschina.net/liangzi1210/blog/172913)<span style="color:black; font-family:Arial; font-size:12pt">
		</span>
<div><table style="border-collapse:collapse" border="0"><colgroup><col style="width:36px"/><col style="width:798px"/></colgroup><tbody valign="top"><tr><td vAlign="middle">

<span style="font-family:宋体; font-size:12pt">1</span>
</td><td vAlign="middle">

<span style="font-family:宋体; font-size:12pt">-L/usr/local/sqlite-arm-linux/.libs -L/usr/local/arm/3.3.2/lib -Wl,-dn -lsqlite -Wl,-dy</span>
</td></tr></tbody></table></div>

<span style="font-size:12pt"><span style="color:black"><span style="font-family:Arial">
</span><span style="font-family:宋体; background-color:white">－</span><span style="font-family:Arial; background-color:white">Wl,-dn </span><span style="font-family:宋体; background-color:white">和</span><span style="font-family:Arial; background-color:white"> -Wl,-dy</span><span style="font-family:宋体; background-color:white">成对出现才能起到标题所说的作用。</span><span style="font-family:Arial"><span style="background-color:white">   </span>

</span></span><span style="font-family:宋体">
			</span></span>

<span style="color:black; font-size:12pt"><span style="font-family:宋体">关于</span><span style="font-family:Arial">-Wl,</span><span style="font-family:宋体">后面的参数还有很多，全部明白我也不能。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:12pt"><span style="font-family:宋体; background-color:white">还有一个问题值得注意，在</span><span style="font-family:Arial; background-color:white">-Wl,</span><span style="font-family:宋体; background-color:white">后面不能有空格，否则会出错！</span><span style="font-family:Arial"><span style="background-color:white"> </span>

</span><span style="font-family:宋体; background-color:white">关于</span><span style="font-family:Arial; background-color:white">-Wl,option </span><span style="font-family:宋体; background-color:white">说明还有一段说明</span><span style="font-family:Arial"><span style="background-color:white"> </span>

<span style="background-color:white">GCC</span></span><span style="font-family:宋体; background-color:white">命令参数的英文原文</span><span style="font-family:Arial"><span style="background-color:white"> </span>

<span style="background-color:white">-Wl,option </span>

<span style="background-color:white">Pass option as an option to the linker. If option contains commas, it is split into multiple options at the commas. </span>

</span><span style="font-family:宋体; background-color:white">传递参数</span><span style="font-family:Arial; background-color:white">option</span><span style="font-family:宋体; background-color:white">作为</span><span style="font-family:Arial; background-color:white">linker</span><span style="font-family:宋体; background-color:white">的一个参数，如果</span><span style="font-family:Arial; background-color:white">option</span><span style="font-family:宋体; background-color:white">包含逗号，将在逗号处分割成几个参数。</span><span style="font-family:Arial"><span style="background-color:white"> </span>

</span><span style="font-family:宋体; background-color:white">例如：</span><span style="font-family:Arial"><span style="background-color:white"> </span>

<span style="background-color:white">-Wl,-dn –lsqlite </span>

</span><span style="font-family:宋体; background-color:white">－</span><span style="font-family:Arial; background-color:white">dn </span><span style="font-family:宋体; background-color:white">开始静态链接</span><span style="font-family:Arial"><span style="background-color:white"> </span>

</span><span style="font-family:宋体; background-color:white">－</span><span style="font-family:Arial; background-color:white">lsqlite </span><span style="font-family:宋体; background-color:white">静态链接</span><span style="font-family:Arial; background-color:white">sqlite</span><span style="font-family:宋体; background-color:white">库</span><span style="font-family:Arial"><span style="background-color:white"> </span>

</span><span style="font-family:宋体; background-color:white">静态链接完后，然后需要动态链接</span><span style="font-family:Arial"><span style="background-color:white"> </span>

<span style="background-color:white">-Wl,-dy </span>

</span><span style="font-family:宋体; background-color:white">重新开始动态链接。</span><span style="font-family:Arial; background-color:white"> </span></span>
