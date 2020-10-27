FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools
COPY jobclub_realm.json /tmp
COPY themes/jobclub /opt/jboss/keycloak/themes/jobclub
COPY deployments/keycloak-to-rabbit-1.0.jar /opt/jboss/keycloak/standalone/deployments/
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

