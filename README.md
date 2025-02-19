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
scp decidim4cs:decidim4cs/secrets.env secrets.env  # Edit secrets.env and set RAILS_ENV to development if needed
scp decidim4cs:decidim4cs/backups/backup-<xxxxx>.tar.gz restore.tar.gz
bin/restore.sh <branch>
```
## Creating a backup 

```bash
docker-compose down
docker-compose up -d backup
docker-compose exec backup ./backup.sh
docker-compose down
```

## Restoring a backup

First make sure your decidim4cs/Gemfile is in the same decidim4cs version of the backup you want to restore, which should be in restore.tar.gz!!!!

```bash
bin/restore.sh <branch>
```

In development, it could be the case that you are told that migrations are required, specially if you have been playing with updating back an forth to different versions of decidim. If that is the case, you can go to the `decidim4cs/db/migrate` directory and remove all migrations. 

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

If you want to migrate to a higher decidim version, make sure you read this general information on [updating decidim](https://docs.decidim.org/en/install/update/)

Then do:

``` bash
docker-compose down
git checkout update-xx
docker-compose up --no-start --build --force-recreate  
docker-compose run --rm decidim gem install bundler
docker-compose run --rm decidim bundle install # If this fails you can try 'docker-compose run --rm decidim bundle update'
docker-compose run --rm decidim bin/rails decidim:upgrade
docker-compose run --rm decidim bin/rails db:migrate
docker-compose run --rm decidim bin/rails assets:precompile
```
