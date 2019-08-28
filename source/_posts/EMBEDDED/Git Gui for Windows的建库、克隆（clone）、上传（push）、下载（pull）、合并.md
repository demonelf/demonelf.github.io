---
title: Git Gui for Windows的建库、克隆（clone）、上传（push）、下载（pull）、合并
id: 682
comment: false
categories:
  - arm
date: 2016-06-16 10:55:09
tags:
---

<span style="font-size:12pt"><span style="font-family:Verdana"> </span><span style="font-family:宋体">本教程将讲述：</span><span style="font-family:Verdana">gitk</span><span style="font-family:宋体">的<a href="http://lib.csdn.net/base/28" title="Git知识库" target="_blank"/></span><span style="color:#df3434; font-family:Verdana; text-decoration:underline">**Git**</span><span style="font-family:Verdana"> Gui</span><span style="font-family:宋体">的部分常用功能和使用方法，包括：建库、克隆（</span><span style="font-family:Verdana">clone</span><span style="font-family:宋体">）、上传（</span><span style="font-family:Verdana">push</span><span style="font-family:宋体">）、下载（</span><span style="font-family:Verdana">pull - fetch</span><span style="font-family:宋体">）、合并（</span><span style="font-family:Verdana">pull - merge</span><span style="font-family:宋体">）。</span><span style="font-family:Arial">
			</span></span>

<!-- more -->
<span style="font-size:12pt"><span style="font-family:Verdana">——————————————————————————————————————————————</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt">**<span style="font-family:Verdana">1</span><span style="font-family:宋体">、下载并安装</span>**<span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Verdana">    </span><span style="font-family:宋体">下载地址：</span><span style="font-family:Arial">
			</span></span>

<span style="font-family:Verdana"><span style="font-size:12pt">        <a href="http://code.google.com/p/msysgit/downloads/detail?name=Git-1.7.10-preview20120409.exe" target="_blank"/></span><span style="color:#0055ff; text-decoration:underline">http://code.google.com/p/msysgit/downloads/detail?name=Git-1.7.10-preview20120409.exe</span></span><span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Verdana">    </span><span style="font-family:宋体">安装的话，新手的话，全部</span><span style="font-family:Verdana">"</span><span style="font-family:宋体">下一步（</span><span style="font-family:Verdana">next</span><span style="font-family:宋体">）</span><span style="font-family:Verdana">"</span><span style="font-family:宋体">即可。</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt">**<span style="font-family:Verdana">2</span><span style="font-family:宋体">、建库（</span><span style="font-family:Verdana">init</span><span style="font-family:宋体">）</span>**<span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Verdana">    </span><span style="font-family:宋体">（<span style="color:red">如果你需要在本机计算机建库并管理自己的代码，请看此节。）</span></span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Verdana">    </span><span style="font-family:宋体">首先，新建一个文件夹，进入文件夹后点击右键，选择</span><span style="font-family:Verdana">"**Git Init Here**"</span><span style="font-family:宋体">：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi1.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">执行完这个操作后，会发现此文件夹中，多了一个</span><span style="font-family:Arial">"**.git**"</span><span style="font-family:宋体">的隐藏文件夹，说明执行成功。</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">然后，将源代码</span><span style="font-family:Arial">copy</span><span style="font-family:宋体">到此目录中（也可以直接在源代码处直接</span><span style="font-family:Arial">init</span><span style="font-family:宋体">）：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi2.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">做完这个操作后，再点击鼠标右键后，点击</span><span style="font-family:Arial">"**Git Commit Tool**"</span><span style="font-family:宋体">，填写完</span><span style="font-family:Arial">commit</span><span style="font-family:宋体">后，点击</span><span style="font-family:Arial">"</span><span style="font-family:宋体">**提交**</span><span style="font-family:Arial">"</span><span style="font-family:宋体">即可：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi3.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">最后，我们来看一下</span><span style="font-family:Arial">History</span><span style="font-family:宋体">，右键点击鼠标选择</span><span style="font-family:Arial">"**Git History**"</span><span style="font-family:宋体">：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi4.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    Enjoy~</span><span style="font-family:宋体">！</span><span style="font-family:Arial">\(^o^)/~
</span></span>

<span style="font-size:12pt">**<span style="font-family:Verdana">3</span><span style="font-family:宋体">、克隆（</span><span style="font-family:Verdana">clone</span><span style="font-family:宋体">）</span>**<span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Verdana">   </span><span style="color:red"><span style="font-family:宋体">（如果你从属于某个项目下，需要将远程的库</span><span style="font-family:Verdana">down</span><span style="font-family:宋体">到本机计算机，请看此节。）</span></span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Verdana">    </span><span style="font-family:宋体">在需要建立库的目录下点击右键选择：</span><span style="font-family:Verdana">"Git Gui" </span><span style="font-family:宋体">：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi5.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">在弹出窗口点击</span><span style="font-family:Arial">"</span><span style="font-family:宋体">克隆已经版本库</span><span style="font-family:Arial">"</span><span style="font-family:宋体">：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi6.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="color:red; font-family:宋体">**重点来了，之所以将这步称为重点，是因为网上大多数这一步的教程都错误的！**</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">**     **</span><span style="font-family:宋体">然后在</span><span style="font-family:Arial">Source Location</span><span style="font-family:宋体">中输入完整的待克隆版本库所在地址，在</span><span style="font-family:Arial">Target Directory</span><span style="font-family:宋体">中输入或选择本地的目录（请注意此处会自动新建一个目录，不需要提前建立！）</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">我以</span><span style="font-family:Arial">ssh</span><span style="font-family:宋体">为例，</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">以下第一幅图是局域网内部为例的：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi7.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">上面是局域网案例的。</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">下面是访问外网</span><span style="font-family:Arial">IP</span><span style="font-family:宋体">的方式：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi8.jpg)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="color:red; font-family:宋体">外网访问</span><span style="font-family:宋体">可以需要注意几点：</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">（</span><span style="font-family:Arial">1</span><span style="font-family:宋体">）、因为</span><span style="font-family:Arial">Gui</span><span style="font-family:宋体">的</span><span style="font-family:Arial">source location</span><span style="font-family:宋体">这里其实<span style="color:red">**不能更换**</span></span>**<span style="font-family:Arial">ssh</span><span style="color:red; font-family:宋体">默认端口</span>**<span style="font-family:宋体">，就算加上</span><span style="font-family:Arial">":</span><span style="font-family:宋体">实际端口号</span><span style="font-family:Arial">"</span><span style="font-family:宋体">也会返回以下错误信息：</span><span style="font-family:Arial">
			</span></span>

<span style="font-family:Arial; font-size:12pt">————————————
</span>

<span style="font-family:Arial; font-size:12pt">ssh: connect to host 123.117.67.67 port 22: Bad file number
fatal: The remote end hung up unexpectedly
</span>

<span style="font-family:Arial; font-size:12pt">————————————
</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">（</span><span style="font-family:Arial">2</span><span style="font-family:宋体">）、<span style="color:red">**不能使用**</span></span>**<span style="font-family:Arial">~</span><span style="color:red; font-family:宋体">号</span>**<span style="font-family:宋体">来代替家目录的路径组成部分了，<span style="color:red">**必须使用**</span></span>**<span style="font-family:Arial">git</span><span style="color:red; font-family:宋体">远端库的绝对地址</span>**<span style="font-family:宋体">。</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">然后点击</span><span style="font-family:Arial">"</span><span style="font-family:宋体">克隆</span><span style="font-family:Arial">"</span><span style="font-family:宋体">，会提示输入</span><span style="font-family:Arial">ssh</span><span style="font-family:宋体">对应的密码：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi9.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">输入密码后，就会自动克隆了，这里可能要<span style="color:#0055ff">**输入**</span></span>**<span style="font-family:Arial">3</span><span style="color:#0055ff; font-family:宋体">次密码</span>**<span style="font-family:宋体">，请一次次认真输入吧。成功后会提示类似信息：</span><span style="font-family:Arial">
			</span></span>

<span style="font-family:Arial; font-size:12pt">——————————————————————————
</span>

<span style="font-family:Arial; font-size:12pt">From 192.168.31.130:~/jmcx
 * [new branch]      master     -&gt; origin/master
</span>

<span style="font-family:Arial; font-size:12pt">——————————————————————————
</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">关闭掉当前窗口，会自动弹出</span><span style="font-family:Arial">git gui</span><span style="font-family:宋体">，然后可以在</span><span style="font-family:Arial">"</span><span style="font-family:宋体">版本库</span><span style="font-family:Arial">"</span><span style="font-family:宋体">下选择</span><span style="font-family:Arial">"</span><span style="font-family:宋体">浏览</span><span style="font-family:Arial">master</span><span style="font-family:宋体">上的文件</span><span style="font-family:Arial">"</span><span style="font-family:宋体">查看已下载文件，也可以直接去刚才的</span><span style="font-family:Arial">Target Directory</span><span style="font-family:宋体">中查看相关文件。</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt">**<span style="font-family:Arial">4</span><span style="font-family:宋体">、上传（</span><span style="font-family:Arial">push</span><span style="font-family:宋体">）</span>**<span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">   </span><span style="color:red"><span style="font-family:宋体">（如果你从属于某个项目下，已经</span><span style="font-family:Arial">clone</span><span style="font-family:宋体">了远程的库，需要将本地代码修改后，上传到远端库，请看此节。）</span></span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">前提条件需要满足已经完成上面的</span><span style="font-family:Arial">"**2**</span><span style="font-family:宋体">**、建库**</span><span style="font-family:Arial">"</span><span style="font-family:宋体">操作了。修改文件后，在</span><span style="font-family:Arial">Git Gui</span><span style="font-family:宋体">下进行</span><span style="font-family:Arial">"</span><span style="font-family:宋体">缓存改动</span><span style="font-family:Arial">"</span><span style="font-family:宋体">，然后输入描述，点击</span><span style="font-family:Arial">"</span><span style="font-family:宋体">提交</span><span style="font-family:Arial">"</span><span style="font-family:宋体">，点击</span><span style="font-family:Arial">"</span><span style="font-family:宋体">上传</span><span style="font-family:Arial">"</span><span style="font-family:宋体">，输入密码后回自动上传。成功应该是：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi10.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt">**<span style="font-family:Arial">5</span><span style="font-family:宋体">、下载（</span><span style="font-family:Arial">pull - fetch</span><span style="font-family:宋体">）</span>**<span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">右键在</span><span style="font-family:Arial">git</span><span style="font-family:宋体">库所在目录下打开</span><span style="font-family:Arial">Git Gui</span><span style="font-family:宋体">，在上方找到</span><span style="font-family:Arial">"</span><span style="font-family:宋体">远端（</span><span style="font-family:Arial">remote</span><span style="font-family:宋体">）</span><span style="font-family:Arial">"</span><span style="font-family:宋体">，点开之后选择</span><span style="font-family:Arial">"</span><span style="font-family:宋体">从</span><span style="font-family:Arial">..</span><span style="font-family:宋体">获取（</span><span style="font-family:Arial">fetch</span><span style="font-family:宋体">）</span><span style="font-family:Arial">"</span><span style="font-family:宋体">，自动展开后，点击</span><span style="font-family:Arial">"origin"</span><span style="font-family:宋体">：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi11.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">然后输入密码，点击</span><span style="font-family:Arial">OK</span><span style="font-family:宋体">，即可完成操作：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi12.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">这样就</span><span style="font-family:Arial">OK</span><span style="font-family:宋体">了，不过这样只是下载了，并没有和你本地的代码合并，要合并的话，还需要做一个操作，请看下节。</span><span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt">**<span style="font-family:Arial">6</span><span style="font-family:宋体">、合并（</span><span style="font-family:Arial">pull - merge</span><span style="font-family:宋体">）</span>**<span style="font-family:Arial">
			</span></span>

<span style="font-size:12pt"><span style="font-family:Arial">    fetch</span><span style="font-family:宋体">之后，到</span><span style="font-family:Arial">Git Gui</span><span style="font-family:宋体">的</span><span style="font-family:Arial">"</span><span style="font-family:宋体">合并（</span><span style="font-family:Arial">merge</span><span style="font-family:宋体">）</span><span style="font-family:Arial">"</span><span style="font-family:宋体">下点击</span><span style="font-family:Arial">"</span><span style="font-family:宋体">本地合并</span><span style="font-family:Arial">"</span><span style="font-family:宋体">，一般情况下是默认条件直接点击</span><span style="font-family:Arial">"</span><span style="font-family:宋体">合并（</span><span style="font-family:Arial">merge</span><span style="font-family:宋体">）</span><span style="font-family:Arial">"</span><span style="font-family:宋体">即可：</span><span style="font-family:Arial">
			</span></span>

![](http://www.madhex.com/wp-content/uploads/2016/06/061616_0255_GitGuiforWi13.png)<span style="font-family:Arial; font-size:12pt">
		</span>

<span style="font-family:Arial; font-size:12pt">————————————————————————————————————————————
</span>

<span style="font-size:12pt"><span style="font-family:Arial">    </span><span style="font-family:宋体">到这里教程就告一段落了。</span></span>
