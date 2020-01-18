FROM docker:17.12.0-ce as docker
FROM stakater/java-centos:7-1.8
#FROM maven as build
WORKDIR /code
COPY . .
#RUN mvn package

COPY --from=docker /usr/local/bin/docker /usr/bin/
ENV DOCKER_API_VERSION=1.32

LABEL name="Stakater Maven Image on CentOS" \
      maintainer="Stakater <stakater@aurorasolutions.io>" \
      vendor="Stakater" \
      release="1" \
      summary="A Maven based image on CentOS"

# Setting Maven Version that needs to be installed
ARG MAVEN_VERSION=3.5.4

# Changing user to root to install maven
USER root

# Maven
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV M2_HOME /usr/share/maven
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

# Define default command, can be overriden by passing an argument when running the container
CMD ["mvn","-version"]

FROM java:8-jre-alpine
WORKDIR /
#COPY --from=build /code/target/spring-petclinic-*.jar app
EXPOSE 8000
CMD java -jar app
