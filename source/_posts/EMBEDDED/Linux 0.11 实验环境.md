---
title: Linux 0.11 实验环境
id: 663
comment: false
categories:
  - arm
date: 2016-06-15 08:53:40
tags:
---

<span style="font-size:10pt"><span style="font-family:宋体">可快速构建，支持</span><span style="font-family:Times New Roman">Docker/Qemu/Bochs/Ubuntu/OS X/Windows</span></span><span style="font-family:宋体; font-size:12pt">
		</span>

<!-- more -->
<span style="color:#aa3333; font-size:11pt">**<span style="font-family:Arial">1 </span><span style="font-family:宋体">项目描述</span><span style="font-family:Arial">
				</span>**</span>

<span style="font-size:10pt"><span style="font-family:宋体">该项目致力于快速构建一个</span><span style="font-family:Times New Roman"> Linux 0.11 </span><span style="font-family:宋体">实验环境，可配合[<span style="color:#4a630f; text-decoration:underline">《</span>](http://www.oldlinux.org/download/clk011c-3.0.pdf)</span><span style="text-decoration:underline"><span style="font-family:Times New Roman">Linux</span><span style="color:#4a630f; font-family:宋体">内核完全注释》</span></span><span style="font-family:Times New Roman"> </span><span style="font-family:宋体">一书使用。</span><span style="font-family:Times New Roman">
			</span></span>

*   <span style="font-size:12pt"><span style="font-family:宋体">使用文档：</span><span style="font-family:Times New Roman"> [<span style="color:#4a630f; text-decoration:underline">README.md</span>](https://github.com/tinyclub/linux-0.11-lab/blob/master/README.md)
				</span></span>
*   <span style="font-size:12pt"><span style="font-family:宋体">代码仓库：[</span><span style="font-family:Times New Roman"><span style="color:#4a630f; text-decoration:underline">https://github.com/tinyclub/linux-0.11-lab.git</span>
				</span></span>
*   <div><span style="font-size:12pt"><span style="font-family:宋体">基本特性：</span><span style="font-family:Times New Roman">
					</span></span></div>

        *   <span style="font-size:12pt"><span style="font-family:宋体">包含所有可用的映像文件</span><span style="font-family:Times New Roman">: ramfs/floppy/hard disk image</span><span style="font-family:宋体">。</span><span style="font-family:Times New Roman">
						</span></span>
    *   <span style="font-size:12pt"><span style="font-family:宋体">轻松支持</span><span style="font-family:Times New Roman"> qemu </span><span style="font-family:宋体">和</span><span style="font-family:Times New Roman"> bochs</span><span style="font-family:宋体">，可通过配置</span><span style="font-family:Times New Roman"> tools/vm.cfg </span><span style="font-family:宋体">切换。</span><span style="font-family:Times New Roman">
						</span></span>
    *   <span style="font-family:宋体; font-size:12pt">可以生成任何函数的调用关系，方便代码分析：</span><span style="font-family:Courier; font-size:9pt; background-color:#f7f7f9">make cg f=func d=file|dir</span><span style="font-family:Times New Roman; font-size:12pt">
					</span>
    *   <span style="font-size:12pt"><span style="font-family:宋体">支持</span><span style="font-family:Times New Roman"> Ubuntu </span><span style="font-family:宋体">和</span><span style="font-family:Times New Roman"> Mac OS X</span><span style="font-family:宋体">，在</span><span style="font-family:Times New Roman"> VirtualBox </span><span style="font-family:宋体">的支持下也可以在</span><span style="font-family:Times New Roman"> Windows </span><span style="font-family:宋体">上工作。</span><span style="font-family:Times New Roman">
						</span></span>
    *   <span style="font-size:12pt"><span style="font-family:宋体">测试过的编译器</span><span style="font-family:Times New Roman">: Ubuntu: gcc-4.8</span><span style="font-family:宋体">，</span><span style="font-family:Times New Roman"> Mac OS X</span><span style="font-family:宋体">：</span><span style="font-family:Times New Roman">i386-elf-gcc 4.7.2
</span></span>
    *   <span style="font-size:12pt"><span style="font-family:宋体">在解压之前整个大小只有</span><span style="font-family:Times New Roman"> 30M
</span></span>

<span style="color:#aa3333; font-size:11pt">**<span style="font-family:Arial">2 </span><span style="font-family:宋体">相关文章</span><span style="font-family:Arial">
				</span>**</span>

*   <a href="http://tinylab.org/take-5-minutes-to-build-linux-0-11-experiment-envrionment/"><span style="color:#4a630f; font-size:12pt; text-decoration:underline"><span style="font-family:宋体">五分钟内搭建</span><span style="font-family:Times New Roman"> Linux 0.11 </span><span style="font-family:宋体">的实验环境</span></span>](https://github.com/tinyclub/linux-0.11-lab)<span style="font-family:Times New Roman; font-size:12pt">
			</span>
*   [<span style="color:#4a630f; font-size:12pt; text-decoration:underline"><span style="font-family:宋体">基于</span><span style="font-family:Times New Roman"> Docker </span><span style="font-family:宋体">快速构建</span><span style="font-family:Times New Roman"> Linux 0.11 </span><span style="font-family:宋体">实验环境</span></span>](http://tinylab.org/build-linux-0-11-lab-with-docker/)<span style="font-family:Times New Roman; font-size:12pt">
			</span>

<span style="color:#aa3333; font-size:11pt">**<span style="font-family:Arial">3 </span><span style="font-family:宋体">五分钟教程</span><span style="font-family:Arial">
				</span>**</span>

<span style="color:#3333aa">**<span style="font-family:Arial">3.1 </span><span style="font-family:宋体">准备</span><span style="font-family:Arial">
				</span>**</span>

<span style="font-size:10pt"><span style="font-family:宋体">以</span><span style="font-family:Times New Roman"> Ubuntu </span><span style="font-family:宋体">和</span><span style="font-family:Times New Roman"> Qemu </span><span style="font-family:宋体">为例</span><span style="font-family:Times New Roman">, </span><span style="font-family:宋体">对于</span><span style="font-family:Times New Roman"> Mac OS X </span><span style="font-family:宋体">和</span><span style="font-family:Times New Roman"> Bochs </span><span style="font-family:宋体">的用法，请参考</span><span style="font-family:Times New Roman"> [<span style="color:#4a630f; text-decoration:underline">README.md</span>](https://github.com/tinyclub/linux-0.11-lab/blob/master/README.md).
</span></span>

1.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt">apt<span style="color:#666600">-<span style="color:#000088">get<span style="color:black"> install vim cscope exuberant<span style="color:#666600">-<span style="color:black">ctags build<span style="color:#666600">-<span style="color:black">essential qemu</span>
										</span></span></span></span></span></span></span></div>

<span style="color:#3333aa">**<span style="font-family:Arial">3.2 </span><span style="font-family:宋体">下载</span><span style="font-family:Arial">
				</span>**</span>

1.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt">git clone https<span style="color:#666600">:<span style="color:#880000">//github.com/tinyclub/linux-0.11-lab.git</span>
					</span></span></div>

<span style="color:#3333aa">**<span style="font-family:Arial">3.3 </span><span style="font-family:宋体">编译</span><span style="font-family:Arial">
				</span>**</span>

1.  <div style="background: whitesmoke"><span style="font-family:Times New Roman; font-size:9pt"><span style="color:black">make</span>
				</span></div>

<span style="color:#3333aa">**<span style="font-family:Arial">3.4 </span><span style="font-family:宋体">从硬盘启动</span><span style="font-family:Arial">
				</span>**</span>

1.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt">make start<span style="color:#666600">-<span style="color:black">hd</span>
					</span></span></div>

<span style="color:#3333aa">**<span style="font-family:Arial">3.5 </span><span style="font-family:宋体">调试</span><span style="font-family:Arial">
				</span>**</span>

<span style="font-size:10pt"><span style="font-family:宋体">打开一个终端并启动进入调试模式</span><span style="font-family:Times New Roman">:
</span></span>

1.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt">make debug<span style="color:#666600">-<span style="color:black">hd</span>
					</span></span></div>

<span style="font-size:10pt"><span style="font-family:宋体">打开另外一个终端启动</span><span style="font-family:Times New Roman"> gdb </span><span style="font-family:宋体">开始调试</span><span style="font-family:Times New Roman">:
</span></span>

1.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt">gdb images<span style="color:#666600">/<span style="color:black">kernel<span style="color:#666600">.<span style="color:black">sym</span>
							</span></span></span></span></div>
2.  <div style="background: #eeeeee"><span style="color:#666600; font-family:Times New Roman; font-size:9pt">(<span style="color:black">gdb<span style="color:#666600">)<span style="color:black"> target remote <span style="color:#666600">:<span style="color:#006666">1234</span>
								</span></span></span></span></span></div>
3.  <div style="background: whitesmoke"><span style="color:#666600; font-family:Times New Roman; font-size:9pt">(<span style="color:black">gdb<span style="color:#666600">)<span style="color:black"> b main</span>
						</span></span></span></div>
4.  <div style="background: #eeeeee"><span style="color:#666600; font-family:Times New Roman; font-size:9pt">(<span style="color:black">gdb<span style="color:#666600">)<span style="color:black"> c</span>
						</span></span></span></div>

<span style="color:#3333aa">**<span style="font-family:Arial">3.6 </span><span style="font-family:宋体">获得帮助</span><span style="font-family:Arial">
				</span>**</span>

1.  <div style="background: whitesmoke"><span style="font-family:Times New Roman; font-size:9pt"><span style="color:black">make help</span>
				</span></div>
2.  <div style="background: #eeeeee"><span style="color:#666600; font-family:Times New Roman; font-size:9pt">&gt;<span style="color:black">
						<span style="color:#660066">Usage<span style="color:#666600">:</span>
						</span></span></span></div>
3.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make <span style="color:#666600">--<span style="color:black">generate a kernel floppy <span style="color:#660066">Image<span style="color:black">
									<span style="color:#000088">with<span style="color:black"> a fs on hda1</span>
									</span></span></span></span></span></span></div>
4.  <div style="background: #eeeeee"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make start <span style="color:#666600">--<span style="color:black"> boot the kernel <span style="color:#000088">in<span style="color:black"> qemu</span>
							</span></span></span></span></div>
5.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make start<span style="color:#666600">-<span style="color:black">fd <span style="color:#666600">--<span style="color:black"> boot the kernel <span style="color:#000088">with<span style="color:black"> fs <span style="color:#000088">in<span style="color:black"> floppy</span>
											</span></span></span></span></span></span></span></span></div>
6.  <div style="background: #eeeeee"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make start<span style="color:#666600">-<span style="color:black">hd <span style="color:#666600">--<span style="color:black"> boot the kernel <span style="color:#000088">with<span style="color:black"> fs <span style="color:#000088">in<span style="color:black"> hard disk</span>
											</span></span></span></span></span></span></span></span></div>
7.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make debug <span style="color:#666600">--<span style="color:black"> debug the kernel <span style="color:#000088">in<span style="color:black"> qemu <span style="color:#666600">&amp;<span style="color:black"> gdb at port <span style="color:#006666">1234</span>
										</span></span></span></span></span></span></span></div>
8.  <div style="background: #eeeeee"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make debug<span style="color:#666600">-<span style="color:black">fd <span style="color:#666600">--<span style="color:black"> debug the kernel <span style="color:#000088">with<span style="color:black"> fs <span style="color:#000088">in<span style="color:black"> floppy</span>
											</span></span></span></span></span></span></span></span></div>
9.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make debug<span style="color:#666600">-<span style="color:black">hd <span style="color:#666600">--<span style="color:black"> debug the kernel <span style="color:#000088">with<span style="color:black"> fs <span style="color:#000088">in<span style="color:black"> hard disk</span>
											</span></span></span></span></span></span></span></span></div>
10.  <div style="background: #eeeeee"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make disk  <span style="color:#666600">--<span style="color:black"> generate a kernel <span style="color:#660066">Image<span style="color:black">
									<span style="color:#666600">&amp;<span style="color:black"> copy it to floppy</span>
									</span></span></span></span></span></span></div>
11.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make cscope <span style="color:#666600">--<span style="color:black"> genereate the cscope index databases</span>
					</span></span></div>
12.  <div style="background: #eeeeee"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make tags <span style="color:#666600">--<span style="color:black"> generate the tag file</span>
					</span></span></div>
13.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make cg <span style="color:#666600">--<span style="color:black"> generate callgraph of the system architecture</span>
					</span></span></div>
14.  <div style="background: #eeeeee"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make clean <span style="color:#666600">--<span style="color:black"> clean the <span style="color:#000088">object<span style="color:black"> files</span>
							</span></span></span></span></div>
15.  <div style="background: whitesmoke"><span style="color:black; font-family:Times New Roman; font-size:9pt"> make distclean <span style="color:#666600">--<span style="color:black"> only keep the source code files</span>
					</span></span></div>

<span style="color:#3333aa">**<span style="font-family:Arial">3.7 </span><span style="font-family:宋体">生成</span><span style="font-family:Arial"> main </span><span style="font-family:宋体">函数调用关系</span><span style="font-family:Arial">
				</span>**</span>

1.  <div style="background: whitesmoke"><span style="font-family:Times New Roman; font-size:9pt"><span style="color:black">make cg</span>
				</span></div>
2.  <div style="background: #eeeeee"><span style="color:black; font-family:Times New Roman; font-size:9pt">ls calltree<span style="color:#666600">/<span style="color:black">linux<span style="color:#666600">-<span style="color:#006666">0.11<span style="color:#666600">.<span style="color:black">jpg</span>
									</span></span></span></span></span></span></div>

<span style="font-family:Times New Roman; font-size:10pt">See:
</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061516_0053_Linux0111.jpg)<span style="font-family:Times New Roman; font-size:10pt">
		</span>
