FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools
COPY jobclub /opt/jboss/keycloak/themes/custom

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

