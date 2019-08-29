stage1：
```
    包含bootstrap.sh，
    scripts/bootstrap.sh用于安装
    glibc、gcc、zlib、binutils、textinfo、ncurses、gettext、sed、emerge、portage等
    创建stage2 包含emerge的环境
    执行：scripts/bootstrap.sh
```

stage2:    
```
   包含了完整的emerge的环境
   构建system系统，编译没有替代物的系统软件包。
   执行：emerge -e system
```

构想：
1. stage1可以通过lfs方法得到

  stage1要保证能运行bootstrap.sh和emerge 

    bootstrap.sh：bash

    portage:bash python

2. stage1 在通过bootstrap.sh生成stage2

   参考： https://wiki.gentoo.org/wiki/Project:Prefix/Bootstrap

3. 我们可以运行：emerge -e system 生成官方提供的的stage3了。


	以上stage2环境可以由lfs替代.直接在lfs或其它系统上安装porage，
	
	所以共有两种安装方法：
	第一种：
		1.下载stage1 
		2.bootstrap.sh
		3.emerge system
		4.stage3正常安装
	第二种：
		1.创建lfs
		2.安装portage
		3.emerge system
		4.emerge world

    参考：https://wiki.gentoo.org/wiki/Portage


