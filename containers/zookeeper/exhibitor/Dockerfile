FROM openjdk:8-jre-alpine
MAINTAINER Tony Li Xu tony@lixu.ca

# Install required packages
RUN apk add --no-cache \
    bash \
    su-exec

# Set up environment varibales
ENV \
    ZK_RELEASE="http://www.apache.org/dist/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz" \
    EXHIBITOR_POM="https://raw.githubusercontent.com/Netflix/exhibitor/d911a16d704bbe790d84bbacc655ef050c1f5806/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml" \
    MAVEN_BINARY="http://ftp.fau.de/apache/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz" \
    BUILD_DEPS="curl maven"

ENV PATH $PATH:/usr/lib/mvn/bin

# Install Zookeeper and Exhibitor
RUN \
    # Install dependencies
    apk update \
    && apk add wget bash curl \
    && curl -Lo /tmp/apache-maven-3.5.3-bin.tar.gz $MAVEN_BINARY \
    && tar -xz -f /tmp/apache-maven-3.5.3-bin.tar.gz \
    && rm /tmp/apache-maven-3.5.3-bin.tar.gz \
    && mv /tmp/apache-maven-3.5.3 /usr/lib/mvn \

    # Install ZK
    && curl -Lo /tmp/zookeeper.tgz $ZK_RELEASE \
    && mkdir -p /opt/zookeeper/transactions /opt/zookeeper/snapshots \
    && tar -xzf /tmp/zookeeper.tgz -C /opt/zookeeper --strip=1 \
    && rm /tmp/zookeeper.tgz \

    # Install Exhibitor
    && mkdir -p /opt/exhibitor \
    && curl -Lo /opt/exhibitor/pom.xml $EXHIBITOR_POM \
    && mvn -f /opt/exhibitor/pom.xml package \
    && ln -s /opt/exhibitor/target/exhibitor*jar /opt/exhibitor/exhibitor.jar \

# Get Exhibitor
RUN mkdir /opt/exhibitor
ADD include/pom.xml /opt/exhibitor/pom.xml
RUN cd /opt/exhibitor && mvn clean package
RUN ln -s /opt/exhibitor/target/${EXHIBITOR_NAME} /opt/exhibitor/exhibitor.jar

# Add the wrapper script to setup configs and exec exhibitor
ADD include/wrapper.sh /opt/exhibitor/wrapper.sh

# Add the optional web.xml for authentication
ADD include/web.xml /opt/exhibitor/web.xml

USER root
WORKDIR /opt/exhibitor
EXPOSE 2181 2888 3888 8080 8181

# Volumes for store local files
VOLUME /opt/zookeeper/local_configs

# Add name and version metadata to the image
LABEL name="zookeeper-ex" version="3.4.8"

ENTRYPOINT ["bash", "-ex", "/opt/exhibitor/wrapper.sh"]