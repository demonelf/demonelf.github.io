---
title: 使用SSH反向隧道进行内网穿透
categories:
  - SYSTEM
date: 2017-11-14 09:35:32
tags:
---

**1，前提条件**

| 环境             | 系统类型                         | 本地用户    | SSH服务端口 |
| -------------- | ---------------------------- | ------- | ------- |
| A机位于公司的NAT网络   | 安装在VMware里的Debian 8 64bit虚拟机 | userA   | 22      |
| B机是一台有公网IP的VPS | CentOS 6 64bit               | userVPS | 1022    |
| C机位于家庭的NAT网络   | Windows系统                    | –       | –       |

实现目的：使得位于家庭NAT网络内的C机，可以SSH访问位于公司NAT网络内的A机。

**2，原理分析**
这里先讲向SS反向隧道的原理，如果你对原理不感兴趣，可以跳过这一节。

```
ssh -p 22 -qngfNTR 6766:127.0.0.1:22 usera@VPS的IP  #回车以后没有反应是正常的,隧道已经建立
```

命令解析：
从(位于本地NAT网络里的)**本机**访问**VPS**，建立一条SSH隧道（本机的随机端口到VPS的22端口）
同时建立了一条反向隧道，将**VPS**上的6766端口转发到**本机**的22端口。

然后，就可以从VPS的6766端口访问本地的22端口了

```
ssh -p 6766 userA@127.0.0.1  #从SSH访问位于NAT网络里的linux机器
```

从SSH访问位于本地NAT网络里的linux机器，这里的userA当然是本地NAT网络里的linux机器用户啦。

这样做有一个问题，那就是，由本地建立的SSH连接是会超时关闭的，如果连接关闭，隧道无法维持，那么VPS就无法利用反向隧道访问本地NAT网络了，为此我们需要一种方案来提供一条稳定的SSH反向隧道，于是autossh就派上用场了；

另外有个问题是，如果本地的Linux系统重启，那么autossh建立的隧道仍然会失效。所以这里我们采取的做法是：
1，将本地Linux系统的public key发给VPS，建立信任机制，这样，本地Linux系统可以无需VPS的密码而建立一条SSH隧道；
2，将autossh写入系统服务，使之在开机时可以自动建立SSH隧道。

知道了原理以后，接下来开始实际的操作步骤。

**3，VPS(B机)的操作**

```
vim /etc/ssh/sshd_config  #打开如下选项
GatewayPorts yes
 
/etc/init.d/sshd reload
```

**4，A机的操作**
前面说了，A机位于公司内部NAT网络内，是一台安装在VMware Workstation Player里的Debian 8 64bit虚拟机。

```
sudo apt-get install autossh openssh-server
```

**配置A机可以免密码登陆到VPS(B机)**
具体方法为将A机的公钥发给VPS(B机)，这样A机开机时就可以自动建立一条到VPS的SSH隧道

```
su - userA    #这步可省略,但需要确保以下命令是在A机上以userA用户的身份运行的
 
ssh-keygen -t rsa    #连续三次回车,即在本地生成了公钥和私钥,不要设置密码
ssh-copy-id -p VPS的SSH端口 -i ~/.ssh/id_rsa.pub userVPS@VPS的IP
 
sudo touch /var/log/ssh_nat.log && sudo chmod 777 /var/log/ssh_nat.log
 
sudo vim /lib/systemd/system/autossh.service  #将下例内容粘贴复制进去
```

```
[Unit]
Description=Auto SSH Tunnel
After=network-online.target
 
[Service]
User=userA     #改掉这里A机的用户
Type=simple
ExecStart=/usr/bin/autossh -M 6777 -NR 8388:127.0.0.1:22 -i ~/.ssh/id_rsa userVPS@VPS的IP -p VPS的SSH端口 >> /var/log/ssh_nat.log 2>&1 &
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=always
 
[Install]
WantedBy=multi-user.target
WantedBy=graphical.target
```

解释一下上面的autossh命令：
添加的一个-M 6777参数,负责通过6777端口监视连接状态,连接有问题时就会自动重连
去掉了一个-f参数,因为autossh本身就会在background运行



```
sudo chmod +x /lib/systemd/system/autossh.service    #给予可执行权限
sudo systemctl enable autossh    #设置开机自启
sudo systemctl start autossh     #现在就启动服务
sudo systemctl status autossh  #查看状态,出现Active: active (running)表示正常运行
```

也可以**登陆到VPS（B机）**上看看8388端口是否真的有程序在监听

```
$ netstat -antp | grep :8388
tcp        0      0 0.0.0.0:8388       0.0.0.0:*                   LISTEN      20041/sshd
tcp        0      0 :::8388            :::*                        LISTEN      20041/sshd
```

**5，尝试远程登陆**
接下来，我们就可以在家里的电脑(C机)上登陆到位于公司NAT网络里的那台Debian8虚拟机(A机)。

```
ssh userA@VPS的IP -p 8388
```

注意：这里的userA并不是VPS(B机)上的用户，而是Debian8虚拟机(A机)上的用户。

参考资料：
[使用SSH反向隧道进行内网穿透](http://arondight.me/2016/02/17/%E4%BD%BF%E7%94%A8SSH%E5%8F%8D%E5%90%91%E9%9A%A7%E9%81%93%E8%BF%9B%E8%A1%8C%E5%86%85%E7%BD%91%E7%A9%BF%E9%80%8F/)
[SSH反向连接及Autossh](http://www.cnblogs.com/eshizhan/archive/2012/07/16/2592902.html)
[Fun and Profit with Reverse SSH Tunnels and AutoSSH](https://hobo.house/2016/06/20/fun-and-profit-with-reverse-ssh-tunnels-and-autossh/)

2016/10/29 由 [bear](https://www.zhukun.net/archives/author/admin) 发表在 [Linux运维](https://www.zhukun.net/archives/category/linux-2) 分类 | 标签: | 将 [固定链接](https://www.zhukun.net/archives/8130) 加入收藏夹