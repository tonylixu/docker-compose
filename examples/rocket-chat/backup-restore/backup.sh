#!/bin/bash
## This is assuming you placed the archive.json in /opt/rocketchat/data/dump/
## (which is linked to the container's /data/dump folder)
set -ex
APP_NAME="rocketchat"
TIMESTAMP=`date +%F-%H%M`
BACKUP_DIR="/var/backups/mongo"
BACKUP_PATH="$BACKUP_DIR/$APP_NAME$TIMESTAMP.tgz"
docker exec mongo mongodump --archive=/dump/archive.json
7z a -t7z -mx=4 -mfb=64 -md=32m -ms=on $BACKUP_PATH /opt/rocketchat/data/dump/archive.json
