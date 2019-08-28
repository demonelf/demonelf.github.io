---
title: openocd+jlink为mini2440调试u-boot
date: 2017-07-21 10:10:01
tags:
---


需要安装openocd，如果已经安装了系统默认的openocd(默认是0.5.0，版本太低），需要先卸载掉。

在安装前需要安装必需的一些库文件：

  sudo apt-get install libusb-1.0-0-dev libusb-1.0-0 automake autconf libtool pkg-config

然后执行安装：

 <a title="复制代码">![复制代码](http://common.cnblogs.com/images/copycode.gif)</a>

    git clone git://git.code.sf.net/p/openocd/code openocd
    cd openocd
    ./bootstrap
    ./configure --prefix=/usr/local \
        --enable-stlink --enable-jlink
    echo -e "all:\ninstall:" > doc/Makefile
    make
    sudo make install
 <a title="复制代码">![复制代码](http://common.cnblogs.com/images/copycode.gif)</a>

默认情况下openocd会安装到/usr/local/bin文件夹下，有可能会无法执行openocd命令，如果无法执行，可以将/usr/local/bin加入到PATH变量即可。

将mini2440和jlink以及pc连接起来，然后执行下面的命令：

 sudo openocd -f interface/jlink.cfg  -f board/mini2440.cfg

但是会提示下面的错误：

 Runtime Error: /usr/local/share/openocd/scripts/board/mini2440.cfg:124: jtag interface: command requires more arguments

将/usr/local/share/openocd/scripts/board/mini2440.cfg的124行注释掉（此行最前面添加一个‘#’符号，类似于bash注释)

然后在执行openocd：

 sudo openocd -f interface/jlink.cfg  -f board/mini2440.cfg

另开一个控制台，查看串口信息：

 sudo minicom

还需要打开一个控制台，在该控制台下执行下面的命令：

 telnet localhost 4444
halt
init_2440
load_image /home/host/soft/mini2440/u-boot/u-boot.bin 0x33f80000 bin 
resume 0x33f80000

/home/host/soft/mini2440/u-boot/u-boot.bin是我的u-boot.bin文件路径，可以将其修改成自己的文件路径即可。

这几条命令是从/usr/local/share/openocd/scripts/board/mini2440.cfg中几个预定义的命令代码中提取出来的，可以执行help_2440显示当前所支持的自定义命令列表。

可惜的是，openocd没有检测到mini2440上的nand flash,所以无法烧写,后来经过调查，voltcraft_dso-3062c.cfg中采用了相同的nand flash。
貌似是openocd代码修改了，但是mini2440.cfg中配置却没有改掉，将/usr/local/share/openocd/scripts/board/mini2440.cfg文件中的nand device s3c2440 0
这一行修改成voltcraft_dso-3062c.cfg中的对应行：
    nand device $_CHIPNAME.nand s3c2440 $_TARGETNAME

重新启动openocd:

 sudo openocd -f interface/jlink.cfg  -f board/mini2440.cfg

然后在另外一个控制台烧写uboot:

 <a title="复制代码">![复制代码](http://common.cnblogs.com/images/copycode.gif)</a>

telnet localhost 4444
halt
init_2440
nand erase 0 0x0 0x100000
nand write 0 /home/host/soft/mini2440/u-boot/u-boot.bin 0 
reset
 <a title="复制代码">![复制代码](http://common.cnblogs.com/images/copycode.gif)</a>

刚开始遇到好几次烧写不成功，后来执行了一次nand erase 0将整个nand flash擦除后才能成功执行烧写，

这个问题有可能是nand flash坏块多引起的（我的mini2440是二手开发板）。