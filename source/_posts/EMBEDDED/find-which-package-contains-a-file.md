---
title: Find which package contains a file
id: 950
comment: false
categories:
  - arm
date: 2016-09-28 16:16:00
tags:
---

dpkg --search /usr/bin/amidi # debian/ubuntu, local search

<!-- more -->
apt-file update;apt-file search amidi # debian/ubuntu, remote seach. You need install apt-file at first.

equery b -e amidi # gentoo, remote/local search. You need install gentoolkits at first

pacman -Qo admidi # archlinux, local search

pkgfile amidi # archlinux, You need install pkgfile
