---
title: arm环境u-boot功能和linux启动过程
id: 905
comment: false
categories:
  - arm
date: 2016-09-19 15:58:02
tags:
---

1.  <div style="background: #4f81bd">
# <span style="font-family:幼圆">U-BOOT概况总结</span><span style="font-family:Calibri"> </span><span style="font-family:幼圆"></span>
</div>

    1.  启动代码为start.S
    2.  由于u-boot为裸板上第一个程序，所以要初始化各个外设，由于u-boot已经初始化了，包括：中断禁用、分配动态内存、初始化BBS区域、初始化页目录、打开缓存等任务。所以linux内核不需要全部再次初始化，所以可以理解bootloader和kernel其实是两兄弟。
    3.  U-boot引导内核第一步要做的的是把内核下到ram中，然后跳到内核的start函数。
例:
```
/*start code on reset*/
    Reset:
    bl set_cpu_mode                /*设置特权模式*/
    bl turn_off_watchdog           /*关闭看门狗*/
    bl mask_irqs                   /*关闭中断*/
    bl set_clock                   /*设置时钟*/
    bl disable_id_caches           /*关闭caches*/
    bl init_memory                 /*初始化sram*/
    bl init_stack                  /*初始化栈*/
    bl clean_bss                   /*初始化bss*/
    bl nand_init                   /*初始化nand*/
    bl copy_to_ram                 /*复制自身到ram*/
    ldr pc, =arm_main              /*执行main函数*/
```


四、bootloader必须提供5种功能：RAM初始化、串行端口初始化、查找机器类别、构建tagged list内核、将控制移交到内核镜像。

2.  <div style="background: #4f81bd">

    # <span style="font-family:幼圆">linux内核初始化流程
</div>

    ![](http://www.madhex.com/wp-content/uploads/2016/12/122616_0856_armubootl1.png)<span style="font-family:幼圆">

<span style="font-family:幼圆">u-boot跳到linux内核的arch/arm/boot/compressed/head.S中start后
</span>

![](http://www.madhex.com/wp-content/uploads/2016/12/122616_0856_armubootl2.png)<span style="font-family:幼圆">
				</span>

<span style="font-family:幼圆">内核大致可以理解为三部曲：</span>

<span style="font-family:幼圆">第一步 解压内核并跳到start_kernel()。</span>

<span style="font-family:幼圆">    1.arch/arm/<span style="background-color:yellow">boot/compressed</span>/<span style="color:red">head.S(<span style="color:#5b9bd5">start<span style="color:red">)
</span></span></span></span>

<span style="font-family:幼圆">准备解压内核
</span>

<span style="font-family:幼圆">    2.arch/arm/<span style="background-color:yellow">boot/compressed</span>/<span style="color:red">head.S</span>
				</span>

<span style="font-family:幼圆">通过<span style="color:#5b9bd5">decompress_kernel</span> 解压zImage</span>

<span style="font-family:幼圆">通过<span style="color:#5b9bd5">call_kernel</span>调用已解压后内核vmlinux
</span>

<span style="font-family:幼圆">    3.arch/arm/<span style="background-color:yellow">kernel</span>/<span style="color:red">head.S
</span></span>

<span style="font-family:幼圆">通过<span style="color:#5b9bd5">ENTRY(stext)-&gt;</span></span>

<span style="color:#5b9bd5; font-family:幼圆">处理器信息搜寻——__look_processor_type
</span>

<span style="color:#5b9bd5; font-family:幼圆">搜寻我的机型——__lookup_machine_type
</span>

<span style="font-family:幼圆">通过<span style="color:#5b9bd5">__mmap_switched</span>调用<span style="color:#5b9bd5">start_kernel</span>
				</span>

<span style="font-family:幼圆">第二步 跳到真正第一个内核代码<span style="background-color:yellow">init</span>/<span style="color:red">main.c(<span style="color:#5b9bd5">start_kernel()<span style="color:red">)</span>。</span>注</span>:在linux 0.11中为init/main.c main()。
</span>

<span style="font-family:幼圆">其中明星函数（排名不分先后）：
</span>

<span style="font-family:幼圆">1.初始化console(<span style="color:red">此处为平台相关需要hack的地方&lt;1&gt;</span>)
</span>

<span style="font-family:幼圆">  start_kernel-&gt;console_init-&gt;serial_pxa_console_init
</span>

<span style="font-family:幼圆">2.处理与架构相关的一系列事物
</span>

<span style="font-family:幼圆">  start_kernel-&gt;setup-arch()
</span>

![](http://www.madhex.com/wp-content/uploads/2016/12/122616_0856_armubootl3.png)<span style="font-family:幼圆">
				</span>

<span style="font-family:幼圆">3.初始化驱动平台platform
</span>

<span style="font-family:幼圆">start_kernel→kernel_init()→do_basic_setup()→driver_init()→platform_bus_init()→bus_register(&amp;platform_bus_type)</span>

<span style="font-family:幼圆">4.初始化soc(initcall参考 下面的init.h)
</span>

<span style="font-family:幼圆">start_kernel-&gt;kernel_init-&gt;依次调用do_basic_setup()-&gt;do_initcalls()-&gt;do_one_initcall()
</span>

![](http://www.madhex.com/wp-content/uploads/2016/12/122616_0856_armubootl4.png)<span style="font-family:幼圆">
				</span>

<span style="font-family:幼圆">第三步 就为愉快的init的代码了也就是第一个进程，在linux 0.11中集成在内核中。在之后版本由用户态提供。
</span>

<span style="font-family:幼圆">        当然我已经升级为systemd啦，哈哈。
</span>

<span style="font-family:幼圆">1.  linux初始化代码框架
</span>


<span style="font-family:幼圆">哪部分是只和CPU相关的部分，
</span>

<span style="font-family:幼圆">哪部分是SOC平台相关的部分，
</span>

<span style="font-family:幼圆">也再次标明LINUX下大致逻辑。
</span>

## <span style="font-family:幼圆">第一部分代码arch/arm/boot/</span>

<span style="font-family:幼圆">简介：也就是自我解压部分，可以理解为和cpu相关但和SOC无关。
</span>
<span style="font-family:幼圆">移植：移植时选择对应的cpu。
</span>
<span style="font-family:幼圆">功能：arch/arm/boot/compressed/head.S自我解压前准备、解压缩。跳到start_kernel。
</span>

## <span style="font-family:幼圆">第二部分代码init/main.c</span>

<span style="font-family:幼圆">简介：也就是start_kernel（）或0.11中的main（） 可以理解内核真正的第一代码。为平台无关代码。
</span>

<span style="font-family:幼圆">移植：移植时不用管。
</span>

<span style="font-family:幼圆">功能：此代码虽说简单的大几十行，但功能太多，我还是给个linux 0.11中main()的靓照吧~_~！
</span>

![](http://www.madhex.com/wp-content/uploads/2016/12/122616_0856_armubootl5.png)<span style="font-family:幼圆">
				</span>

## <span style="font-family:幼圆">第三部分代码 arch/arm/PLAT- arch/arm/MACH-
</span>

<span style="font-family:幼圆">简介：为了完成start_kernel()中初始化的SOC相关部分。
</span>

<span style="font-family:幼圆">移植：移植时需要考虑对应的SOC。没有对应soc支持时，才是各路玩家大显身手的时候。
</span>

<span style="font-family:幼圆">功能：看下面的介绍吧。
</span>
<span style="font-family:幼圆">1. Mini2440的plat和mach
</span>
<span style="font-family:幼圆">plat-s3c24xx</span>
<span style="font-family:幼圆">mach-s3c2440</span>
<span style="font-family:幼圆">mach-s3c2410
</span>

<span style="font-family:幼圆">======================
</span>

<span style="font-family:幼圆">
1. 三星这样分层的理由是s3c系列的soc具有一定的共通性, plat-实现了一些较通用的封装, 这些封装的具体参数一般是宏, 这些宏如寄存器地址可能是在mach-里面被定义;
</span>

<span style="font-family:幼圆">    linux/arch/arm/plat-s3c24xx/common-smdk.c
</span>

static struct s3c24xx_led_platdata smdk_pdata_led5 = {

            .gpio        = S3C2410_GPF5,
            .flags       = S3C24XX_LEDF_ACTLOW | S3C24XX_LEDF_TRISTATE,
            .name        = "led5",
            .def_trigger    = "nand-disk",
        };

linux/include/asm-arm/arch-s3c2410/regs-gpio.h

#define S3C2410_GPF5        S3C2410_GPIONO(S3C2410_GPIO_BANKF, 5)


<span style="font-family:幼圆">
2. 原则上是把所有s3c系列共同的东西放在    plat-里面去, 具体的io或者比较有mach-特色的部分放到mach-里面;
</span>

<span style="font-family:幼圆">    改板时, 实际上大多是直接在mach-里面增删自己的功能. (不按三星预设方案的改动除外)
</span>

<span style="font-family:幼圆">    plat里面需要动的相对更少, 不过在linux/arch/arm/plat-s3c24xx/common-smdk.c里面, 我们可以根据实际情形来分配nand的分区(修改static struct mtd_partition smdk_default_nand_part[] );
</span>

<span style="font-family:幼圆">3\. 编译时,一般只会选中一个特定的mach-, mach-会调用plat-的功能具体实现平台的资源和设备初始化.
</span>

## <span style="font-family:幼圆">MACHINE_START
</span>

<span style="font-family:幼圆">
以mach-s3c2440/mach-smdk2440.c 为例：
</span>

<span style="font-family:幼圆">MACHINE_START(S3C2440, "SMDK2440")
</span>

<span style="font-family:幼圆">    /* Maintainer: Ben Dooks &lt;ben@fluff.org&gt; */
</span>

<span style="font-family:幼圆">    .phys_io    = S3C2410_PA_UART,
</span>

<span style="font-family:幼圆">    .io_pg_offst    = (((u32)S3C24XX_VA_UART) &gt;&gt; 18) &amp; 0xfffc,
</span>

<span style="font-family:幼圆">    .boot_params    = S3C2410_SDRAM_PA + 0x100,
</span>

<span style="font-family:幼圆">    .init_irq        = s3c24xx_init_irq,
</span>

<span style="font-family:幼圆">    .map_io    = smdk2440_map_io,
</span>

<span style="font-family:幼圆">    .<span style="color:red">init_machine</span>    = smdk2440_machine_init,
</span>

<span style="font-family:幼圆">    .timer        = &amp;s3c24xx_timer,
</span>

<span style="font-family:幼圆">MACHINE_END
</span>

<span style="font-family:幼圆"><span style="color:red">start_kernel</span>里setup_arch：
</span>

<span style="font-family:幼圆">mdesc = setup_machine(machine_arch_type);
</span>

<span style="font-family:幼圆">init_arch_irq = mdesc-&gt;init_irq;
</span>

<span style="font-family:幼圆">system_timer = mdesc-&gt;timer;
</span>

<span style="font-family:幼圆">init_machine = mdesc-&gt;init_machine;
</span>

<span style="font-family:幼圆">mdesc 即是我们定义的machine type，这个结构体里我们定义的借口调用顺序如下：
</span>

<span style="font-family:幼圆">mdesc-&gt;fixup()；          //setup_arch调用
</span>

<span style="font-family:幼圆">mdesc-&gt;map_io()；         //setup_arch-》paging_init-》devicemaps_init
</span>

<span style="font-family:幼圆">init_arch_irq；           //start_kernel-》init_IRQ
</span>

<span style="font-family:幼圆">system_timer-&gt;init();        //start_kernel-》time_init
</span>

<span style="font-family:幼圆"><span style="color:red">init_machine</span>;             //arch_initcall
</span>

<span style="font-family:幼圆">通过本文可以体会到，对于内核，移植它改造它有难度呀。
</span>

<span style="font-family:幼圆">会裸板驱动、会写bootloader只是基础。
</span>

<span style="font-family:幼圆">还要熟悉内核代码，真是上知系统、应用，下知硬件、驱动。
</span>

<span style="font-family:幼圆">参考资料：
</span>

<span style="font-family:幼圆">[console] early printk实现流程
</span>

[<span style="font-family:幼圆">http://blog.csdn.net/ooonebook/article/details/52654120</span>](http://blog.csdn.net/ooonebook/article/details/52654120)<span style="font-family:幼圆">
				</span>

<span style="font-family:幼圆">linux2.6中的console_init初始化的研究
</span>

[<span style="font-family:幼圆">http://blog.csdn.net/breeze_vickie/article/details/5563375</span>](http://blog.csdn.net/breeze_vickie/article/details/5563375)<span style="font-family:幼圆">
				</span>

<span style="font-family:幼圆">linux下tty，控制台，虚拟终端，串口，console（控制台终端）详解
</span>

[<span style="font-family:幼圆">http://blog.csdn.net/liaoxinmeng/article/details/5004743</span>](http://blog.csdn.net/liaoxinmeng/article/details/5004743)<span style="font-family:幼圆">
				</span>

<span style="font-family:幼圆">【原创】s3c2440内核启动时如何注册串口为终端设备
</span>

[<span style="font-family:幼圆">http://blog.sina.com.cn/s/blog_70ef2ee90100zc4z.html</span>](http://blog.sina.com.cn/s/blog_70ef2ee90100zc4z.html)<span style="font-family:幼圆">
				</span>
