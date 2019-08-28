---
title: x11vnc利用xvfd实现远程vncserver
date: 2017-08-09
categories: SYSTEM
---
当然你可以直接安装vncserver实现以下功能。
例如：TigerVNC

环境：gentoo

安装：xvfd
>sudo USE="xvfb" emerge -av xorg-server

启动：xvfd

>Xvfb :2 -screen 0 800x600x24 -nolisten tcp &
>export DISPLAY=:2

安装：x11vnc
>sudo emerge -av x11vnc

启动：x11vnc
>x11vnc -listen 0.0.0.0 -rfbport 5900 -noipv6 -passwd password -display :2 -forever

启动桌面：
>gnome-session --debug --disable-acceleration-check

然后启动你喜欢的vnc客户端连接吧
>官方客户端为：ssvn 用此客户端可以实现自动缩放


