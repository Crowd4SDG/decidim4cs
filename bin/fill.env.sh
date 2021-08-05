#!/usr/bin/env bash
USER_ID=`id -u`
GROUP_ID=`id -g`
echo "USER_ID=$USER_ID" > .env
echo "GROUP_ID=$GROUP_ID" >> .env
echo "CURRENT_UID=$USER_ID:$GROUP_ID" >> .env
echo "DECIDIM_PORT=3000" >> .env
if [[ ! -f secrets.env ]]; then
    cp secrets.env.in secrets.env
fi
