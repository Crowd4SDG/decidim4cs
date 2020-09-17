#!/usr/bin/env bash
docker-compose down
docker volume prune -f
if [[ -d "${DECIDIM_APP_NAME}" ]]; then
    echo "Removing app ${DECIDIM_APP_NAME}" 
    rm -rf ${DECIDIM_APP_NAME}
fi
