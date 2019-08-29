#!/bin/bash
set -x
export PATH="/usr/local/bin:/usr/bin:/bin:/opt/bin:/c/Windows/System32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0/:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/toolchain/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin:/opt/FriendlyARM/toolschain/4.4.3/bin:/c/Users/jimmy/AppData/Roaming/npm:/c/Program Files/nodejs"
root=/e/hexo

rsync -aP --size-only --delete ../_posts/ $root/source/_posts/

cd $root
rm $root/public/* -rf
hexo clean
hexo generate
rsync -aP --size-only $root/source/_posts/* $root/public/
#hexo server

rsync -aP --size-only --delete $root/public/ $root/demonelf.github.io/  --cvs-exclude --exclude=$root/demonelf.github.io/.git

mkdir $root/demonelf.github.io/config
rsync -aP $root/source/_posts/update.sh $root/demonelf.github.io/config/
rsync -aP $root/.gitignore $root/demonelf.github.io/config/
rsync -aP $root/package.json $root/demonelf.github.io/config/
rsync -aP $root/package-lock.json $root/demonelf.github.io/config/
rsync -aP $root/_config.yml $root/demonelf.github.io/config/
rsync -aP $root/themes/material-x $root/demonelf.github.io/config/

cd $root/demonelf.github.io/
tar -cvf config.tar config
rm config -rf

git pull
git add -A
git commit -m "1.自动更新"
git push
