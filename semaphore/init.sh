#!/usr/bin/env bash
set -e

sem-version node 16.20.2
sem-version ruby 3.2.0

gem install bundler -v '2.3.7'

checkout --use-cache

sem-service start postgres 15
sem-service start redis 7
