#!/usr/bin/env bash
echo "Rails env is ${RAILS_ENV}"
cat Gemfile.start ${DECIDIM_APP_NAME}/Gemfile > Gemfile
mv Gemfile ${DECIDIM_APP_NAME}/Gemfile
if [[ $RAILS_ENV == "production" ]]; then 
    cat ${DECIDIM_APP_NAME}/Gemfile Gemfile.end > Gemfile
    mv Gemfile ${DECIDIM_APP_NAME}/Gemfile    
fi    
cd /code/${DECIDIM_APP_NAME}
bundle install
bundle exec figaro install
if [[ $RAILS_ENV == "production" ]]; then 
    RAKE_SECRET=`bundle exec rake secret`
    echo "production:" >> config/application.xml
    echo "  DATABASE_URL: ${DATABASE_URL_PROD}" >> config/application.yml
    echo "  SECRET_KEY_BASE: ${RAKE_SECRET}" >> config/application.yml
    echo "  SMTP_USERNAME: ${SMTP_USERNAME}" >> config/application.yml
    echo "  SMTP_PASSWORD: ${SMTP_PASSWORD}" >> config/application.yml
    echo "  SMTP_ADDRESS: ${SMTP_ADDRESS}" >> config/application.yml
    echo "  SMTP_DOMAIN: ${SMTP_DOMAIN}" >> config/application.yml
fi
echo "Initializing database"
bin/rails db:create
if [[ $RAILS_ENV == "production" ]]; then
    bin/rails assets:precompile
    #echo "No precomp"
fi
bin/rails db:migrate
if [[ $RAILS_ENV == "production" ]]; then
    echo "Creating system user"
    bin/rails console < /code/make-system.rb
else
    bin/rails db:seed
fi
