#!/usr/bin/env bash
if [[ "$RAILS_ENV" -eq "production" ]]; then
    #export RACK_ENV=production
    export RAILS_SERVE_STATIC_FILES=1
    export DATABASE_URL=$DATABASE_URL_PROD
fi
if [[ -z "${DECIDIM_APP_NAME}" ]]; then
    echo "Please set DECIDIM_APP_NAME value in compose.env file"
else
    if [ ! -d "/code/${DECIDIM_APP_NAME}" ]; then
        source /code/bin/init-app.sh
    fi    
    echo "${DECIDIM_APP_NAME} is initialized, starting rails"
    cd /code/${DECIDIM_APP_NAME}
    # tail -f /dev/null
    # bin/rails server -b 0.0.0.0
    echo "$@"
    exec "$@"
    # bin/rails server -b 'ssl://localhost:3000?key=localhost.key&cert=localhost.crt'
fi

