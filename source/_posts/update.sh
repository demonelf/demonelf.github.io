#!/bin/bash
set -x
export PATH="/usr/local/bin:/usr/bin:/bin:/opt/bin:/c/Windows/System32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0/:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/toolchain/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin:/opt/FriendlyARM/toolschain/4.4.3/bin:/c/Users/jimmy/AppData/Roaming/npm:/c/Program Files/nodejs"
root=/e/hexo

rsync -aP --size-only --delete ../_posts/ $root/source/_posts/

cd $root/demonelf.github.io/
git pull

cd $root
rm $root/public/* -rf

hexo g
rsync -aP --size-only --delete $root/public/ $root/demonelf.github.io/  --cvs-exclude --exclude=$root/demonelf.github.io/.git
rsync -aP $root/_posts $root/demonelf.github.io/
rsync -aP $root/_config.yml $root/demonelf.github.io/

cd $root/demonelf.github.io/
git add -A
git commit -m "1.自动更新"
git push
