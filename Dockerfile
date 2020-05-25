FROM openjdk:8-jdk-alpine
MAINTAINER haoshenqi/shenqivpn@yahoo.com
VOLUME ["/logs"]
COPY target/holiday-0.0.1-SNAPSHOT.jar app.jar
RUN echo "Asia/Shanghai" > /etc/timezone
EXPOSE 8081
ENTRYPOINT ["java","-jar","/app.jar"]
