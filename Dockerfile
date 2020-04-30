FROM openjdk:8-jdk-alpine
MAINTAINER haoshenqi/shenqivpn@yahoo.com
VOLUME ["/logs"]
COPY target/holiday-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","/app.jar"]