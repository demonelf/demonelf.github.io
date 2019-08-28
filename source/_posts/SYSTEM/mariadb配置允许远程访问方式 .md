---
title: mariadb配置允许远程访问方式 
categories:
  - SYSTEM
date: 2017-11-03 18:18:53
tags:
---





首先配置允许访问的用户，采用授权的方式给用户权限

```shell
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'IDENTIFIED BY '123456' WITH GRANT OPTION;
```

说明：root是登陆数据库的用户，123456是登陆数据库的密码，*就是意味着任何来源任何主机反正就是权限很大的样子。



最后配置好权限之后不应该忘记刷新使之生效

> flush privileges;

 

再次访问就可以了吧。



sudo vim /etc/mysql/my.cnf

> bind-address                            = 0.0.0.0



sudo systemctl restart mariadb.service

