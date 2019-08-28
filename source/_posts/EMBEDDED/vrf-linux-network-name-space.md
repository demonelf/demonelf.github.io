---
title: VRF & Linux Network Name Space
id: 888
comment: false
categories:
  - arm
date: 2016-08-10 16:24:15
tags:
---

<span style="color:#222222; font-family:Arial; font-size:13pt">**Introduction
**</span>
<!-- more -->

<span style="color:#222222; font-family:Arial; font-size:10pt"><span style="background-color:white">As we know, VRF (Virtual Routing and Forwarding on Switch) and [<span style="color:#888888; text-decoration:underline">Linux Network Name Space</span>](http://rmadapur.blogspot.in/2014/02/linux-network-namespaces.html) (on Linux hosts) can be used to achieve Network Isolation. Lets see how we can use them together.</span>

</span><span style="font-family:宋体; font-size:12pt">
		</span>

<span style="color:#222222; font-family:Arial; font-size:13pt">**Setup 
**</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/081016_0824_VRFLinuxNet1.png)

<span style="color:#222222"><span style="font-family:Arial; font-size:10pt"><span style="background-color:white">Host there are two namespaces, namely <span style="color:red">**red**<span style="color:#222222"> and <span style="color:blue">**blue.**</span></span></span></span><span style="color:#222222">
<span style="background-color:white">Each of the namespace is connected to its own Linux Bridge (i.e Red Namespace is connected to Bridge_red  and Blue Namespace is connected to Bridge_Blue ). Virtual Interface (veth0) connected to each bridge is assigned the same ip address (10.70.70.12/24). This L3 Network isolation achieved on the same host by using Network Namespaces.</span>

<span style="background-color:white">Bridge_red is connected to external interface eth5 via eth5.80(eth5.80 sends tagged packet with vlan value as 80).</span>
<span style="background-color:white">Bridge_blue is connected to external interface eth5 via eth5.90(eth5.80 sends tagged packet with vlan value as 90).</span>

<span style="background-color:white">Linux host is connected to external device (that has VRF capability). 10.70.70.14/24 is the ip address configured on both the blue and red vrf's.</span>

</span></span><span style="font-family:宋体; font-size:12pt">
			</span></span>

<span style="color:#222222; font-family:Arial; font-size:13pt">**Commands to Create Red Name Space
**</span>

//Create a red namespace

ip netns add red

//Create eth5.80 (80 vlan tagged interface on eth5)

ip link add link eth5 eth5.80 type vlan id 80

//Create a veth pair 

ip link add veth0 type veth peer name veth_red

//Set on end of the veth pair to red namespace

ip link set veth0 netns red

//Bring up the veth pairs

ip netns exec red ip link set dev veth0  up

ip link set dev veth_red up

//create a red bridge and add interfaces

brctl addbr bridge_red

brctl addif bridge_red eth5.80

brctl addif bridge_red veth_red

//bring up bridge interfaces

ip link set dev bridge_red up

ip link set dev eth5.80 up

//Configuer ip address within the namespace

ip netns exec red ifconfig veth0 10.70.70.12 netmask 255.255.255.0 up

ip netns exec red ip route add default via 10.70.70.12

<span style="color:#222222; font-family:Arial; font-size:13pt">**Commands to Create Blue Name Space 
**</span>

ip link add link eth5 eth5.90 type vlan id 90

//Create a blue Namespace.

ip netns add blue

//Create veth pair

ip link add veth0 type veth peer name veth_blue

//assign one end of the veth pair to blue namespace

ip link set veth0 netns blue

//Bring veth pairs

ip netns exec blue ip link set dev veth0  up

ip link set dev veth_blue up

//Create Linux bridge and add interfaces to it.

brctl addbr bridge_blue

brctl addif bridge_blue eth5.90

brctl addif bridge_blue veth_blue

//Bring up the bridge interfaces

ip link set dev bridge_blue up

ip link set dev eth5.90 up

//Assign ip address to veth pair in the blue Namespace

ip netns exec blue ifconfig veth0 10.70.70.12 netmask 255.255.255.0 up

ip netns exec blue ip route add default via 10.70.70.12

<span style="color:#222222; font-family:Arial; font-size:13pt">**Commands to Create VRF on external device.
**</span>

//interface connected to eth5

interface GigabitEthernet 3/0/41

 switchport

 switchport mode trunk

 switchport trunk allowed vlan add 80,90

 switchport trunk tag native-vlan

 spanning-tree shutdown

 no shutdown

!

//Configuration for VRF red

rbridge-id 153

 vrf red

  rd 1:1

  address-family ipv4 max-route 3600

  !

 !

interface Ve 80

  vrf forwarding red

  ip proxy-arp

  ip address 10.70.70.14/24

  no shutdown

 !

!

rbridge-id 153

 vrf blue

  rd 1:2

  address-family ipv4 max-route 3600

  !

 !

!

interface Ve 90

  vrf forwarding blue

  ip proxy-arp

  ip address 10.70.70.14/24

  no shutdown

 !

### <span style="color:#222222; font-family:Arial; font-size:13pt">Communication from Linux host to external device (ie Network Namespace to VRF)
</span>

<span style="color:#222222; font-family:Arial; font-size:10pt">Here ping is initiated from the veth0(10.70.70.12) in the blue namespace to 10.70.70.14 (in the blue VRF)
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/081016_0824_VRFLinuxNet2.png)

<span style="color:#222222; font-family:Arial; font-size:10pt; background-color:white">ping is initiated from the veth0(10.70.70.12) in the red namespace to 10.70.70.14 (in the redVRF)
</span>

![](http://www.madhex.com/wp-content/uploads/2016/08/081016_0824_VRFLinuxNet3.png)

<span style="color:#222222; font-family:Arial; font-size:10pt"><span style="background-color:white">an be used on LinuxBridge interfaces to verify that traffic is indeed flowing to the correct VRF on the external device.</span>

<span style="background-color:white">Network Isolation (L3,ip address isolation)  can be achieved by using Linux Network Namespaces and VRFs.Also, we have seen here how they can be interconnected.</span>

<span style="background-color:white">Network Isolation is an important concept in multi-tenant cloud environment.</span></span>
