---
title: WordPress不同分类目录调用不同模板
id: 123
categories:
  - arm
date: 2013-04-04 23:27:21
tags:
---

为了给我某个网站改版，达到WordPress不同分类目录调用不同模板这个效果，折腾了许久，找到一有效办法，下面分享：<!--more-->
<!-- more -->

[WordPress](http://www.lxmseo.com/wordpress)是国外著名的开源博客程序，因为其结构的标准性和易用性也被越来越多的网站所使用，Wordpress更多的还是被用来做新闻或者产品的发布平台。因为网站开发或者用户的需要所以我们常常也会为不同的分类目录添加不同的模板页面，以变得更有个性化。但Wordpress主题中默认控制分类栏目的一般都只有category.php或者single.php页面，不过我有个站的主题是在archive.php这个模板。所以大家自己根据自己的主题在找到控制分类目录的那个模板。下面我们就来为分类目录添加不同的模板样式了：

首先我们要做的就是找到你网站正在使用的主题文件(默认路径..wp-contentthemes)，并用编辑器打开category.php文件，然后用下面的代码替换里面除get_header()与get_footer()除外的代码，并将原来被替换的代码拷贝出来并粘贴到你新建的模板文件中，如category_default.php。
<div>

&nbsp;

&lt;?php
$post = $wp_query-&gt;post;
if(in_category('16')) {
include(TEMPLATEPATH.'/category_16.php');
}
else if (in_category('7')){
include(TEMPLATEPATH.'/category_7.php');
}
else {
include(TEMPLATEPATH.'/category-default.php');
}
?&gt;

&nbsp;

</div>
一般最终结果如下面这样既可，不过某些主题除了get_header()和get_footer()还有例如&lt;?php get_sidebar(); ?&gt;之类的，请灵活修改。
<div>

&nbsp;

&lt;?php get_header(); ?&gt;
&lt;?php
$post = $wp_query-&gt;post;
if(in_category('16')) {
include(TEMPLATEPATH.'/category_16.php');
}
else if (in_category('7')){
include(TEMPLATEPATH.'/category_7.php');
}
else {
include(TEMPLATEPATH.'/category-default.php');
}
?&gt;
&lt;?php get_footer(); ?&gt;

&nbsp;

</div>
这段代码函数的主要作用就是根据分类目录的ID去判断并调用对应的模板，如果分类目录ID为16，则为这个分类目录调用category_16.php模板，如果ID为7，则调用category_7.php模板，如果以上两者都不是则调用category-default.php这个默认的模板。当然了，如果你如果需要给更多的分类目录指定模板，你只需要再添加一个else if语句既可，如下面代码所示：
<div>

&nbsp;

&lt;?php get_header(); ?&gt;
&lt;?php
$post = $wp_query-&gt;post;
if(in_category('16')) {
include(TEMPLATEPATH.'/category_16.php');
}
else if (in_category('7')){
include(TEMPLATEPATH.'/category_7.php');
}
else if (in_category('8')){
include(TEMPLATEPATH.'/category_8.php');
}
else {
include(TEMPLATEPATH.'/category-default.php');
}
?&gt;
&lt;?php get_footer(); ?&gt;

&nbsp;

</div>
另外要注意的就是category_8.php等这些模板文件的调用路径了，如果你想单独新建一个文件夹来放这些分类目录模板文件，那上面代码中也要一起修改。

到这里为不同的分类目录调用不同的模板就结束了，最后你要做的就是根据自己的完美思想去定义模板文件了。

* * *

2013-03-29补充：

如果大家按照上述方法修改后出现无效或者调用混乱等情况，可以把上面的“in_category”改成“is_category”再试试看。

我自己修改的时候遇到过这个问题，按照补充的方法解决了。

&nbsp;

按同样的原理,
&lt;?php if(is_category(指定ID)){ ?&gt;
&lt;link rel="stylesheet" type="text/css" media="all" href="&lt;?php%20bloginfo('template_url');%20?&gt;/is_category/is_category1.css"/&gt;
&lt;?php }?&gt;
这样就可以指定所要的CSS了,CSS也分身几个调用就是了
