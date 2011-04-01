#!/bin/bash
SHADOW_DIR=/home/ec2-user/mc/shadow
ARCHIVES=/var/www/html
[ $# -lt 1 ] && exit 7
if [ "$1" = "-X" ]; then
    shift
    ASYNC=1
fi
DIR=$1
NAME=${2:-`basename $1`}
TARGET=$SHADOW_DIR/$NAME

if [ -n "$ASYNC" ]; then
    tar czf $ARCHIVES/$NAME.tgz $DIR
    ~/mapper.sh $DIR $NAME
    echo "Done!"
else
    rsync -r $DIR $TARGET
    nohup $0 -X $TARGET $NAME &
fi
