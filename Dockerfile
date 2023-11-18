FROM openjdk
VOLUME /tmp
ENV ARTIFACT_NAME=spring-boot-2-hello-world-*.jar
ARG JAR_FILE
COPY target/$ARTIFACT_NAME  app.jar

ENV JAR_OPTS=""
ENV JAVA_OPTS=""
ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar $JAR_OPTS
