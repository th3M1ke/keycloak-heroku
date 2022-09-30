FROM maven:3.8.6-amazoncorretto-17 as builder

WORKDIR /usr/src/app

COPY modules/api-key/pom.xml .
RUN mvn -B -e -C -T 1C org.apache.maven.plugins:maven-dependency-plugin:3.1.2:go-offline

COPY modules/api-key .
RUN mvn -f . package


FROM quay.io/keycloak/keycloak:13.0.1

COPY docker-entrypoint.sh /opt/jboss/tools
COPY themes/wtc /opt/jboss/keycloak/themes/wtc
COPY deployments/keycloak-to-rabbit-1.12.jar /opt/jboss/keycloak/standalone/deployments/
COPY deployments/keycloak-signicat-1.7.jar /opt/jboss/keycloak/standalone/deployments/
COPY --from=builder /usr/src/app/target/deploy /opt/jboss/keycloak/standalone/deployments/
COPY scripts/keycloak-to-rabbit.cli /opt/jboss/startup-scripts
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]