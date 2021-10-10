FROM java:8-jdk-alpine

COPY ./target/DemoPipelineJava-0.0.1-SNAPSHOT.jar /usr/app/

WORKDIR /usr/app

RUN sh -c 'touch DemoPipelineJava-0.0.1-SNAPSHOT.jar'

EXPOSE 8080

ENTRYPOINT ["java","-jar","DemoPipelineJava-0.0.1-SNAPSHOT.jar"]