# Docker images for IBM Maximo Asset Management V7.6.1 with Liberty.

**This repository makes some updates over the Yasutaka Nishimura (nish2go) repository. All credits goes to nishi2go!!!**

**What is new?**
* IBM Installation Manager 1.9, IBM DB2 11.1.4.7.
* IBM WebSphere Liberty 22.0.0.9

Maximo with Liberty on Docker enables to run Maximo Asset Management with WebSphere Liberty on Docker. The images are deployed fine-grained services instead of a single instance. The following instructions describe how to set up IBM Maximo Asset Management V7.6 Docker images. These images consist of several components e.g. WebSphere Liberty, Db2, and Maximo installation program.

Before you start, learn more about Maximo WebSphere Liberty support from the official documentation. [Maximo Asset Management 7.6.1 WebSphere Liberty Support](https://www.ibm.com/support/pages/node/572105)

![Components of Docker Images](docs/maximo-liberty-docker.svg) 

## Required packages.


| Filename                                 | Part Number | Package          |           Description                                        |
|------------------------------------------|-------------|------------------|--------------------------------------------------------------|
| agent.installer.linux.gtk.x86_64_1.9.2002.20220323_1321.zip | -     | IBM Installation Manager V1.8.5 for Linux x86_64      | [Fix Central](http://www-945.ibm.com/support/fixcentral/)  |
| MAM_7.6.1.0_LINUX64.tar.gz               | CNVK0ML     | IBM Maximo Asset Management V7.6.1 Linux 64 Multilingual      | [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html)  |
| MAMMTFP7612IMRepo.zip                    | -           | IBM Maximo Asset Management V7.6.1 Feature pack 2 | [Fix Central](http://www-945.ibm.com/support/fixcentral/)  |
| DB2_AWSE_REST_Svr_11.1_Lnx_86-64.tar.gz  | CNB8FML     | IBM DB2 Advanced Workgroup Server Edition Server Restricted Use V11.1 for Linux on AMD64 and Intel | [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html)  |
| v11.1.4fp7_linuxx64_server_t.tar.gz      | -           | IBM Db2 Server V11.1 Fix Pack 5 | [Fix Central](http://www-945.ibm.com/support/fixcentral/)  |
| wlp-nd-license.jar                       | CND1QML     | IBM WebSphere Application Server Liberty Network Deployment License Upgrade| [Passport Advantage](http://www-01.ibm.com/software/passportadvantage/pao_customer.html) |


## Building IBM Maximo Asset Management V7.6.1 with Liberty image by using a build tool.

You can use a tool for building docker images by using the build tool.

Usage:

```
Usage: build.sh [OPTIONS]

Build Maximo Docker containers.

-r  | --remove                    Remove images when an image exists in repository.
-R  | --remove-only               Remove images without building when an image exists in repository.
-rt | --remove-latest-tag         Do not add the "latest" tag to the built images.
-c  | --use-custom-image          Build a custom image for Maximo installation container.
-v  | --verbose                   Show detailed output of the docker build.
-p  | --prune                     Remove intermediate multi-stage builds automatically.
-s  | --skip-db                   Skip building and removing a DB image.
-i  | --preserve-image-container  Do not remove and recreate an installation image container.
--deploy-db-on-runtime            Deploy the Maximo database on runtime.
--push-registry=REGISTRY_URL      Push the built images to a specified remote Docker registry.
--namespace=NAMESPACE             Specify the namespace of the Docker images (default: maximo-liberty).
-h  | --help                      Show this help text.
```

Procedures:

1. Clone this repository
   ```bash
   git clone https://github.com/ebasso/maximo-liberty-docker.git
   ```
2. Place the downloaded Maximo, IBM Db2, IBM Installation Manager and IBM WebSphere Liberty License binaries into the maximo-liberty-docker/images directory.
   ```bash
   > cd maximo-liberty-docker
   > ls -l images
   check.sh
   Dockerfile
   MAM_7.6.1.0_LINUX64.tar.gz
   packages.list
   wlp-nd-license.jar
   DB2_AWSE_REST_Svr_11.1_Lnx_86-64.tar.gz
   agent.installer.linux.gtk.x86_64_1.9.2002.20220323_1321.zip
   MAMMTFP7612IMRepo.zip
   v11.1.4fp7_linuxx64_server_t.tar.gz
   ```
3. Run the build tool

   ```bash
   bash build.sh [-r] [-v] [-c] [-rt] [-p] [-i]
   ```

   Example:

   ```bash
   bash build.sh -r -v -rt -p
   ```

   Note: This script works on Windows Subsystem on Linux.

4. Edit `docker-compose.yml` to enable optional services e.g. maximo-api, maximo-report and etc.

5. Run containers by using the Docker Compose file to create and deploy instances:
   ```bash
   docker compose up -d
   ```
   To scale servers with the `docker-compose --scale` option:
   ```bash
   docker compose up -d --scale maximo-ui=2
   ```
6. Make sure to be accessible to Maximo login page: http://hostname/maximo

7. Stop containers by using the Docker Compose file:
   ```bash
   docker compose down
   ```

## Articles

* [How to Backup/Restore your Docker Images](docs/backup-your-docker-images.md) 

* [How to deploy Maximo on Kubernetes](kubernetes/README.md)

* [How to use a custom build image](docs/how-to-use-custom-build-images.md)


## Customize your environment.

In order to install a second language, deploy demo data or change default passwords, edit the `build.args` and `.env` file before building the container images. The following parameters are available by default.

`build.args`

```properties
# Deploy DB schema on build.
deploy_db_on_build=yes
# Enable and build the JMS services.
enable_jms=yes
# Update Installation Manager to the latest level.
update_im=no
```

`.env`

```properties
# Default passwords
ENV_DB_MAXIMO_PASSWORD=changeit
ENV_MXINTADM_PASSWORD=changeit
ENV_MAXADMIN_PASSWORD=changeit
ENV_MAXREG_PASSWORD=changeit
# Liberty admin user
ENV_ADMIN_USER_NAME=admin
ENV_ADMIN_PASSWORD=changeit
# Language installation
ENV_BASE_LANG=en
ENV_ADD_LANGS=de,fr,ja
# Default e-mail configurations
ENV_ADMIN_EMAIL_ADDRESS=root@localhost
ENV_SMTP_SERVER_HOST_NAME=localhost
# Skin
ENV_SKIN=iot18
# Install the demo data
ENV_ENABLE_DEMO_DATA=no
```

## Enable LDAP/AD support

Maximo has supported LDAP and MS AD to authenticate users a.k.a. Application Server Secuirty on Liberty servers. IBM published the detailed instruction [here](https://www.ibm.com/support/pages/deploying-maximo-liberty-ldap). Maximo on Docker has an automated setup feature to enable it.

Edit the following lines in `.env`. If you want to enable MS Active Directory or any other directory services, edit the `maximo/ldapUserRegistry.xml`. Then build container images.

```properties
ENV_USE_APP_SERVER_SECURITY=no
ENV_USER_MANAGEMENT=mixed
ENV_LDAP_HOST_NAME=ldap
ENV_LDAP_PORT=389
ENV_LDAP_BIND_DN=cn=readonly,dc=mydomain,dc=com
ENV_LDAP_BASE_DN=dc=mydomain,dc=com
ENV_LDAP_DOMAIN=mydomain.com
ENV_LDAP_ORGANIZATION="Example Inc."
ENV_LDAP_USER_NAME=readonly
ENV_LDAP_ADMIN_PASSWORD=changeit
ENV_LDAP_CONFIG_PASSWORD=changeit
```

Uncomment the following lines in `docker-compose.yml` when you want to run a LDAP server inside the container environment. To change the default passwords, edit the `ldap/maximo.ldif` file before running the `docker-compose`.

```yml
ldap:
  image: osixia/openldap:1.5.0
  hostname: "${ENV_LDAP_HOST_NAME}"
  command: --loglevel debug
  environment:
    - LDAP_LOG_LEVEL=256
    - "LDAP_ORGANISATION=${ENV_LDAP_ORGANIZATION}"
    - "LDAP_DOMAIN=${ENV_LDAP_DOMAIN}"
    # - "LDAP_BASE_DN=${ENV_LDAP_BASE_DN}"
    # - "LDAP_ADMIN_PASSWORD=${ENV_LDAP_ADMIN_PASSWORD}"
    - "LDAP_CONFIG_PASSWORD=${ENV_LDAP_CONFIG_PASSWORD}"
    - LDAP_READONLY_USER=true
    - "LDAP_READONLY_USER_USERNAME=${ENV_LDAP_USER_NAME}"
    - "LDAP_READONLY_USER_PASSWORD=${ENV_LDAP_ADMIN_PASSWORD}"
    - LDAP_RFC2307BIS_SCHEMA=false
    - LDAP_BACKEND=mdb
    - LDAP_TLS=false
    - LDAP_REPLICATION=false
    - KEEP_EXISTING_CONFIG=false
    - LDAP_REMOVE_CONFIG_AFTER_SETUP=false
  volumes:
    - /var/lib/ldap
    - /etc/ldap/slapd.d
    - /container/service/slapd/assets/certs/
    - ./ldap:/container/service/slapd/assets/config/bootstrap/ldif/custom
  networks:
    - backend
  ports:
    - "${ENV_LDAP_PORT}:${ENV_LDAP_PORT}"
```

## Database deployment on build vs. on runtime.

The database deployment a.k.a maxinst and updatedb will be executed on the docker build time by default. It reduces to the initial start-up time, but longer the build time. When you want to switch the behavior to deploy the database schema on runtime, run the following procedures before building the images.

#### Procedures to switch deploy database schemas on runtime.

1. Uncomment the all `volumes` sections in `docker-compose.yml`.
2. Uncomment the maximo section in `docker-compose.yml`.
3. Run the build command with `--deploy-db-on-runtime` or change `deploy_db_on_build` to `no` in `build.args` then run the build.sh command.

   Example:

   ```bash
   bash build.sh -r -v -rt -p --deploy-db-on-runtime
   ```

4. Change the values of `ENV_GEN_MAXIMO_PROPERTIES` to `no` in `.env`

## Skip running the maxinst program using a Db2 backup image at the Docker build.

[Maxinst program](http://www-01.ibm.com/support/docview.wss?uid=swg21314938) supports to initialize and create a Maximo database that is called during the "deployConfiguration" process in the Maximo installer. This process is painfully slow because it creates more than a thousand tables from scratch. To skip the process, you can use a backup database image to restore during the build time in a maxdb container image.

#### Procedures:

1. Move to the cloned directory.
   ```bash
   cd maximo-liberty-docker
   ```
2. Make a backup directory.
   ```bash
   mkdir ./images/backup
   ```
3. Place your backup image to the above directory.
4. Build container images by using the build tool.

## Building IBM Maximo Asset Management V7.6 images with an Oracle Database Container by using build tool

Oracle database containers are officially provided by Oracle from the [repository](https://github.com/oracle/docker-images/tree/master/OracleDatabase). You can run the Maximo on Docker on top of Oracle Container. Currently, the supported installation process is [database deployment on runtime](https://github.com/oracle/docker-images/tree/master/OracleDatabase) only.

### Prerequisites:

- An Oracle Database containar or any on-premise instance must be prepared before running `docker-compose` command.

1. Follow the guide from the [repo](https://github.com/oracle/docker-images/tree/master/OracleDatabase) to create an Oracle Database container.
2. Clone this repository
   ```bash
   git clone https://github.com/nishi2go/maximo-liberty-docker.git
   ```
3. Place the downloaded Maximo, IBM Db2, IBM Installation Manager and IBM WebSphere Liberty License binaries into the maximo-liberty-docker/images directory.
   ```bash
   > cd maximo-liberty-docker
   > ls -l images
   check.sh
   Dockerfile
   MAM_7.6.1_LINUX64.tar.gz
   packages.list
   wlp-nd-license.jar
   DB2_AWSE_REST_Svr_11.1_Lnx_86-64.tar.gz
   IED_V1.8.8_Wins_Linux_86.zip
   MAMMTFP7612IMRepo.zip
   v11.1.4fp5_linuxx64_server_t.tar.gz
   ```
4. Run the build tool
   Example:
   ```bash
   bash build.sh -r -v -c -rt --skip-db
   ```
   Note: This script works on Windows Subsystem on Linux.
5. Uncomment the all `volumes` sections in `docker-compose.ora.yml`.
6. Edit `docker-compose.ora.yml` to enable optional servers e.g. maximo-api, maximo-report and etc.
7. Run the Oracle container by using the Docker Compose file to create and deploy the database instance first:

   ```bash
   docker-compose -f docker-compose.ora.yml up -d maxdb
   ```

   Wait until the text "`DATABASE IS READY TO USE!`" is shown in the logs.

   ```bash
   docker-compose -f docker-compose.ora.yml logs -f maxdb
   ```

8. Run the Maximo container to deploy the database schema to Oracle database.

   ```bash
   docker-compose -f docker-compose.ora.yml up -d maximo
   ```

   Wait until the text "`CTGIN5012I: The reconfiguration action updateApplicationDBLite completed successfully.`" is shown in the logs.

   ```bash
   docker-compose -f docker-compose.ora.yml logs -f maximo
   ```

   Note: It will take 3-4 hours (depend on your machine spec) to complete the installation.

9. Run the all other containers:

   ```bash
   docker-compose -f docker-compose.ora.yml up -d
   ```
   To scale servers with the `docker-compose --scale` option.
   ```bash
   docker-compose -f docker-compose.ora.yml up -d --scale maximo-ui=2
   ```
10. Make sure to be accessible to Maximo login page: http://hostname/maximo

## Restore the database during starting up the maxdb container by using a Db2 backup image.

When you want to restore your database backup image on runtime, run the following procedures.

#### Procedures:

1. Build container images first (follow above instructions)
2. Move to the cloned directory.
   ```bash
   cd maximo-liberty-docker
   ```
3. Make a backup directory.
   ```bash
   mkdir ./backup
   ```
4. Uncomment the following volume configuration in `docker-compose.yml.`
   ```yaml
   maxdb:
     volumes:
       - type: bind
         source: ./backup
         target: /backup
   ```
5. Run containers by using the Docker Compose file. (follow the above instructions)

#### Take a backup database from a running container.

You can take a backup from the `maxdb` container by using a backup tool.

```bash
docker-compose exec maxdb /work/db2/backup.sh maxdb76 /backup
```

Note: There must be one file in the directory. The restore task will fail when more than two images in it.
