FROM gradle:jdk14 as builder 
COPY ./microservices-example /java-microservice
WORKDIR /java-microservice

RUN chmod +x gradlew && ./gradlew clean build 

FROM openjdk:14.0.1-slim
RUN mkdir -p /opt/java-microservice
WORKDIR /opt/java-microservice

COPY --from=builder /java-microservice/config-server/build/libs/config-server.jar .
COPY --from=builder /java-microservice/eureka-server/build/libs/eureka-server.jar .
COPY --from=builder /java-microservice/items-service/build/libs/items-service.jar .
COPY --from=builder /java-microservice/items-ui/build/libs/items-ui.jar .
COPY --from=builder /java-microservice/ui-gateway/build/libs/ui-gateway.jar .
COPY ./wait-for-it.sh /opt/java-microservice/wait-for-it.sh

# config-server
#EXPOSE 8888
# eureka-server
#EXPOSE 8081

#ENTRYPOINT ["java", "-jar"]
