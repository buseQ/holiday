FROM openjdk:8-jdk-alpine
MAINTAINER haoshenqi/shenqivpn@yahoo.com
VOLUME ["/var/logs"]
COPY target/holiday-0.0.1-SNAPSHOT.jar app.jar
RUN echo "Asia/Shanghai" > /etc/timezone
EXPOSE 8001
ENTRYPOINT ["java","-jar","/app.jar"]
