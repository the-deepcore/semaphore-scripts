#!/bin/bash

# Always set -e part or your bash scripts may silently fail
# and cause some hard to find bugs.
echo "======> set -e"
set -e

# In order to better understand the output of the script
# be sure to print each command
# echo "======> "

###
# ALL SYMBOLIC LINKS SHOULD BE REPLACED WITH A COPY OF THE LINKED FOLDERS/FILES
###

# switch to monorepo sub-folder (if we are in a monorepo)
echo "======> [[ -v APP_BASE ]] && cd \$APP_BASE"
[[ -v APP_BASE ]] && cd $APP_BASE

echo "======> pwd"
pwd

# CALCULATE MD5 OF APP/JAVASCRIPT
echo "======> JS_MD5=(\$(find ./app/javascript -type f -exec bash -c 'echo \$(md5sum \"\$0\")' {} \; | LC_ALL=C sort | md5sum | awk '{ print $1 }' ))"
JS_MD5=($(find ./app/javascript -type f -exec bash -c 'echo $(md5sum "$0")' {} \; | LC_ALL=C sort | md5sum | awk '{ print $1 }' ))

echo "======> cache restore gems-\$APP_BASE-revision-\$(checksum Gemfile.lock),gems-\$APP_BASE-dev,gems-\$APP_BASE-master"
cache restore gems-$APP_BASE-revision-$(checksum Gemfile.lock),gems-$APP_BASE-dev,gems-$APP_BASE-master

echo "======> bundle install --deployment -j 4 --path vendor/bundle"
bundle install --deployment -j 4 --path vendor/bundle

echo "======> cache restore node-modules-\$APP_BASE-revision-\$( checksum yarn.lock),node-modules-\$APP_BASE-dev,node-modules-\$APP_BASE-master"
cache restore node-modules-$APP_BASE-revision-$( checksum yarn.lock),node-modules-$APP_BASE-dev,node-modules-$APP_BASE-master

echo "======> yarn install"
yarn install

#### re-compile assets (apartment gem requires valid db connection)

echo "======> cache restore assets-\$APP_BASE-revision-\$(checksum yarn.lock)-\$JS_MD5"
cache restore assets-$APP_BASE-revision-$(checksum yarn.lock)-$JS_MD5

echo "======> cache restore packs-test-\$APP_BASE-revision-\$(checksum yarn.lock)-\$JS_MD5"
cache restore packs-test-$APP_BASE-revision-$(checksum yarn.lock)-$JS_MD5

echo "======> bin/rails db:create"
bin/rails db:create

echo "======> bin/rails db:migrate"
bin/rails db:migrate