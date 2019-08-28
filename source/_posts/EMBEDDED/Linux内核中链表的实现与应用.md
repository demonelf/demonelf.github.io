---
title: Linux内核中链表的实现与应用
id: 737
comment: false
categories:
  - arm
date: 2016-06-21 08:56:56
tags:
---

<span style="font-size: 12pt;"><span style="color: #4c4c4c;"><span style="font-family: Arial; background-color: white;">       </span><span style="font-family: 宋体; background-color: white;">链表（循环双向链表）是</span><span style="font-family: Arial; background-color: white;">Linux</span><span style="font-family: 宋体; background-color: white;">内核中最简单、最常用的一种数据结构。</span></span><span style="font-family: 宋体;">
</span></span>

<!-- more -->
<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">       1</span><span style="font-family: 宋体;">、链表的定义</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            struct list_head {
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                struct list_head *next, *prev;
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            }
</span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">           </span><span style="font-family: 宋体;">这个不含数据域的链表</span><span style="font-family: Arial;">,</span><span style="font-family: 宋体;">可以嵌入到任何数据结构中</span><span style="font-family: Arial;">,</span><span style="font-family: 宋体;">例如可按如下方式定义含有数据域的链表：</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            struct my_list {
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                void  * mydata;
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                struct list_head  list;
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            } ;
</span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">       2</span><span style="font-family: 宋体;">、链表的声明和初始化宏</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">            struct list_head </span><span style="font-family: 宋体;">只定义了链表结点</span><span style="font-family: Arial;">,</span><span style="font-family: 宋体;">并没有专门定义链表头</span><span style="font-family: Arial;">.</span><span style="font-family: 宋体;">那么一个链表结点是如何建立起来的？</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: 宋体;">内核代码</span><span style="font-family: Arial;"> list.h </span><span style="font-family: 宋体;">中定义了两个宏：</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">            #defind  LIST_HEAD_INIT(name)    { &amp;(name), &amp;(name) }      //</span><span style="font-family: 宋体;">仅初始化</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">            #defind  LIST_HEAD(name)     struct list_head  name = LIST_HEAD_INIT(name)  //</span><span style="font-family: 宋体;">声明并初始化</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">            </span><span style="font-family: 宋体;">如果要声明并初始化链表头</span><span style="font-family: Arial;">mylist_head</span><span style="font-family: 宋体;">，则直接调用：</span><span style="font-family: Arial;">LIST_HEAD(mylist_head)</span><span style="font-family: 宋体;">，之后，</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">mylist_head</span><span style="font-family: 宋体;">的</span><span style="font-family: Arial;">next</span><span style="font-family: 宋体;">、</span><span style="font-family: Arial;">prev</span><span style="font-family: 宋体;">指针都初始化为指向自己。这样，就有了一个带头结点的空链表。</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">             </span><span style="font-family: 宋体;">判断链表是否为空的函数：</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">             static inline int list_empty(const struct list_head  * head) {
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                  return head-&gt;next  ==  head;
</span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">              }    //</span><span style="font-family: 宋体;">返回</span><span style="font-family: Arial;">1</span><span style="font-family: 宋体;">表示链表为空，</span><span style="font-family: Arial;">0</span><span style="font-family: 宋体;">表示不空</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">      3</span><span style="font-family: 宋体;">、在链表中增加一个结点</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">          </span><span style="font-family: 宋体;">（内核代码中，函数名前加两个下划线表示内部函数）</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            static inline void   __list_add(struct list_head *new, struct list_head *prev, struct list_head *next)
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            {
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                     next -&gt; prev = new ;
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                     new -&gt; next = next ;
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                     new -&gt; prev = prev ;
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                     prev -&gt; next = new ;
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            }
</span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">            list.h </span><span style="font-family: 宋体;">中增加结点的两个函数为：</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">           </span><span style="font-family: 宋体;">（链表是循环的，可以将任何结点传递给</span><span style="font-family: Arial;">head</span><span style="font-family: 宋体;">，调用这个内部函数以分别在链表头和尾增加结点）</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            static inline void list_add(struct list_head *new, struct llist_head *head)
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            {
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                    __list_add(new, head, head -&gt; next) ;
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            }
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            static inline void list_add_tail(struct list_head 8new, struct list_head *head)
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            {
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">                     __list_add(new, head -&gt; prev, head) ;
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">            }
</span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">            </span><span style="font-family: 宋体;">附：给</span><span style="font-family: Arial;">head</span><span style="font-family: 宋体;">传递第一个结点，可以用来实现一个队列，传递最后一个结点，可以实现一个栈。</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">            static </span><span style="font-family: 宋体;">加在函数前，表示这个函数是静态函数，其实际上是对作用域的限制，指该函数作用域仅局限</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">           </span><span style="font-family: 宋体;">于本文件。所以说，</span><span style="font-family: Arial;">static </span><span style="font-family: 宋体;">具有信息隐蔽的作用。而函数前加</span><span style="font-family: Arial;"> inline </span><span style="font-family: 宋体;">关键字的函数，叫内联函数，表</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">           </span><span style="font-family: 宋体;">示编译程序在调用这个函数时，立即将该函数展开。</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">    4</span><span style="font-family: 宋体;">、</span><span style="font-family: Arial;">
</span><span style="font-family: 宋体;">遍历链表</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">           list.h </span><span style="font-family: 宋体;">中定义了如下遍历链表的宏：</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">           #define   list_for_each(pos, head)    for(pos = (head)-&gt; next ;  pos != (head) ;  pos = pos -&gt; next)
</span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">           </span><span style="font-family: 宋体;">这种遍历仅仅是找到一个个结点的当前位置，那如何通过</span><span style="font-family: Arial;">pos</span><span style="font-family: 宋体;">获得起始结点的地址，从而可以引用结</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: 宋体;">点的域？</span><span style="font-family: Arial;">list.h </span><span style="font-family: 宋体;">中定义了</span><span style="font-family: Arial;"> list_entry </span><span style="font-family: 宋体;">宏：</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">           #define   list_entry( ptr, type, member )  \
</span>

<span style="color: #4c4c4c; font-family: Arial; font-size: 12pt;">              ( (type *) ( (char *) (ptr)  - (unsigned long) ( &amp;( (type *)0 )  -&gt;  member ) ) )
</span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">          </span><span style="font-family: 宋体;">分析：</span><span style="font-family: Arial;">(unsigned long) ( &amp;( (type *)0 )  -&gt;  member ) </span><span style="font-family: 宋体;">把</span><span style="font-family: Arial;"> 0 </span><span style="font-family: 宋体;">地址转化为</span><span style="font-family: Arial;"> type </span><span style="font-family: 宋体;">结构的指针，然后获取该</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">          </span><span style="font-family: 宋体;">结构中</span><span style="font-family: Arial;"> member </span><span style="font-family: 宋体;">域的指针，也就是获得了</span><span style="font-family: Arial;"> member </span><span style="font-family: 宋体;">在</span><span style="font-family: Arial;">type </span><span style="font-family: 宋体;">结构中的偏移量。其中</span><span style="font-family: Arial;">  (char *) (ptr) </span><span style="font-family: 宋体;">求</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">         </span><span style="font-family: 宋体;">出的是</span><span style="font-family: Arial;"> ptr </span><span style="font-family: 宋体;">的绝对地址，二者相减，于是得到</span><span style="font-family: Arial;"> type </span><span style="font-family: 宋体;">类型结构体的起始地址，即起始结点的地址。</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">   5</span><span style="font-family: 宋体;">、链表的应用</span><span style="font-family: Arial;">
</span></span>

<span style="color: #4c4c4c; font-size: 12pt;"><span style="font-family: Arial;">         </span><span style="font-family: 宋体;">一个用以创建、增加、删除和遍历一个双向链表的</span><span style="font-family: Arial;">Linux</span><span style="font-family: 宋体;">内核模块</span><span style="font-family: Arial;">
</span></span>

#include &lt;linux/kernel.h&gt;
#include &lt;linux/module.h&gt;
#include &lt;linux/slab.h&gt;
#include &lt;linux/list.h&gt;

MODULE_LICENCE("GPL");
MODULE_AUTHOR("LUOTAIJIA");

#define N 10
struct numlist {
int num;
struct list_head list;
};

struct numlist numhead;

static int __init doublelist_init(void)
{
//初始化头结点
struct numlist * listnode; //每次申请链表结点时所用的指针
struct list_head * pos;
struct numlist * p;
int i;

printk("doublelist is starting...\n");
INIT_LIST_HEAD(&amp;numhead.list);
/*
* static inline void INIT_LIST_HEAD(struct list_head *list)
* {
* list-&gt;next = list;
* list-&gt;prev = list;
* }
*/

//建立N个结点，依次加入到链表当中
for (i=0; i&lt;N; i++) {
listnode = (struct numlist *)kmalloc(sizeof(struct numlist), GFP_KERNEL);
//void *kmalloc(size_t size, int flages)
//分配内存，size 要分配内存大小，flags 内存类型
listnode-&gt;num = i+1;
list_add_tail(&amp;listnode-&gt;list, &amp;numhead.list);
printk("Node %d has added to the doublelist...\n", i+1);
}
//遍历链表
i = 1;
list_for_each(pos, &amp;numhead.list) {
p = list_entry(pos, struct numlist, list);
printk("Node %d's data: %d\n", i, p-&gt;num);
i++;
}
return 0;
}

static void __exit doublelist_exit(void)
{
struct list_head *pos, *n;
struct numlist *p;
int i;

//依次删除N个结点
i = 1;
list_for_each_safe(pos, n, &amp;numhead.list) {
//为了安全删除结点而进行的遍历
list_del(pos); //从链表中删除当前结点
p = list_entry(pos, struct numlist, llist);
//得到当前数据结点的首地址，即指针
kfree(p); //释放该数据结点所占空间
printk("Node %d has removed from the doublelist...\n", i++);
}
printk("doublelist is exiting...\n");
}

module_init(doublelist_init);
module_exit(doublelist_exit);

参考资料：Linux操作系统原理与应用（第2版） 陈莉君、康华 编著
