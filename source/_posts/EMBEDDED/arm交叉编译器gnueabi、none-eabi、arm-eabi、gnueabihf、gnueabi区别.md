---
title: arm交叉编译器gnueabi、none-eabi、arm-eabi、gnueabihf、gnueabi区别
id: 639
comment: false
categories:
  - arm
date: 2016-06-03 11:49:16
tags:
---

 

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi1.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi2.png)<span style="font-family:Times New Roman; font-size:10pt">
		</span>

<!-- more -->
<span style="font-size:12pt"><span style="color:#333333"><span style="font-family:宋体">交叉编译工具链的命名规则为：</span><span style="font-family:Arial">**arch [-vendor] [-os] [-(gnu)eabi]**</span></span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="color:#333333"><span style="font-family:Arial">**arch **- </span><span style="font-family:宋体">体系架构，如 </span><span style="font-family:Arial">ARM</span><span style="font-family:宋体">，</span><span style="font-family:Arial">MIPS</span></span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="color:#333333"><span style="font-family:Arial">**vendor **- </span><span style="font-family:宋体">工具链提供商</span></span><span style="font-family:宋体">
			</span></span>

<span style="font-size:12pt"><span style="color:#333333"><span style="font-family:Arial">**os **- </span><span style="font-family:宋体">目标操作系统</span></span><span style="font-family:宋体">
			</span></span>

<span style="color:#333333">**eabi **- <span style="font-family:宋体">嵌入式应用二进制接口（</span><span style="color:#3c3c3c">Embedded Application Binary Interface<span style="color:#333333"><span style="font-family:宋体">） <span style="color:#454545">根据对操作系统的支持与否，</span></span>ARM GCC<span style="color:#454545">
						<span style="font-family:宋体">可分为支持和不支持操作系统，如</span></span><span style="font-family:宋体">
					</span></span></span></span>

<span style="color:#333333">**arm-none-eabi**<span style="font-family:宋体">：这个是没有操作系统的，自然不可能支持那些跟操作系统 关系密切的函数，比如 </span>fork(2)<span style="font-family:宋体">。他使用的是 </span>newlib <span style="font-family:宋体">这个专用于嵌入式系统 的 </span>C <span style="font-family:宋体">库。</span></span><span style="font-family:宋体">
		</span>

<span style="font-size:12pt"><span style="color:#333333"><span style="font-family:Arial">**arm-none-<span style="color:blue">linux<span style="color:#333333">-eabi</span></span>**</span><span style="font-family:宋体">：用于 </span><span style="font-family:Arial">Linux </span><span style="font-family:宋体">的，使用 </span><span style="font-family:Arial">Glibc</span></span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi3.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi4.png)<span style="font-family:Arial; font-size:10pt">
		</span>

# <span style="color:#333333">1<span style="font-family:Microsoft JhengHei">、</span>arm-none-eabi-gcc</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi5.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi6.png)<span style="font-family:Arial; font-size:1pt">
		</span>

<span style="color:#333333"><span style="font-family:宋体">（</span><span style="text-decoration:underline">ARM architecture</span><span style="font-family:宋体">，</span><span style="color:red"><span style="text-decoration:underline">no <span style="color:#333333">vendor</span></span><span style="font-family:宋体">，</span><span style="text-decoration:underline">not <span style="color:#3c3c3c">target an operating system</span></span><span style="color:#333333"><span style="font-family:宋体">，</span><span style="color:#3c3c3c"><span style="text-decoration:underline">complies</span>
						<span style="text-decoration:underline">with the ARM EABI</span><span style="font-family:宋体"><span style="color:#333333">）</span>
						</span></span></span></span></span>

<span style="color:#333333"><span style="font-family:宋体">用于编译 </span>ARM <span style="font-family:宋体">架构的裸机系统（包括 </span>ARM Linux <span style="font-family:宋体">的 </span>boot<span style="font-family:宋体">、</span>kernel<span style="font-family:宋体">，<span style="color:red">不适用编 译 </span></span>Linux<span style="color:red">
				<span style="font-family:宋体">应用 </span>Application<span style="color:#333333"><span style="font-family:宋体">），一般适合 </span>ARM7<span style="font-family:宋体">、</span>Cortex-M <span style="font-family:宋体">和 </span>Cortex-R <span style="font-family:宋体">内核的 芯片使用，所以不支持那些跟操作系统关系密切的函数，比如 </span>fork(2)<span style="font-family:宋体">，他使用 的是 </span>newlib <span style="font-family:宋体">这个专用于嵌入式系统的 </span>C <span style="font-family:宋体">库。</span></span><span style="font-family:宋体">
				</span></span></span>

# <span style="color:#333333">2<span style="font-family:Microsoft JhengHei">、</span>arm-none-linux-gnueabi-gcc</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi7.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi8.png)<span style="font-family:Arial; font-size:1pt">
		</span>

<span style="color:#333333">(<span style="text-decoration:underline">ARM architecture</span>, <span style="color:red"><span style="text-decoration:underline">no <span style="color:#333333">vendor</span></span>, <span style="color:#3c3c3c"><span style="text-decoration:underline">creates binaries that run on</span>
					<span style="text-decoration:underline">the <span style="color:green">**Linux **<span style="color:#3c3c3c">operating system</span></span></span>, <span style="text-decoration:underline">and uses the GNU EABI</span><span style="color:#333333">)</span>
				</span></span></span>

<span style="color:#333333"><span style="font-family:宋体">主要用于基于 </span>ARM <span style="font-family:宋体">架构的 </span>Linux <span style="font-family:宋体">系统，可用于编译 </span>ARM <span style="font-family:宋体">架构的 </span>u-boot<span style="font-family:宋体">、</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333">Linux <span style="font-family:宋体">内核、</span>linux <span style="font-family:宋体">应用等。</span>arm-none-linux-gnueabi <span style="font-family:宋体">基于 </span>GCC<span style="font-family:宋体">，使用 </span><span style="color:#454545">Glibc <span style="font-family:宋体">库， <span style="color:#333333">经过 </span></span>Codesourcery<span style="color:#333333">
					<span style="font-family:宋体">公司优化过推出的编译器。</span>arm-none-linux-gnueabi-xxx <span style="font-family:宋体">交 叉编译工具的浮点运算非常优秀。一般 </span>ARM9<span style="font-family:宋体">、</span>ARM11<span style="font-family:宋体">、</span>Cortex-A <span style="font-family:宋体">内核，带有 </span>Linux <span style="font-family:宋体">操作系统的会用到。</span></span><span style="font-family:宋体">
				</span></span></span>

# <span style="color:#333333">3<span style="font-family:Microsoft JhengHei">、</span>arm-eabi-gcc</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi9.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi10.png)<span style="font-family:Arial; font-size:1pt">
		</span>

<span style="color:#333333">Android ARM <span style="font-family:宋体">编译器。</span></span><span style="font-family:宋体">
		</span>

# <span style="color:#333333">4<span style="font-family:Microsoft JhengHei">、</span>armcc</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi11.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi12.png)<span style="font-family:Arial; font-size:1pt">
		</span>

<span style="color:#333333">ARM <span style="font-family:宋体">公司推出的编译工具，<span style="text-decoration:underline">功能和 </span></span><span style="text-decoration:underline">arm-none-eabi <span style="font-family:宋体">类似</span></span>，可以编译裸机程序</span><span style="font-family:宋体">
		</span>

<span style="color:#333333"><span style="font-family:宋体">（</span>u-boot<span style="font-family:宋体">、</span>kernel<span style="font-family:宋体">），但是不能编译 </span>Linux <span style="font-family:宋体">应用程序。</span>armcc <span style="font-family:宋体">一般和 </span>ARM <span style="font-family:宋体">开发 工具一起，</span>Keil MDK<span style="font-family:宋体">、</span>ADS<span style="font-family:宋体">、</span>RVDS <span style="font-family:宋体">和 </span>DS-5 <span style="font-family:宋体">中的编译器都是 </span>armcc<span style="font-family:宋体">，所以 </span>armcc <span style="font-family:宋体">编译器都是收费的（爱国版除外，呵呵</span>~~<span style="font-family:宋体">）。</span></span><span style="font-family:宋体">
		</span>

# <span style="color:#333333">5<span style="font-family:Microsoft JhengHei">、</span><span style="color:#454545">arm-none-uclinuxeabi-gcc <span style="font-family:Microsoft JhengHei">和 </span>arm-none-symbianelf-gcc</span>
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi13.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi14.png)<span style="font-family:Arial; font-size:1pt">
		</span>

<span style="color:#454545">arm-none-uclinuxeabi <span style="font-family:宋体">用于 </span><span style="text-decoration:underline">**uCLinux**</span><span style="font-family:宋体">，使用 </span>Glibc<span style="font-family:宋体">。</span></span><span style="font-family:宋体">
		</span>

<span style="color:#454545">arm-none-symbianelf <span style="font-family:宋体">用于 </span><span style="text-decoration:underline">**symbian**</span><span style="font-family:宋体">，没用过，不知道 </span>C <span style="font-family:宋体">库是什么 <span style="color:#333333">。</span>
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi15.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi16.png)<span style="font-family:宋体; font-size:10pt">
		</span>

<span style="color:#333333">**Codesourcery **<span style="font-family:宋体">推出的产品叫 </span>Sourcery G++ Lite Edition<span style="font-family:宋体">，其中基于 </span>command-line <span style="font-family:宋体">的编译器是免费的，在官网上可以下载，而其中包含的 </span>IDE <span style="font-family:宋体">和 </span>debug <span style="font-family:宋体">工具是收费的，当然也有 </span>30 <span style="font-family:宋体">天试用版本的。</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333; font-family:宋体">目前 </span>CodeSourcery <span style="font-family:宋体">已经由明导国际</span>(Mentor Graphics)<span style="font-family:宋体">收购，所以原本的网站 风格已经全部变为 </span>Mentor <span style="font-family:宋体">样式，但是 </span>Sourcery G++ Lite Edition <span style="font-family:宋体">同样可以注 册后免费下载。
</span>

<span style="color:#333333">Codesourcery <span style="font-family:宋体">一直是在做 </span>ARM <span style="font-family:宋体">目标 </span>GCC <span style="font-family:宋体">的开发和优化，它的 </span>ARM GCC <span style="font-family:宋体">在 目前在市场上非常优秀，很多 </span>patch <span style="font-family:宋体">可能还没被 </span>gcc <span style="font-family:宋体">接受，所以还是应该直接 用它的（而且他提供 </span>Windows <span style="font-family:宋体">下</span>[mingw <span style="font-family:宋体">交叉编译的</span>]<span style="font-family:宋体">和 </span>Linux <span style="font-family:宋体">下的二进制版本， 比较方便；如果不是很有时间和兴趣，不建议下载 </span>src <span style="font-family:宋体">源码包自己编译，很麻 烦，</span>Codesourcery <span style="font-family:宋体">给的 </span>shell <span style="font-family:宋体">脚本很多时候根本没办法直接用，得自行提取关 键的部分手工执行，又费精力又费时间，如果想知道细节，其实不用自己编译 一遍，看看他是用什么步骤构建的即可，如果你对交叉编译器感兴趣的话。</span></span><span style="font-family:宋体">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi17.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi18.png)<span style="font-family:宋体; font-size:10pt">
		</span>

<span style="color:#333333">**ABI**<span style="font-family:宋体">：二进制应用程序接口</span>(Application Binary Interface (ABI) for the ARM Architecture)<span style="font-family:宋体">。在计算机中，应用二进制接口描述了应用程序（或者其他类型） 和操作系统之间或其他应用程序的低级接口。</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333">**EABI**<span style="font-family:宋体">：嵌入式 </span>ABI<span style="font-family:宋体">。嵌入式应用二进制接口指定了文件格式、数据类型、寄存 器使用、堆积组织优化和在一个嵌入式软件中的参数的标准约定。开发者使用 自己的汇编语言也可以使用 </span>EABI <span style="font-family:宋体">作为与兼容的编译器生成的汇编语言的接口。</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333"><span style="font-family:宋体">两者主要区别是，</span>ABI <span style="font-family:宋体">是计算机上的，</span>EABI <span style="font-family:宋体">是嵌入式平台上（如 </span>ARM<span style="font-family:宋体">，</span>MIPS</span>

<span style="font-family:宋体"><span style="color:#333333">等）。</span>
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi19.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi20.png)<span style="font-family:宋体; font-size:10pt">
		</span>

<span style="color:#333333"><span style="font-family:宋体">两个交叉编译器分别适用于 </span>armel <span style="font-family:宋体">和 </span>armhf <span style="font-family:宋体">两个不同的架构，</span>armel <span style="font-family:宋体">和 </span>armhf <span style="font-family:宋体">这两种架构在对待浮点运算采取了不同的策略（有 </span>fpu <span style="font-family:宋体">的 </span>arm <span style="font-family:宋体">才能支持这两种 浮点运算策略）。</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333"><span style="font-family:宋体">其实这两个交叉编译器只不过是 </span>gcc <span style="font-family:宋体">的选项 </span><span style="text-decoration:underline">-mfloat-abi </span><span style="font-family:宋体">的默认值不同。</span>gcc <span style="font-family:宋体">的 选项 </span>-mfloat-abi <span style="font-family:宋体">有三种值 </span>**soft<span style="font-family:Microsoft JhengHei">、</span>softfp<span style="font-family:Microsoft JhengHei">、</span>hard**<span style="font-family:宋体">（其中后两者都要求 </span>arm <span style="font-family:宋体">里有 </span>fpu <span style="font-family:宋体">浮点运算单元，</span>soft <span style="font-family:宋体">与后两者是兼容的，但 </span>softfp <span style="font-family:宋体">和 </span>hard <span style="font-family:宋体">两种模式互不兼</span></span><span style="font-family:宋体">
		</span>

<span style="font-family:宋体"><span style="color:#333333">容）：</span>
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi21.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi22.png)<span style="color:#333333">**soft<span style="font-family:Microsoft JhengHei">： </span>**<span style="font-family:宋体">不用 </span>fpu <span style="font-family:宋体">进行浮点计算，即使有 </span>fpu <span style="font-family:宋体">浮点运算单元也不用，而是使用软 件模式。</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333">**softfp<span style="font-family:Microsoft JhengHei">： </span>**armel <span style="font-family:宋体">架构（对应的编译器为 </span><span style="text-decoration:underline">arm-linux-gnueabi-gcc </span><span style="font-family:宋体">）采用的默认值</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333"><span style="font-family:宋体">用 </span>fpu <span style="font-family:宋体">计算，但是传参数用普通寄存器传，这样中断的时候，只需要保存普通 寄存器，中断负荷小，但是参数需要转换成浮点的再计算。</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333">**hard<span style="font-family:Microsoft JhengHei">： </span>**armhf <span style="font-family:宋体">架构（对应的编译器 </span><span style="text-decoration:underline">arm-linux-gnueabi<span style="color:blue">hf-gcc </span></span><span style="font-family:宋体"><span style="color:#333333">）采用的默认值，</span>
			</span></span>

<span style="color:#333333"><span style="font-family:宋体">用 </span>fpu <span style="font-family:宋体">计算，传参数也用 </span>fpu <span style="font-family:宋体">中的浮点寄存器传，省去了转换，性能最好，但 是中断负荷高。</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333"><span style="font-family:宋体">把以下测试使用的 </span>C <span style="font-family:宋体">文件内容保存成 </span>mfloat.c<span style="font-family:宋体">：</span></span><span style="font-family:宋体">
		</span>

<span style="color:#333333">#include &lt;stdio.h&gt; int main(void)</span>

<span style="color:#333333">{</span>

<span style="color:#333333">double a,b,c; a = 23.543;</span>

<span style="color:#333333">b = 323.234;</span>

<span style="color:#333333">c = b/a;</span>

<span style="color:#333333">printf("the 13/2 = %f\n", c); printf("hello world !\n"); return 0;</span>

<span style="color:#333333">}</span>

# <span style="color:#333333">1<span style="font-family:Microsoft JhengHei">、使用  </span>arm-linux-gnueabihf-gcc <span style="font-family:Microsoft JhengHei">编译，使用</span>"-v"<span style="font-family:Microsoft JhengHei">选项以获取更详细的信息：</span></span><span style="font-family:Microsoft JhengHei">
		</span>

<span style="color:blue"># arm-linux-gnueabihf-gcc -v mfloat.c</span>

<span style="color:#333333">COLLECT_GCC_OPTIONS='-v' '-march=armv7-a' '-mfloat-abi=hard' '- mfpu=vfpv3-d16′ '-mthumb'</span>

<span style="color:#333333">-mfloat-abi=<span style="color:red">hard</span>
		</span>

<span style="color:#333333"><span style="font-family:宋体">可看出使用 </span>hard <span style="font-family:宋体">硬件浮点模式。</span></span><span style="font-family:宋体">
		</span>

# <span style="color:#333333">2<span style="font-family:Microsoft JhengHei">、使用 </span>arm-linux-gnueabi-gcc <span style="font-family:Microsoft JhengHei">编译：</span></span><span style="font-family:Microsoft JhengHei">
		</span>

<span style="color:blue"># arm-linux-gnueabi-gcc -v mfloat.c</span>

<span style="color:#333333">COLLECT_GCC_OPTIONS='-v' '-march=armv7-a' '-mfloat-abi=softfp' '- mfpu=vfpv3-d16′ '-mthumb'</span>

<span style="color:#333333">-mfloat-abi=<span style="color:red">softfp</span>
		</span>

<span style="color:#333333"><span style="font-family:宋体">可看出使用 </span>softfp <span style="font-family:宋体">模式。</span></span><span style="font-family:宋体">
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi23.jpg)<span style="font-family:宋体; font-size:10pt">
		</span>

<span style="font-family:宋体"><span style="color:#333333">交叉编译工具</span>
		</span>

![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi24.png)![](http://www.madhex.com/wp-content/uploads/2016/06/060316_0349_armgnueabi25.png)<span style="font-family:宋体; font-size:10pt">
		</span>

*   <div><span style="font-size:12pt"><span style="color:#333333"><span style="font-family:宋体">交叉编译器 </span><span style="font-family:Arial">arm-linux-gnueabi </span><span style="font-family:宋体">和 </span><span style="font-family:Arial">arm-linux-gnueabihf </span><span style="font-family:宋体">的区别：</span></span><span style="font-family:宋体">
					</span></span></div>

    [<span style="color:#418bca; text-decoration:underline">http://www.cnblogs.com/xiaotlili/p/3306100.html</span>](http://www.cnblogs.com/xiaotlili/p/3306100.html)

*   <div><span style="font-size:12pt"><span style="color:#333333"><span style="font-family:Arial">arm-none-linux-gnueabi</span><span style="font-family:宋体">，</span><span style="font-family:Arial">arm-none-eabi </span><span style="font-family:宋体">与 </span><span style="font-family:Arial">arm-eabi </span><span style="font-family:宋体">区别：</span></span><span style="font-family:宋体">
					</span></span></div>

    [<span style="color:#418bca; text-decoration:underline">http://blog.csdn.net/mantis_1984/article/details/21049273</span>](http://blog.csdn.net/mantis_1984/article/details/21049273)

*   <span style="color:#333333; font-family:Arial; font-size:12pt">What's the difference between arm-linux- / arm-none-linux-gnueabi- / arm-fsl-linux-gnueabi- in LTIB?<span style="color:#418bca; text-decoration:underline">https://community.freescale.com/thread/313490</span>
			</span>

<span style="color:#333333"><span style="font-family:宋体">文章来自 </span>VeryARM<span style="font-family:宋体">：<a href="http://www.veryarm.com/296.html"/></span><span style="color:#418bca"><span style="text-decoration:underline">http://www.veryarm.com/296.html</span><span style="color:#333333; font-family:宋体">，转载请保留。</span></span></span>
