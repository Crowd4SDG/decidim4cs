#!/usr/bin/env bash
docker-compose down
git checkout $1
docker-compose up --no-start --build --force-recreate  
docker-compose run decidim /code/bin/rebundle.sh; docker-compose down
#scp decidim4cs:decidim4cs/backups/backup-<xxxxx>.tar.gz restore.tar.gz
docker run --rm --env-file .env -v `basename $PWD`_pg-prod:/dst/backup/pg-prod -v $PWD/decidim4cs/public:/dst/backup/public -v $PWD/decidim4cs/storage:/dst/backup/storage  -v $PWD/restore.tar.gz:/root/restore.tar.gz -v $PWD/bin/restore_backup.sh:/root/r.sh ubuntu /root/r.sh
#docker ps
#docker-compose up -d; docker-compose logs -f
#docker-compose down
