FROM alpine/git as clone
WORKDIR /app
RUN git clone https://github.com/dorikro/spring-petclinic-clone.git
FROM maven:3.5-jdk-8-alpine as build
WORKDIR /app
COPY --from=clone /app/spring-petclinic /app
RUN mvn install
FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=build /app/target/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar /app
CMD ["java -jar spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar"]
EXPOSE 8000
