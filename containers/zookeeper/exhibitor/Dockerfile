FROM java:8-alpine

RUN apk add --update ca-certificates && rm -rf /var/cache/apk/* && \
  find /usr/share/ca-certificates/mozilla/ -name "*.crt" -exec keytool -import -trustcacerts \
  -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts -storepass changeit -noprompt \
  -file {} -alias {} \; && \
  keytool -list -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts --storepass changeit

ENV \
    ZK_RELEASE="http://www.apache.org/dist/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz" \
    EXHIBITOR_POM="https://raw.githubusercontent.com/Netflix/exhibitor/master/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml"

ENV MAVEN_VERSION 3.5.2
ENV MAVEN_HOME /usr/lib/maven
ENV PATH $MAVEN_HOME/bin:$PATH

# Use one step so we can remove intermediate dependencies and minimize size
RUN \
    # Install dependencies
    apk update \
    && apk add wget bash curl \
    cd /tmp && \
    wget -q http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar xzf - && \
    mv /tmp/apache-maven-$MAVEN_VERSION /usr/lib/maven && \
    ln -s /usr/lib/maven/bin/mvn /usr/bin/mvn && \
    rm -rf /tmp/* && \

    # Install ZK
    && curl -s -Lo /tmp/zookeeper.tgz $ZK_RELEASE \
    && mkdir -p /opt/zookeeper/transactions /opt/zookeeper/snapshots \
    && tar xzf /tmp/zookeeper.tgz -C /opt/zookeeper --strip-components=1 \
    && rm /tmp/zookeeper.tgz \

    # Install Exhibitor
    && mkdir -p /opt/exhibitor \
    && curl -s -Lo /opt/exhibitor/pom.xml $EXHIBITOR_POM \
    && mvn -f /opt/exhibitor/pom.xml package \
    && ln -s /opt/exhibitor/target/exhibitor*jar /opt/exhibitor/exhibitor.jar


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