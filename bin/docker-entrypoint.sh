#!/bin/sh

RAILS_ENV=test bundle exec rake db:setup
bundle check || bundle install
echo
echo
exec "$@"
