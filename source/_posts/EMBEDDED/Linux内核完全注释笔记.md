---
title: Linux内核完全注释笔记
id: 744
comment: false
categories:
  - arm
date: 2016-06-21 14:33:55
tags:
---

1.  <div style="background: #4f81bd">

    # 概述

    </div>

<!-- more -->
1.  <div style="background: #4f81bd">

    # 微型计算机组成结构

    </div>

1.  <div style="background: #4f81bd">

    # 内核编程语言和环境

    </div>

1.  <div style="background: #4f81bd">

    # 80X86保护模式及其编程

    </div>

1.  <div style="background: #4f81bd">

    # Linux内核体系结构

    </div>

![](http://www.madhex.com/wp-content/uploads/2016/06/062116_0633_Linux1.png)

1.  <div style="background: #4f81bd">

    # 引导启动程序(boot)

    </div>

1.  <div style="background: #4f81bd">

    # 初始化程序(init)

    </div>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* </span><span style="font-family:宋体">内核初始化主程序。初始化结束后将以任务</span><span style="font-family:Courier New">0 (idle</span><span style="font-family:宋体">任务即空闲任务</span><span style="font-family:Courier New">)</span><span style="font-family:宋体">的身份运行。</span><span style="font-family:Courier New"> */<span style="color:#444444">
				</span></span></span>

<span style="color:#d7005f; font-family:Courier New; font-size:10pt">**void**<span style="color:#444444">
				<span style="color:#ea4335">main<span style="color:#444444">(<span style="color:#d7005f">**void**<span style="color:#444444">)                         <span style="color:#878787">/* This really IS void, no error here. */<span style="color:#444444">
									</span></span></span></span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">{                                       <span style="color:#878787">/* The startup routine assumes (well, ...) this */<span style="color:#444444">
				</span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#878787">/* </span></span><span style="font-family:宋体">这里确实是</span><span style="color:#878787"><span style="font-family:Courier New">void</span><span style="font-family:宋体">，并没错。在</span><span style="font-family:Courier New">startup </span><span style="font-family:宋体">程序</span><span style="font-family:Courier New">(head.s)</span><span style="font-family:宋体">中就是这样假设的。</span><span style="font-family:Courier New">
					<span style="color:#444444">
					</span></span></span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">                                         * </span><span style="font-family:宋体">参见</span><span style="font-family:Courier New">head.s </span><span style="font-family:宋体">程序第</span><span style="font-family:Courier New">136 </span><span style="font-family:宋体">行开始的几行代码。</span><span style="font-family:Courier New"> */<span style="color:#444444">
				</span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">trap_init <span style="color:#444444">();                   <span style="color:#878787">/* </span></span></span></span><span style="font-family:宋体">陷阱门（硬件中断向量）初始化。（</span><span style="color:#878787"><span style="font-family:Courier New">kernel/traps.c</span><span style="font-family:宋体">，</span><span style="font-family:Courier New">181 </span><span style="font-family:宋体">行）</span><span style="font-family:Courier New"> */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">tty_init <span style="color:#444444">();                    <span style="color:#878787">/* tty </span></span></span></span><span style="font-family:宋体">初始化。（</span><span style="color:#878787"><span style="font-family:Courier New">kernel/chr_dev/tty_io.c</span><span style="font-family:宋体">，</span><span style="font-family:Courier New">105 </span><span style="font-family:宋体">行）</span><span style="font-family:Courier New">  */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">sched_init <span style="color:#444444">();                  <span style="color:#878787">/* </span></span></span></span><span style="font-family:宋体">调度程序初始化</span><span style="color:#878787"><span style="font-family:Courier New">(</span><span style="font-family:宋体">加载了任务</span><span style="font-family:Courier New">0 </span><span style="font-family:宋体">的</span><span style="font-family:Courier New">tr, ldtr) </span><span style="font-family:宋体">（</span><span style="font-family:Courier New">kernel/sched.c</span><span style="font-family:宋体">，</span><span style="font-family:Courier New">385</span><span style="font-family:宋体">）</span><span style="font-family:Courier New">   */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">buffer_init <span style="color:#444444">(buffer_memory_end);<span style="color:#878787">/* </span></span></span></span><span style="font-family:宋体">缓冲管理初始化，建内存链表等。（</span><span style="color:#878787"><span style="font-family:Courier New">fs/buffer.c</span><span style="font-family:宋体">，</span><span style="font-family:Courier New">348</span><span style="font-family:宋体">）</span><span style="font-family:Courier New">   */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">sti <span style="color:#444444">();                         <span style="color:#878787">/* </span></span></span></span><span style="font-family:宋体">所有初始化工作都做完了，开启中断。</span><span style="color:#878787; font-family:Courier New">   */<span style="color:#444444">
				</span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#878787">/* </span></span><span style="font-family:宋体">下面过程通过在堆栈中设置的参数，利用中断返回指令切换到任务</span><span style="color:#878787"><span style="font-family:Courier New">0</span><span style="font-family:宋体">。</span><span style="font-family:Courier New">    */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">move_to_user_mode <span style="color:#444444">();           <span style="color:#878787">/* </span></span></span></span><span style="font-family:宋体">移到用户模式。（</span><span style="color:#878787"><span style="font-family:Courier New">include/asm/system.h</span><span style="font-family:宋体">，第</span><span style="font-family:Courier New">1 </span><span style="font-family:宋体">行）</span><span style="font-family:Courier New">   */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**if**<span style="color:#444444"> (!<span style="color:#ea4335">fork<span style="color:#444444">())
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">    {           <span style="color:#878787">/* we count on this going ok */<span style="color:#444444">
				</span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">init<span style="color:#444444">();
</span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">    }
</span>

<span style="color:#878787; font-family:Courier New; font-size:10pt">/*<span style="color:#444444">
			</span></span>

<span style="color:#878787; font-family:Courier New; font-size:10pt"> *   NOTE!!   For any other task 'pause()' would mean we have to get a<span style="color:#444444">
			</span></span>

<span style="color:#878787; font-family:Courier New; font-size:10pt"> * signal to awaken, but task0 is the sole exception (see 'schedule()')<span style="color:#444444">
			</span></span>

<span style="color:#878787; font-family:Courier New; font-size:10pt"> * as task 0 gets activated at every idle moment (when no other tasks<span style="color:#444444">
			</span></span>

<span style="color:#878787; font-family:Courier New; font-size:10pt"> * can run). For task0 'pause()' just means we go check if some other<span style="color:#444444">
			</span></span>

<span style="color:#878787; font-family:Courier New; font-size:10pt"> * task can run, and if not we return here.<span style="color:#444444">
			</span></span>

<span style="color:#878787; font-family:Courier New; font-size:10pt"> */<span style="color:#444444">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* </span><span style="font-family:宋体">注意</span><span style="font-family:Courier New">!! </span><span style="font-family:宋体">对于任何其它的任务，</span><span style="font-family:Courier New">'pause()'</span><span style="font-family:宋体">将意味着我们必须等待收到一个信号才会返</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New"> * </span><span style="font-family:宋体">回就绪运行态，但任务</span><span style="font-family:Courier New">0</span><span style="font-family:宋体">（</span><span style="font-family:Courier New">task0</span><span style="font-family:宋体">）是唯一的意外情况（参见</span><span style="font-family:Courier New">'schedule()'</span><span style="font-family:宋体">），因为任务</span><span style="font-family:Courier New">0 </span><span style="font-family:宋体">在</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New"> * </span><span style="font-family:宋体">任何空闲时间里都会被激活（当没有其它任务在运行时），因此对于任务</span><span style="font-family:Courier New">0'pause()'</span><span style="font-family:宋体">仅意味着</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New"> * </span><span style="font-family:宋体">我们返回来查看是否有其它任务可以运行，如果没有的话我们就回到这里，一直循环执行</span><span style="font-family:Courier New">'pause()'</span><span style="font-family:宋体">。</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-family:Courier New; font-size:10pt"> */<span style="color:#444444">
			</span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**for**<span style="color:#444444">(;;) <span style="color:#ea4335">pause<span style="color:#444444">();
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">}
</span>

<span style="color:#d7005f; font-family:Courier New; font-size:10pt">**void**<span style="color:#444444">
				<span style="color:#ea4335">init<span style="color:#444444">(<span style="color:#d7005f">**void**<span style="color:#444444">)
</span></span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">{
</span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#d7005f">**int**<span style="color:#444444"> pid,i;
</span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#878787">/* </span></span><span style="font-family:宋体">读取硬盘参数包括分区表信息并建立虚拟盘和安装根文件系统设备。</span><span style="color:#878787; font-family:Courier New"> */<span style="color:#444444">
				</span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#878787">/* </span></span><span style="font-family:宋体">该函数是在</span><span style="color:#878787"><span style="font-family:Courier New">25 </span><span style="font-family:宋体">行上的宏定义的，对应函数是</span><span style="font-family:Courier New">sys_setup()</span><span style="font-family:宋体">，在</span><span style="font-family:Courier New">kernel/blk_drv/hd.c,71 </span><span style="font-family:宋体">行。</span><span style="font-family:Courier New">    */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">setup<span style="color:#444444">((<span style="color:#d7005f">**void**<span style="color:#444444"> *) &amp;drive_info);
</span></span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">    (<span style="color:#d7005f">**void**<span style="color:#444444">) <span style="color:#ea4335">open<span style="color:#444444">(<span style="color:#718c00">"/dev/tty0"<span style="color:#444444">,O_RDWR,<span style="color:#d75f00">0<span style="color:#444444">);  <span style="color:#878787">/* </span></span></span></span></span></span></span></span></span></span><span style="font-family:宋体">用读写访问方式打开设备</span><span style="color:#878787"><span style="font-family:Courier New">"/dev/tty0"</span><span style="font-family:宋体">，</span><span style="font-family:Courier New">  */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#878787">/* </span></span><span style="font-family:宋体">这里对应终端控制台。</span><span style="color:#878787; font-family:Courier New"> */<span style="color:#444444">
				</span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#878787">/* </span></span><span style="font-family:宋体">返回的句柄号</span><span style="color:#878787"><span style="font-family:Courier New">0 -- stdin </span><span style="font-family:宋体">标准输入设备。</span><span style="font-family:Courier New">    */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">    (<span style="color:#d7005f">**void**<span style="color:#444444">) <span style="color:#ea4335">dup <span style="color:#444444">(<span style="color:#d75f00">0<span style="color:#444444">);                     <span style="color:#878787">/* </span></span></span></span></span></span></span></span><span style="font-family:宋体">复制句柄，产生句柄</span><span style="color:#878787"><span style="font-family:Courier New">1 </span><span style="font-family:宋体">号</span><span style="font-family:Courier New"> -- stdout </span><span style="font-family:宋体">标准输出设备。</span><span style="font-family:Courier New">  */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">    (<span style="color:#d7005f">**void**<span style="color:#444444">) <span style="color:#ea4335">dup <span style="color:#444444">(<span style="color:#d75f00">0<span style="color:#444444">);                     <span style="color:#878787">/* </span></span></span></span></span></span></span></span><span style="font-family:宋体">复制句柄，产生句柄</span><span style="color:#878787"><span style="font-family:Courier New">2 </span><span style="font-family:宋体">号</span><span style="font-family:Courier New"> -- stderr </span><span style="font-family:宋体">标准出错输出设备。</span><span style="font-family:Courier New">  */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">printf<span style="color:#444444">(<span style="color:#718c00">"%d buffers = %d bytes buffer space**\n\r**"<span style="color:#444444">,NR_BUFFERS,NR_BUFFERS*BLOCK_SIZE);  <span style="color:#878787">/* </span></span></span></span></span></span><span style="font-family:宋体">打印缓冲区块数和总字节数，每块</span><span style="color:#878787"><span style="font-family:Courier New">1024 </span><span style="font-family:宋体">字节。</span><span style="font-family:Courier New">    */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">printf<span style="color:#444444">(<span style="color:#718c00">"Free mem: %d bytes**\n\r**"<span style="color:#444444">,memory_end-main_memory_start);      <span style="color:#878787">/*</span></span></span></span></span></span><span style="font-family:宋体">空闲内存字节数。</span><span style="color:#878787; font-family:Courier New">  */<span style="color:#444444">
				</span></span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* </span><span style="font-family:宋体">下面</span><span style="font-family:Courier New">fork()</span><span style="font-family:宋体">用于创建一个子进程</span><span style="font-family:Courier New">(</span><span style="font-family:宋体">子任务</span><span style="font-family:Courier New">)</span><span style="font-family:宋体">。</span><span style="font-family:Courier New">   */<span style="color:#444444">
				</span></span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* </span><span style="font-family:宋体">对于被创建的子进程，</span><span style="font-family:Courier New">fork()</span><span style="font-family:宋体">将返回</span><span style="font-family:Courier New">0 </span><span style="font-family:宋体">值，</span><span style="font-family:Courier New">
			</span><span style="font-family:宋体">对于原</span><span style="font-family:Courier New">(</span><span style="font-family:宋体">父进程</span><span style="font-family:Courier New">)</span><span style="font-family:宋体">将返回子进程的进程号。</span><span style="font-family:Courier New">    */<span style="color:#444444">
				</span></span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* </span><span style="font-family:宋体">所以</span><span style="font-family:Courier New">180-184 </span><span style="font-family:宋体">句是子进程执行的内容。</span><span style="font-family:Courier New">   */<span style="color:#444444">
				</span></span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* </span><span style="font-family:宋体">该子进程关闭了句柄</span><span style="font-family:Courier New">0(stdin)</span><span style="font-family:宋体">，以只读方式打开</span><span style="font-family:Courier New">/etc/rc </span><span style="font-family:宋体">文件，并执行</span><span style="font-family:Courier New">/bin/sh </span><span style="font-family:宋体">程序，所带参数和</span><span style="font-family:Courier New">   */<span style="color:#444444">
				</span></span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* </span><span style="font-family:宋体">环境变量分别由</span><span style="font-family:Courier New">argv_rc </span><span style="font-family:宋体">和</span><span style="font-family:Courier New">envp_rc </span><span style="font-family:宋体">数组给出。参见后面的描述。</span><span style="font-family:Courier New">   */<span style="color:#444444">
				</span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**if**<span style="color:#444444"> (!(pid=<span style="color:#ea4335">fork<span style="color:#444444">())) {
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">close<span style="color:#444444">(<span style="color:#d75f00">0<span style="color:#444444">);
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**if**<span style="color:#444444"> (<span style="color:#ea4335">open<span style="color:#444444">(<span style="color:#718c00">"/etc/rc"<span style="color:#444444">,O_RDONLY,<span style="color:#d75f00">0<span style="color:#444444">))
</span></span></span></span></span></span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">_exit<span style="color:#444444">(<span style="color:#d75f00">1<span style="color:#444444">);                   <span style="color:#878787">/* </span></span></span></span></span></span><span style="font-family:宋体">如果打开文件失败，则退出</span><span style="color:#878787"><span style="font-family:Courier New">(/lib/_exit.c,10)</span><span style="font-family:宋体">。</span><span style="font-family:Courier New">  */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">execve<span style="color:#444444">(<span style="color:#718c00">"/bin/sh"<span style="color:#444444">,argv_rc,envp_rc);  <span style="color:#878787">/* </span></span></span></span></span></span><span style="font-family:宋体">装入</span><span style="color:#878787"><span style="font-family:Courier New">/bin/sh </span><span style="font-family:宋体">程序并执行。</span><span style="font-family:Courier New"> */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-size:10pt"><span style="font-family:Courier New">
				<span style="color:#ea4335">_exit<span style="color:#444444">(<span style="color:#d75f00">2<span style="color:#444444">);                       <span style="color:#878787">/* </span></span></span></span></span></span><span style="font-family:宋体">若</span><span style="color:#878787"><span style="font-family:Courier New">execve()</span><span style="font-family:宋体">执行失败则退出</span><span style="font-family:Courier New">(</span><span style="font-family:宋体">出错码</span><span style="font-family:Courier New">2,"</span><span style="font-family:宋体">文件或目录不存在</span><span style="font-family:Courier New">")</span><span style="font-family:宋体">。</span><span style="font-family:Courier New">   */<span style="color:#444444">
					</span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">    }
</span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* </span><span style="font-family:宋体">下面是父进程执行的语句。</span><span style="font-family:Courier New"> */<span style="color:#444444">
				</span></span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* wait()</span><span style="font-family:宋体">是等待子进程停止或终止，其返回值应是子进程的进程号</span><span style="font-family:Courier New">(pid)</span><span style="font-family:宋体">。这三句的作用是父进程等待子进程的结束。</span><span style="font-family:Courier New">    */<span style="color:#444444">
				</span></span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* &amp;i </span><span style="font-family:宋体">是存放返回状态信息的位置。</span><span style="font-family:Courier New">
			</span><span style="font-family:宋体">如果</span><span style="font-family:Courier New">wait()</span><span style="font-family:宋体">返回值不等于子进程号，则继续等待。</span><span style="font-family:Courier New">   */<span style="color:#444444">
				</span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**if**<span style="color:#444444"> (pid&gt;<span style="color:#d75f00">0<span style="color:#444444">)
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**while**<span style="color:#444444"> (pid != <span style="color:#ea4335">wait<span style="color:#444444">(&amp;i))
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#878787">/* nothing */<span style="color:#444444">;
</span></span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New">/* </span><span style="font-family:宋体">如果执行到这里，说明刚创建的子进程的执行已停止或终止了。下面循环中首先再创建一个子进程，</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New"> * </span><span style="font-family:宋体">如果出错，则显示</span><span style="font-family:Courier New">"</span><span style="font-family:宋体">初始化程序创建子进程失败</span><span style="font-family:Courier New">"</span><span style="font-family:宋体">的信息并继续执行。对于所创建的子进程关闭所有</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New"> * </span><span style="font-family:宋体">以前还遗留的句柄</span><span style="font-family:Courier New">(stdin, stdout, stderr)</span><span style="font-family:宋体">，新创建一个会话并设置进程组号，然后重新打开</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New"> * /dev/tty0 </span><span style="font-family:宋体">作为</span><span style="font-family:Courier New">stdin</span><span style="font-family:宋体">，并复制成</span><span style="font-family:Courier New">stdout </span><span style="font-family:宋体">和</span><span style="font-family:Courier New">stderr</span><span style="font-family:宋体">。</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New"> * </span><span style="font-family:宋体">再次执行系统解释程序</span><span style="font-family:Courier New">/bin/sh</span><span style="font-family:宋体">。但这次执行所选用的参数和环境数组另选了一套（见上面</span><span style="font-family:Courier New">165-167 </span><span style="font-family:宋体">行）。</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New"> * </span><span style="font-family:宋体">然后父进程再次运行</span><span style="font-family:Courier New">wait()</span><span style="font-family:宋体">等待。如果子进程又停止了执行，则在标准输出上显示出错信息</span><span style="font-family:Courier New">"</span><span style="font-family:宋体">子进程</span><span style="font-family:Courier New">pid </span><span style="font-family:宋体">停</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-size:10pt"><span style="font-family:Courier New"> * </span><span style="font-family:宋体">止了运行，返回码是</span><span style="font-family:Courier New">i"</span><span style="font-family:宋体">，然后继续重试下去</span><span style="font-family:Courier New">…</span><span style="font-family:宋体">，形成</span><span style="font-family:Courier New">"</span><span style="font-family:宋体">大</span><span style="font-family:Courier New">"</span><span style="font-family:宋体">死循环。</span><span style="color:#444444; font-family:Courier New">
			</span></span>

<span style="color:#878787; font-family:Courier New; font-size:10pt"> */<span style="color:#444444">
			</span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**while**<span style="color:#444444"> (<span style="color:#d75f00">1<span style="color:#444444">) {
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**if**<span style="color:#444444"> ((pid=<span style="color:#ea4335">fork<span style="color:#444444">())&lt;<span style="color:#d75f00">0<span style="color:#444444">) {
</span></span></span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">printf<span style="color:#444444">(<span style="color:#718c00">"Fork failed in init**\r\n**"<span style="color:#444444">);
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#d7005f">continue<span style="color:#444444">;
</span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">        }
</span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**if**<span style="color:#444444"> (!pid) {
</span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">close<span style="color:#444444">(<span style="color:#d75f00">0<span style="color:#444444">);<span style="color:#ea4335">close<span style="color:#444444">(<span style="color:#d75f00">1<span style="color:#444444">);<span style="color:#ea4335">close<span style="color:#444444">(<span style="color:#d75f00">2<span style="color:#444444">);
</span></span></span></span></span></span></span></span></span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">setsid<span style="color:#444444">();
</span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">            (<span style="color:#d7005f">**void**<span style="color:#444444">) <span style="color:#ea4335">open<span style="color:#444444">(<span style="color:#718c00">"/dev/tty0"<span style="color:#444444">,O_RDWR,<span style="color:#d75f00">0<span style="color:#444444">);
</span></span></span></span></span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">            (<span style="color:#d7005f">**void**<span style="color:#444444">) <span style="color:#ea4335">dup<span style="color:#444444">(<span style="color:#d75f00">0<span style="color:#444444">);
</span></span></span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">            (<span style="color:#d7005f">**void**<span style="color:#444444">) <span style="color:#ea4335">dup<span style="color:#444444">(<span style="color:#d75f00">0<span style="color:#444444">);
</span></span></span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">_exit<span style="color:#444444">(<span style="color:#ea4335">execve<span style="color:#444444">(<span style="color:#718c00">"/bin/sh"<span style="color:#444444">,argv,envp));
</span></span></span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">        }
</span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**while**<span style="color:#444444"> (<span style="color:#d75f00">1<span style="color:#444444">)
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#8959a8">**if**<span style="color:#444444"> (pid == <span style="color:#ea4335">wait<span style="color:#444444">(&amp;i))
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#d7005f">break<span style="color:#444444">;
</span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">printf<span style="color:#444444">(<span style="color:#718c00">"**\n\r**child %d died with code %04x**\n\r**"<span style="color:#444444">,pid,i);
</span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">sync<span style="color:#444444">();
</span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">    }
</span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">
			<span style="color:#ea4335">_exit<span style="color:#444444">(<span style="color:#d75f00">0<span style="color:#444444">);   <span style="color:#878787">/* NOTE! _exit, not exit() */<span style="color:#444444">
								</span></span></span></span></span></span></span>

<span style="color:#444444; font-family:Courier New; font-size:10pt">}
</span>

。
