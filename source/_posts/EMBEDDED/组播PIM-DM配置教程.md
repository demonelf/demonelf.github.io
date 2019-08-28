---
title: 组播PIM-DM配置教程
id: 403
comment: false
categories:
  - arm
date: 2016-05-09 15:52:06
tags:
---

PIM-DM理论知识：http://www.023wg.com/Multicast/216.html

<!-- more -->
PIM-DM网络的所有设备使能了PIM-DM后，就可为用户主机提供任意源组播服务，加入同一组播组的用户主机都能收到任意源发往该组的组播数据。配置PIM-DM前需先配置单播路由协议，保证网络内单播路由畅通。VPN实例或者公网实例上不能同时使能PIM-DM和PIM-SM。建议将处于PIM-DM网络内的所有接口都使能PIM-DM，以确保与其相连的PIM设备都能建立邻居关系。

      如果接口上需要同时使能PIM-DM和IGMP，必须要先使能PIM-DM，再使能IGMP。

**1、公网实例的PIM-DM配置**

1.1、设置组播转发模式为大规格模式（可选）

[Huawei]set multicast forwarding-table super-mode

# 此功能需要重启设备才能生效。配置此功能后，PIM-DM的状态刷新报文发送间隔由60s变为255s。配置此功能后，PIM-DM的Join/Prune报文保持时间由210s变为300s

1.2、优化接口板上组播报文的复制能力

[Huawei]assign multicast-ressource-mode optimize

1.3、使能组播路由功能

[Huawei]multicast routing-enable

1.4、使能PIM-DM

[Huawei-GigabitEthernet0/0/1]pim dm

**2、VPN实例的PIM-DM配置**

[Huawei]ip vpn-instance 1

[Huawei-vpn-instance-1]

[Huawei-vpn-instance-1]multicast routing-enable

[Huawei-GigabitEthernet0/0/2]ip binding vpn-instance 1   # 将接口与VPN实例进行关联

[Huawei-GigabitEthernet0/0/2]pim dm

**3、PIM-DM组播源控制参数设置**

通过ACL对组播源的地址进行过滤，以及对组播源生存时间进行控制，可以提高数据安全性、控制网络流量。

<a name="dc_cfg_pim-dm_ipv4_0006__1.4.1"/>当PIM设备在接收到源S发往组播组G的组播报文后，就会启动该（S，G）表项的定时器，时间设为源生存时间。如果超时前接收到源S后续发来的报文，则重置定时器；如果超时后没有接收到源S后续发来的报文，则认为（S，G）表项失效，将其删除。

如果希望控制组播流量或者保证接收数据的安全性，还可在PIM设备上配置源地址过滤策略，只接收该策略允许范围内组播源发送的组播数据。

3.1、组播源生存时间

<a name="dc_cfg_pim-dm_ipv4_0006__1.4.3"/>[Huawei-pim]source-lifetime ?

  INTEGER&lt;60-65535&gt;  Specify source lifetime in seconds

3.2、源地址过滤策略

[Huawei-pim]source-policy ?

  INTEGER&lt;2000-3999&gt;  Apply basic or advanced ACL

  acl-name            Name ACL

# 如果指定ACL没有配置过滤规则，则不转发任何源地址发送的组播报文。执行本功能不过滤静态（S，G）和记录了私网加入信息的PIM表项。

**4、PIM-DM Hello报文的时间控制参数设置**

PIM设备通过周期性地发送Hello报文来维护PIM邻居关系。当PIM设备收到邻居发来Hello报文后，会启动定时器，时间设为该Hello报文的保持时间。

如果超时后没有收到邻居发来的Hello报文，则认为该邻居失效或者不可达。因此，PIM设备发送Hello报文的时间间隔必须要小于Hello报文的保持时间。

为了避免多个PIM设备同时发送Hello报文而导致冲突，当PIM设备接收到Hello报文时，将延迟一段时间再发送Hello报文。该段时间的值为一个随机值，并且小于触发Hello报文的最大延迟。

发送Hello报文的时间间隔、Hello报文的保持时间在全局PIM视图下和接口视图下都可配置。如果同时配置，接口视图上的配置生效。

触发Hello报文的最大延迟时间只能在接口上配置。

4.1、发送Hello报文的时间间隔

[Huawei-pim]timer hello ?

  INTEGER&lt;1-2147483647&gt;  Timer interval in seconds

或

[Huawei-GigabitEthernet0/0/1]pim timer hello ?

  INTEGER&lt;1-2147483647&gt;  Timer interval in seconds

4.2、Hello报文的保持时间

[Huawei-pim]hello-option holdtime ?

  INTEGER&lt;1-65535&gt;  Holdtime in seconds

或

[Huawei-GigabitEthernet0/0/1]pim  hello-option holdtime ?

  INTEGER&lt;1-65535&gt;  Holdtime in seconds

4.3、设置触发Hello报文的最大延迟

[Huawei-GigabitEthernet0/0/1]pim triggered-hello-delay ?

  INTEGER&lt;1-5&gt;  Specify triggered hello delay interval in seconds

**5、PIM-DM邻居过滤策略设置**

设备支持不同的邻居过滤策略，来保证PIM-DM网络的安全和畅通：

限定合法的邻居地址范围，防止非法邻居入侵等。拒绝接收无Generation ID的Hello报文，保证设备相连的都是正常工作的PIM邻居。

5.1、配置合法的邻居地址范围

[Huawei-GigabitEthernet0/0/1]pim neighbor-policy ?

  INTEGER&lt;2000-2999&gt;  Apply basic ACL

  acl-name            Name ACL

# 设备上配置了合法的邻居地址范围后，如果之前与其建立好邻居关系的PIM设备不在其合法地址范围内，后续将不会再收到邻居设备的Hello报文。邻居关系也会因Hello报文的保持时间超时而解除。

在定义ACL的rule时，通过permit参数配置接口仅接收指定地址范围的Hello报文。如果ACL未定义rule，则接口过滤掉所有地址范围的Hello报文。

5.2、只接收包含Generation ID的Hello报文

[Huawei-GigabitEthernet0/0/1]pim require-genid

**6、PIM-DM Join/Prune报文的保持时间**

<a name="dc_cfg_pim-dm_ipv4_0012__1.4.1"/>PIM设备通过向上游发送Prune（剪枝）信息请求停止转发组播数据。实际上，Prune信息被封装在了PIM协议通用的转发控制报文（即Join/Prune报文）中。

上游设备在收到Join/Prune报文后，就会启动定时器，时间设为Join/Prune报文自身携带的保持时间。超时后，如果没有收到下游后续发来的Join/Prune报文，则恢复相应组播组下游接口的转发。

Join/Prune报文的保持时间在全局PIM视图下和接口视图下都可配置，如果同时配置，接口视图上的配置生效。

[Huawei-pim]holdtime join-prune ?

  INTEGER&lt;1-65535&gt;  Join/prune holdtime in seconds

或

[Huawei-GigabitEthernet0/0/1]pim holdtime join-prune ?

  INTEGER&lt;1-65535&gt;  Join/prune holdtime in seconds

**7、PIM-DM Join/Prune报文信息携带能力**

<a name="dc_cfg_pim-dm_ipv4_0013__1.4.1"/>在PIM-DM网络中，Join/Prune报文主要包含了需要剪枝的表项信息。设备支持通过配置Join/Prune报文长度、包含表项数目、发送方式，来调整向上游发送剪枝信息的信息量：

当PIM邻居设备性能比较差，处理单个Join/Prune报文耗时比较长，可以通过调整发送的Join/Prune报文长度来控制发送Join/Prune报文携带的(S, G)表项数量，来降低PIM邻居设备的压力。

当PIM邻居设备Join/Prune报文处理吞吐量比较小时，可以通过调整周期性报文发送队列长度，控制每次发给PIM邻居设备的(S, G)表项数量，采取小量多批次方式发送Join/Prune报文，从而避免PIM邻居设备来不及处理就将报文丢弃，引起路由振荡。

缺省情况下，为了提高发送效率，Join/Prune报文都是打包向上游发送。如果不希望Join/Prune报文打包发送，可去使能此功能。

7.1、设备发送的Join/Prune报文的最大长度

[Huawei-pim]join-prune max-packet-length ?

  INTEGER&lt;100-8100&gt;  Specify maximum join/prune packet length in bytes, the default is 8100 bytes

7.2、设备每秒发送Join/Prune报文中包含的表项数目。

[Huawei-pim]join-prune periodic-messages queue-size ?

  INTEGER&lt;16-4096&gt;  Specify maximum join/prune entries sent once

7.3、关闭实时触发的Join/Prune报文打包功能

[Huawei-pim]join-prune triggered-message-pack disable

**8、PIM-DM剪枝延迟时间设置**

<a name="dc_cfg_pim-dm_ipv4_0014__1.4.1"/>在剪枝过程中，从收到下游设备发来的剪枝信息到继续向上游设备发送剪枝信息会有延迟时间，这段时间称为LAN-Delay。

PIM设备在向上游发完剪枝信息后，也不会立即将相应下游接口剪掉，还会保持一段时间向下游转发。如果下游又有组播需求，必须要在这段时间内发送加入请求以否决这个剪枝动作。

这段否决剪枝的时间称为Override-Interval。

所以，实际上PIM设备从收到剪枝信息到完成剪枝动作总共延迟了LAN-Delay＋Override-Interval段时间。

LAN-Delay、Override-Interval在全局PIM视图下和接口视图下都可配置，如果同时配置，接口视图下的配置优先级高于系统视图下的配置，接口视图下的配置生效。

8.1、发送剪枝报文的延迟时间

[Huawei-pim]hello-option lan-delay ?

  INTEGER&lt;1-32767&gt;  Lan delay in milliseconds

或

[Huawei-GigabitEthernet0/0/1]pim hello-option lan-delay ?

  INTEGER&lt;1-32767&gt;  Lan delay in milliseconds

8.2、否决剪枝的时间

[Huawei-pim]hello-option override-interval ?

  INTEGER&lt;1-65535&gt;  Override interval in milliseconds

或

[Huawei-GigabitEthernet0/0/1]pim hello-option override-interval ?

  INTEGER&lt;1-65535&gt;  Override interval in milliseconds

**9、PIM-DM嫁接（Graft）控制参数配置**

设备通过发送嫁接（Graft）报文，使被剪枝网段能够快速的恢复转发。通过调整嫁接控制参数，可以控制组播数据报文的转发来支持不同转发场景。

<a name="dc_cfg_pim-dm_ipv4_0016__1.4.1"/>为使被剪枝网段快速恢复转发，设备会向上游发送Graft报文请求恢复组播数据转发，并同时在发送接口启动定时器。超时后，如果设备仍没有接收到组播数据，会重新向上游发送Graft报文。

[Huawei-GigabitEthernet0/0/1]pim  timer graft-retry ?  # Graft报文重传的时间间隔

  INTEGER&lt;1-65535&gt;  Timer interval in seconds

**10、禁止PIM-DM状态刷新报文转发**

<a name="dc_cfg_pim-dm_ipv4_0018__1.4.1"/>有时候为了避免下游一直没有组播需求的被剪枝接口因为超时而恢复转发，与组播源S直连的PIM设备会触发发送（S，G）状态刷新报文。该报文会逐跳向下游扩散，刷新所有PIM设备上的剪枝定时器。这样没有转发需求的接口将一直处于抑制转发状态。

缺省情况下，设备都具备状态刷新报文的转发能力。如果希望组播数据每一次"扩散-剪枝"时都能在全网扩散，不需要通过设备转发状态刷新报文来抑制被剪枝接口转发组播数据，可在接口上禁止此功能。

状态刷新机制能够很好的减少网络资源浪费，一般情况下不建议禁止接口的状态刷新报文的收发能力。

[Huawei-GigabitEthernet0/0/1]undo pim  state-refresh-capable

**11调整PIM-DM状态刷新报文时间控制参数**

<a name="dc_cfg_pim-dm_ipv4_0019__1.4.1"/>与组播源直连的第一跳PIM设备会周期性的向下游发送状态刷新报文。由于状态刷新报文扩散发送，设备很有可能在短时间内收到重复的状态刷新报文。

为了避免这种情况发生，设备在收到针对某（S，G）的状态刷新报文后，就会启动定时器，时间设为该报文的抑制时间。

在定时器超时前，如果收到相同的状态刷新报文，就会直接丢弃。

11.1、在与组播源直接相连的第一跳设备上配置状态刷新报文的发送周期

[Huawei-pim]state-refresh-interval ?

  INTEGER&lt;1-255&gt;  Specify state refresh interval in seconds

11.2、在所有设备上配置相同状态刷新报文抑制时间

[Huawei-pim]state-refresh-rate-limit ?

  INTEGER&lt;1-65535&gt;  Specify state refresh rate-limit in seconds

**12、设置PIM-DM状态刷新报文的TTL值**

<a name="dc_cfg_pim-dm_ipv4_0020__1.4.1"/>设备在收到状态刷新报文后，会将状态刷新报文的TTL值减1，然后继续向下游扩散转发来刷新下游设备的剪枝定时器，直至状态刷新报文的TTL值为0。

当网络规模很小而TTL值很大时，会造成状态刷新报文在网络中循环传递。

因此，为了有效控制刷新报文的传递范围，需要根据网络规模大小配置合适的TTL值。

因为状态刷新报文是由与组播源直连的第一跳PIM设备触发发送，所以状态刷新报文的TTL值只在该设备上配置有效。

[Huawei-pim]state-refresh-ttl ?

  INTEGER&lt;1-255&gt;  Specify TTL value of PIM DM state refresh message

**13、PIM-DM断言（Assert）控制参数设置**

当设备从下游接口接收到组播数据时，说明该网段中还存在其他的上游设备。设备从该接口发出Assert报文，参与竞选唯一上游。

<a name="dc_cfg_pim-dm_ipv4_0022__1.4.1"/>当一个网段内有多个相连的PIM设备RPF检查通过向该网段转发组播数据时，则需要通过断言竞选来保证只有一个PIM设备向该网段转发组播数据。

在竞选中落败的PIM设备会抑制相应下游接口向该网段转发组播数据，但是这种竞选失败的状态只会保持一段时间，这段时间称为Assert报文的保持时间。超时后，落选的设备会重新恢复转发组播数据从而触发新一轮的竞选。

Assert报文保持时间在全局PIM视图下和接口视图下都可配置，如果同时配置，接口视图上的配置生效。

[Huawei-pim]holdtime assert ?

  INTEGER&lt;7-65535&gt;  Specify assert holdtime

或

[Huawei-GigabitEthernet0/0/1]pim holdtime assert ?

  INTEGER&lt;7-65535&gt;  Specify assert holdtime

**14、PIM-DM Silent设置**

<a name="dc_cfg_pim-dm_ipv4_0023__1.4.1"/>在接入层上，设备直连用户主机的接口上如果需要使能PIM协议，在该接口上可以建立PIM邻居，处理各类PIM协议报文。

此配置同时存在着安全隐患：当恶意主机模拟发送PIM Hello报文时，有可能导致设备瘫痪。为了避免这样的情况发生，可以将该接口设置为PIM Silent状态（即PIM消极状态）。

当接口进入PIM消极状态后，禁止接收和转发任何PIM协议报文，删除该接口上的所有PIM邻居以及PIM状态机，该接口作为静态DR立即生效。同时，该接口上的IGMP功能不受影响。

该功能仅适用于与用户主机网段直连的PIM设备接口，且该用户网段只与这一台PIM设备相连。

配置了该功能后，接口将不再接收和转发任何PIM协议报文，即该接口配置的其他PIM功能将失效，请谨慎使用。

[Huawei-GigabitEthernet0/0/1]pim silent
