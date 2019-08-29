**前情提要**

最近想在mini2440上模仿linux 0.12的代码实现arm版本的linux。
一来是想巩固下arm，在就是学习下操作系统的相关只是。 
哎、最后之前的想法非常幼稚，心想学就学最新，当时想看懂linux 3.x的版本。
没想到越看越老，从3.x到2.x, 再到0.12 呵。
我想真把 0.12 玩的非常通其实也不是件易事。
从硬件到系统，mmu到进程，等等。如何有机的组在一起运行起来，也是很费精力。

废话不多说，学习的环境为，gentoo + qemu_mini2440.
    
说实话如果你条件方便，还是买个板子吧， 因为学操作系统和硬件非常相关。
而qemu虚拟只是模拟出用到的基本功能，和真实的硬件环境确实相差不少。
例如，在真是环境中，mini2440 的启动方式为，sd 或nand 到 stepping stone,
然后再纠结的到sdram。 
但是到了qemu你就醉了，它是直接把代码拷贝到sdram的。你说你是不很闹心。
玩起来是不并不是随心所欲了 呵呵。

发现此问题是通过gdb调试发现。

在此顺便记下qemu_gdb方法：

qemu启动：

>qemu-system-arm -M mini2440 -m 256m -mtdblock mini2440_nand128.bin -serial stdio -nographic -gdb tcp::1234 -S

gdb启动：
# gdb
```
(gdb) file vmlinux
(gdb) target remote :1234
(gdb) b start_kernel
(gdb) c
(gdb) x /200xb 0x004013ce  //以十六进制查看内存
(gdb) x /10i main		   //以汇编的方式查看内存
(gdb) disassemble main	   //等同上面
```















