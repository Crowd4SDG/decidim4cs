# 
# Decidim 4 CS 

## Abstract

This document describes the steps to install and run decidim4cs.

<!--## Starting up 

First thing to do is to install docker, git and docker-compose on your production machine. Follow the instructions [here](https://docs.docker.com/compose/install/)

Select the directory on your production machine for your decidim deployment. Our example organization is [IIIA](http://iiia.csic.es) and we will use `~/decidim-iiia` as its directory. Make sure the directory does not exist.

```bash
	git clone --depth=1 --branch=master git@gitlab.iiia.csic.es:cerquide/decidim-compose.git ~/decidim-iiia
	rm -rf ~/decidim-iiia.git
	cd ~/decidim-iiia
```
 
**Pro tip**. We recommend that you use Git to keep the files of your decidim deployment. To do that, 

```bash
	git init .
	git commit -m "Initial commit. Compose files from git@gitlab.iiia.csic.es:cerquide/decidim-compose.git"
```
-->
There are three files that require modification. Let's visit them one by one. 

1. The `.env` file contains information regarding the user id and group id of the user running the instance in the production machine. They are automatically filled by running 
```bash
	bin/fill.env.sh
``` 
<!--2. The `app.env` file contains the name of the rails app. By default it is `my_decidim` and there is no need to modify it. However, you are welcome to change the name if you like.-->

2. The `secrets.env` file contains the information of your app that is secret and thus should not go into the git repository. Edit `secrets.env` and make sure you set your email related data here. Ideally you should ask your sysadmin to have an e-mail account created in your institution (such as `decidim@iiia.csic.es` in our case). Otherwise you can use Gmail. If you are using gmail, make sure you enable "less secure applications" on your account. To do that, go to [this link](
https://myaccount.google.com/lesssecureapps) (logged into your Gmail account), and activate the checkbox "Allow less secure apps". Official instructions from Google are [here](https://support.google.com/accounts/answer/6010255?hl=en). 
Once this is done add your gmail username and gmail password into the `SMTP_USERNAME` and `SMTP_PASSWORD` variable. If you are not using gmail you can also modify the remaining `SMTP` variables, to specify the server and the domain. 

By now, you are done with your configuration. Let's bring up the production machine for the first time. We recommend that you bring it up by doing

<!-- ```bash
	docker-compose up 
```
or alternatively 
-->
```bash
	docker-compose up -d
	docker-compose logs -f
```

Grab a cup of coffee and sip for a while. When you see something like this,

```decidim_1  | => Booting Puma
decidim_1  | => Rails 5.2.3 application starting in production 
decidim_1  | => Run `rails server -h` for more startup options
decidim_1  | Puma starting in single mode...
decidim_1  | * Version 4.3.3 (ruby 2.5.3-p105), codename: Mysterious Traveller
decidim_1  | * Min threads: 5, max threads: 5
decidim_1  | * Environment: production
decidim_1  | * Listening on tcp://0.0.0.0:3000
decidim_1  | Use Ctrl-C to stop
```

 you are done. Then, point your browser [here](http://localhost/system) and login with the values specified at `secrets.env` for the `DECIDIM_SYSTEM_USERNAME` and `DECIDIM_SYSTEM_PASSWORD`. 

If you log in successfully, it means you have started managing a decidim4cs deployment. Congratulations.

## The system console

A decidim deployment is an installation of decidim4cs in a server. A deployment can be used by different organizations at the same time.

The starting point for managing a decidim deployment is the system console. Read about the [system console](https://github.com/decidim/decidim/blob/master/decidim-system/README.md)

<!-- Click [here](http://localhost/system) to log into the system console of your local decidim deployment. You should use `system@example.org` as user and `decidim123456` as password. -->

### Exercise. Create a new project.
 
To create a new project we need to:
1. Have a host name that we can assign as the organization host name. An easy way to do that is to 
	1. Choose a host name (say `patata.decidim4cs.iiia.csic.es`)
	2. Ideally you should have your name mapped to this machine IP in the DNS (ask you sysadmin to do so). 
2. Each organization needs an administrator. You will be required to enter the name of the administrator and its email (You can set yourself as administrator and put there your professional or personal email address).
3. Make sure you enable at least a locale and that you select it as default. You can select `Allow participants to register and login` as default option.  
4. You can skip the remaining configuration and directly click on `Create organization and invite admin` 

After creating the organization, the admin will receive an email from where he will be able to go into the system and complete his/her data as user. The next thing he will have to do is to accept the terms of use. From there on, pointing the browser to [http://decidim.iiia.csic.es/admin](http://decidim.iiia.csic.es/admin) and loging in, he will be able to administer the project. 

## Administering the project

Detailed information on how to administer an organization in decidim appears in this [administration manual](
https://decidim.org/pdf/Decidim_AdminManual_EN_0.10.pdf) 

## Stop the deployment

You can stop the instance by doing
```bash
	docker-compose down
``` 

## Managing different versions of the database

**TO DO** Most of the configuration of decidim is inside the database. In our case, every piece of data of the database is inside a docker volume. Here we should document the procedures for backing up those volumes and restoring them in case something happens. Some other administrative task should be included... But by now we keep it like this

<!--## Removing the organization to start from scratch

Make sure you know what you do. This will destroy all the information. If you do not know what this is doing internally, ask someone before trying it.

```bash
	source app.env
	source bin/remove-project.sh
```

-->

## Updating the rails app 

In can happen that you get a message similar to

```Could not find rake-13.0.0 in any of the sources```

when starting the decidim container. 
It also can happen that you want to migrate to a higher decidim version. 
Make sure you read this general information on [updating decidim](https://docs.decidim.org/en/install/update/)

Then do:

``` bash
docker-compose stop decidim
docker-compose run decidim gem install bundler
docker-compose run decidim bundle install
docker-compose run decidim bundle update decidim
docker-compose run decidim bin/rails decidim:upgrade
docker-compose run decidim bin/rails db:migrate
docker-compose run decidim bin/rails assets:precompile
``` 

<!--Then, clone the decidim-compose repo:

https://gitlab.iiia.csic.es/cerquide/decidim-compose/-/archive/master/decidim-compose-master.zip
```
git clone https://github.com/decidim/decidim.git
cd decidim
d/bundle install
d/rake development_app
d/rails server -b 0.0.0.0
```

This will install the software and make it ready to see at [localhost](http://localhost:3000). When you click there, you should see something similar to what you see in the [decidim online demo](https://try.decidim.org/). You can login into [localhost](http://localhost:3000) using `admin@example.org` as user and `decidim123456` as password. 
-->

