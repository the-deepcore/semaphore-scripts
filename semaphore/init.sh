#!/usr/bin/env bash
set -e

sem-version node $NODE_VERSION
sem-version ruby $RUBY_VERSION

gem install bundler -v $BUNDLER_VERSION --no-document

gem update --system $RUBYGEMS_VERSION

checkout --use-cache

sem-service start postgres 16
sem-service start redis 7
