# Deploy Keycloak to Heroku

This repository deploys the [Keycloak](https://www.keycloak.org) Identity and Access Manangement Solution 
to Heroku.  It is based of Keycloak's official docker image with some slight modifications to use the
Heroku variable for `PORT` and `DATABASE_URL` properly.

The deployment will be made with a single Standard-2X dyno (it won't run very well in smaller dynos
due to Java's memory hunger) with a free Postgres database attached.

This Docker image enables you to work effectively with Keycloak themes and deployments, both locally and when deploying to Heroku

#### Themes
The Docker file copies the theme from `themes/jobclub` to `/opt/jboss/keycloak/themes/jobclub`
    
    COPY themes/jobclub /opt/jboss/keycloak/themes/jobclub

It also copies the rabbitmq integration as a jar to Wildfly's deployment folder

    COPY deployments/keycloak-to-rabbit-1.0.jar /opt/jboss/keycloak/standalone/deployments/

The source code is here: [keycloak-event-listener-rabbitmq](https://github.com/seniordevonly/keycloak-event-listener-rabbitmq)

### Docker 
Build Docker image:
    
    $ cd <project home>
    $ docker build -t keycloak/seniordev .
    
Run Docker image with themes mounted locally in this project: 

    $ docker run -d --name keycloak_sd_container -d -p 8080:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=123456 -v "$PWD/themes/jobclub":/opt/jboss/keycloak/themes/jobclub keycloak/seniordev
    $ docker run -d --name keycloak_sd_container -d -p 8080:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=123456 -v "/Users/vervik/projectsGit/podium/keycloak-heroku/themes/jobclub":/opt/jboss/keycloak/themes/jobclub keycloak/seniordev

Check the mounting of disk works correctly

    $ docker exec -it keycloak_sd_container bash
    $ cd /opt/jboss/keycloak/themes/jobclub
    
Publish [image](https://linuxconfig.org/how-to-customize-docker-images-with-dockerfiles)

    $ docker login
    $ docker tag <image name> keycloak/seniordev:<tag name>
    $ docker tag keycloak/seniordev keycloak/seniordev:1
    $ docker push keycloak/seniordev:1

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)


    "KEYCLOAK_IMPORT": {
        "description": "The path to realm.json to be imported on startup",
        "value": "/tmp/jobclub_realm.json",
        "required": false
    }