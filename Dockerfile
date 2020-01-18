FROM maven as build
WORKDIR /code
COPY . .
RUN mvn package


FROM java:8-jre-alpine
WORKDIR /
COPY --from=build /code/target/spring-petclinic-*.jar app
EXPOSE 8000
CMD java -jar app
