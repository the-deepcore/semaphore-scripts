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

echo "======> if ! cache has_key packs-test-\$APP_BASE-revision-\$(checksum yarn.lock)-\$JS_MD5; then cache store packs-test-\$APP_BASE-revision-\$(checksum yarn.lock)-\$JS_MD5 public/packs-test; fi"
if ! cache has_key packs-test-$APP_BASE-revision-$(checksum yarn.lock)-$JS_MD5; then cache store packs-test-$APP_BASE-revision-$(checksum yarn.lock)-$JS_MD5 public/packs-test; fi

echo "======> if ! cache has_key assets-\$APP_BASE-revision-\$(checksum yarn.lock)-\$JS_MD5; then cache store assets-\$APP_BASE-revision-\$(checksum yarn.lock)-\$JS_MD5 public/assets; fi"
if ! cache has_key assets-$APP_BASE-revision-$(checksum yarn.lock)-$JS_MD5; then cache store assets-$APP_BASE-revision-$(checksum yarn.lock)-$JS_MD5 public/assets; fi

echo "======> if ! cache has_key cache-webpacker-\$APP_BASE-revision-\$(checksum yarn.lock)-\$JS_MD5; then cache store cache-webpacker-\$APP_BASE-revision-\$(checksum yarn.lock)-\$JS_MD5 tmp/cache/webpacker; fi"
if ! cache has_key cache-webpacker-$APP_BASE-revision-$(checksum yarn.lock)-$JS_MD5; then cache store cache-webpacker-$APP_BASE-revision-$(checksum yarn.lock)-$JS_MD5 tmp/cache/webpacker; fi

echo "======> setting cache for gems on dev and master branch"
if [ "$SEMAPHORE_GIT_BRANCH" == "dev" ]; then cache delete gems-$APP_BASE-dev ; fi
if [ "$SEMAPHORE_GIT_BRANCH" == "dev" ]; then cache store gems-$APP_BASE-dev vendor/bundle ; fi
if [ "$SEMAPHORE_GIT_BRANCH" == "master" ]; then cache delete gems-$APP_BASE-master ; fi
if [ "$SEMAPHORE_GIT_BRANCH" == "master" ]; then cache store gems-$APP_BASE-master vendor/bundle ; fi

echo "======> setting cache for node_modules on dev and master branch"
if [ "$SEMAPHORE_GIT_BRANCH" == "dev" ]; then cache delete node-modules-$APP_BASE-dev ; fi
if [ "$SEMAPHORE_GIT_BRANCH" == "dev" ]; then cache store node-modules-$APP_BASE-dev node_modules ; fi
if [ "$SEMAPHORE_GIT_BRANCH" == "master" ]; then cache delete node-modules-$APP_BASE-master ; fi
if [ "$SEMAPHORE_GIT_BRANCH" == "master" ]; then cache store node-modules-$APP_BASE-master node_modules ; fi