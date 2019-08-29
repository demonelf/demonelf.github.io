<span style="color:#333333; font-family:幼圆; font-size:10pt">作者: 北京—小武
</span>

<!-- more -->
<span style="color:#333333; font-family:幼圆; font-size:10pt">邮箱：[<span style="color:#336699">night_elf1020@163.com</span>](mailto:night_elf1020@163.com)
		</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">新浪微博：北京-小武
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">BCM芯片有几个大的模块： VLAN、L2、L3和FP等几个，其中FP的使用也最为灵活，能解析匹配数据包文的前128字节比特级的内容，动作包括转发、丢弃、结合qos修改相应字段、分配vid、流镜像、流重定向、指定端口转发（比如CPU口）、指定下一跳转发往、指定隧道转发等，往往在实现功能上有意想不到的功效。简单来说，如果硬件和BSP分别是九阳真经和九阴真经的话，那么port和vlan是少林七十二项绝技的组合，L2转发则是显得有点悠闲的峨眉派功夫，当然L3则是以太极拳为代表的武当派功夫，那么FP可以是以乾坤大挪移、吸星大法等为代表的魔教的邪而又邪的"旁门左道"，当然其他功能是零零散散的其他门派功夫。能够灵活运用好FP是增加很多交换机新功能的一种常用的手段。本文总结下FP这个模块BCM在硬件上的实现原理及SDK的相关数据结构。因为FP在实现功能上的灵活性，在此希望能抛砖引玉，激发大家更多的应用FP实现新功能的火花。
</span>

<span style="color:#333333; font-family:幼圆; font-size:18pt">**<a name="t1"/>BCM芯片FP实现原理
**</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">FP的全称是Fields Processors，也称为ContentAwareProcess（CAP），在BCM较早的芯片称为Fast Filter Processors（FFP），和现在的FP相比有一些原理不同，不过现在交换芯片已经不再使用FFP，所以在此也不再介绍。FP本质来说，是一组相互之间有关联的表，一起通过查找、匹配等来决定对报文施加的动作；在BCM芯片交换机中，有三种查找查找方式：hash，index，tcam。FP的查找主要用到了index和tcam，其中CAM的全称是ContentAddressable Memory，中文是内容寻址器，TCAM则是Ternary ContentAddressable Memory，中文称为三态内存寻址器，TCAM的实现是通过对应比特位+掩码产生三种匹配方式：掩码为0表示不关心、掩码为1且对应位为1或掩码为1且对应位为0。 这就是三态的具体含义。
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">
在我们自研交换机所用的芯片中有三个FP：VFP(VLAN FP)、IFP（ingres FP）和EFP（Egress FP），另外在四代芯片kylin卡中曾出现外扩FP，称为E-IFP，表项大小为128K，为L2和L3转发用，有点openflow的意味。其中VFP主要用于对报文tag的处理，比如添删或修改vid的灵活QINQ的实现就基于此FP；IFP的用途比较多，主要是对进入端口后的报文进行处理，主要有入口acl、流重定向、流镜像、设置下一跳、为qos数据报文分类等用途；EFP的用途和IFP类似，但是因为EFP是报文在转出前在出端口进行处理的规则，IFP有的动作类型在EFP不太适用。虽然三种FP用途和数据包流经顺序不太一样，但是硬件原理是一致的。下面介绍下FP的硬件原理。
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0642_BCMFPSDK1.png)<span style="color:#333333; font-size:10pt"><span style="font-family:Arial"> </span><span style="font-family:幼圆">
			</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">图1 FP原理组成图
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">图1中，每一个查找引擎和策略引擎及后面的counter资源和meter资源组合成一个规则组，芯片称之为一个slice，从图1可以看出，FP的实现有五部分组成：
</span>

<span style="color:red; font-family:幼圆; font-size:10pt">智能解析模板<span style="color:#333333">：主要将报文信息（最多报文前128字节，可以精确到每一位bit）根据对每个slice的care字段将各对应字段解析出来，再加上前面L2、L3的转发信息，一起送给每个slice的查找引擎去匹配；
</span></span>

<span style="color:red; font-family:幼圆; font-size:10pt">查找引擎：<span style="color:#333333">将解析出来的字段按照TCAM方式去查找本slice的规则是否有匹配的，即HIT的，只要有一条hit的即刻返回这条规则的index不再继续查找本slice后面规则，后面即使还有匹配的规则；这样做就是为了保证一个slice内部规则的优先级；如果没有匹配说明此slice没有匹配的规则或根本就没有规则，后面的流程也无需再走；
</span></span>

<span style="color:red; font-family:幼圆; font-size:10pt">策略引擎：<span style="color:#333333">根据查找引擎得到的index直接索引策略引擎的动作，动作类型有转发、丢弃、重定向（包括到CPU口且可指定队列）、流镜像（包括到CPU口且可指定队列）、修改报文特定的字段（COS、DSCP、EXP等）、与后面的meter一起对报文染色并对不同染色报文指定相应动作、指定下一跳、指定ECMP、指定TTL是否修改、指定URPF的模式等相关动作；需要说明的是，一条规可以对报文执行多种动作，当然需要报文动作之间是不冲突的，即slice规则的动作冲突是靠配置下发来检查的，同一条规则有冲突的动作无法下发硬件；
</span></span>

<span style="color:red; font-family:幼圆; font-size:10pt">Counter和meter资源<span style="color:#333333">： counter资源用于计数，有基于byte和packet的两种方式；meter主要用于测速，然后根据速度对报文进行染色（绿、黄和红）然后对报文应用不同的QOS策略；meter的工作原理可以参见我原先写的有关令牌桶相关文档。
</span></span>

<span style="color:red; font-family:幼圆; font-size:10pt">动作冲突决策引擎：<span style="color:#333333">前面说过，一条slice的动作冲突是靠配置下发检查来实现的，冲突的动作无法同时下发到硬件；但是FP通常有多个slice，每个slice都有规则被匹配且动作时间有冲突时，需要动作冲突决策引擎来处理到底执行哪一个规则的动作，如果多个动作不冲突都执行；原则是丢弃、重定向等优先级最高，其他时候看slice号（这个slice号有的芯片只支持是物理的，高级芯片支持虚拟slice号），slice号越大优先级越高；
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">我们一条规则的匹配报文长度信息是有限的，对于IPV4报文同时匹配SMAC、DMAC、SIP、DIP等信息的时候，就不够了，芯片提供了将两条规则合并成一条规则，组成更大长度规则的方法，主要有图2示的两种,：
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">    ![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0642_BCMFPSDK2.png)</span><span style="font-family:幼圆">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">                      </span><span style="font-family:幼圆">图2 两种slice宽模式
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">第一种是将一条slice的规则分为前后两部分，然后进行如图2左边的方式拼成double模式，这种模式称为double wide模式；第二种是用两条slice，直接如图2右边所示的方式拼成double模式，这种拼接方式称之为slice-paring模式。这两种模式，有的低级芯片都不支持，只能用单倍模式，有的芯片支持其中一种，我们的redstone交换机就只支持左边的这种方式。还有的芯片可以同时支持这两种拼接方式，那么就可以利用这点拼接处具有更大长度信息的四倍模式：
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial"> ![](http://www.madhex.com/wp-content/uploads/2016/08/080416_0642_BCMFPSDK3.png)</span><span style="font-family:幼圆">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">                      </span><span style="font-family:幼圆"> 图3 四倍key模式
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">这种模式常用于IPV6报文的匹配中，因为IPV6的SIP和DIP实在太长了，再加上匹配其他信息，只能用四倍模式才能完全覆盖所有字段。但是我们的redstone交换机只支持slice-pairng模式，所以在IPV6报文的匹配中需要做折中。
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">前面我们提到slice有物理slice和虚拟slice，这个与物理内存和虚拟内存有点类似，FP都有物理slice，在高级的芯片上，为了更好的解决slice之间的动作冲突，对slice进行了虚拟编号，虚拟slice号越大优先级越高，这样就可以实现动作的优先级指定；可能做过物理slice的同学能体会为了保证各种应用slice的优先级在软件处理所做的代码处理工作有多么的艰辛；硬件进步这么一步，支持虚拟slice后，这部分工作就完全交给硬件来处理了，我们只需要指定优先级高低就可以了。而且虚拟slice还支持虚拟slice组的概念，每一个虚拟slice组就像一条slice一样，只会有一个动作产生出，这样就又大大减少了动作冲突的机会，而且还能使得每种应用使用更多的slice资源，无需考虑因为物理slice带来的动作优先级打破应用的优先级，更符合实际。
</span>

<span style="color:#333333; font-family:幼圆; font-size:18pt">**<a name="t2"/>BCM对FP操作的接口
**</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">BCM的SDK提供了四套对于FP资源使用和管理的函数接口，需要视具体应用环境和个人喜好来定夺，四种接口如下：
</span>

<span style="color:red; font-family:幼圆; font-size:10pt">SOC API<span style="color:#333333">：直接硬件表项或寄存器操作，BCM各种问题明确不提倡的接口，因为需要配置人员管理和组织大量的逻辑；
</span></span>

<span style="color:red; font-family:幼圆; font-size:10pt">Bcmx接口<span style="color:#333333">：通常不被使用的接口，因为不太灵活，且SDK被改造成为所有ACL规则为一个大的group，现在暂时IFP只有协议规则和ACL使用，所以还勉强满足需求，以lport作为端口的配置参数；但是每次下发新规则都要先删除原来规则，这个是没有必要的；这套接口和下面BCM接口的区别不是很大。相关函数接口有：
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_group_create
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_group_create_id
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_group_compress
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_group_install
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_group_remove
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_group_destroy
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_entry_create
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_entry_destroy
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_entry_destroy_all
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_data_qualifier_destroy
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_data_qualifier_destroy_all
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_qualify_clear
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_data_qualifier_**_add
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcmx_field_data_qualifier_**_ delete等。
</span>

<span style="color:red; font-family:幼圆; font-size:10pt">Bcm接口<span style="color:#333333">：BCM中对FP操作的最灵活的一组接口，非常适合运营商多种应用的场合，这组接口传递的参数也非常详细；相关函数接口有：
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_group_create
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_group_create_id
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_group_priority_set
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_group_compress
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_group_install
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_group_remove
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_group_destroy
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_entry_create
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_entry_create_id
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_entry_destroy
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_entry_destroy_all
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_entry_reinstall
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_entry_remove
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_qualify_clea
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_qualify_****
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_action_add
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">bcm_field_action_delete等。
</span>

<span style="color:red; font-family:幼圆; font-size:10pt">Bcma接口<span style="color:#333333">：这套接口称为AdvancedContentAware Enhanced Software (ACES) implementation，传递的参数为bcma_acl_t*list，以结构体形式将规则所有参数下发到硬件；
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">/* List Management functions */
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">extern int bcma_acl_add(bcma_acl_t*list_id);
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">extern int bcma_acl_remove(bcma_acl_list_id_tlist_id);
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">extern int bcma_acl_get(bcma_acl_list_id_tlist_id, bcma_acl_t *list);
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">extern intbcma_acl_rule_add(bcma_acl_list_id_t list_id,
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">                            </span><span style="font-family:幼圆"> bcma_acl_rule_t*rule);
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">extern int bcma_acl_rule_remove(bcma_acl_list_id_tlist_id,
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">                               </span><span style="font-family:幼圆">bcma_acl_rule_id_t rule_id);
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">extern intbcma_acl_rule_get(bcma_acl_rule_id_t rule_id,
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">                     </span><span style="font-family:幼圆">
			</span><span style="font-family:Arial">       </span><span style="font-family:幼圆">bcma_acl_rule_t **rule);
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">/* Validation and Installation functions */
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">extern int bcma_acl_install(void);
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">extern int bcma_acl_uninstall(void); 等。
</span>

<span style="color:#333333; font-family:幼圆; font-size:18pt">**<a name="t3"/>SDK对FP资源管理的相关数据结构
**</span>

<span style="color:red; font-size:10pt"><span style="font-family:幼圆">1.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">BCM芯片每一个unit都有这么一个结构体来保存芯片所有FP的资源占用情况：<span style="color:#333333">
				</span></span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">static _field_control_t</span><span style="font-family:Arial">        </span><span style="font-family:幼圆"> *_field_control[BCM_MAX_NUM_UNITS];
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">field_control_t的具体内容为（每个变量都有详细注释，此处不再阐述）：
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">struct _field_control_s {</span><span style="font-family:Arial">                                           </span><span style="font-family:幼圆">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">sal_mutex_t</span><span style="font-family:Arial">           </span><span style="font-family:幼圆">fc_lock;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* Protectionmutex.</span><span style="font-family:Arial">            </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">bcm_field_stage_t</span><span style="font-family:Arial">     </span><span style="font-family:幼圆">
			</span><span style="font-family:Arial"> </span><span style="font-family:幼圆">stage;</span><span style="font-family:Arial">        </span><span style="font-family:幼圆">/* Default FP pipeline stage.</span><span style="font-family:Arial">   </span><span style="font-family:幼圆">*/
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆">max_stage_id;</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> /* Number of fpstages.</span><span style="font-family:Arial">         </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">_field_udf_t</span><span style="font-family:Arial">          </span><span style="font-family:幼圆"> *udf;</span><span style="font-family:Arial">         </span><span style="font-family:幼圆"> /* field_status-&gt;group_total</span><span style="font-family:Arial">    </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">struct _field_group_s</span><span style="font-family:Arial"> </span><span style="font-family:幼圆">*groups;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* List of groupsin unit.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">struct_field_stage_s </span><span style="font-family:Arial"> </span><span style="font-family:幼圆">*stages;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* Pipeline stage FP info.</span><span style="font-family:Arial">  </span><span style="font-family:幼圆">
			</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">}
</span>

<span style="color:red; font-size:10pt"><span style="font-family:幼圆">2.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">然后对field_control_t中的_field_group_s表示一种应用占用的slice和slice的规则记录：<span style="color:#333333">
				</span></span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">_field_group_s {
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">bcm_field_group_t</span><span style="font-family:Arial">     </span><span style="font-family:幼圆"> gid;</span><span style="font-family:Arial">           </span><span style="font-family:幼圆"> /* Opaque handle.</span><span style="font-family:Arial">               </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆">priority;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* Field grouppriority.</span><span style="font-family:Arial">        </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">bcm_field_qset_t</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> qset;</span><span style="font-family:Arial">          </span><span style="font-family:幼圆"> /* This group's Qualifier Set.</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">uint8</span><span style="font-family:Arial">                 </span><span style="font-family:幼圆"> flags;</span><span style="font-family:Arial">         </span><span style="font-family:幼圆"> /* Group configuration flags.</span><span style="font-family:Arial">   </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">_field_slice_t</span><span style="font-family:Arial">        </span><span style="font-family:幼圆">*slices;</span><span style="font-family:Arial">       </span><span style="font-family:幼圆"> /* Pointer intoslice array.</span><span style="font-family:Arial">    </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">bcm_pbmp_t</span><span style="font-family:Arial">            </span><span style="font-family:幼圆"> pbmp;</span><span style="font-family:Arial">          </span><span style="font-family:幼圆"> /* Ports in use this group.</span><span style="font-family:Arial">     </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">_field_sel_t sel_codes[_FP_MAX_ENTRY_WIDTH]; /* Select codes forslice(s). */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">_bcm_field_group_qual_t qual_arr[_FP_MAX_ENTRY_WIDTH];
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">                          </span><span style="font-family:幼圆">
			</span><span style="font-family:Arial">                </span><span style="font-family:幼圆">/* Qualifiers available in each
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">                                             </span><span style="font-family:幼圆">individual entry part.</span><span style="font-family:Arial">       </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">_field_stage_id_t</span><span style="font-family:Arial">     </span><span style="font-family:幼圆"> stage_id;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* FP pipeline stage id.</span><span style="font-family:Arial">        </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">}
</span>

<span style="color:red; font-size:10pt"><span style="font-family:幼圆">3.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">在每一个unit中还有_field_stage_s来对各种FP（VFP/IFP/EFP）的资源记录的数据结构：<span style="color:#333333">
				</span></span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">typedef struct _field_stage_s {
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">_field_stage_id_t</span><span style="font-family:Arial">     </span><span style="font-family:幼圆">stage_id;</span><span style="font-family:Arial">       </span><span style="font-family:幼圆"> /* Pipeline stageid.</span><span style="font-family:Arial">          </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">uint8</span><span style="font-family:Arial">                 </span><span style="font-family:幼圆"> flags;</span><span style="font-family:Arial">          </span><span style="font-family:幼圆"> /* Stage flags.</span><span style="font-family:Arial">                </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆">tcam_sz;</span><span style="font-family:Arial">        </span><span style="font-family:幼圆"> /* Number ofentries in TCAM.</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆">tcam_slices;</span><span style="font-family:Arial">    </span><span style="font-family:幼圆"> /* Number ofinternal slices.</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">struct_field_slice_s</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> *slices;</span><span style="font-family:Arial">        </span><span style="font-family:幼圆"> /* Array of slices.*/
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">}
</span>

<span style="color:red; font-size:10pt"><span style="font-family:幼圆">4.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">在在每一个_field_stage_s中用_field_slice_s对每一个slice资源进行记录的结构体：<span style="color:#333333">
				</span></span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">_field_slice_s {
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">uint8</span><span style="font-family:Arial">                 </span><span style="font-family:幼圆">slice_number;</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> /* Hardware slicenumber.</span><span style="font-family:Arial">        </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆">start_tcam_idx;/* Slice first entry tcam index.</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆">entry_count;</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> /* Number of entriesin the slice.*/
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆">free_count;</span><span style="font-family:Arial">   </span><span style="font-family:幼圆"> /* Number of freeentries.</span><span style="font-family:Arial">       </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆">counters_count;/* Number of counters accessible. */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆">meters_count;</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> /* Number of metersaccessible.</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">_field_counter_bmp_t</span><span style="font-family:Arial">  </span><span style="font-family:幼圆">counter_bmp;</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> /* Bitmap forcounter allocation. */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">_field_meter_bmp_t</span><span style="font-family:Arial">    </span><span style="font-family:幼圆">meter_bmp;</span><span style="font-family:Arial">    </span><span style="font-family:幼圆"> /* Bitmap for meterallocation.</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">_field_stage_id_t</span><span style="font-family:Arial">     </span><span style="font-family:幼圆">stage_id;</span><span style="font-family:Arial">     </span><span style="font-family:幼圆"> /* Pipeline stageslice belongs.</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆">bcm_pbmp_t</span><span style="font-family:Arial">   </span><span style="font-family:幼圆">
			</span><span style="font-family:Arial">         </span><span style="font-family:幼圆">pbmp;</span><span style="font-family:Arial">         </span><span style="font-family:幼圆"> /* Ports in use by groups.</span><span style="font-family:Arial">       </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">    </span><span style="font-family:幼圆">struct _field_entry_s</span><span style="font-family:Arial"> </span><span style="font-family:幼圆">**entries;</span><span style="font-family:Arial">    </span><span style="font-family:幼圆"> /* List of entriespointers.</span><span style="font-family:Arial">     </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">}
</span>

<span style="color:red; font-size:10pt"><span style="font-family:幼圆">5.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">在在每一个_field_slice_s中用_field_entry_s对slice内部的entry进行记录：<span style="color:#333333">
				</span></span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">struct_field_entry_s {
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> bcm_field_entry_t</span><span style="font-family:Arial">     </span><span style="font-family:幼圆"> eid;</span><span style="font-family:Arial">       </span><span style="font-family:幼圆">/* BCM unit unique entryidentifier</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> int</span><span style="font-family:Arial">                   </span><span style="font-family:幼圆"> prio;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* Entry priority</span><span style="font-family:Arial">                    </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> uint32</span><span style="font-family:Arial">                </span><span style="font-family:幼圆"> slice_idx;</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> /* Field entry tcam index.</span><span style="font-family:Arial">           </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> uint16</span><span style="font-family:Arial">                </span><span style="font-family:幼圆"> flags;</span><span style="font-family:Arial">     </span><span style="font-family:幼圆"> /* _FP_ENTRY_xxx flags</span><span style="font-family:Arial">               </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> _field_tcam_t</span><span style="font-family:Arial">         </span><span style="font-family:幼圆"> tcam;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* Fields to be written intoFP_TCAM</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> _field_tcam_t</span><span style="font-family:Arial">         </span><span style="font-family:幼圆"> extra_tcam;
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">#ifdefined(BCM_RAPTOR_SUPPORT) || defined(BCM_TRX_SUPPORT)
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> _field_pbmp_t</span><span style="font-family:Arial">         </span><span style="font-family:幼圆"> pbmp;</span><span style="font-family:Arial">     </span><span style="font-family:幼圆"> /* Port bitmap */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">#endif /*BCM_RAPTOR_SUPPORT || BCM_TRX_SUPPORT */</span><span style="font-family:Arial">   </span><span style="font-family:幼圆">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> _field_action_t</span><span style="font-family:Arial">       </span><span style="font-family:幼圆"> *actions;</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> /* linked list of actions for entry</span><span style="font-family:Arial">  </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> _field_slice_t</span><span style="font-family:Arial">        </span><span style="font-family:幼圆"> *fs;</span><span style="font-family:Arial">       </span><span style="font-family:幼圆"> /* Slice where entry lives</span><span style="font-family:Arial">           </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> _field_group_t</span><span style="font-family:Arial">        </span><span style="font-family:幼圆"> *group;</span><span style="font-family:Arial">    </span><span style="font-family:幼圆"> /* Group where entry lives</span><span style="font-family:Arial">           </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> _field_entry_stat_t</span><span style="font-family:Arial">   </span><span style="font-family:幼圆"> statistic;</span><span style="font-family:Arial"> </span><span style="font-family:幼圆">/* Statistics collection entity.</span><span style="font-family:Arial">     </span><span style="font-family:幼圆">*/</span><span style="font-family:Arial">          </span><span style="font-family:幼圆">
			</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">                                      </span><span style="font-family:幼圆"> /*Policers attached to the entry.</span><span style="font-family:Arial">   </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> _field_entry_policer_tpolicer[_FP_POLICER_LEVEL_COUNT];
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">#ifdefined(BCM_KATANA_SUPPORT)
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> _field_entry_policer_tglobal_meter_policer;
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">#endif
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> struct _field_entry_s</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> *next;</span><span style="font-family:Arial">     </span><span style="font-family:幼圆">/* Entry lookup linked list.</span><span style="font-family:Arial">         </span><span style="font-family:幼圆">*/
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">};
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">上面actions 是一个_field_action_t的结构体的链表，其信息为：
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">typedef struct_field_action_s {
</span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> bcm_field_action_t</span><span style="font-family:Arial">    </span><span style="font-family:幼圆"> action;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* action type</span><span style="font-family:Arial">              </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> uint32</span><span style="font-family:Arial">                </span><span style="font-family:幼圆"> param0;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* Action specific parameter */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> uint32</span><span style="font-family:Arial">                </span><span style="font-family:幼圆"> param1;</span><span style="font-family:Arial">      </span><span style="font-family:幼圆"> /* Action specific parameter */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> uint8</span><span style="font-family:Arial">                 </span><span style="font-family:幼圆"> inst_flg;</span><span style="font-family:Arial">    </span><span style="font-family:幼圆"> /* Installed Flag</span><span style="font-family:Arial">           </span><span style="font-family:幼圆"> */
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> struct _field_action_s *next;
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">}_field_action_t;
</span>

<span style="color:red; font-size:10pt"><span style="font-family:幼圆">6.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">在SDK编码中，用UNIT号获取对应的_field_control_t信息的代码可以如下：<span style="color:#333333">
				</span></span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">_field_control_t</span><span style="font-family:Arial">   </span><span style="font-family:幼圆"> *fc;
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">BCM_IF_ERROR_RETURN(_field_control_get(unit,&amp;fc));
</span>

<span style="color:red; font-size:10pt"><span style="font-family:幼圆">7.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">进而获取每一个group资源的代码可以如下：<span style="color:#333333">
				</span></span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial"> </span><span style="font-family:幼圆">_field_group_t</span><span style="font-family:Arial">     </span><span style="font-family:幼圆"> *fg;
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial"> </span><span style="font-family:幼圆">fg = fc-&gt;groups;
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> while (fg != NULL) {
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">       </span><span style="font-family:幼圆"> if (fg-&gt;gid == gid) {
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">           </span><span style="font-family:幼圆"> *group_p = fg;
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">           </span><span style="font-family:幼圆"> return (BCM_E_NONE);
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">       </span><span style="font-family:幼圆"> }
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">       </span><span style="font-family:幼圆"> fg = fg-&gt;next;
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial">   </span><span style="font-family:幼圆"> }
</span></span>

<span style="color:red; font-size:10pt"><span style="font-family:幼圆">8.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">获取每一个slice的资源可以如下<span style="color:#333333">
				</span></span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">_field_slice_t</span><span style="font-family:Arial">        </span><span style="font-family:幼圆"> *slices;
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">slice =&amp;fg-&gt;slices[0];
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">while(slice !=NULL){
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">slice = slice-&gt;prev;
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">}
</span>

<span style="color:red; font-size:10pt"><span style="font-family:幼圆">9.</span><span style="font-family:Arial">      </span><span style="font-family:幼圆">获取slice中规则的的资源可以如下：<span style="color:#333333">
				</span></span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:幼圆">_field_entry_t</span><span style="font-family:Arial">  </span><span style="font-family:幼圆">*f_ent;
</span></span>

<span style="color:#333333; font-size:10pt"><span style="font-family:Arial"> </span><span style="font-family:幼圆">_field_action_t</span><span style="font-family:Arial"> </span><span style="font-family:幼圆"> *fa_iter;
</span></span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">_field_entry_get(unit, entry, _FP_ENTRY_PRIMARY,&amp;f_ent);//entry
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">fa_iter = f_ent-&gt;actions;//entry的action
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">熟悉FP同学可能深知FP资源的稀缺性和重要性，可以用惜slice如黄金来做比喻；虽然FP的规则数很多，但是FP的资源申请和释放是按照slice为单位来进行的，且slice的数目一般都不是很多；所以我们要将尽量多的规则整合到一个slice里，尽量减少slice里有规则被浪费的现象；这个也是再将来的协议改造中必须考虑到的一个因素。
</span>

<span style="color:#333333; font-family:幼圆; font-size:10pt">到这里对FP的原理和SDK的相关数据结构介绍到这里，如果描述中有不清晰或者不准确的地方欢迎随时沟通讨论。
</span>
