echo "Initializing database"
bin/rails db:create
if [[ $RAILS_ENV == "production" ]]; then
    bin/rails assets:precompile
    #echo "No precomp"
fi
bundle
bundle exec rails decidim_initiatives:install:migrations
bundle exec rails db:migrate
bin/rails db:migrate
if [[ $RAILS_ENV == "production" ]]; then
    echo "Creating system user"
    bin/rails console < /code/make-system.rb
else
    bin/rails db:seed
fi
