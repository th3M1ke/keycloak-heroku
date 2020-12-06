FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools
COPY themes/wtc /opt/jboss/keycloak/themes/wtc
COPY deployments/keycloak-to-rabbit-1.5.jar /opt/jboss/keycloak/standalone/deployments/
COPY scripts/keycloak-to-rabbit.cli /opt/jboss/startup-scripts
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]