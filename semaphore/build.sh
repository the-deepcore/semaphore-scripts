#!/usr/bin/env bash
set -e

[[ -v APP_BASE ]] && cd $APP_BASE

pwd

bundle install

yarn install

DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:drop RAILS_ENV=development

DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:create RAILS_ENV=development

DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:migrate db:seed RAILS_ENV=development

bundle exec rails assets:precompile