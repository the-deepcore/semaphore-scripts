#!/usr/bin/env bash
set -e

sem-version node $NODE_VERSION -f
sem-version ruby $RUBY_VERSION -f

gem install bundler -v '2.3.7' --no-document
bundle config set path 'vendor/bundle'
rbenv rehash

checkout --use-cache
sem-service start postgres 15
sem-service start redis 7
