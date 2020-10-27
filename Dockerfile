FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools
COPY jobclub_realm.json /tmp
COPY themes/jobclub /opt/jboss/keycloak/themes/jobclub
COPY deployments/keycloak-to-rabbit-1.1.jar /opt/jboss/keycloak/standalone/deployments/
COPY scripts/keycloak-to-rabbit.cli /opt/jboss/startup-scripts
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]