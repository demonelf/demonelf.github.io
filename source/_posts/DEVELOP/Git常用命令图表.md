---
title: Git 常用命令图表
categories:
  - DEVELOP
date: 2017-09-21 09:12:18
tags:

---

有这几个git命令就够用了



![](Git常用命令图表.png)





示例: 保存本地/home/example_a目录到本地/home/example_b目录

``` shell
cd /home/example_b
git init --bare
cd /home/example_a
git init
git remote add test_remote /home/example_b
git add -A
git commit -m "1.git初始化"
git push -u test_remote master
```

