# Deploy Keycloak to Heroku

This repository deploys the [Keycloak](https://www.keycloak.org) Identity and Access Manangement Solution 
to Heroku.  It is based of Keycloak's official docker image with some slight modifications to use the
Heroku variable for `PORT` and `DATABASE_URL` properly.

The deployment will be made with a single Performance-M dyno (it won't run very well in smaller dynos
due to Java's memory hunger) with a free Postgres database attached.

### RabbitMQ integration
We using [keycloak-event-listener-rabbitmq](https://github.com/seniordevonly/keycloak-event-listener-rabbitmq)

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)


        "KEYCLOAK_IMPORT": {
            "description": "The path to realm.json to be imported on startup",
            "value": "/tmp/jobclub_realm.json",
            "required": false
        }