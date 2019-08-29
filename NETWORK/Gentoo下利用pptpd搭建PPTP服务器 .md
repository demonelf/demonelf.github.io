首先检查当前系统的linux kernel有没有支持ppp, netfilter, mppe和 netfilter的nat,如果没有，请先配置支持这些组建，编译更新内核，然后重启系统。这块不再详述，如果想知道详细情况，可以留言问我。
接着安装必要软件
>emerge ppp
>
>emerge pptpd

然后修改配置文件
先是pptpd的配置文件 /etc/pptpd.conf
```
ppp /usr/sbin/pppd
option /etc/ppp/options.pptpd
logwtmp
localip 172.16.0.1
remoteip 172.16.0.2-254
```
接着是ppp的配置文件 /etc/ppp/options.pptpd 
```
ms-dns 8.8.8.8
ms-dns 8.8.4.4
```
最后是用户密码文件 /etc/ppp/chap-secret 
```
#name server secret ip
test@test.com pptpd test *
```
第一项是登录vpn时使用的用户名，第二项是vpn服务器名（pptpd，l2tpd，xl2tpd等，也可以用*号），第三项是密码，第四项是分配给客户端的ip，如果是＊号，vpn服务器则会从自己的配置文件中选择一个ip分配给客户端。 

开启系统的封包转发： 
> echo 1 > /proc/sys/net/ipv4/ip_forward

最后别忘了启动pptpd服务
> /etc/init.d/pptpd start 

gentoo下客户端示例

>pptp 192.168.2.12 user test@test.com password test
