### Apache Zookeeper
Apache ZooKeeper is a software project of the Apache Software Foundation, providing an open source distributed configuration service, synchronization service, and naming registry for large distributed systems. 

### Support Architectures
Supported architectures:
* `amd64`
* `arm32v6`
* `arm64v8`
* `i386`
* `ppc64le`
* `s390x`

### How to Use:
Standard:
* Check out the source code into a directory called "zookeeper".
* Start the docker containers by:
```bash
$ docker-compose -f stack.yml up -d
```
* Check all three zookeepers are running:
```bash
$ docker-compose -f stack.yml ps
      Name                    Command               State                     Ports
------------------------------------------------------------------------------------------------------
zookeeper_zoo1_1   /docker-entrypoint.sh zkSe ...   Up      0.0.0.0:2181->2181/tcp, 2888/tcp, 3888/tcp
zookeeper_zoo2_1   /docker-entrypoint.sh zkSe ...   Up      0.0.0.0:2182->2181/tcp, 2888/tcp, 3888/tcp
zookeeper_zoo3_1   /docker-entrypoint.sh zkSe ...   Up      0.0.0.0:2183->2181/tcp, 2888/tcp, 3888/tcp
```

With Exhibitor: