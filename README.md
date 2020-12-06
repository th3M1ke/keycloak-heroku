# Deploy Keycloak to Heroku

This repository deploys the [Keycloak](https://www.keycloak.org) Identity and Access Manangement Solution 
to Heroku.  It is based of Keycloak's official [docker image](https://hub.docker.com/r/jboss/keycloak/) with some slight modifications to use the
Heroku variable for `PORT` and `DATABASE_URL` properly.

The deployment will be made with a single Standard-2X dyno (it won't run very well in smaller dynos
due to Java's memory hunger) with a free Postgres database attached.

This Docker image enables you to work effectively with Keycloak themes and deployments, both locally and when deploying to Heroku

#### Environment variables
    
    URL_GO_BACK=http://localhost:4200
    PORT=8080
    KEYCLOAK_USER=admin
    KEYCLOAK_PASSWORD=123456
    KEYCLOAK_IMPORT=/tmp/jobclub_realm.json

#### Themes
The Docker file copies the theme from `themes/jobclub` to `/opt/jboss/keycloak/themes/jobclub`
    
    COPY themes/jobclub /opt/jboss/keycloak/themes/jobclub

#### Deployments
It also copies the rabbitmq integration as a jar to Wildfly's deployment folder

    COPY deployments/keycloak-to-rabbit-1.0.jar /opt/jboss/keycloak/standalone/deployments/

    $ docker cp deployments/keycloak-to-rabbit-1.1.jar jobclub-cloud_keycloak_1:/opt/jboss/keycloak/standalone/deployments/
    $ docker rm -rf jobclub-cloud_keycloak_1:/opt/jboss/keycloak/standalone/deployments/keycloak-to-rabbit-1.1.jar.deployed
    $ docker rm -rf jobclub-cloud_keycloak_1:/opt/jboss/keycloak/standalone/deployments/keycloak-to-rabbit-1.1.jar

Enable logging in Keycloak UI by adding keycloak-to-rabbitmq
    
    Manage > Events > Config > Events Config > Event Listeners

The source code is here: [keycloak-event-listener-rabbitmq](https://github.com/seniordevonly/keycloak-event-listener-rabbitmq)

### Docker 
Build Docker image:
    
    $ cd <project home>
    $ docker build -t keycloak/intellitech .
    
Run Docker image with themes mounted locally in this project: 

    $ docker run -d --name keycloak_sd_container -d -p 8080:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=123456 -v "$PWD/themes/jobclub":/opt/jboss/keycloak/themes/jobclub keycloak/seniordev
    
    $ docker run -it --name keycloak_sd_container \
        -p 8080:8080 -e PORT=8080 \
        -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=123456 \
        -e URL_GO_BACK=http://localhost:4200 \
        -e KEYCLOAK_IMPORT=/tmp/jobclub_realm.json \
        -v /Users/vervik/projectsGit/podium/keycloak-heroku/themes/jobclub:/opt/jboss/keycloak/themes/jobclub \
        --mount type=bind,source=/Users/vervik/projectsGit/podium/keycloak-heroku/scripts,target=/opt/jboss/startup-scripts \
        keycloak/seniordev

    $ docker run -it --name volume1 --mount type=volume,source=logdata,target=c:\logdata microsoft/windowsservercore powershell


Check the mounting of disk works correctly

    $ docker ps
    take the container id
    $ docker exec -it <container id> bash
    $ cd /opt/jboss/keycloak/themes/wtc
    
    
    docker exec -it <container id> cp
    docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
    docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PAT
    
    docker cp deployments/keycloak-to-rabbit-1.2.jar 615d51ae075d:/opt/jboss/keycloak/standalone/deployments
    
    docker cp 35e2729ded6e:/opt/jboss/keycloak/standalone/configuration/standalone.xml .
    docker cp ./standalone.xml 35e2729ded6e:/opt/jboss/keycloak/standalone/configuration/standalone.xml

    docker exec -u root -it  45aee5282128 sh
    
    docker exec -u root -it  <container_id> sh
    microdnf install yum
    yum install vim
    vim /opt/jboss/keycloak/standalone/configuration/standalone.xml

## Logs
Documentation [here](https://docs.docker.com/engine/reference/commandline/logs/)

    $ docker logs [OPTIONS] CONTAINER
    $ docker logs --follow
    $ docker logs 45aee5282128 --follow

To investigate the structure of user profile JSON data provided by social providers you can enable the 

    $ /opt/jboss/keycloak/standalone/configuration/standalone.xml
    DEBUG level logger org.keycloak.social.user_profile_dump. 

This is done in the server’s app-server configuration file (domain.xml or standalone.xml).
    
Publish [image](https://linuxconfig.org/how-to-customize-docker-images-with-dockerfiles)

    $ docker login
    $ docker tag <image name> keycloak/seniordev:<tag name>
    $ docker tag keycloak/seniordev keycloak/seniordev:1
    $ docker push keycloak/seniordev:1

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Theme
- [theme-properties](https://www.keycloak.org/docs/latest/server_development/#theme-properties)
- [how-to-turn-off-the-keycloak-theme-cache](https://keycloakthemes.com/blog/how-to-turn-off-the-keycloak-theme-cache)


## Mount / Volumns
- [introduction-to-docker-bind-mounts-and-volumes/](https://4sysops.com/archives/introduction-to-docker-bind-mounts-and-volumes/)
- [Volumn for H2](https://github.com/jhipster/generator-jhipster/issues/7157)

## Export realm

- [keycloak-containers/blob/master/server/README.md#exporting-a-realm](https://github.com/keycloak/keycloak-containers/blob/master/server/README.md#exporting-a-realm)


    $ docker exec -it keycloak_sd_container /opt/jboss/keycloak/bin/standalone.sh \
        -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export \
        -Dkeycloak.migration.provider=singleFile \
        -Dkeycloak.migration.realmName=jobclub \
        -Dkeycloak.migration.usersExportStrategy=REALM_FILE \
        -Dkeycloak.migration.file=/tmp/jobclub_realm2.json
    
    $ docker cp keycloak_sd_container:/tmp/jobclub_realm2.json .

## Keycloak BankID
- [bankidnorge.no technical documentation](https://confluence.bankidnorge.no/confluence/pdoidclc/technical-documentation/core-concepts/session-handling)
- [Swedish BankID](https://github.com/bankid4keycloak/bankid4keycloak)

## Notes
    "KEYCLOAK_IMPORT": {
        "description": "The path to realm.json to be imported on startup",
        "value": "/tmp/jobclub_realm.json",
        "required": false
    }
    
## Resource
- [identity_broker](https://www.keycloak.org/docs/latest/server_admin/#_identity_broker)
- [identity_broker_first_login](https://www.keycloak.org/docs/latest/server_admin/#_identity_broker_first_login)
- [authentication/#guides](https://beta.developer.signicat.com/docs/authentication/#guides)
- [openid-connect/endpoints](https://developer.signicat.com/documentation/authentication/protocols/openid-connect/endpoints/)
- [identity-broker/mappers.html](https://wjw465150.gitbooks.io/keycloak-documentation/content/server_admin/topics/identity-broker/mappers.html)