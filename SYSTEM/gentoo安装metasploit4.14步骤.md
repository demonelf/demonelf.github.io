先来个小忍者看看

![metasploit](metasploit.JPG)

## 环境准备

1. make.conf中添加

   RUBY_TARGETS="ruby23"

2. /etc/portage/package.keywords 中添加

   =dev-lang/ruby-2.3.5

3. 更新系统

   emerge --ask --update --deep --newuse @world

4. 选择ruby

   eselect ruby set ruby23



## 正式安装

``` shell
sudo emerge -av metasploit
emerge --config postgresql
/etc/init.d/postgresql-<version> start 
//systemctl start postgresql-<version>
emerge --config =metasploit-4.14.16
ln -s /usr/lib/metasploit/lib /home/demonelf/.msf4/lib
```



