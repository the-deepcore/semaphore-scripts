#!/usr/bin/env bash
set -e

sem-version node 14.21.3
sem-version ruby 3.2.0

gem install bundler -v '2.3.7' --no-document

gem update --system 3.5.17

checkout --use-cache

sem-service start postgres 16
sem-service start redis 7
