# How to Backup/Restore your Docker Images

I'm building Demos with different versions and databases.

But as the Build takes a lot of time, I'm backing up the Docker images, to make my day to day easier.

Below I put the steps to backup and restore these environments.

## Backup

Stop the containers

```bash
cd /maximo-liberty-docker

docker compose down

```

Backup maximo-liberty-docker

```bash
mkdir /mybackup

cd /mybackup

tar -cvf /mybackup/maximo-liberty-docker-7612.tar /maximo-liberty-docker
```

Backup containers and gzip files

```bash
docker save -o maximo-liberty-mea-7612.tar             maximo-liberty/maximo-mea:7.6.1.2
docker save -o maximo-liberty-report-7612.tar      maximo-liberty/maximo-report:7.6.1.2
docker save -o maximo-liberty-api-7612.tar             maximo-liberty/maximo-api:7.6.1.2
docker save -o maximo-liberty-cron-7612.tar        maximo-liberty/maximo-cron:7.6.1.2
docker save -o maximo-liberty-ui-7612.tar              maximo-liberty/maximo-ui:7.6.1.2

gzip *
```

## Restore images


Backup containers and gzip files

```bash
gunzip *.gz

docker load --input maximo-liberty-mea-7612.tar
docker load --input maximo-liberty-report-7612.tar
docker load --input maximo-liberty-api-7612.tar
docker load --input maximo-liberty-cron-7612.tar
docker load --input maximo-liberty-ui-7612.tar

```bash