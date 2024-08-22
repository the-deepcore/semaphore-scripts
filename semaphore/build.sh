#!/usr/bin/env bash
set -e

[[ -v APP_BASE ]] && cd $APP_BASE

pwd

bundle install

yarn install

# Prepare database
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:drop RAILS_ENV=test
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:create RAILS_ENV=test
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:schema:load RAILS_ENV=test
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:migrate db:seed RAILS_ENV=test

# Build assets
bundle exec rails tmp:clear RAILS_ENV=test
bundle exec rails assets:precompile RAILS_ENV=test
