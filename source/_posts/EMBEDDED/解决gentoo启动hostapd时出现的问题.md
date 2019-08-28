---
title: 解决gentoo启动hostapd时出现的问题
id: 656
comment: false
categories:
  - arm
date: 2016-06-10 22:39:56
tags:
---

问题一：

<!-- more -->
nl80211: Could not configure driver mode
nl80211 driver initialization failed.
hostapd_free_hapd_data: Interface wlan0 wasn’t started

解决方法

sudo nmcli nm wifi off //nmcli是NetworkManager的命令行版

**UPDATE:** But if for the first command you get the error message `Error: Object 'nm' is unknown`

then use this instead:

    sudo nmcli radio wifi off

sudo rfkill unblock wlan

sudo ifconfig wlan0 10.15.0.1/24 up
sleep 1
sudo service isc-dhcp-server restart
sudo service hostapd restart

&nbsp;

&nbsp;

问题二：

nl80211: Could not configure driver mode
nl80211: deinit ifname=wlp0s15f5u1u4 disabled_11b_rates=0
nl80211 driver initialization failed.
wlp0s15f5u1u4: interface state UNINITIALIZED-&gt;DISABLED
wlp0s15f5u1u4: AP-DISABLED
hostapd_free_hapd_data: Interface wlp0s15f5u1u4 wasn't started

解决方法

# rfkill list
4: phy4: Wireless LAN
Soft blocked: no
Hard blocked: no

&nbsp;

<span class="postbody">My problem is gone now. First, I pulled out the USB WiFi device that I was using with hostapd and inserted it again, not particularly I knew what I was doing but just to make sure I didn't miss anything obvious. That didn't solve the problem, but it now gave me a different error message.</span>

&nbsp;
<table border="0" width="90%" cellspacing="1" cellpadding="3" align="center">
<tbody>
<tr>
<td><span class="genmed">**Code:**</span></td>
</tr>
<tr>
<td class="code">VLAN: vlan_set_name_type: SET_VLAN_NAME_TYPE_CMD name_type=2 failed: Package not installed</td>
</tr>
</tbody>
</table>
&nbsp;

Quick research revealed that I needed CONFIG_VLAN_8021Q in the kernel, so I enabled the following. Not sure I really needed CONFIG_VLAN_8021Q_GVRP and CONFIG_VLAN_8021Q_MVRP, but well, I just enabled them while I was there.
<table border="0" width="90%" cellspacing="1" cellpadding="3" align="center">
<tbody>
<tr>
<td><span class="genmed">**Code:**</span></td>
</tr>
<tr>
<td class="code">Networking support
Networking options
802.1Q/802.1ad VLAN Support (CONFIG_VLAN_8021Q)
GVRP (GARP VLAN Registration Protocol) support (CONFIG_VLAN_8021Q_GVRP)
MVRP (Multiple VLAN Registration Protocol) support (CONFIG_VLAN_8021Q_MVRP)</td>
</tr>
</tbody>
</table>
&nbsp;

I rebooted the system, and the newer version of hostapd worked just as well as the old one.
