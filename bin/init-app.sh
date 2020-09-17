#!/usr/bin/env bash
echo "I am Creating app ${DECIDIM_APP_NAME}"
decidim ${DECIDIM_APP_NAME}
echo "App ${DECIDIM_APP_NAME} created"
source /code/bin/setup.sh
