---
title: '[Keepalived-devel] 1.2.7 wont compile with 2.6.32 kernel'
id: 335
comment: false
categories:
  - arm
date: 2016-05-04 15:07:10
tags:
---

<div style="margin-left: 7pt"><table style="border-collapse:collapse" border="0"><colgroup><col style="width:765px"/></colgroup><tbody valign="top"><tr><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

![](http://www.madhex.com/wp-content/uploads/2016/05/050416_0710_Keepalivedd1.gif)<span style="color:#555555; font-family:Courier New; font-size:10pt">
							</span>
<!-- more -->

<span style="color:#555555; font-family:Courier New; font-size:10pt">I want to use keepalived vrrp with vmac in 2.6.32-13 linux kernel, but 
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">configuration is failing and I do a trick and configured successfully but 
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">when I compiling I encountered with errors.
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">IFLA_MACVLAN_MODE and MACVLAN_MODE_PRIVATE not exported through
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">netlink in 2.6.32.
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">How can I use keepalived vrrp(with vmac) with  2.6.32-13 linux kernel?
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">What is the supported minimum kernel version of keepalived?
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt"> ./configure --with-kernel-dir=/usr/src/linux-headers-2.6.32-13
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">Keepalived configuration
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">------------------------
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">Keepalived version       : 1.2.3
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">Compiler                 : gcc
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">Compiler flags           : -g -O2
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">Extra Lib                : -lpopt -lssl -lcrypto  -lnl
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">Use IPVS Framework       : Yes
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">IPVS sync daemon support : Yes
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">IPVS use libnl           : Yes
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">Use VRRP Framework       : Yes
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">Use Debug flags          : No
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">gcc -g -O2  -I/usr/src/linux-headers-2.6.32/include -I../include
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">-I../../lib -Wall -Wunused -Wstrict-prototypes -D_KRNL_2_6_
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">-D_WITH_LVS_ -D_HAVE_IPVS_SYNCD_  -c vrrp_vmac.c
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">vrrp_vmac.c: In function 'netlink_link_setmode':
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">vrrp_vmac.c:96: error: 'IFLA_MACVLAN_MODE' undeclared (first use in
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">this function)
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">vrrp_vmac.c:96: error: (Each undeclared identifier is reported only once
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">vrrp_vmac.c:96: error: for each function it appears in.)
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">vrrp_vmac.c:97: error: 'MACVLAN_MODE_PRIVATE' undeclared (first use in
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">this function)
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">make[2]: *** [vrrp_vmac.o] Error 1
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">make[2]: Leaving directory `/home/szepcs/keepalived-1.2.3/keepalived/vrrp'
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">make[1]: *** [all] Error 1
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">make[1]: Leaving directory `/home/szepcs/keepalived-1.2.3/keepalived'
</span>

<span style="color:#555555; font-family:Courier New; font-size:10pt">make: *** [all] Error 2</span>
</td></tr></tbody></table></div>

![](http://www.madhex.com/wp-content/uploads/2016/05/050416_0710_Keepalivedd2.png)<span style="font-family:宋体; font-size:12pt">
		</span>

<span style="color:#555555; font-family:Arial; font-size:10pt">**Thread view
**</span>
<div style="margin-left: 7pt"><table style="border-collapse:collapse" border="0"><colgroup><col style="width:765px"/></colgroup><tbody valign="top"><tr style="background: #dddddd"><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

[<span style="color:#006699; font-family:宋体; font-size:10pt; text-decoration:underline">**[Keepalived-devel] 1.2.7 wont compile with 2.6.32 kernel**</span>](https://sourceforge.net/p/keepalived/mailman/message/30785477/)<span style="font-family:宋体; font-size:10pt">
							</span>

<span style="font-family:宋体; font-size:9pt">From: umit &lt;uyalap@gm...&gt; - 2013-04-29 21:56:01</span>
</td></tr><tr><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

<span style="font-family:Courier New; font-size:10pt">I want to use keepalived vrrp with vmac in 2.6.32-13 linux kernel, but 
</span>

<span style="font-family:Courier New; font-size:10pt">configuration is failing and I do a trick and configured successfully but 
</span>

<span style="font-family:Courier New; font-size:10pt">when I compiling I encountered with errors.
</span>

<span style="font-family:Courier New; font-size:10pt">IFLA_MACVLAN_MODE and MACVLAN_MODE_PRIVATE not exported through
</span>

<span style="font-family:Courier New; font-size:10pt">netlink in 2.6.32.
</span>

<span style="font-family:Courier New; font-size:10pt">How can I use keepalived vrrp(with vmac) with  2.6.32-13 linux kernel?
</span>

<span style="font-family:Courier New; font-size:10pt">What is the supported minimum kernel version of keepalived?
</span>

<span style="font-family:Courier New; font-size:10pt"> ./configure --with-kernel-dir=/usr/src/linux-headers-2.6.32-13
</span>

<span style="font-family:Courier New; font-size:10pt">Keepalived configuration
</span>

<span style="font-family:Courier New; font-size:10pt">------------------------
</span>

<span style="font-family:Courier New; font-size:10pt">Keepalived version       : 1.2.3
</span>

<span style="font-family:Courier New; font-size:10pt">Compiler                 : gcc
</span>

<span style="font-family:Courier New; font-size:10pt">Compiler flags           : -g -O2
</span>

<span style="font-family:Courier New; font-size:10pt">Extra Lib                : -lpopt -lssl -lcrypto  -lnl
</span>

<span style="font-family:Courier New; font-size:10pt">Use IPVS Framework       : Yes
</span>

<span style="font-family:Courier New; font-size:10pt">IPVS sync daemon support : Yes
</span>

<span style="font-family:Courier New; font-size:10pt">IPVS use libnl           : Yes
</span>

<span style="font-family:Courier New; font-size:10pt">Use VRRP Framework       : Yes
</span>

<span style="font-family:Courier New; font-size:10pt">Use Debug flags          : No
</span>

<span style="font-family:Courier New; font-size:10pt">gcc -g -O2  -I/usr/src/linux-headers-2.6.32/include -I../include
</span>

<span style="font-family:Courier New; font-size:10pt">-I../../lib -Wall -Wunused -Wstrict-prototypes -D_KRNL_2_6_
</span>

<span style="font-family:Courier New; font-size:10pt">-D_WITH_LVS_ -D_HAVE_IPVS_SYNCD_  -c vrrp_vmac.c
</span>

<span style="font-family:Courier New; font-size:10pt">vrrp_vmac.c: In function 'netlink_link_setmode':
</span>

<span style="font-family:Courier New; font-size:10pt">vrrp_vmac.c:96: error: 'IFLA_MACVLAN_MODE' undeclared (first use in
</span>

<span style="font-family:Courier New; font-size:10pt">this function)
</span>

<span style="font-family:Courier New; font-size:10pt">vrrp_vmac.c:96: error: (Each undeclared identifier is reported only once
</span>

<span style="font-family:Courier New; font-size:10pt">vrrp_vmac.c:96: error: for each function it appears in.)
</span>

<span style="font-family:Courier New; font-size:10pt">vrrp_vmac.c:97: error: 'MACVLAN_MODE_PRIVATE' undeclared (first use in
</span>

<span style="font-family:Courier New; font-size:10pt">this function)
</span>

<span style="font-family:Courier New; font-size:10pt">make[2]: *** [vrrp_vmac.o] Error 1
</span>

<span style="font-family:Courier New; font-size:10pt">make[2]: Leaving directory `/home/szepcs/keepalived-1.2.3/keepalived/vrrp'
</span>

<span style="font-family:Courier New; font-size:10pt">make[1]: *** [all] Error 1
</span>

<span style="font-family:Courier New; font-size:10pt">make[1]: Leaving directory `/home/szepcs/keepalived-1.2.3/keepalived'
</span>

<span style="font-family:Courier New; font-size:10pt">make: *** [all] Error 2
</span>

<span style="font-family:Courier New; font-size:10pt">
							</span> 
</td></tr><tr style="background: #dddddd"><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

[<span style="color:#006699; font-family:宋体; font-size:10pt; text-decoration:underline">**Re: [Keepalived-devel] 1.2.7 wont compile with 2.6.32 kernel**</span>](https://sourceforge.net/p/keepalived/mailman/message/30791775/)<span style="font-family:宋体; font-size:10pt">
							</span>

<span style="font-family:宋体; font-size:9pt">From: Sander Klein &lt;roedie@ro...&gt; - 2013-05-01 09:29:08</span>
</td></tr><tr><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

<span style="font-family:Courier New; font-size:10pt">On 29.04.2013 23:55, umit wrote:
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; I want to use keepalived vrrp with vmac in 2.6.32-13 linux kernel, but
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; configuration is failing and I do a trick and configured successfully 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; but
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; when I compiling I encountered with errors.
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; IFLA_MACVLAN_MODE and MACVLAN_MODE_PRIVATE not exported through
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; netlink in 2.6.32.
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; How can I use keepalived vrrp(with vmac) with  2.6.32-13 linux kernel?
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; What is the supported minimum kernel version of keepalived?
</span>

<span style="font-family:Courier New; font-size:10pt">I'm not sure which kernel exactly, but I believe you need something 
</span>

<span style="font-family:Courier New; font-size:10pt">like 3.0.X or higher to get this working.
</span>

<span style="font-family:Courier New; font-size:10pt">Greets,
</span>

<span style="font-family:Courier New; font-size:10pt">Sander
</span>

<span style="font-family:Courier New; font-size:10pt">
							</span> 
</td></tr></tbody></table></div>

<div style="margin-left: 7pt"><table style="border-collapse:collapse" border="0"><colgroup><col style="width:765px"/></colgroup><tbody valign="top"><tr style="background: #dddddd"><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

[<span style="color:#006699; font-family:宋体; font-size:10pt; text-decoration:underline">**Re: [Keepalived-devel] 1.2.7 wont compile with 2.6.32 kernel**</span>](https://sourceforge.net/p/keepalived/mailman/message/30793758/)<span style="font-family:宋体; font-size:10pt">
							</span>

<span style="font-family:宋体; font-size:9pt">From: Lennart Sorensen &lt;lsorense@cs...&gt; - 2013-05-01 18:59:02</span>
</td></tr><tr><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

<span style="font-family:Courier New; font-size:10pt">On Wed, May 01, 2013 at 11:12:28AM +0200, Sander Klein wrote:
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; On 29.04.2013 23:55, umit wrote:
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; I want to use keepalived vrrp with vmac in 2.6.32-13 linux kernel, but
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; configuration is failing and I do a trick and configured successfully 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; but
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; when I compiling I encountered with errors.
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; IFLA_MACVLAN_MODE and MACVLAN_MODE_PRIVATE not exported through
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; netlink in 2.6.32.
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; How can I use keepalived vrrp(with vmac) with  2.6.32-13 linux kernel?
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; What is the supported minimum kernel version of keepalived?
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; I'm not sure which kernel exactly, but I believe you need something 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; like 3.0.X or higher to get this working.
</span>

<span style="font-family:Courier New; font-size:10pt">2.6.33 was the first kernel with IFLA_MACVLAN_MODE defined.  2.6.32 is
</span>

<span style="font-family:Courier New; font-size:10pt">too old.
</span>

<span style="font-family:Courier New; font-size:10pt">-- 
</span>

<span style="font-family:Courier New; font-size:10pt">Len Sorensen
</span>

<span style="font-family:Courier New; font-size:10pt">
							</span> 
</td></tr><tr style="background: #dddddd"><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

[<span style="color:#006699; font-family:宋体; font-size:10pt; text-decoration:underline">**Re: [Keepalived-devel] 1.2.7 wont compile with 2.6.32 kernel**</span>](https://sourceforge.net/p/keepalived/mailman/message/30794140/)<span style="font-family:宋体; font-size:10pt">
							</span>

<span style="font-family:宋体; font-size:9pt">From: umit &lt;uyalap@gm...&gt; - 2013-05-01 20:46:46</span>
</td></tr><tr><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

<span style="font-family:Courier New; font-size:10pt">Thanks for reply, but 2.6.32.y kernel is long-term kernel version so I think 
</span>

<span style="font-family:Courier New; font-size:10pt">there must be a patch for support this behaviour.
</span>

<span style="font-family:Courier New; font-size:10pt">Can I find a patch that only difference from 2.6.32.y is about 
</span>

<span style="font-family:Courier New; font-size:10pt">macvlan(IFLA_MACVLAN_MODE)? 
</span>

<span style="font-family:Courier New; font-size:10pt">
							</span> 
</td></tr></tbody></table></div>

<div style="margin-left: 7pt"><table style="border-collapse:collapse" border="0"><colgroup><col style="width:765px"/><col style="width:303px"/></colgroup><tbody valign="top"><tr style="background: #dddddd"><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

[<span style="color:#006699; font-family:宋体; font-size:10pt; text-decoration:underline">**Re: [Keepalived-devel] 1.2.7 wont compile with 2.6.32 kernel**</span>](https://sourceforge.net/p/keepalived/mailman/message/30794242/)<span style="font-family:宋体; font-size:10pt">
							</span>

<span style="font-family:宋体; font-size:9pt">From: Lennart Sorensen &lt;lsorense@cs...&gt; - 2013-05-01 21:19:28</span>
</td></tr><tr><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

<span style="font-family:Courier New; font-size:10pt">On Wed, May 01, 2013 at 08:46:18PM +0000, umit wrote:
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; Thanks for reply, but 2.6.32.y kernel is long-term kernel version so I think 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; there must be a patch for support this behaviour.
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; Can I find a patch that only difference from 2.6.32.y is about 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; macvlan(IFLA_MACVLAN_MODE)? 
</span>

<span style="font-family:Courier New; font-size:10pt">The commit 27c0b1a850cdea6298f573d835782f3337be913c in Linus's git tree
</span>

<span style="font-family:Courier New; font-size:10pt">was done around the time of 2.6.32, and applies cleanly to 2.6.32(.0),
</span>

<span style="font-family:Courier New; font-size:10pt">so you can probably grab that and apply it easily.
</span>

<span style="font-family:Courier New; font-size:10pt">-- 
</span>

<span style="font-family:Courier New; font-size:10pt">Len Sorensen
</span>

<span style="font-family:Courier New; font-size:10pt">
							</span> 
</td></tr><tr style="background: #dddddd"><td colspan="2" vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

[<span style="color:#006699; font-family:宋体; font-size:10pt; text-decoration:underline">**Re: [Keepalived-devel] 1.2.7 wont compile with 2.6.32 kernel**</span>](https://sourceforge.net/p/keepalived/mailman/message/30810244/)<span style="font-family:宋体; font-size:10pt">
							</span>

<span style="font-family:宋体; font-size:9pt">From: umit &lt;uyalap@gm...&gt; - 2013-05-06 09:32:07</span>
</td></tr><tr><td colspan="2" vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

<span style="font-family:Courier New; font-size:10pt">Lennart Sorensen &lt;lsorense &lt;at&gt; csclub.uwaterloo.ca&gt; writes:
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; On Wed, May 01, 2013 at 08:46:18PM +0000, umit wrote:
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; Thanks for reply, but 2.6.32.y kernel is long-term kernel version so I
</span>

<span style="font-family:Courier New; font-size:10pt">think 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; there must be a patch for support this behaviour.
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; Can I find a patch that only difference from 2.6.32.y is about 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; &gt; macvlan(IFLA_MACVLAN_MODE)? 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; The commit 27c0b1a850cdea6298f573d835782f3337be913c in Linus's git tree
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; was done around the time of 2.6.32, and applies cleanly to 2.6.32(.0),
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; so you can probably grab that and apply it easily.
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">Thanks a lot. 
</span>

<span style="font-family:Courier New; font-size:10pt">I searched macvlan at linux git tree
</span>

<span style="font-family:Courier New; font-size:10pt">([<span style="color:#006699; text-decoration:underline">http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?id=27c0b1a850cdea6298f573d835782f3337be913c&amp;qt=grep&amp;q=macvlan</span>](http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?id=27c0b1a850cdea6298f573d835782f3337be913c&amp;qt=grep&amp;q=macvlan))
</span>

<span style="font-family:Courier New; font-size:10pt">I saw macvlan.c file after the commit
</span>

<span style="font-family:Courier New; font-size:10pt">2c11455321f37da6fe6cc36353149f9ac9183334  is equal with my mine 2.6.32.13
</span>

<span style="font-family:Courier New; font-size:10pt">macvlan.c file
</span>

<span style="font-family:Courier New; font-size:10pt">So there are some extra patches with
</span>

<span style="font-family:Courier New; font-size:10pt">2c11455321f37da6fe6cc36353149f9ac9183334 and
</span>

<span style="font-family:Courier New; font-size:10pt">27c0b1a850cdea6298f573d835782f3337be913c commits. 
</span>

<span style="font-family:Courier New; font-size:10pt">Can I apply direct 27c0b1a850cdea6298f573d835782f3337be913c commit in my kernel?
</span>

<span style="font-family:Courier New; font-size:10pt">Should I apply other paches between above commits?
</span>

<span style="font-family:Courier New; font-size:10pt">
							</span> 
</td></tr></tbody></table></div>

<div style="margin-left: 7pt"><table style="border-collapse:collapse" border="0"><colgroup><col style="width:1068px"/></colgroup><tbody valign="top"><tr style="background: #dddddd"><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

[<span style="color:#006699; font-family:宋体; font-size:10pt; text-decoration:underline">**Re: [Keepalived-devel] 1.2.7 wont compile with 2.6.32 kernel**</span>](https://sourceforge.net/p/keepalived/mailman/message/30810996/)<span style="font-family:宋体; font-size:10pt">
							</span>

<span style="font-family:宋体; font-size:9pt">From: Lennart Sorensen &lt;lsorense@cs...&gt; - 2013-05-06 13:31:12</span>
</td></tr><tr><td vAlign="middle" style="padding-top: 5px; padding-left: 10px; padding-bottom: 5px; padding-right: 10px; border-top:  none; border-left:  none; border-bottom:  solid #e5e5e5 0.75pt; border-right:  none">

<span style="font-family:Courier New; font-size:10pt">On Mon, May 06, 2013 at 09:31:32AM +0000, umit wrote:
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; Thanks a lot. 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; I searched macvlan at linux git tree
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; ([<span style="color:#006699; text-decoration:underline">http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?id=27c0b1a850cdea6298f573d835782f3337be913c&amp;qt=grep&amp;q=macvlan</span>](http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?id=27c0b1a850cdea6298f573d835782f3337be913c&amp;qt=grep&amp;q=macvlan))
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; I saw macvlan.c file after the commit
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 2c11455321f37da6fe6cc36353149f9ac9183334  is equal with my mine 2.6.32.13
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; macvlan.c file
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; So there are some extra patches with
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 2c11455321f37da6fe6cc36353149f9ac9183334 and
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 27c0b1a850cdea6298f573d835782f3337be913c commits. 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; 
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; Can I apply direct 27c0b1a850cdea6298f573d835782f3337be913c commit in my kernel?
</span>

<span style="font-family:Courier New; font-size:10pt">Yes.  As far as I can tell it applies cleanly without any other commits.
</span>

<span style="font-family:Courier New; font-size:10pt">It might need other commits to work I suppose.
</span>

<span style="font-family:Courier New; font-size:10pt">&gt; Should I apply other paches between above commits?
</span>

<span style="font-family:Courier New; font-size:10pt">I see commits on macvlan.c from 2.6.32 up to the one adding the netlink
</span>

<span style="font-family:Courier New; font-size:10pt">interface with the defines you need are:
</span>

<span style="font-family:Courier New; font-size:10pt">commit 27c0b1a850cdea6298f573d835782f3337be913c
</span>

<span style="font-family:Courier New; font-size:10pt">Author: Arnd Bergmann &lt;arnd@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">Date:   Thu Nov 26 06:07:11 2009 +0000
</span>

<span style="font-family:Courier New; font-size:10pt">    macvlan: export macvlan mode through netlink
</span>

<span style="font-family:Courier New; font-size:10pt">    In order to support all three modes of macvlan at
</span>

<span style="font-family:Courier New; font-size:10pt">    runtime, extend the existing netlink protocol
</span>

<span style="font-family:Courier New; font-size:10pt">    to allow choosing the mode per macvlan slave
</span>

<span style="font-family:Courier New; font-size:10pt">    interface.
</span>

<span style="font-family:Courier New; font-size:10pt">    This depends on a matching patch to iproute2
</span>

<span style="font-family:Courier New; font-size:10pt">    in order to become accessible in user land.
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: Arnd Bergmann &lt;arnd@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Acked-by: Patrick McHardy &lt;kaber@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: David S. Miller &lt;davem@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">commit 618e1b7482f7a8a4c6c6e8ccbe140e4c331df4e9
</span>

<span style="font-family:Courier New; font-size:10pt">Author: Arnd Bergmann &lt;arnd@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">Date:   Thu Nov 26 06:07:10 2009 +0000
</span>

<span style="font-family:Courier New; font-size:10pt">    macvlan: implement bridge, VEPA and private mode
</span>

<span style="font-family:Courier New; font-size:10pt">    This allows each macvlan slave device to be in one
</span>

<span style="font-family:Courier New; font-size:10pt">    of three modes, depending on the use case:
</span>

<span style="font-family:Courier New; font-size:10pt">    MACVLAN_PRIVATE:
</span>

<span style="font-family:Courier New; font-size:10pt">      The device never communicates with any other device
</span>

<span style="font-family:Courier New; font-size:10pt">      on the same upper_dev. This even includes frames
</span>

<span style="font-family:Courier New; font-size:10pt">      coming back from a reflective relay, where supported
</span>

<span style="font-family:Courier New; font-size:10pt">      by the adjacent bridge.
</span>

<span style="font-family:Courier New; font-size:10pt">    MACVLAN_VEPA:
</span>

<span style="font-family:Courier New; font-size:10pt">      The new Virtual Ethernet Port Aggregator (VEPA) mode,
</span>

<span style="font-family:Courier New; font-size:10pt">      we assume that the adjacent bridge returns all frames
</span>

<span style="font-family:Courier New; font-size:10pt">      where both source and destination are local to the
</span>

<span style="font-family:Courier New; font-size:10pt">      macvlan port, i.e. the bridge is set up as a reflective
</span>

<span style="font-family:Courier New; font-size:10pt">      relay.
</span>

<span style="font-family:Courier New; font-size:10pt">      Broadcast frames coming in from the upper_dev get
</span>

<span style="font-family:Courier New; font-size:10pt">      flooded to all macvlan interfaces in VEPA mode.
</span>

<span style="font-family:Courier New; font-size:10pt">      We never deliver any frames locally.
</span>

<span style="font-family:Courier New; font-size:10pt">    MACVLAN_BRIDGE:
</span>

<span style="font-family:Courier New; font-size:10pt">      We provide the behavior of a simple bridge between
</span>

<span style="font-family:Courier New; font-size:10pt">      different macvlan interfaces on the same port. Frames
</span>

<span style="font-family:Courier New; font-size:10pt">      from one interface to another one get delivered directly
</span>

<span style="font-family:Courier New; font-size:10pt">      and are not sent out externally. Broadcast frames get
</span>

<span style="font-family:Courier New; font-size:10pt">      flooded to all other bridge ports and to the external
</span>

<span style="font-family:Courier New; font-size:10pt">      interface, but when they come back from a reflective
</span>

<span style="font-family:Courier New; font-size:10pt">      relay, we don't deliver them again.
</span>

<span style="font-family:Courier New; font-size:10pt">      Since we know all the MAC addresses, the macvlan bridge
</span>

<span style="font-family:Courier New; font-size:10pt">      mode does not require learning or STP like the bridge
</span>

<span style="font-family:Courier New; font-size:10pt">      module does.
</span>

<span style="font-family:Courier New; font-size:10pt">    Based on an earlier patch "macvlan: Reflect macvlan packets
</span>

<span style="font-family:Courier New; font-size:10pt">    meant for other macvlan devices" by Eric Biederman.
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: Arnd Bergmann &lt;arnd@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Acked-by: Patrick McHardy &lt;kaber@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Cc: Eric Biederman &lt;ebiederm@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: David S. Miller &lt;davem@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">commit a1e514c5d0397b5581721aad9b303f7df83b103d
</span>

<span style="font-family:Courier New; font-size:10pt">Author: Arnd Bergmann &lt;arnd@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">Date:   Thu Nov 26 06:07:09 2009 +0000
</span>

<span style="font-family:Courier New; font-size:10pt">    macvlan: cleanup rx statistics
</span>

<span style="font-family:Courier New; font-size:10pt">    We have very similar code for rx statistics in
</span>

<span style="font-family:Courier New; font-size:10pt">    two places in the macvlan driver, with a third
</span>

<span style="font-family:Courier New; font-size:10pt">    one being added in the next patch.
</span>

<span style="font-family:Courier New; font-size:10pt">    Consolidate them into one function to improve
</span>

<span style="font-family:Courier New; font-size:10pt">    overall readability of the driver.
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: Arnd Bergmann &lt;arnd@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Acked-by: Patrick McHardy &lt;kaber@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: David S. Miller &lt;davem@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">commit fccaf71011b171883efee5bae321eac4760584d1
</span>

<span style="font-family:Courier New; font-size:10pt">Author: Eric Dumazet &lt;eric.dumazet@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">Date:   Tue Nov 17 08:53:49 2009 +0000
</span>

<span style="font-family:Courier New; font-size:10pt">    macvlan: Precise RX stats accounting
</span>

<span style="font-family:Courier New; font-size:10pt">    With multi queue devices, its possible that several cpus call
</span>

<span style="font-family:Courier New; font-size:10pt">    macvlan RX routines simultaneously for the same macvlan device.
</span>

<span style="font-family:Courier New; font-size:10pt">    We update RX stats counter without any locking, so we can
</span>

<span style="font-family:Courier New; font-size:10pt">    get slightly wrong counters.
</span>

<span style="font-family:Courier New; font-size:10pt">    One possible fix is to use percpu counters, to get precise
</span>

<span style="font-family:Courier New; font-size:10pt">    accounting and also get guarantee of no cache line ping pongs
</span>

<span style="font-family:Courier New; font-size:10pt">    between cpus.
</span>

<span style="font-family:Courier New; font-size:10pt">    Note: this adds 16 bytes (32 bytes on 64bit arches) of percpu
</span>

<span style="font-family:Courier New; font-size:10pt">    data per macvlan device.
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: Eric Dumazet &lt;eric.dumazet@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: David S. Miller &lt;davem@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">commit cbbef5e183079455763fc470ccf69008f92ab4b6
</span>

<span style="font-family:Courier New; font-size:10pt">Author: Patrick McHardy &lt;kaber@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">Date:   Tue Nov 10 06:14:24 2009 +0000
</span>

<span style="font-family:Courier New; font-size:10pt">    vlan/macvlan: propagate transmission state to upper layers
</span>

<span style="font-family:Courier New; font-size:10pt">    Both vlan and macvlan devices usually don't use a qdisc and immediately
</span>

<span style="font-family:Courier New; font-size:10pt">    queue packets to the underlying device. Propagate transmission state of
</span>

<span style="font-family:Courier New; font-size:10pt">    the underlying device to the upper layers so they can react on congestion
</span>

<span style="font-family:Courier New; font-size:10pt">    and/or inform the sending process.
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: Patrick McHardy &lt;kaber@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: David S. Miller &lt;davem@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">commit 81adee47dfb608df3ad0b91d230fb3cef75f0060
</span>

<span style="font-family:Courier New; font-size:10pt">Author: Eric W. Biederman &lt;ebiederm@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">Date:   Sun Nov 8 00:53:51 2009 -0800
</span>

<span style="font-family:Courier New; font-size:10pt">    net: Support specifying the network namespace upon device creation.
</span>

<span style="font-family:Courier New; font-size:10pt">    There is no good reason to not support userspace specifying the
</span>

<span style="font-family:Courier New; font-size:10pt">    network namespace during device creation, and it makes it easier
</span>

<span style="font-family:Courier New; font-size:10pt">    to create a network device and pass it to a child network namespace
</span>

<span style="font-family:Courier New; font-size:10pt">    with a well known name.
</span>

<span style="font-family:Courier New; font-size:10pt">    We have to be careful to ensure that the target network namespace
</span>

<span style="font-family:Courier New; font-size:10pt">    for the new device exists through the life of the call.  To keep
</span>

<span style="font-family:Courier New; font-size:10pt">    that logic clear I have factored out the network namespace grabbing
</span>

<span style="font-family:Courier New; font-size:10pt">    logic into rtnl_link_get_net.
</span>

<span style="font-family:Courier New; font-size:10pt">    In addtion we need to continue to pass the source network namespace
</span>

<span style="font-family:Courier New; font-size:10pt">    to the rtnl_link_ops.newlink method so that we can find the base
</span>

<span style="font-family:Courier New; font-size:10pt">    device source network namespace.
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: Eric W. Biederman &lt;ebiederm@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Acked-by: Eric Dumazet &lt;eric.dumazet@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">commit 23289a37e2b127dfc4de1313fba15bb4c9f0cd5b
</span>

<span style="font-family:Courier New; font-size:10pt">Author: Eric Dumazet &lt;eric.dumazet@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">Date:   Tue Oct 27 07:06:36 2009 +0000
</span>

<span style="font-family:Courier New; font-size:10pt">    net: add a list_head parameter to dellink() method
</span>

<span style="font-family:Courier New; font-size:10pt">    Adding a list_head parameter to rtnl_link_ops-&gt;dellink() methods
</span>

<span style="font-family:Courier New; font-size:10pt">    allow us to queue devices on a list, in order to dismantle
</span>

<span style="font-family:Courier New; font-size:10pt">    them all at once.
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: Eric Dumazet &lt;eric.dumazet@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">    Signed-off-by: David S. Miller &lt;davem@...&gt;
</span>

<span style="font-family:Courier New; font-size:10pt">That seems to match the range you found.  You probably do need all of
</span>

<span style="font-family:Courier New; font-size:10pt">those (starting from the bottom and working forward).
</span>

<span style="font-family:Courier New; font-size:10pt">-- 
</span>

<span style="font-family:Courier New; font-size:10pt">Len Sorensen
</span>

<span style="font-family:Courier New; font-size:10pt">
							</span> 
</td></tr></tbody></table></div>
