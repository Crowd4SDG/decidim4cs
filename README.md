# 
# Decidim 4 CS 

## Abstract

This document describes the steps to install and run decidim4cs.

## Preparing a machine 

Create a virtual machine with Ubuntu 64 bits RAM 2048MB A VDI dinamically allocated 20GB disk drive 

First thing to do is to install docker, git and docker-compose on your production machine. Follow the instructions [here](https://docs.docker.com/compose/install/)

ssh to your production machine and do 
```bash
git clone  git@github.com:Crowd4SDG/decidim4cs.git
cd decidim4cs
bin/fill.env.sh
docker-compose build
docker-compose run decidim /code/bin/rebundle.sh
scp decidim4cs:decidim4cs/secrets.env secrets.env
scp decidim4cs:decidim4cs/backups/backup-<xxxxx>.tar.gz restore.tar.gz
docker run --env-file .env -v `basename $PWD`_pg-prod:/dst/backup/pg-prod -v $PWD/decidim4cs/public:/dst/backup/public -v $PWD/decidim4cs/storage:/dst/backup/storage  -v $PWD/restore.tar.gz:/root/restore.tar.gz -v $PWD/bin/restore_backup.sh:/root/r.sh ubuntu /root/r.sh
docker-compose up -d; docker-compose logs -f 
```

## Restoring a backup

First make sure your decidim4cs/Gemfile is in the same decidim4cs version of the backup you want to restore!!!!

```bash
docker-compose down
docker-compose build
docker-compose run decidim /code/bin/rebundle.sh
scp decidim4cs:decidim4cs/backups/backup-<xxxxx>.tar.gz restore.tar.gz
docker run --env-file .env -v `basename $PWD`_pg-prod:/dst/backup/pg-prod -v $PWD/decidim4cs/public:/dst/backup/public -v $PWD/decidim4cs/storage:/dst/backup/storage  -v $PWD/restore.tar.gz:/root/restore.tar.gz -v $PWD/bin/restore_backup.sh:/root/r.sh ubuntu /root/r.sh
docker-compose up -d; docker-compose logs -f 
```

## Decidim4CS configuration files 

There are three files that keep the configuration. Let's visit them one by one. 

1. The `.env` file contains information regarding the user id and group id of the user running the instance in the production machine. This should not got into the git repository. They are automatically filled by running 
```bash
	bin/fill.env.sh
```
2. The `app.env` file contains the name of the rails app. And some other configuration stuff which is not secret. 

3. The `secrets.env` file contains the information of your app that is secret and thus should not go into the git repository. 


## Administering the project

Detailed information on how to administer an organization in decidim appears in this [administration manual](
https://decidim.org/pdf/Decidim_AdminManual_EN_0.10.pdf) 

## Stop the deployment

You can stop the instance by doing
```bash
	docker-compose down
```

## Updating the decidim version 

In can happen that you get a message similar to

```Could not find rake-13.0.0 in any of the sources```

when starting the decidim container. 
It also can happen that you want to migrate to a higher decidim version. 
Make sure you read this general information on [updating decidim](https://docs.decidim.org/en/install/update/)

Then do:

``` bash
git checkout update-xx
docker-compose stop decidim
docker-compose run decidim gem install bundler
docker-compose run decidim bundle install
docker-compose run decidim bundle update decidim
docker-compose run decidim bin/rails decidim:upgrade
docker-compose run decidim bin/rails db:migrate
docker-compose run decidim bin/rails assets:precompile
``` 

