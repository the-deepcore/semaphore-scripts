#!/bin/bash

# Always set -e part or your bash scripts may silently fail
# and cause some hard to find bugs.
echo "======> set -e"
set -e

# https://stackoverflow.com/a/63442072
# echo "======>sudo apt-get --assume-yes install ubuntu-dev-tools"
# sudo apt-get --assume-yes install ubuntu-dev-tools

# In order to better understand the output of the script
# be sure to print each command
# echo "======> "

### SSH SETUP ###
# Correct permissions since they are too open by default
[[ -v BOTYGLOT_USE_CUSTOM_SSH_KEYS ]] && echo "======> chmod 0600 ~/.ssh/botyglot-*"
[[ -v BOTYGLOT_USE_CUSTOM_SSH_KEYS ]] && chmod 0600 ~/.ssh/*
# Add the key to the ssh agent:
[[ -v BOTYGLOT_USE_CUSTOM_SSH_KEYS ]] && echo "======> ssh-add ~/.ssh/botyglot-*"
[[ -v BOTYGLOT_USE_CUSTOM_SSH_KEYS ]] && ssh-add ~/.ssh/botyglot-*

### INITIAL DEPENDECIES SETUP ###
echo "======> sem-version ruby $NODE_VERSION -f"
sem-version node $NODE_VERSION -f
echo "======> sem-version ruby $RUBY_VERSION -f"
sem-version ruby $RUBY_VERSION -f
# sem-version python 2.7
# echo "======> sem-version c 8"
# sem-version c 8
# echo "======> nvm use 12.22.5"
# nvm use 12.22.5
echo "======> gem install bundler -v '2.1.4' --no-document"
gem install bundler -v '2.1.4' --no-document
echo "======> bundle config set path 'vendor/bundle'"
bundle config set path 'vendor/bundle'
echo "======> rbenv rehash"
rbenv rehash

### VERSIONS ####
echo "======> git --version"
git --version
echo "======> gcc --version"
gcc --version
echo "======> ruby -v"
ruby -v
echo "======> yarn --version"
yarn --version
echo "======> node --version"
node --version

### CI SETUP
echo "======> checkout --use-cache"
checkout --use-cache
echo "======> sem-service start postgres 11"
sem-service start postgres 11
echo "======> sem-service start redis 6"
sem-service start redis 6

### ENV VARIABLES
echo "======> set LAST_GIT_COMMIT_MESSAGE env variables"
export LAST_GIT_COMMIT_MESSAGE="$(git log -1 --pretty=%B)"
echo  "LAST_GIT_COMMIT_MESSAGE: \"$LAST_GIT_COMMIT_MESSAGE\""

echo "======> set VISUAL_TESTING_ADAPTER env variables"
VISUAL_TESTING_REGEXP="visual([ \-]{1})test"
if [[ $LAST_GIT_COMMIT_MESSAGE =~ $VISUAL_TESTING_REGEXP ]]; then export VISUAL_TESTING_ADAPTER="percy"; fi
echo  "VISUAL_TESTING_ADAPTER: \"$VISUAL_TESTING_ADAPTER\""
