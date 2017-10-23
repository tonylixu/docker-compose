#!/bin/bash
set -ex
APP_NAME="rocketchat"
TIMESTAMP=`date +%F-%H%M`
BACKUP_DIR="/var/backups/mongo"
BACKUP_PATH="$BACKUP_DIR/$APP_NAME$TIMESTAMP.tgz"
docker exec mongo mongodump --archive=/dump/archive.json
7z a -t7z -mx=4 -mfb=64 -md=32m -ms=on $BACKUP_PATH /opt/rocketchat/data/dump/archive.json
