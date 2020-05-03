#!/bin/bash

ROOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
NAME=nsd-dnssec
IMAGE=hardware/nsd-dnssec

RUNNING=$(docker ps --format='{{.Names}}' \
    | grep ^$NAME$)

if [[ "$RUNNING" ]]
then
    docker container stop "$NAME"
    exit 0
fi


EXISTS=$(docker ps -a --format='{{.Names}}' \
    | grep ^$NAME$)

if [[ "$EXISTS" ]]
then
    docker container rm "$NAME"
fi

docker run --name "$NAME" \
    --volume="$ROOTDIR/nsd/conf":/etc/nsd \
    --volume="$ROOTDIR/nsd/zones":/zones \
    --volume="$ROOTDIR/nsd/db":/var/db/nsd \
    --publish=127.0.1.1:53:53/tcp \
    --publish=127.0.1.1:53:53/udp \
    --restart=unless-stopped \
    --detach=true \
    "$IMAGE:latest"

