#!/usr/bin/env bash
cd /code/${DECIDIM_APP_NAME}
gem install bundler
bundle install
bundle exec figaro install
