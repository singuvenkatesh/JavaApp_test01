FROM java:8-jdk-alpine

COPY ./target/DemoPipelineJava.jar /usr/app/

WORKDIR /usr/app

RUN sh -c 'touch DemoPipelineJava.jar'

EXPOSE 8080

ENTRYPOINT ["java","-jar","DemoPipelineJava.jar"]