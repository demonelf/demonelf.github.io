---
title: Linux 时钟管理
id: 574
comment: false
categories:
  - arm
date: 2016-05-27 10:00:20
tags:
---

<span style="color:black; font-size:18pt">**<span style="font-family:Helvetica">Linux </span><span style="font-family:宋体">中的定时器</span><span style="font-family:Helvetica">
				</span>**</span>

<!-- more -->
<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">内核中主要有两种类型的定时器。一类称为</span><span style="font-family:Arial"> timeout </span><span style="font-family:宋体">类型，另一类称为</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">类型。</span><span style="font-family:Arial">timeout </span><span style="font-family:宋体">类型的定时器通常用于检测各种错误条件，例如用于检测网卡收发数据包是否会超时的定时器，</span><span style="font-family:Arial">IO </span><span style="font-family:宋体">设备的读写是否会超时的定时器等等。通常情况下这些错误很少发生，因此，使用</span><span style="font-family:Arial"> timeout </span><span style="font-family:宋体">类型的定时器一般在超时之前就会被移除，从而很少产生真正的函数调用和系统开销。总的来说，使用</span><span style="font-family:Arial"> timeout </span><span style="font-family:宋体">类型的定时器产生的系统开销很小，它是下文提及的</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">通常使用的环境。此外，在使用</span><span style="font-family:Arial"> timeout </span><span style="font-family:宋体">类型定时器的地方往往并不关心超时处理，因此超时精确与否，早</span><span style="font-family:Arial"> 0.01 </span><span style="font-family:宋体">秒或者晚</span><span style="font-family:Arial"> 0.01 </span><span style="font-family:宋体">秒并不十分重要，这在下文论述</span><span style="font-family:Arial"> deferrable timers </span><span style="font-family:宋体">时会进一步介绍。</span><span style="font-family:Arial">timer </span><span style="font-family:宋体">类型的定时器与</span><span style="font-family:Arial"> timeout </span><span style="font-family:宋体">类型的定时器正相反，使用</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">类型的定时器往往要求在精确的时钟条件下完成特定的事件，通常是周期性的并且依赖超时机制进行处理。例如设备驱动通常会定时读写设备来进行数据交互。如何高效的管理</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">类型的定时器对提高系统的处理效率十分重要，下文在介绍</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">时会有更加详细的论述。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">内核需要进行时钟管理，离不开底层的硬件支持。在早期是通过</span><span style="font-family:Arial"> 8253 </span><span style="font-family:宋体">芯片提供的</span><span style="font-family:Arial"> PIT</span><span style="font-family:宋体">（</span><span style="font-family:Arial">Programmable Interval Timer</span><span style="font-family:宋体">）来提供时钟，但是</span><span style="font-family:Arial"> PIT </span><span style="font-family:宋体">的频率很低，只能提供最高</span><span style="font-family:Arial"> 1ms </span><span style="font-family:宋体">的时钟精度，由于</span><span style="font-family:Arial"> PIT </span><span style="font-family:宋体">触发的中断速度太慢，会导致很大的时延，对于像音视频这类对时间精度要求更高的应用并不足够，会极大的影响用户体验。随着硬件平台的不断发展变化，陆续出现了</span><span style="font-family:Arial"> TSC</span><span style="font-family:宋体">（</span><span style="font-family:Arial">Time Stamp Counter</span><span style="font-family:宋体">），</span><span style="font-family:Arial">HPET</span><span style="font-family:宋体">（</span><span style="font-family:Arial">High Precision Event Timer</span><span style="font-family:宋体">），</span><span style="font-family:Arial">ACPI PM Timer</span><span style="font-family:宋体">（</span><span style="font-family:Arial">ACPI Power Management Timer</span><span style="font-family:宋体">），</span><span style="font-family:Arial">CPU Local APIC Timer </span><span style="font-family:宋体">等精度更高的时钟。这些时钟陆续被</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">的时钟子系统所采纳，从而不断的提高</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">时钟子系统的性能和灵活性。这些不同的时钟会在下文不同的章节中分别进行介绍。</span><span style="font-family:Arial">
			</span></span>

[<span style="color:#745285; font-family:宋体; font-size:9pt; text-decoration:underline">**回页首**</span>](https://www.ibm.com/developerworks/cn/linux/l-cn-timerm/)<span style="color:#222222; font-family:Arial; font-size:9pt">
		</span>

<span style="color:black; font-family:Helvetica; font-size:18pt">**Timer wheel
**</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在</span><span style="font-family:Arial"> Linux 2.6.16 </span><span style="font-family:宋体">之前，内核一直使用一种称为</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">的机制来管理时钟。这就是熟知的</span><span style="font-family:Arial"> kernel </span><span style="font-family:宋体">一直采用的基于</span><span style="font-family:Arial"> HZ </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">机制。</span><span style="font-family:Arial">Timer wheel </span><span style="font-family:宋体">的核心数据结构如清单</span><span style="font-family:Arial"> 1 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 1\. Timer wheel </span><span style="font-family:宋体">的核心数据结构</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> #define TVN_BITS (CONFIG_BASE_SMALL ? 4 : 6) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> #define TVR_BITS (CONFIG_BASE_SMALL ? 6 : 8) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> #define TVN_SIZE (1 &lt;&lt; TVN_BITS) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> #define TVR_SIZE (1 &lt;&lt; TVR_BITS) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> #define TVN_MASK (TVN_SIZE - 1) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> #define TVR_MASK (TVR_SIZE - 1) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> struct tvec { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct list_head vec[TVN_SIZE]; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> struct tvec_root { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct list_head vec[TVR_SIZE]; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> struct tvec_base { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        spinlock_t lock; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct timer_list *running_timer; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        unsigned long timer_jiffies; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        unsigned long next_timer; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct tvec_root tv1; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct tvec tv2; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct tvec tv3; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct tvec tv4; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct tvec tv5; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> } ____cacheline_aligned;
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">以</span><span style="font-family:Arial"> CONFIG_BASE_SMALL </span><span style="font-family:宋体">定义为</span><span style="font-family:Arial"> 0 </span><span style="font-family:宋体">为例，</span><span style="font-family:Arial">TVR_SIZE </span><span style="font-family:宋体">＝</span><span style="font-family:Arial"> 256</span><span style="font-family:宋体">，</span><span style="font-family:Arial">TVN_SIZE </span><span style="font-family:宋体">＝</span><span style="font-family:Arial"> 64</span><span style="font-family:宋体">，这样</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">可以得到如图</span><span style="font-family:Arial"> 1 </span><span style="font-family:宋体">所示的</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">的结构。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">图</span><span style="font-family:Arial"> 1\. Timer wheel </span><span style="font-family:宋体">的逻辑结构</span><span style="font-family:Arial">
				</span>**</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052716_0200_Linux1.jpg)<span style="color:black; font-family:Arial; font-size:9pt">
		</span>

<span style="color:#222222; font-size:9pt">**<span style="font-family:Arial">list_head</span><span style="font-family:宋体">的作用</span>**<span style="font-family:Arial">
list_head </span><span style="font-family:宋体">是</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">内核使用的一个双向循环链表表头。任何一个需要使用链表的数据结构可以通过内嵌</span><span style="font-family:Arial"> list_head </span><span style="font-family:宋体">的方式，将其链接在一起从而形成一个双向链表。参见</span><span style="font-family:Arial"> list_head </span><span style="font-family:宋体">在</span><span style="font-family:Arial"> include/Linux/list.h </span><span style="font-family:宋体">中的定义和实现。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">的框架下，所有系统正在使用的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">并不是顺序存放在一个平坦的链表中，因为这样做会使得查找，插入，删除等操作效率低下。</span><span style="font-family:Arial">Timer wheel </span><span style="font-family:宋体">提供了</span><span style="font-family:Arial"> 5 </span><span style="font-family:宋体">个</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">数组，数组之间存在着类似时分秒的进位关系。</span><span style="font-family:Arial">TV1 </span><span style="font-family:宋体">为第一个</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">数组，其中存放着从</span><span style="font-family:Arial"> timer_jiffies</span><span style="font-family:宋体">（当前到期的</span><span style="font-family:Arial"> jiffies</span><span style="font-family:宋体">）到</span><span style="font-family:Arial"> timer_jiffies + 255 </span><span style="font-family:宋体">共</span><span style="font-family:Arial"> 256 </span><span style="font-family:宋体">个</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">对应的</span><span style="font-family:Arial"> timer list</span><span style="font-family:宋体">。因为在一个</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">上可能同时有多个</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">等待超时处理，</span><span style="font-family:Arial">timer wheel </span><span style="font-family:宋体">使用</span><span style="font-family:Arial"> list_head </span><span style="font-family:宋体">将所有</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">串成一个链表，以便在超时时顺序处理。</span><span style="font-family:Arial">TV2 </span><span style="font-family:宋体">有</span><span style="font-family:Arial"> 64 </span><span style="font-family:宋体">个单元，每个单元都对应着</span><span style="font-family:Arial"> 256 </span><span style="font-family:宋体">个</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，因此</span><span style="font-family:Arial"> TV2 </span><span style="font-family:宋体">所表示的超时时间范围从</span><span style="font-family:Arial"> timer_jiffies + 256 </span><span style="font-family:宋体">到</span><span style="font-family:Arial"> timer_jiffies + 256 * 64 – 1</span><span style="font-family:宋体">。依次类推</span><span style="font-family:Arial"> TV3</span><span style="font-family:宋体">，</span><span style="font-family:Arial">TV4</span><span style="font-family:宋体">，</span><span style="font-family:Arial">TV5</span><span style="font-family:宋体">。以</span><span style="font-family:Arial"> HZ=1000 </span><span style="font-family:宋体">为例，每</span><span style="font-family:Arial"> 1ms </span><span style="font-family:宋体">产生一次中断，</span><span style="font-family:Arial">TV1 </span><span style="font-family:宋体">就会被访问一次，但是</span><span style="font-family:Arial"> TV2 </span><span style="font-family:宋体">要每</span><span style="font-family:Arial"> 256ms </span><span style="font-family:宋体">才会被访问一次，</span><span style="font-family:Arial">TV3 </span><span style="font-family:宋体">要</span><span style="font-family:Arial"> 16s</span><span style="font-family:宋体">，</span><span style="font-family:Arial">TV4 </span><span style="font-family:宋体">要</span><span style="font-family:Arial"> 17 </span><span style="font-family:宋体">分钟，</span><span style="font-family:Arial">TV5 </span><span style="font-family:宋体">甚至要</span><span style="font-family:Arial"> 19 </span><span style="font-family:宋体">小时才有机会检查一次。最终，</span><span style="font-family:Arial">timer wheel </span><span style="font-family:宋体">可以管理的最大超时值为</span><span style="font-family:Arial"> 2^32</span><span style="font-family:宋体">。一共使用了</span><span style="font-family:Arial"> 512 </span><span style="font-family:宋体">个</span><span style="font-family:Arial"> list_head</span><span style="font-family:宋体">（</span><span style="font-family:Arial">256+64+64+64+64</span><span style="font-family:宋体">）。如果</span><span style="font-family:Arial"> CONFIG_BASE_SMALL </span><span style="font-family:宋体">定义为</span><span style="font-family:Arial"> 1</span><span style="font-family:宋体">，则最终使用的</span><span style="font-family:Arial"> list_head </span><span style="font-family:宋体">个数为</span><span style="font-family:Arial"> 128 </span><span style="font-family:宋体">个（</span><span style="font-family:Arial">64+16+16+16+16</span><span style="font-family:宋体">），占用的内存更少，更适合嵌入式系统使用。</span><span style="font-family:Arial">Timer wheel </span><span style="font-family:宋体">的处理逻辑如清单</span><span style="font-family:Arial"> 2 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 2\. timer wheel </span><span style="font-family:宋体">的核心处理函数</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> static inline void __run_timers(struct tvec_base *base) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    struct timer_list *timer; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    spin_lock_irq(&amp;base-&gt;lock); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    while (time_after_eq(jiffies, base-&gt;timer_jiffies)) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct list_head work_list; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct list_head *head = &amp;work_list; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        int index = base-&gt;timer_jiffies &amp; TVR_MASK; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        /* 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">         * Cascade timers: 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">         */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        if (!index &amp;&amp; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            (!cascade(base, &amp;base-&gt;tv2, INDEX(0))) &amp;&amp; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                (!cascade(base, &amp;base-&gt;tv3, INDEX(1))) &amp;&amp; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                    !cascade(base, &amp;base-&gt;tv4, INDEX(2))) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            cascade(base, &amp;base-&gt;tv5, INDEX(3)); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        ++base-&gt;timer_jiffies; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        list_replace_init(base-&gt;tv1.vec + index, &amp;work_list); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        while (!list_empty(head)) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            void (*fn)(unsigned long); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            unsigned long data; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            timer = list_first_entry(head, struct timer_list,entry); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            fn = timer-&gt;function; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            data = timer-&gt;data; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            fn(data); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">base-&gt;timer_jiffies </span><span style="font-family:宋体">用来记录在</span><span style="font-family:Arial"> TV1 </span><span style="font-family:宋体">中最接近超时的</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">的位置。</span><span style="font-family:Arial">index </span><span style="font-family:宋体">是用来遍历</span><span style="font-family:Arial"> TV1 </span><span style="font-family:宋体">的索引。每一次循环</span><span style="font-family:Arial"> index </span><span style="font-family:宋体">会定位一个当前待处理的</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，并处理这个</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">下所有超时的</span><span style="font-family:Arial"> timer</span><span style="font-family:宋体">。</span><span style="font-family:Arial">base-&gt;timer_jiffies </span><span style="font-family:宋体">会在每次循环后增加一个</span><span style="font-family:Arial"> jiffy</span><span style="font-family:宋体">，</span><span style="font-family:Arial">index </span><span style="font-family:宋体">也会随之向前移动。当</span><span style="font-family:Arial"> index </span><span style="font-family:宋体">变为</span><span style="font-family:Arial"> 0 </span><span style="font-family:宋体">时表示</span><span style="font-family:Arial"> TV1 </span><span style="font-family:宋体">完成了一次完整的遍历，此时所有在</span><span style="font-family:Arial"> TV1 </span><span style="font-family:宋体">中的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">都被处理了，因此需要通过</span><span style="font-family:Arial"> cascade </span><span style="font-family:宋体">将后面</span><span style="font-family:Arial"> TV2</span><span style="font-family:宋体">，</span><span style="font-family:Arial">TV3 </span><span style="font-family:宋体">等</span><span style="font-family:Arial"> timer list </span><span style="font-family:宋体">中的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">向前移动，类似于进位。这种层叠的</span><span style="font-family:Arial"> timer list </span><span style="font-family:宋体">实现机制可以大大降低每次检查超时</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">的时间，每次中断只需要针对</span><span style="font-family:Arial"> TV1 </span><span style="font-family:宋体">进行检查，只有必要时才进行</span><span style="font-family:Arial"> cascade</span><span style="font-family:宋体">。即便如此，</span><span style="font-family:Arial">timer wheel </span><span style="font-family:宋体">的实现机制仍然存在很大弊端。一个弊端就是</span><span style="font-family:Arial"> cascade </span><span style="font-family:宋体">开销过大。在极端的条件下，同时会有多个</span><span style="font-family:Arial"> TV </span><span style="font-family:宋体">需要进行</span><span style="font-family:Arial"> cascade </span><span style="font-family:宋体">处理，会产生很大的时延。这也是为什么说</span><span style="font-family:Arial"> timeout </span><span style="font-family:宋体">类型的定时器是</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">的主要应用环境，或者说</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">是为</span><span style="font-family:Arial"> timeout </span><span style="font-family:宋体">类型的定时器优化的。因为</span><span style="font-family:Arial"> timeout </span><span style="font-family:宋体">类型的定时器的应用场景多是错误条件的检测，这类错误发生的机率很小，通常不到超时就被删除了，因此不会产生</span><span style="font-family:Arial"> cascade </span><span style="font-family:宋体">的开销。另一方面，由于</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">是建立在</span><span style="font-family:Arial"> HZ </span><span style="font-family:宋体">的基础上的，因此其计时精度无法进一步提高。毕竟一味的通过提高</span><span style="font-family:Arial"> HZ </span><span style="font-family:宋体">值来提高计时精度并无意义，结果只能是产生大量的定时中断，增加额外的系统开销。因此，有必要将高精度的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">与低精度的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">分开，这样既可以确保低精度的</span><span style="font-family:Arial"> timeout </span><span style="font-family:宋体">类型的定时器应用，也便于高精度的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">类型定时器的应用。还有一个重要的因素是</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">的实现与</span><span style="font-family:Arial"> jiffies </span><span style="font-family:宋体">的耦合性太强，非常不便于扩展。因此，自从</span><span style="font-family:Arial"> 2.6.16 </span><span style="font-family:宋体">开始，一个新的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">子系统</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">被加入到内核中。</span><span style="font-family:Arial">
			</span></span>

[<span style="color:#745285; font-family:宋体; font-size:9pt; text-decoration:underline">**回页首**</span>](https://www.ibm.com/developerworks/cn/linux/l-cn-timerm/)<span style="color:#222222; font-family:Arial; font-size:9pt">
		</span>

<span style="color:black; font-family:Helvetica; font-size:18pt">**hrtimer (High-resolution Timer)
**</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">首先要实现的功能就是要克服</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">的缺点：低精度以及与内核其他模块的高耦合性。在正式介绍</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">之前，有必要先介绍几个常用的基本概念：</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt">**<span style="font-family:宋体">时钟源设备（</span><span style="font-family:Arial">clock-source device</span><span style="font-family:宋体">）</span>**<span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">系统中可以提供一定精度的计时设备都可以作为时钟源设备。如</span><span style="font-family:Arial"> TSC</span><span style="font-family:宋体">，</span><span style="font-family:Arial">HPET</span><span style="font-family:宋体">，</span><span style="font-family:Arial">ACPI PM-Timer</span><span style="font-family:宋体">，</span><span style="font-family:Arial">PIT </span><span style="font-family:宋体">等。但是不同的时钟源提供的时钟精度是不一样的。像</span><span style="font-family:Arial"> TSC</span><span style="font-family:宋体">，</span><span style="font-family:Arial">HPET </span><span style="font-family:宋体">等时钟源既支持高精度模式（</span><span style="font-family:Arial">high-resolution mode</span><span style="font-family:宋体">）也支持低精度模式（</span><span style="font-family:Arial">low-resolution mode</span><span style="font-family:宋体">），而</span><span style="font-family:Arial"> PIT </span><span style="font-family:宋体">只能支持低精度模式。此外，时钟源的计时都是单调递增的（</span><span style="font-family:Arial">monotonically</span><span style="font-family:宋体">），如果时钟源的计时出现翻转（即返回到</span><span style="font-family:Arial"> 0 </span><span style="font-family:宋体">值），很容易造成计时错误，</span><span style="font-family:Arial">
			</span><span style="font-family:宋体">内核的一个</span><span style="font-family:Arial"> patch</span><span style="font-family:宋体">（</span><span style="font-family:Arial">commit id: ff69f2</span><span style="font-family:宋体">）就是处理这类问题的一个很好示例。时钟源作为系统时钟的提供者，在可靠并且可用的前提下精度越高越好。在</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">中不同的时钟源有不同的</span><span style="font-family:Arial"> rating</span><span style="font-family:宋体">，具有更高</span><span style="font-family:Arial"> rating </span><span style="font-family:宋体">的时钟源会优先被系统使用。如图</span><span style="font-family:Arial"> 2 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">表</span><span style="font-family:Arial"> 1\. </span><span style="font-family:宋体">时钟源中</span><span style="font-family:Arial"> rating </span><span style="font-family:宋体">的定义</span><span style="font-family:Arial">
				</span>**</span>
<div><table style="border-collapse:collapse" border="0"><colgroup><col style="width:131px"/><col style="width:94px"/><col style="width:116px"/><col style="width:78px"/><col style="width:134px"/></colgroup><tbody valign="top"><tr><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 10px; border-top:  solid #999999 1.5pt; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  solid white 2.25pt">

<span style="color:black; font-family:宋体; font-size:12pt">**1 ~ 99**</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  solid #999999 1.5pt; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  solid white 2.25pt">

<span style="color:black; font-family:宋体; font-size:12pt">**100 ~ 199**</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  solid #999999 1.5pt; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  solid white 2.25pt">

<span style="color:black; font-family:宋体; font-size:12pt">**200 ~ 299**</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  solid #999999 1.5pt; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  solid white 2.25pt">

<span style="color:black; font-family:宋体; font-size:12pt">**300 ~ 399**</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  solid #999999 1.5pt; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  none">

<span style="color:black; font-family:宋体; font-size:12pt">**400 ~ 499**</span>
</td></tr><tr><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #cccccc 0.75pt; border-right:  solid white 2.25pt">

<span style="color:#555555; font-family:宋体; font-size:12pt">非常差的时钟源，只能作为最后的选择。如 jiffies</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  none; border-left:  none; border-bottom:  solid #cccccc 0.75pt; border-right:  solid white 2.25pt">

<span style="color:#555555; font-family:宋体; font-size:12pt">基本可以使用但并非理想的时钟源。如 PIT</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  none; border-left:  none; border-bottom:  solid #cccccc 0.75pt; border-right:  solid white 2.25pt">

<span style="color:#555555; font-family:宋体; font-size:12pt">正确可用的时钟源。如 ACPI PM Timer，HPET</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  none; border-left:  none; border-bottom:  solid #cccccc 0.75pt; border-right:  solid white 2.25pt">

<span style="color:#555555; font-family:宋体; font-size:12pt">快速并且精确的时钟源。如 TSC</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  none; border-left:  none; border-bottom:  solid #cccccc 0.75pt; border-right:  none">

<span style="color:#555555; font-family:宋体; font-size:12pt">理想时钟源。如 kvm_clock，xen_clock</span>
</td></tr></tbody></table></div>

<span style="color:#222222; font-size:9pt">**<span style="font-family:宋体">时钟事件设备（</span><span style="font-family:Arial">clock-event device</span><span style="font-family:宋体">）</span>**<span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">系统中可以触发</span><span style="font-family:Arial"> one-shot</span><span style="font-family:宋体">（单次）或者周期性中断的设备都可以作为时钟事件设备。如</span><span style="font-family:Arial"> HPET</span><span style="font-family:宋体">，</span><span style="font-family:Arial">CPU Local APIC Timer </span><span style="font-family:宋体">等。</span><span style="font-family:Arial">HPET </span><span style="font-family:宋体">比较特别，它既可以做时钟源设备也可以做时钟事件设备。时钟事件设备的类型分为全局和</span><span style="font-family:Arial"> per-CPU </span><span style="font-family:宋体">两种类型。全局的时钟事件设备虽然附属于某一个特定的</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">上，但是完成的是系统相关的工作，例如完成系统的</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">更新；</span><span style="font-family:Arial">per-CPU </span><span style="font-family:宋体">的时钟事件设备主要完成</span><span style="font-family:Arial"> Local CPU </span><span style="font-family:宋体">上的一些功能，例如对在当前</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">上运行进程的时间统计，</span><span style="font-family:Arial">profile</span><span style="font-family:宋体">，设置</span><span style="font-family:Arial"> Local CPU </span><span style="font-family:宋体">上的下一次事件中断等。和时钟源设备的实现类似，时钟事件设备也通过</span><span style="font-family:Arial"> rating </span><span style="font-family:宋体">来区分优先级关系。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-family:Arial; font-size:9pt">**tick device**
		</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">Tick device </span><span style="font-family:宋体">用来处理周期性的</span><span style="font-family:Arial"> tick event</span><span style="font-family:宋体">。</span><span style="font-family:Arial">Tick device </span><span style="font-family:宋体">其实是时钟事件设备的一个</span><span style="font-family:Arial"> wrapper</span><span style="font-family:宋体">，因此</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">也有</span><span style="font-family:Arial"> one-shot </span><span style="font-family:宋体">和周期性这两种中断触发模式。每注册一个时钟事件设备，这个设备会自动被注册为一个</span><span style="font-family:Arial"> tick device</span><span style="font-family:宋体">。全局的</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">用来更新诸如</span><span style="font-family:Arial"> jiffies </span><span style="font-family:宋体">这样的全局信息，</span><span style="font-family:Arial">per-CPU </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">则用来更新每个</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">相关的特定信息。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-family:Arial; font-size:9pt">**broadcast**
		</span>

<span style="color:#222222; font-size:9pt">**<span style="font-family:Arial">CPU </span><span style="font-family:宋体">的</span>**<span style="font-family:Arial">** C-STATE
**CPU </span><span style="font-family:宋体">在空闲时会根据空闲时间的长短选择进入不同的睡眠级别，称为</span><span style="font-family:Arial"> C-STATE</span><span style="font-family:宋体">。</span><span style="font-family:Arial">C0 </span><span style="font-family:宋体">为正常运行状态，</span><span style="font-family:Arial">C1 </span><span style="font-family:宋体">到</span><span style="font-family:Arial"> C7 </span><span style="font-family:宋体">为睡眠状态，数值越大，睡眠程度越深，也就越省电。</span><span style="font-family:Arial">CPU </span><span style="font-family:宋体">空闲越久，进入睡眠的级别越高，但是唤醒所需的时间也越长。唤醒也是需要消耗能源的，因此，只有选择合适的睡眠级别才能确保节能的最大化。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">Broadcast </span><span style="font-family:宋体">的出现是为了应对这样一种情况：假定</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">使用</span><span style="font-family:Arial"> Local APIC Timer </span><span style="font-family:宋体">作为</span><span style="font-family:Arial"> per-CPU </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> tick device</span><span style="font-family:宋体">，但是某些特定的</span><span style="font-family:Arial"> CPU</span><span style="font-family:宋体">（如</span><span style="font-family:Arial"> Intel </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> Westmere </span><span style="font-family:宋体">之前的</span><span style="font-family:Arial"> CPU</span><span style="font-family:宋体">）在进入</span><span style="font-family:Arial"> C3+ </span><span style="font-family:宋体">的状态时</span><span style="font-family:Arial"> Local APIC Timer </span><span style="font-family:宋体">也会同时停止工作，进入睡眠状态。在这种情形下</span><span style="font-family:Arial"> broadcast </span><span style="font-family:宋体">可以替代</span><span style="font-family:Arial"> Local APIC Timer </span><span style="font-family:宋体">继续完成统计进程的执行时间等有关操作。本质上</span><span style="font-family:Arial"> broadcast </span><span style="font-family:宋体">是发送一个</span><span style="font-family:Arial"> IPI</span><span style="font-family:宋体">（</span><span style="font-family:Arial">Inter-processor interrupt</span><span style="font-family:宋体">）中断给其他所有的</span><span style="font-family:Arial"> CPU</span><span style="font-family:宋体">，当目标</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">收到这个</span><span style="font-family:Arial"> IPI </span><span style="font-family:宋体">中断后就会调用原先</span><span style="font-family:Arial"> Local APIC Timer </span><span style="font-family:宋体">正常工作时的中断处理函数，从而实现了同样的功能。目前主要在</span><span style="font-family:Arial"> x86 </span><span style="font-family:宋体">以及</span><span style="font-family:Arial"> MIPS </span><span style="font-family:宋体">下会用到</span><span style="font-family:Arial"> broadcast </span><span style="font-family:宋体">功能。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-family:Arial; font-size:9pt">**Timekeeping &amp; GTOD (Generic Time-of-Day)**
		</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">Timekeeping</span><span style="font-family:宋体">（可以理解为时间测量或者计时）是内核时间管理的一个核心组成部分。没有</span><span style="font-family:Arial"> Timekeeping</span><span style="font-family:宋体">，就无法更新系统时间，维持系统</span><span style="font-family:Arial">"</span><span style="font-family:宋体">心跳</span><span style="font-family:Arial">"</span><span style="font-family:宋体">。</span><span style="font-family:Arial">GTOD </span><span style="font-family:宋体">是一个通用的框架，用来实现诸如设置系统时间</span><span style="font-family:Arial"> gettimeofday </span><span style="font-family:宋体">或者修改系统时间</span><span style="font-family:Arial"> settimeofday </span><span style="font-family:宋体">等工作。为了实现以上功能，</span><span style="font-family:Arial">Linux </span><span style="font-family:宋体">实现了多种与时间相关但用于不同目的的数据结构。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> struct timespec { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    __kernel_time_t    tv_sec;               /* seconds */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    long                tv_nsec;               /* nanoseconds */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> };
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">timespec </span><span style="font-family:宋体">精度是纳秒。它用来保存从</span><span style="font-family:Arial"> 00:00:00 GMT, 1 January 1970 </span><span style="font-family:宋体">开始经过的时间。内核使用全局变量</span><span style="font-family:Arial"> xtime </span><span style="font-family:宋体">来记录这一信息，这就是通常所说的</span><span style="font-family:Arial">"Wall Time"</span><span style="font-family:宋体">或者</span><span style="font-family:Arial">"Real Time"</span><span style="font-family:宋体">。与此对应的是</span><span style="font-family:Arial">"System Time"</span><span style="font-family:宋体">。</span><span style="font-family:Arial">System Time </span><span style="font-family:宋体">是一个单调递增的时间，每次系统启动时从</span><span style="font-family:Arial"> 0 </span><span style="font-family:宋体">开始计时。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> struct timeval { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    __kernel_time_t          tv_sec;          /* seconds */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    __kernel_suseconds_t    tv_usec;         /* microseconds */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> };
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">timeval </span><span style="font-family:宋体">精度是微秒。</span><span style="font-family:Arial">timeval </span><span style="font-family:宋体">主要用来指定一段时间间隔。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> union ktime { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        s64     tv64; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> #if BITS_PER_LONG != 64 &amp;&amp; !defined(CONFIG_KTIME_SCALAR) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        struct { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> # ifdef __BIG_ENDIAN 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        s32     sec, nsec; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> # else 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        s32     nsec, sec; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> # endif 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        } tv; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> #endif 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> };
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">ktime_t </span><span style="font-family:宋体">是</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">主要使用的时间结构。无论使用哪种体系结构，</span><span style="font-family:Arial">ktime_t </span><span style="font-family:宋体">始终保持</span><span style="font-family:Arial"> 64bit </span><span style="font-family:宋体">的精度，并且考虑了大小端的影响。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> typedef u64 cycle_t;
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">cycle_t </span><span style="font-family:宋体">是从时钟源设备中读取的时钟类型。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">为了管理这些不同的时间结构，</span><span style="font-family:Arial">Linux </span><span style="font-family:宋体">实现了一系列辅助函数来完成相互间的转换。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">ktime_to_timespec</span><span style="font-family:宋体">，</span><span style="font-family:Arial">ktime_to_timeval</span><span style="font-family:宋体">，</span><span style="font-family:Arial">ktime_to_ns/ktime_to_us</span><span style="font-family:宋体">，反过来有诸如</span><span style="font-family:Arial"> ns_to_ktime </span><span style="font-family:宋体">等类似的函数。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">timeval_to_ns</span><span style="font-family:宋体">，</span><span style="font-family:Arial">timespec_to_ns</span><span style="font-family:宋体">，反过来有诸如</span><span style="font-family:Arial"> ns_to_timeval </span><span style="font-family:宋体">等类似的函数。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">timeval_to_jiffies</span><span style="font-family:宋体">，</span><span style="font-family:Arial">timespec_to_jiffies</span><span style="font-family:宋体">，</span><span style="font-family:Arial">msecs_to_jiffies, usecs_to_jiffies, clock_t_to_jiffies </span><span style="font-family:宋体">反过来有诸如</span><span style="font-family:Arial"> ns_to_timeval </span><span style="font-family:宋体">等类似的函数。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-family:Arial; font-size:9pt">clocksource_cyc2ns / cyclecounter_cyc2ns
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">有了以上的介绍，通过图</span><span style="font-family:Arial"> 3 </span><span style="font-family:宋体">可以更加清晰的看到这几者之间的关联。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">图</span><span style="font-family:Arial"> 2\. </span><span style="font-family:宋体">内核时钟子系统的结构关系</span><span style="font-family:Arial">
				</span>**</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052716_0200_Linux2.jpg)<span style="color:black; font-family:Arial; font-size:9pt">
		</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">时钟源设备和时钟事件设备的引入，将原本放在各个体系结构中重复实现的冗余代码封装到各自的抽象层中，这样做不但消除了原来</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">与内核其他模块的紧耦合性，更重要的是系统可以在运行状态动态更换时钟源设备和时钟事件设备而不影响系统正常使用，譬如当</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">由于睡眠要关闭当前使用的时钟源设备或者时钟事件设备时系统可以平滑的切换到其他仍处于工作状态的设备上。</span><span style="font-family:Arial">Timekeeping/GTOD </span><span style="font-family:宋体">在使用时钟源设备的基础上也采用类似的封装实现了体系结构的无关性和通用性。</span><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">则可以通过</span><span style="font-family:Arial"> timekeeping </span><span style="font-family:宋体">提供的接口完成定时器的更新，通过时钟事件设备提供的事件机制，完成对</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">的管理。在图</span><span style="font-family:Arial"> 3 </span><span style="font-family:宋体">中还有一个重要的模块就是</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的抽象，尤其是</span><span style="font-family:Arial"> dynamic tick</span><span style="font-family:宋体">。</span><span style="font-family:Arial">Dynamic tick </span><span style="font-family:宋体">的出现是为了能在系统空闲时通过停止</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">的运行以达到降低</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">功耗的目的。使用</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的系统，只有在有实际工作时才会产生</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，否则</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">是处于停止状态。下文会有专门的章节进行论述。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt">**<span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">的实现机制</span>**<span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">是建立在</span><span style="font-family:Arial"> per-CPU </span><span style="font-family:宋体">时钟事件设备上的，对于一个</span><span style="font-family:Arial"> SMP </span><span style="font-family:宋体">系统，如果只有全局的时钟事件设备，</span><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">无法工作。因为如果没有</span><span style="font-family:Arial"> per-CPU </span><span style="font-family:宋体">时钟事件设备，时钟中断发生时系统必须产生必要的</span><span style="font-family:Arial"> IPI </span><span style="font-family:宋体">中断来通知其他</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">完成相应的工作，而过多的</span><span style="font-family:Arial"> IPI </span><span style="font-family:宋体">中断会带来很大的系统开销，这样会令使用</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">的代价太大，不如不用。为了支持</span><span style="font-family:Arial"> hrtimer</span><span style="font-family:宋体">，内核需要配置</span><span style="font-family:Arial"> CONFIG_HIGH_RES_TIMERS=y</span><span style="font-family:宋体">。</span><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">有两种工作模式：低精度模式（</span><span style="font-family:Arial">low-resolution mode</span><span style="font-family:宋体">）与高精度模式（</span><span style="font-family:Arial">high-resolution mode</span><span style="font-family:宋体">）。虽然</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">子系统是为高精度的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">准备的，但是系统可能在运行过程中动态切换到不同精度的时钟源设备，因此，</span><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">必须能够在低精度模式与高精度模式下自由切换。由于低精度模式是建立在高精度模式之上的，因此即便系统只支持低精度模式，部分支持高精度模式的代码仍然会编译到内核当中。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在低精度模式下，</span><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">的核心处理函数是</span><span style="font-family:Arial"> hrtimer_run_queues</span><span style="font-family:宋体">，每一次</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">中断都要执行一次。如清单</span><span style="font-family:Arial"> 3 </span><span style="font-family:宋体">所示。这个函数的调用流程为：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> update_process_times 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    run_local_timers 
</span>

<span style="color:black; font-size:8pt"><span style="font-family:Lucida Console">
			</span><span style="font-family:Arial">**hrtimer_run_queues**</span><span style="font-family:Lucida Console">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        raise_softirq(TIMER_SOFTIRQ)
</span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 3\. </span><span style="font-family:宋体">低精度模式下</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">的核心处理函数</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> void hrtimer_run_queues(void) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    struct rb_node *node; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    struct hrtimer_cpu_base *cpu_base = &amp;__get_cpu_var(hrtimer_bases); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    struct hrtimer_clock_base *base; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    int index, gettime = 1; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (hrtimer_hres_active()) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        return; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    for (index = 0; index &lt; HRTIMER_MAX_CLOCK_BASES; index++) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        base = &amp;cpu_base-&gt;clock_base[index]; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        if (!base-&gt;first) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            continue; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        if (gettime) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            hrtimer_get_softirq_time(cpu_base); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            gettime = 0; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        raw_spin_lock(&amp;cpu_base-&gt;lock); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        while ((node = base-&gt;first)) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            struct hrtimer *timer; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            timer = rb_entry(node, struct hrtimer, node); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            if (base-&gt;softirq_time.tv64 &lt;= 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                    hrtimer_get_expires_tv64(timer)) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                break; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            __run_hrtimer(timer, &amp;base-&gt;softirq_time); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        raw_spin_unlock(&amp;cpu_base-&gt;lock); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">hrtimer_bases </span><span style="font-family:宋体">是实现</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">的核心数据结构，通过</span><span style="font-family:Arial"> hrtimer_bases</span><span style="font-family:宋体">，</span><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">可以管理挂在每一个</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">上的所有</span><span style="font-family:Arial"> timer</span><span style="font-family:宋体">。每个</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">上的</span><span style="font-family:Arial"> timer list </span><span style="font-family:宋体">不再使用</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">中多级链表的实现方式，而是采用了红黑树（</span><span style="font-family:Arial">Red-Black Tree</span><span style="font-family:宋体">）来进行管理。</span><span style="font-family:Arial">hrtimer_bases </span><span style="font-family:宋体">的定义如清单</span><span style="font-family:Arial"> 4 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 4\. hrtimer_bases </span><span style="font-family:宋体">的定义</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) = 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        .clock_base = 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                        .index = CLOCK_REALTIME, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                        .get_time = &amp;ktime_get_real, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                        .resolution = KTIME_LOW_RES, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                }, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                        .index = CLOCK_MONOTONIC, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                        .get_time = &amp;ktime_get, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                        .resolution = KTIME_LOW_RES, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                }, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> };
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">图</span><span style="font-family:Arial"> 4 </span><span style="font-family:宋体">展示了</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">如何通过</span><span style="font-family:Arial"> hrtimer_bases </span><span style="font-family:宋体">来管理</span><span style="font-family:Arial"> timer</span><span style="font-family:宋体">。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">图</span><span style="font-family:Arial"> 3\. hrtimer </span><span style="font-family:宋体">的时钟管理</span><span style="font-family:Arial">
				</span>**</span>

![](http://www.madhex.com/wp-content/uploads/2016/05/052716_0200_Linux3.jpg)<span style="color:black; font-family:Arial; font-size:9pt">
		</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">每个</span><span style="font-family:Arial"> hrtimer_bases </span><span style="font-family:宋体">都包含两个</span><span style="font-family:Arial"> clock_base</span><span style="font-family:宋体">，一个是</span><span style="font-family:Arial"> CLOCK_REALTIME </span><span style="font-family:宋体">类型的，另一个是</span><span style="font-family:Arial"> CLOCK_MONOTONIC </span><span style="font-family:宋体">类型的。</span><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">可以选择其中之一来设置</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> expire time, </span><span style="font-family:宋体">可以是实际的时间</span><span style="font-family:Arial"> , </span><span style="font-family:宋体">也可以是相对系统运行的时间。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在</span><span style="font-family:Arial"> hrtimer_run_queues </span><span style="font-family:宋体">的处理中，首先要通过</span><span style="font-family:Arial"> hrtimer_bases </span><span style="font-family:宋体">找到正在执行当前中断的</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">相关联的</span><span style="font-family:Arial"> clock_base</span><span style="font-family:宋体">，然后逐个检查每个</span><span style="font-family:Arial"> clock_base </span><span style="font-family:宋体">上挂的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">是否超时。由于</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">在添加到</span><span style="font-family:Arial"> clock_base </span><span style="font-family:宋体">上时使用了红黑树，最早超时的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">被放到树的最左侧，因此寻找超时</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">的过程非常迅速，找到的所有超时</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">会被逐一处理。超时的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">根据其类型分为</span><span style="font-family:Arial"> softIRQ / per-CPU / unlocked </span><span style="font-family:宋体">几种。如果一个</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">是</span><span style="font-family:Arial"> softIRQ </span><span style="font-family:宋体">类型的，这个超时的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">需要被转移到</span><span style="font-family:Arial"> hrtimer_bases </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> cb_pending </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> list </span><span style="font-family:宋体">上，待</span><span style="font-family:Arial"> IRQ0 </span><span style="font-family:宋体">的软中断被激活后，通过</span><span style="font-family:Arial"> run_hrtimer_pending </span><span style="font-family:宋体">执行，另外两类则必须在</span><span style="font-family:Arial"> hardIRQ </span><span style="font-family:宋体">中通过</span><span style="font-family:Arial"> __run_hrtimer </span><span style="font-family:宋体">直接执行。不过在较新的</span><span style="font-family:Arial"> kernel</span><span style="font-family:宋体">（</span><span style="font-family:Arial">&gt; 2.6.29</span><span style="font-family:宋体">）中，</span><span style="font-family:Arial">cb_pending </span><span style="font-family:宋体">被取消，这样所有的超时</span><span style="font-family:Arial"> timers </span><span style="font-family:宋体">都必须在</span><span style="font-family:Arial"> hardIRQ </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> context </span><span style="font-family:宋体">中执行。这样修改的目的，一是为了简化代码逻辑，二是为了减少</span><span style="font-family:Arial"> 2 </span><span style="font-family:宋体">次</span><span style="font-family:Arial"> context </span><span style="font-family:宋体">的切换：一次从</span><span style="font-family:Arial"> hardIRQ </span><span style="font-family:宋体">到</span><span style="font-family:Arial"> softIRQ</span><span style="font-family:宋体">，另一次从</span><span style="font-family:Arial"> softIRQ </span><span style="font-family:宋体">到被超时</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">唤醒的进程。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在</span><span style="font-family:Arial"> update_process_times </span><span style="font-family:宋体">中，除了处理处于低精度模式的</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">外，还要唤醒</span><span style="font-family:Arial"> IRQ0 </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> softIRQ</span><span style="font-family:宋体">（</span><span style="font-family:Arial">TIMER_SOFTIRQ</span><span style="font-family:宋体">（</span><span style="font-family:Arial">run_timer_softirq</span><span style="font-family:宋体">））以便执行</span><span style="font-family:Arial"> timer wheel </span><span style="font-family:宋体">的代码。由于</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">子系统的加入，在</span><span style="font-family:Arial"> IRQ0 </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> softIRQ </span><span style="font-family:宋体">中，还需要通过</span><span style="font-family:Arial"> hrtimer_run_pending </span><span style="font-family:宋体">检查是否可以将</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">切换到高精度模式，如清单</span><span style="font-family:Arial"> 5 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 5\. hrtimer </span><span style="font-family:宋体">进行精度切换的处理函数</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> void hrtimer_run_pending(void) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (hrtimer_hres_active()) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        return; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    /* 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * This _is_ ugly: We have to check in the softirq context, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * whether we can switch to highres and / or nohz mode. The 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * clocksource switch happens in the timer interrupt with 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * xtime_lock held. Notification from there only sets the 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * check bit in the tick_oneshot code, otherwise we might 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * deadlock vs. xtime_lock. 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (tick_check_oneshot_change(!hrtimer_is_hres_enabled())) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        hrtimer_switch_to_hres(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">正如这段代码的作者注释中所提到的，每一次触发</span><span style="font-family:Arial"> IRQ0 </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> softIRQ </span><span style="font-family:宋体">都需要检查一次是否可以将</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">切换到高精度，显然是十分低效的，希望将来有更好的方法不用每次都进行检查。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">如果可以将</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">切换到高精度模式，则调用</span><span style="font-family:Arial"> hrtimer_switch_to_hres </span><span style="font-family:宋体">函数进行切换。如清单</span><span style="font-family:Arial"> 6 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 6\. hrtimer </span><span style="font-family:宋体">切换到高精度模式的核心函数</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> /* 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> * Switch to high resolution mode 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> static int hrtimer_switch_to_hres(void) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    int cpu = smp_processor_id(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    struct hrtimer_cpu_base *base = &amp;per_cpu(hrtimer_bases, cpu); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    unsigned long flags; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (base-&gt;hres_active) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        return 1; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    local_irq_save(flags); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (tick_init_highres()) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        local_irq_restore(flags); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        printk(KERN_WARNING "Could not switch to high resolution "
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                  "mode on CPU %d\n", cpu); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        return 0; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    base-&gt;hres_active = 1; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    base-&gt;clock_base[CLOCK_REALTIME].resolution = KTIME_HIGH_RES; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    base-&gt;clock_base[CLOCK_MONOTONIC].resolution = KTIME_HIGH_RES; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    tick_setup_sched_timer(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    /* "Retrigger" the interrupt to get things going */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    retrigger_next_event(NULL); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    local_irq_restore(flags); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    return 1; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt">**<span style="font-family:Arial">hrtimer_interrupt</span><span style="font-family:宋体">的使用环境</span>**<span style="font-family:Arial">
hrtimer_interrupt </span><span style="font-family:宋体">有</span><span style="font-family:Arial"> 2 </span><span style="font-family:宋体">种常见的使用方式。一是作为</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">的推动器在产生</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">中断时被调用；另一种情况就是通过软中断</span><span style="font-family:Arial"> HRTIMER_SOFTIRQ</span><span style="font-family:宋体">（</span><span style="font-family:Arial">run_hrtimer_softirq</span><span style="font-family:宋体">）被调用，通常是被驱动程序或者间接的使用这些驱动程序的用户程序所调用</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在这个函数中，首先使用</span><span style="font-family:Arial"> tick_init_highres </span><span style="font-family:宋体">更新与原来的</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">绑定的时钟事件设备的</span><span style="font-family:Arial"> event handler</span><span style="font-family:宋体">，例如将在低精度模式下的工作函数</span><span style="font-family:Arial"> tick_handle_periodic / tick_handle_periodic_broadcast </span><span style="font-family:宋体">换成</span><span style="font-family:Arial"> hrtimer_interrupt</span><span style="font-family:宋体">（它是</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">在高精度模式下的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">中断处理函数），同时将</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的触发模式变为</span><span style="font-family:Arial"> one-shot</span><span style="font-family:宋体">，即单次触发模式，这是使用</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">或者</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">时</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的工作模式。由于</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">可以随时停止和开始，以不规律的速度产生</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，因此支持</span><span style="font-family:Arial"> one-shot </span><span style="font-family:宋体">模式的时钟事件设备是必须的；对于</span><span style="font-family:Arial"> hrtimer</span><span style="font-family:宋体">，由于</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">采用事件机制驱动</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">前进，因此使用</span><span style="font-family:Arial"> one-shot </span><span style="font-family:宋体">的触发模式也是顺理成章的。不过这样一来，原本</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">每次执行中断时需要完成的周期性任务如更新</span><span style="font-family:Arial"> jiffies / wall time (do_timer) </span><span style="font-family:宋体">以及更新</span><span style="font-family:Arial"> process </span><span style="font-family:宋体">的使用时间（</span><span style="font-family:Arial">update_process_times</span><span style="font-family:宋体">）等工作在切换到高精度模式之后就没有了，因此在执行完</span><span style="font-family:Arial"> tick_init_highres </span><span style="font-family:宋体">之后紧接着会调用</span><span style="font-family:Arial"> tick_setup_sched_timer </span><span style="font-family:宋体">函数来完成这部分设置工作，如清单</span><span style="font-family:Arial"> 7 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 7\. hrtimer </span><span style="font-family:宋体">高精度模式下模拟周期运行的</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的简化实现</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> void tick_setup_sched_timer(void) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    struct tick_sched *ts = &amp;__get_cpu_var(tick_cpu_sched); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    ktime_t now = ktime_get(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    u64 offset; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    /* 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * Emulate tick processing via per-CPU hrtimers: 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    hrtimer_init(&amp;ts-&gt;sched_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    ts-&gt;sched_timer.function = tick_sched_timer; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    for (;;) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        hrtimer_forward(&amp;ts-&gt;sched_timer, now, tick_period); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        hrtimer_start_expires(&amp;ts-&gt;sched_timer, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                   HRTIMER_MODE_ABS_PINNED); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        /* Check, if the timer was already in the past */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        if (hrtimer_active(&amp;ts-&gt;sched_timer)) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            break; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        now = ktime_get(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">这个函数使用</span><span style="font-family:Arial"> tick_cpu_sched </span><span style="font-family:宋体">这个</span><span style="font-family:Arial"> per-CPU </span><span style="font-family:宋体">变量来模拟原来</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的功能。</span><span style="font-family:Arial">tick_cpu_sched </span><span style="font-family:宋体">本身绑定了一个</span><span style="font-family:Arial"> hrtimer</span><span style="font-family:宋体">，这个</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">的超时值为下一个</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，回调函数为</span><span style="font-family:Arial"> tick_sched_timer</span><span style="font-family:宋体">。因此，每过一个</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，</span><span style="font-family:Arial">tick_sched_timer </span><span style="font-family:宋体">就会被调用一次，在这个回调函数中首先完成原来</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的工作，然后设置下一次的超时值为再下一个</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，从而达到了模拟周期运行的</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的功能。如果所有的</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">在同一时间点被唤醒，并发执行</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">时可能会出现</span><span style="font-family:Arial"> lock </span><span style="font-family:宋体">竞争以及</span><span style="font-family:Arial"> cache-line </span><span style="font-family:宋体">冲突，为此</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">内核做了特别处理：如果假设</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">的个数为</span><span style="font-family:Arial"> N</span><span style="font-family:宋体">，则所有的</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">都在</span><span style="font-family:Arial"> tick_period </span><span style="font-family:宋体">前</span><span style="font-family:Arial"> 1/2 </span><span style="font-family:宋体">的时间内执行</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">工作，并且每个</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">的执行间隔是</span><span style="font-family:Arial"> tick_period / (2N)</span><span style="font-family:宋体">，见清单</span><span style="font-family:Arial"> 8 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 8\. hrtimer </span><span style="font-family:宋体">在高精度模式下</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">执行周期的设置</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> void tick_setup_sched_timer(void) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    /* Get the next period (per cpu) */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    hrtimer_set_expires(&amp;ts-&gt;sched_timer, tick_init_jiffy_update()); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    offset = ktime_to_ns(tick_period) &gt;&gt; 1; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    do_div(offset, num_possible_cpus()); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    offset *= smp_processor_id(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    hrtimer_add_expires_ns(&amp;ts-&gt;sched_timer, offset); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">回到</span><span style="font-family:Arial"> hrtimer_switch_to_hres </span><span style="font-family:宋体">函数中，在一切准备就绪后，调用</span><span style="font-family:Arial"> retrigger_next_event </span><span style="font-family:宋体">激活下一次的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">就可以开始正常的运作了。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">随着</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">子系统的发展，一些问题也逐渐暴露了出来。一个比较典型的问题就是</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">的功耗问题。现代</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">都实现了节能的特性，在没有工作时</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">会主动降低频率，关闭</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">内部一些非关键模块以达到节能的目的。由于</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">的精度很高，触发中断的频率也会很高，频繁的中断会极大的影响</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">的节能。在这方面</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">一直在不断的进行调整。以下几个例子都是针对这一问题所做的改进。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:Arial">schedule_hrtimeout </span><span style="font-family:宋体">函数</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> /** 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> * schedule_hrtimeout - sleep until timeout 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> * @expires:    timeout value (ktime_t) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> * @mode:       timer mode, HRTIMER_MODE_ABS or HRTIMER_MODE_REL 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> int __sched schedule_hrtimeout(ktime_t *expires, const enum hrtimer_mode mode)
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">schedule_hrtimeout </span><span style="font-family:宋体">用来产生一个高精度的调度超时，以</span><span style="font-family:Arial"> ns </span><span style="font-family:宋体">为单位。这样可以更加细粒度的使用内核的调度器。在</span><span style="font-family:Arial"> Arjan van de Ven </span><span style="font-family:宋体">的最初实现中，这个函数有一个很大的问题：由于其粒度很细，所以可能会更加频繁的唤醒内核，导致消耗更多的能源。为了实现既能节省能源，又能确保精确的调度超时，</span><span style="font-family:Arial">Arjan van de Ven </span><span style="font-family:宋体">的办法是将一个超时点变成一个超时范围。设置</span><span style="font-family:Arial"> hrtimer A </span><span style="font-family:宋体">的超时值有一个上限，称为</span><span style="font-family:Arial"> hard expire</span><span style="font-family:宋体">，在</span><span style="font-family:Arial"> hard expire </span><span style="font-family:宋体">这个时间点上设置</span><span style="font-family:Arial"> hrtimer A </span><span style="font-family:宋体">的超时中断；同时设置</span><span style="font-family:Arial"> hrtimer A </span><span style="font-family:宋体">的超时值有一个下限，称为</span><span style="font-family:Arial"> soft expire</span><span style="font-family:宋体">。在</span><span style="font-family:Arial"> soft expire </span><span style="font-family:宋体">到</span><span style="font-family:Arial"> hard expire </span><span style="font-family:宋体">之间如果有一个</span><span style="font-family:Arial"> hrtimer B </span><span style="font-family:宋体">的中断被触发，在</span><span style="font-family:Arial"> hrtimer B </span><span style="font-family:宋体">的中断处理函数中，内核会检查是否有其他</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> soft expire </span><span style="font-family:宋体">超时了，譬如</span><span style="font-family:Arial"> hrtimer A </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> soft expire </span><span style="font-family:宋体">超时了，即使</span><span style="font-family:Arial"> hrtimer A </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> hard expire </span><span style="font-family:宋体">没有到，也可以顺带被处理。换言之，将原来必须在</span><span style="font-family:Arial"> hard expire </span><span style="font-family:宋体">超时才能执行的一个点变成一个范围后，可以尽量把</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">中断放在一起处理，这样</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">被重复唤醒的几率会变小，从而达到节能的效果，同时这个</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">也可以保证其执行精度。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-family:Arial; font-size:9pt">**Deferrable timers &amp; round jiffies**
		</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在内核中使用的某些</span><span style="font-family:Arial"> legacy timer </span><span style="font-family:宋体">对于精确的超时值并不敏感，早一点或者晚一点执行并不会产生多大的影响，因此，如果可以把这些对时间不敏感同时超时时间又比较接近的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">收集在一起执行，可以进一步减少</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">被唤醒的次数，从而达到节能的目地。这正是引入</span><span style="font-family:Arial"> Deferrable timers </span><span style="font-family:宋体">的目地。如果一个</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">可以被短暂延时，那么可以通过调用</span><span style="font-family:Arial"> init_timer_deferrable </span><span style="font-family:宋体">设置</span><span style="font-family:Arial"> defer </span><span style="font-family:宋体">标记，从而在执行时灵活选择处理方式。不过，如果这些</span><span style="font-family:Arial"> timers </span><span style="font-family:宋体">都被延时到同一个时间点上也不是最优的选择，这样同样会产生</span><span style="font-family:Arial"> lock </span><span style="font-family:宋体">竞争以及</span><span style="font-family:Arial"> cache-line </span><span style="font-family:宋体">的问题。因此，即便将</span><span style="font-family:Arial"> defer timers </span><span style="font-family:宋体">收集到一起，彼此之间也必须稍稍错开一些以防止上述问题。这正是引入</span><span style="font-family:Arial"> round_jiffies </span><span style="font-family:宋体">函数的原因。虽然这样做会使得</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">被唤醒的次数稍多一些，但是由于间隔短，</span><span style="font-family:Arial">CPU </span><span style="font-family:宋体">并不会进入很深的睡眠，这个代价还是可以接受的。由于</span><span style="font-family:Arial"> round_jiffies </span><span style="font-family:宋体">需要在每次更新</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">的超时值（</span><span style="font-family:Arial">mod_timer</span><span style="font-family:宋体">）时被调用，显得有些繁琐，因此又出现了更为便捷的</span><span style="font-family:Arial"> round jiffies </span><span style="font-family:宋体">机制，称为</span><span style="font-family:Arial"> timer slack</span><span style="font-family:宋体">。</span><span style="font-family:Arial">Timer slack </span><span style="font-family:宋体">修改了</span><span style="font-family:Arial"> timer_list </span><span style="font-family:宋体">的结构定义，将需要偏移的</span><span style="font-family:Arial"> jiffies </span><span style="font-family:宋体">值保存在</span><span style="font-family:Arial"> timer_list </span><span style="font-family:宋体">内部，通过</span><span style="font-family:Arial"> apply_slack </span><span style="font-family:宋体">在每次更新</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">的过程中自动更新超时值。</span><span style="font-family:Arial">apply_slack </span><span style="font-family:宋体">的实现如清单</span><span style="font-family:Arial"> 9 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 9\. apply_slack </span><span style="font-family:宋体">的实现</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> /* 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> * Decide where to put the timer while taking the slack into account 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> * 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> * Algorithm: 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> *  1) calculate the maximum (absolute) time 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> *  2) calculate the highest bit where the expires and new max are different 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> *  3) use this bit to make a mask 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> *  4) use the bitmask to round down the maximum time, so that all last 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> *   bits are zeros 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> static inline 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> unsigned long apply_slack(struct timer_list *timer, unsigned long expires) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    unsigned long expires_limit, mask; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    int bit; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    expires_limit = expires; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (timer-&gt;slack &gt;= 0) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        expires_limit = expires + timer-&gt;slack; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    } else { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        unsigned long now = jiffies; /* avoid reading jiffies twice */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        /* if already expired, no slack; otherwise slack 0.4% */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        if (time_after(expires, now)) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">            expires_limit = expires + (expires - now)/256; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    mask = expires ^ expires_limit; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (mask == 0) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        return expires; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    bit = find_last_bit(&amp;mask, BITS_PER_LONG); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    mask = (1 &lt;&lt; bit) - 1; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    expires_limit = expires_limit &amp; ~(mask); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    return expires_limit; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">随着现代计算机系统的发展，对节能的需求越来越高，尤其是在使用笔记本，手持设备等移动环境是对节能要求更高。</span><span style="font-family:Arial">Linux </span><span style="font-family:宋体">当然也会更加关注这方面的需求。</span><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">子系统的优化尽量确保在使用高精度的时钟的同时节约能源，如果系统在空闲时也可以尽量的节能，则</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">系统的节能优势可以进一步放大。这也是引入</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的根本原因。</span><span style="font-family:Arial">
			</span></span>

[<span style="color:#745285; font-family:宋体; font-size:9pt; text-decoration:underline">**回页首**</span>](https://www.ibm.com/developerworks/cn/linux/l-cn-timerm/)<span style="color:#222222; font-family:Arial; font-size:9pt">
		</span>

<span style="color:black; font-family:Helvetica; font-size:18pt">**Dynamic tick &amp; tickless
**</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">引入之前，内核一直使用周期性的基于</span><span style="font-family:Arial"> HZ </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">。传统的</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">机制在系统进入空闲状态时仍然会产生周期性的中断，这种频繁的中断迫使</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">无法进入更深的睡眠。如果放开这个限制，在系统进入空闲时停止</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，有工作时恢复</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，实现完全自由的，根据需要产生</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">的机制，可以使</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">获得更多的睡眠机会以及更深的睡眠，从而进一步节能。</span><span style="font-family:Arial">dynamic tick </span><span style="font-family:宋体">的出现，就是为彻底替换掉周期性的</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">机制而产生的。周期性运行的</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">机制需要完成诸如进程时间片的计算，更新</span><span style="font-family:Arial"> profile</span><span style="font-family:宋体">，协助</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">进行负载均衡等诸多工作，这些工作</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">都提供了相应的模拟机制来完成。由于</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的实现需要内核的很多模块的配合，包括了很多实现细节，这里只介绍</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的核心工作机制，以及如何启动和停止</span><span style="font-family:Arial"> dynamic tick</span><span style="font-family:宋体">。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:13pt">**<span style="font-family:Helvetica">Dynamic tick </span><span style="font-family:宋体">的核心处理流程</span><span style="font-family:Helvetica">
				</span>**</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">从上文中可知内核时钟子系统支持低精度和高精度两种模式，因此</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">也必须有两套对应的处理机制。从清单</span><span style="font-family:Arial"> 5 </span><span style="font-family:宋体">中可以得知，如果系统支持</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">的高精度模式，</span><span style="font-family:Arial">hrtimer </span><span style="font-family:宋体">可以在此从低精度模式切换到高精度模式。其实清单</span><span style="font-family:Arial"> 5 </span><span style="font-family:宋体">还有另外一个重要功能：它也是低精度模式下从周期性</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">到</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的切换点。如果当前系统不支持高精度模式，系统会尝试切换到</span><span style="font-family:Arial"> NOHZ </span><span style="font-family:宋体">模式，也就是使用</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的模式，当然前提是内核使能了</span><span style="font-family:Arial"> NOHZ </span><span style="font-family:宋体">模式。其核心处理函数如清单</span><span style="font-family:Arial"> 10 </span><span style="font-family:宋体">所示。这个函数的调用流程如下：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> tick_check_oneshot_change 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> tick_nohz_switch_to_nohz 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    tick_switch_to_oneshot(tick_nohz_handler)
</span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 10\. </span><span style="font-family:宋体">低精度模式下</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的核心处理函数</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> static void tick_nohz_handler(struct clock_event_device *dev) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    struct tick_sched *ts = &amp;__get_cpu_var(tick_cpu_sched); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    struct pt_regs *regs = get_irq_regs(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    int cpu = smp_processor_id(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    ktime_t now = ktime_get(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    dev-&gt;next_event.tv64 = KTIME_MAX; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        tick_do_timer_cpu = cpu; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    /* Check, if the jiffies need an update */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (tick_do_timer_cpu == cpu) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        tick_do_update_jiffies64(now); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    /* 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * When we are idle and the tick is stopped, we have to touch 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * the watchdog as we might not schedule for a really long 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * time. This happens on complete idle SMP systems while 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * waiting on the login prompt. We also increment the "start 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * of idle" jiffy stamp so the idle accounting adjustment we 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     * do when we go busy again does not account too much ticks. 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">     */ 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    if (ts-&gt;tick_stopped) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        touch_softlockup_watchdog(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        ts-&gt;idle_jiffies++; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    update_process_times(user_mode(regs)); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    profile_tick(CPU_PROFILING); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    while (tick_nohz_reprogram(ts, now)) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        now = ktime_get(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        tick_do_update_jiffies64(now); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在这个函数中，首先模拟周期性</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">完成类似的工作：如果当前</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">负责全局</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的工作，则更新</span><span style="font-family:Arial"> jiffies</span><span style="font-family:宋体">，同时完成对本地</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">的进程时间统计等工作。如果当前</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">在此之前已经处于停止状态，为了防止</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">停止时间过长造成</span><span style="font-family:Arial"> watchdog </span><span style="font-family:宋体">超时，从而引发</span><span style="font-family:Arial"> soft-lockdep </span><span style="font-family:宋体">的错误，需要通过调用</span><span style="font-family:Arial"> touch_softlockup_watchdog </span><span style="font-family:宋体">复位软件看门狗防止其溢出。正如代码中注释所描述的，这种情况有可能出现在启动完毕，完全空闲等待登录的</span><span style="font-family:Arial"> SMP </span><span style="font-family:宋体">系统上。最后需要设置下一次</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">的超时时间。如果</span><span style="font-family:Arial"> tick_nohz_reprogram </span><span style="font-family:宋体">执行时间超过了一个</span><span style="font-family:Arial"> jiffy</span><span style="font-family:宋体">，会导致设置的下一次超时时间已经过期，因此需要重新设置，相应的也需要再次更新</span><span style="font-family:Arial"> jiffies</span><span style="font-family:宋体">。这里虽然设置了下一次的超时事件，但是由于系统空闲时会停止</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">，因此下一次的超时事件可能发生，也可能不发生。这也正是</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">根本特性。</span><span style="font-family:Arial">
			</span></span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">从清单</span><span style="font-family:Arial"> 7 </span><span style="font-family:宋体">中可以看到，在高精度模式下</span><span style="font-family:Arial"> tick_sched_timer </span><span style="font-family:宋体">用来模拟周期性</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的功能。</span><span style="font-family:Arial">dynamic tick </span><span style="font-family:宋体">的实现也使用了这个函数。这是因为</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">在高精度模式时必须使用</span><span style="font-family:Arial"> one-shot </span><span style="font-family:宋体">模式的</span><span style="font-family:Arial"> tick device</span><span style="font-family:宋体">，这也同时符合</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的要求。虽然使用同样的函数，表面上都会触发周期性的</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">中断，但是使用</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的系统在空闲时会停止</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">工作，因此</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">中断不会是周期产生的。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:13pt">**<span style="font-family:Helvetica">Dynamic tick </span><span style="font-family:宋体">的开始和停止</span><span style="font-family:Helvetica">
				</span>**</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">当</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">进入空闲时是最好的时机。此时可以启动</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">机制，停止</span><span style="font-family:Arial"> tick</span><span style="font-family:宋体">；反之在</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">从空闲中恢复到工作状态时，则可以停止</span><span style="font-family:Arial"> dynamic tick</span><span style="font-family:宋体">。见清单</span><span style="font-family:Arial"> 11 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 11\. CPU </span><span style="font-family:宋体">在</span><span style="font-family:Arial"> idle </span><span style="font-family:宋体">时</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的启动</span><span style="font-family:Arial"> / </span><span style="font-family:宋体">停止设置</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> void cpu_idle(void) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        while (1) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                tick_nohz_stop_sched_tick(1); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                while (!need_resched()) { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                           . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                tick_nohz_restart_sched_tick(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

[<span style="color:#745285; font-family:宋体; font-size:9pt; text-decoration:underline">**回页首**</span>](https://www.ibm.com/developerworks/cn/linux/l-cn-timerm/)<span style="color:#222222; font-family:Arial; font-size:9pt">
		</span>

<span style="color:black; font-size:18pt">**<span style="font-family:Helvetica">timer </span><span style="font-family:宋体">子系统的初始化过程</span><span style="font-family:Helvetica">
				</span>**</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在分别了解了内核时钟子系统各个模块后，现在可以系统的介绍内核时钟子系统的初始化过程。系统刚上电时，需要注册</span><span style="font-family:Arial"> IRQ0 </span><span style="font-family:宋体">时钟中断，完成时钟源设备，时钟事件设备，</span><span style="font-family:Arial">tick device </span><span style="font-family:宋体">等初始化操作并选择合适的工作模式。由于刚启动时没有特别重要的任务要做，因此默认是进入低精度</span><span style="font-family:Arial"> + </span><span style="font-family:宋体">周期</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">的工作模式，之后会根据硬件的配置（如硬件上是否支持</span><span style="font-family:Arial"> HPET </span><span style="font-family:宋体">等高精度</span><span style="font-family:Arial"> timer</span><span style="font-family:宋体">）和软件的配置（如是否通过命令行参数或者内核配置使能了高精度</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">等特性）进行切换。在一个支持</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">高精度模式并使能了</span><span style="font-family:Arial"> dynamic tick </span><span style="font-family:宋体">的系统中，第一次发生</span><span style="font-family:Arial"> IRQ0 </span><span style="font-family:宋体">的软中断时</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">就会进行从低精度到高精度的切换，然后再进一步切换到</span><span style="font-family:Arial"> NOHZ </span><span style="font-family:宋体">模式。</span><span style="font-family:Arial">IRQ0 </span><span style="font-family:宋体">为系统的时钟中断，使用全局的时钟事件设备（</span><span style="font-family:Arial">global_clock_event</span><span style="font-family:宋体">）来处理的，其定义如下：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> static struct irqaction irq0  = { 
</span>

<span style="color:black; font-size:8pt"><span style="font-family:Lucida Console">        .handler = </span><span style="font-family:Arial">**timer_interrupt**</span><span style="font-family:Lucida Console">, 
</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        .flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL | IRQF_TIMER, 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        .name = "timer"
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> };
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">它的中断处理函数</span><span style="font-family:Arial"> timer_interrupt </span><span style="font-family:宋体">的简化实现如清单</span><span style="font-family:Arial"> 12 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 12\. IRQ0 </span><span style="font-family:宋体">中断处理函数的简化实现</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> static irqreturn_t timer_interrupt(int irq, void *dev_id) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> . . . . 
</span>

<span style="color:black; font-size:8pt"><span style="font-family:Lucida Console">
			</span><span style="font-family:Arial">**global_clock_event-&gt;event_handler(global_clock_event);**</span><span style="font-family:Lucida Console">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> . . . . 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        return IRQ_HANDLED; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在</span><span style="font-family:Arial"> global_clock_event-&gt;event_handler </span><span style="font-family:宋体">的处理中，除了更新</span><span style="font-family:Arial"> local CPU </span><span style="font-family:宋体">上运行进程时间的统计，</span><span style="font-family:Arial">profile </span><span style="font-family:宋体">等工作，更重要的是要完成更新</span><span style="font-family:Arial"> jiffies </span><span style="font-family:宋体">等全局操作。这个全局的时钟事件设备的</span><span style="font-family:Arial"> event_handler </span><span style="font-family:宋体">根据使用环境的不同，在低精度模式下可能是</span><span style="font-family:Arial"> tick_handle_periodic / tick_handle_periodic_broadcast</span><span style="font-family:宋体">，在高精度模式下是</span><span style="font-family:Arial"> hrtimer_interrupt</span><span style="font-family:宋体">。目前只有</span><span style="font-family:Arial"> HPET </span><span style="font-family:宋体">或者</span><span style="font-family:Arial"> PIT </span><span style="font-family:宋体">可以作为</span><span style="font-family:Arial"> global_clock_event </span><span style="font-family:宋体">使用。其初始化流程清单</span><span style="font-family:Arial"> 13 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-size:10pt">**<span style="font-family:宋体">清单</span><span style="font-family:Arial"> 13\. timer </span><span style="font-family:宋体">子系统的初始化流程</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> void __init time_init(void) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        late_time_init = x86_late_time_init; 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> } 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> static __init void x86_late_time_init(void) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        x86_init.timers.timer_init(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        tsc_init(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> } 
</span>

<span style="color:black; font-size:8pt"><span style="font-family:Lucida Console"> /* x86_init.timers.timer_init </span><span style="font-family:宋体">是指向</span><span style="font-family:Lucida Console"> hpet_time_init </span><span style="font-family:宋体">的回调指针</span><span style="font-family:Lucida Console"> */ 
</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> void __init hpet_time_init(void) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> { 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        if (!hpet_enable()) 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">                setup_pit_timer(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        setup_default_timer_irq(); 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> }
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">由清单</span><span style="font-family:Arial"> 13 </span><span style="font-family:宋体">可以看到，系统优先使用</span><span style="font-family:Arial"> HPET </span><span style="font-family:宋体">作为</span><span style="font-family:Arial"> global_clock_event</span><span style="font-family:宋体">，只有在</span><span style="font-family:Arial"> HPET </span><span style="font-family:宋体">没有使能时，</span><span style="font-family:Arial">PIT </span><span style="font-family:宋体">才有机会成为</span><span style="font-family:Arial"> global_clock_event</span><span style="font-family:宋体">。在使能</span><span style="font-family:Arial"> HPET </span><span style="font-family:宋体">的过程中，</span><span style="font-family:Arial">HPET </span><span style="font-family:宋体">会同时被注册为时钟源设备和时钟事件设备。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> hpet_enable 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    hpet_clocksource_register 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> hpet_legacy_clockevent_register 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    clockevents_register_device(&amp;hpet_clockevent);
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:Arial">clockevent_register_device </span><span style="font-family:宋体">会触发</span><span style="font-family:Arial"> CLOCK_EVT_NOTIFY_ADD </span><span style="font-family:宋体">事件，即创建对应的</span><span style="font-family:Arial"> tick device</span><span style="font-family:宋体">。然后在</span><span style="font-family:Arial"> tick_notify </span><span style="font-family:宋体">这个事件处理函数中会添加新的</span><span style="font-family:Arial"> tick device</span><span style="font-family:宋体">。</span><span style="font-family:Arial">
			</span></span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> clockevent_register_device trigger event CLOCK_EVT_NOTIFY_ADD 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt"> tick_notify receives event CLOCK_EVT_NOTIFY_ADD 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">    tick_check_new_device 
</span>

<span style="color:black; font-family:Lucida Console; font-size:8pt">        tick_setup_device
</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">在</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的设置过程中，会根据新加入的时钟事件设备是否使用</span><span style="font-family:Arial"> broadcast </span><span style="font-family:宋体">来分别设置</span><span style="font-family:Arial"> event_handler</span><span style="font-family:宋体">。对于</span><span style="font-family:Arial"> tick device </span><span style="font-family:宋体">的处理函数，可见图</span><span style="font-family:Arial"> 5 </span><span style="font-family:宋体">所示：</span><span style="font-family:Arial">
			</span></span>

<span style="color:black"><span style="font-size:10pt">**<span style="font-family:宋体">表</span><span style="font-family:Arial"> 2\. tick device </span><span style="font-family:宋体">在不同模式下的处理函数</span>**</span><span style="font-family:Arial"><span style="font-size:10pt">**
						<table style="border-collapse:collapse" border="0"><colgroup><col style="width:110px"/><col style="width:168px"/><col style="width:172px"/></colgroup><tbody valign="top"><tr><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 10px; border-top:  solid #999999 1.5pt; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  solid white 2.25pt"> </td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  solid #999999 1.5pt; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  solid white 2.25pt"><p><span style="color:black; font-family:Arial; font-size:12pt"><strong>low resolution mode**</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  solid #999999 1.5pt; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  none">

<span style="color:black; font-family:Arial; font-size:12pt">**High resolution mode**</span>
</td></tr><tr><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  solid white 2.25pt">

<span style="color:#555555; font-family:Arial; font-size:12pt">**periodic tick**</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  none; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  solid white 2.25pt">

<span style="color:#555555; font-family:宋体; font-size:12pt">tick_handle_periodic</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  none; border-left:  none; border-bottom:  solid #dddddd 0.75pt; border-right:  none">

<span style="color:#555555; font-family:宋体; font-size:12pt">hrtimer_interrupt</span>
</td></tr><tr><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #cccccc 0.75pt; border-right:  solid white 2.25pt">

<span style="color:#555555; font-family:Arial; font-size:12pt">**dynamic tick**</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  none; border-left:  none; border-bottom:  solid #cccccc 0.75pt; border-right:  solid white 2.25pt">

<span style="color:#555555; font-family:宋体; font-size:12pt">tick_nohz_handler</span>
</td><td style="padding-top: 8px; padding-left: 3px; padding-bottom: 5px; padding-right: 5px; border-top:  none; border-left:  none; border-bottom:  solid #cccccc 0.75pt; border-right:  none">

<span style="color:#555555; font-family:宋体; font-size:12pt">hrtimer_interrupt</span>
</td></tr></tbody></table></strong></span>

</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">另外，在系统运行的过程中，可以通过查看</span><span style="font-family:Arial"> /proc/timer_list </span><span style="font-family:宋体">来显示系统当前配置的所有时钟的详细情况，譬如当前系统活动的时钟源设备，时钟事件设备，</span><span style="font-family:Arial">tick device </span><span style="font-family:宋体">等。也可以通过查看</span><span style="font-family:Arial"> /proc/timer_stats </span><span style="font-family:宋体">来查看当前系统中所有正在使用的</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">的统计信息。包括所有正在使用</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">的进程，启动</span><span style="font-family:Arial"> / </span><span style="font-family:宋体">停止</span><span style="font-family:Arial"> timer </span><span style="font-family:宋体">的函数，</span><span style="font-family:Arial">timer </span><span style="font-family:宋体">使用的频率等信息。内核需要配置</span><span style="font-family:Arial"> CONFIG_TIMER_STATS=y</span><span style="font-family:宋体">，而且在系统启动时这个功能是关闭的，需要通过如下命令激活</span><span style="font-family:Arial">"echo 1 &gt;/proc/timer_stats"</span><span style="font-family:宋体">。</span><span style="font-family:Arial">/proc/timer_stats </span><span style="font-family:宋体">的显示格式如下所示：</span><span style="font-family:Arial">
					</span></span>

<span style="color:#222222; font-family:Arial; font-size:9pt">&lt;count&gt;, &lt;pid&gt; &lt;command&gt; &lt;start_func&gt; (&lt;expire_func&gt;)
</span>

[<span style="color:#745285; font-family:宋体; font-size:9pt; text-decoration:underline">**回页首**</span>](https://www.ibm.com/developerworks/cn/linux/l-cn-timerm/)<span style="color:#222222; font-family:Arial; font-size:9pt">
				</span>

<span style="font-size:18pt">**<span style="font-family:宋体">总结</span><span style="font-family:Helvetica">
						</span>**</span>

<span style="color:#222222; font-size:9pt"><span style="font-family:宋体">随着应用环境的改变，使用需求的多样化，</span><span style="font-family:Arial">Linux </span><span style="font-family:宋体">的时钟子系统也在不断的衍变。为了更好的支持音视频等对时间精度高的应用，</span><span style="font-family:Arial">Linux </span><span style="font-family:宋体">提出了</span><span style="font-family:Arial"> hrtimer </span><span style="font-family:宋体">这一高精度的时钟子系统，为了节约能源，</span><span style="font-family:Arial">Linux </span><span style="font-family:宋体">改变了长久以来一直使用的基于</span><span style="font-family:Arial"> HZ </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> tick </span><span style="font-family:宋体">机制，采用了</span><span style="font-family:Arial"> tickless </span><span style="font-family:宋体">系统。即使是在对硬件平台的支持上，也是在不断改进。举例来说，由于</span><span style="font-family:Arial"> TSC </span><span style="font-family:宋体">精度高，是首选的时钟源设备。但是现代</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">会在系统空闲时降低频率以节约能源，从而导致</span><span style="font-family:Arial"> TSC </span><span style="font-family:宋体">的频率也会跟随发生改变。这样会导致</span><span style="font-family:Arial"> TSC </span><span style="font-family:宋体">无法作为稳定的时钟源设备使用。随着新的</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">的出现，即使</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">的频率发生变化，</span><span style="font-family:Arial">TSC </span><span style="font-family:宋体">也可以一直维持在固定频率上，从而确保其稳定性。在</span><span style="font-family:Arial"> Intel </span><span style="font-family:宋体">的</span><span style="font-family:Arial"> Westmere </span><span style="font-family:宋体">之前的</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">中，</span><span style="font-family:Arial">TSC </span><span style="font-family:宋体">和</span><span style="font-family:Arial"> Local APIC Timer </span><span style="font-family:宋体">类似，都会在</span><span style="font-family:Arial"> C3+ </span><span style="font-family:宋体">状态时进入睡眠，从而导致系统需要切换到其他较低精度的时钟源设备上，但是在</span><span style="font-family:Arial"> Intel Westmere </span><span style="font-family:宋体">之后的</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">中，</span><span style="font-family:Arial">TSC </span><span style="font-family:宋体">可以一直保持运行状态，即使</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">进入了</span><span style="font-family:Arial"> C3+ </span><span style="font-family:宋体">的睡眠状态，从而避免了时钟源设备的切换。在</span><span style="font-family:Arial"> SMP </span><span style="font-family:宋体">的环境下，尤其是</span><span style="font-family:Arial"> 16-COREs</span><span style="font-family:宋体">，</span><span style="font-family:Arial">32-COREs </span><span style="font-family:宋体">这样的多</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">系统中，每个</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">之间的</span><span style="font-family:Arial"> TSC </span><span style="font-family:宋体">很难保持同步，很容易出现</span><span style="font-family:Arial">"Out-of-Sync"</span><span style="font-family:宋体">。如果在这种环境下使用</span><span style="font-family:Arial"> TSC</span><span style="font-family:宋体">，会造成</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">之间的计时误差，然而在</span><span style="font-family:Arial"> Intel </span><span style="font-family:宋体">最新的</span><span style="font-family:Arial"> Nehalem-EX CPU </span><span style="font-family:宋体">中，已经可以确保</span><span style="font-family:Arial"> TSC </span><span style="font-family:宋体">在多个</span><span style="font-family:Arial"> CPU </span><span style="font-family:宋体">之间保持同步，从而可以使用</span><span style="font-family:Arial"> TSC </span><span style="font-family:宋体">作为首选的时钟源设备。由此可见，无论是现在还是将来，只要有需要，内核的时钟子系统就会一直向前发展。</span><span style="font-family:Arial">
					</span></span>

<span style="font-size:18pt">**<span style="font-family:宋体">参考资料</span><span style="font-family:Helvetica">
						</span>**</span>

*   <div style="background: white"><span style="color:#333333"><span style="font-family:Arial">"Professional Linux Kernel Architecture"</span><span style="font-family:宋体">一书以</span><span style="font-family:Arial"> Linux 2.6.24 </span><span style="font-family:宋体">为基础全面介绍了</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">内核的整体架构和各个子系统模块的组成和实现。</span><span style="font-family:Arial">
							</span></span></div></span></p>

*   <div style="background: white"><span style="color:#333333"><span style="font-family:Arial">"Understanding Linux Kernel 3<span style="font-size:9pt"><sup>rd</sup></span>version"</span><span style="font-family:宋体">一书以</span><span style="font-family:Arial"> Linux 2.6 </span><span style="font-family:宋体">内核为基础全面介绍了</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">内核的核心组成部分，包括内存管理、</span><span style="font-family:Arial">VFS</span><span style="font-family:宋体">、进程管理和调度等，以及内核自</span><span style="font-family:Arial"> 2.6 </span><span style="font-family:宋体">以来发生的显著变化。</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#333333"><span style="font-family:宋体">有关</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">内核源码，请参考</span><span style="font-family:Arial"> [<span style="color:#745285; text-decoration:underline">Linux source code 2.6.34</span>](http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.34.tar.bz2)</span><span style="font-family:宋体">。</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#333333"><span style="font-family:Arial">Linux symposium 2006 "[<span style="color:#745285; text-decoration:underline">Hrtimers and Beyond: Transforming the Linux Time Subsystems</span>](http://www.kernel.org/doc/ols/2006/ols2006v1-pages-333-346.pdf)"</span><span style="font-family:宋体">讨论了内核</span><span style="font-family:Arial"> Timing </span><span style="font-family:宋体">子系统的发展和变化历程。</span><span style="font-family:Arial">
					</span></span></div>
*   <div style="background: white"><span style="color:#333333"><span style="font-family:宋体">在</span><span style="font-family:Arial"> [<span style="color:#745285; text-decoration:underline">developerWorks Linux </span>](http://www.ibm.com/developerworks/cn/linux/)</span><span style="font-family:宋体; text-decoration:underline">专区</span><span style="font-family:Arial"> </span><span style="font-family:宋体">寻找为</span><span style="font-family:Arial"> Linux </span><span style="font-family:宋体">开发人员（包括</span><span style="font-family:Arial"> [<span style="color:#745285; text-decoration:underline">Linux </span>](http://www.ibm.com/developerworks/cn/linux/newto/)</span><span style="font-family:宋体"><span style="text-decoration:underline">新手入门</span>）准备的更多参考资料，查阅我们</span><span style="font-family:Arial"> [</span><span style="color:#745285"><span style="font-family:宋体"><span style="text-decoration:underline">最受欢迎的文章和教程</span><span style="color:#333333">。</span></span><span style="font-family:Arial">
						</span></span></span></div>
*   <div style="background: white"><span style="color:#333333"><span style="font-family:宋体">在</span><span style="font-family:Arial"> developerWorks </span><span style="font-family:宋体">上查阅所有</span><span style="font-family:Arial"> <a href="http://www.ibm.com/developerworks/cn/views/linux/libraryview.jsp?search_by=Linux+%E6%8A%80%E5%B7%A7"><span style="color:#745285; text-decoration:underline">Linux </span>](http://www.ibm.com/developerworks/cn/linux/best2009/index.html)</span><span style="font-family:宋体; text-decoration:underline">技巧</span><span style="font-family:Arial"> </span><span style="font-family:宋体">和</span><span style="font-family:Arial"> [<span style="color:#745285; text-decoration:underline">Linux </span>](http://www.ibm.com/developerworks/cn/views/linux/libraryview.jsp?type_by=%E6%95%99%E7%A8%8B)</span><span style="font-family:宋体"><span style="text-decoration:underline">教程</span>。</span><span style="font-family:Arial">
					</span></span></div>
