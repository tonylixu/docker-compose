## What's Docker Container?
A Docker container is a container that runs a docker image. Usually a contianer
image is a lightweight, stand-alone, executable package of a piece of software
that includes everything needed to run. Docker containers run on a single
machine share that machine's OS kernel and resources, they starts instantly and
use less compute and RAM. They isolate applications from one another and from
the underlying infrastructure.

## How to Save A Docker Container to Image?
`docker commit` allows you to save a snapshot of your contianer as a docker
image so you can run it again later. Like a normal Docker image, you can
transfer it to other hosts. You can also take advantage of docker-git, to even
version control the images.

Find the docker container ID:
```bash
$ CONTAINER ID        IMAGE               COMMAND                  CREATED
STATUS              PORTS
NAMES
cbc7b7f03fe3        zimbra_docker       "/bin/bash /opt/st..."   2 hours ago
Up 2 hours          0.0.0.0:25->25/tcp, 0.0.0.0:80->80/tcp,
0.0.0.0:110->110/tcp, 0.0.0.0:443->443/tcp,  tender_almeida
```

Save the running container as a docker image:
```bash
$ docker commit cbc7b7f03fe3 tonylixu/zimbra-2017-09-17
```
