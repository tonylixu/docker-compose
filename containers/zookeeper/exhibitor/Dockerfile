FROM openjdk:8-jre-alpine
MAINTAINER Tony Li Xu tony@lixu.ca

# Install required packages
RUN apk add --no-cache \
    bash \
    su-exec

# Set up environment varibales
ENV \
    ZK_RELEASE="http://www.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz" \
    EXHIBITOR_POM="https://raw.githubusercontent.com/Netflix/exhibitor/d911a16d704bbe790d84bbacc655ef050c1f5806/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml" \
    BUILD_DEPS="curl maven"

# Install Zookeeper and Exhibitor
RUN \
    # Install dependencies
    apt-get update \
    && apt-get install -y $BUILD_DEPS \

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
EXPOSE 2181 2888 3888 8181

ENTRYPOINT ["bash", "-ex", "/opt/exhibitor/wrapper.sh"]