FROM openjdk:11-jre
RUN mkdir /app
COPY java-webserver.jar "/app/"
RUN chmod a+x /app/java-webserver.jar
WORKDIR /app
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","java-webserver.jar"]