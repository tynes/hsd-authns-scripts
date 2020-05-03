#!/bin/bash

docker run --rm \
    -v $PWD/nsd/conf:/etc/nsd \
    -ti hardware/nsd-dnssec nsd-checkconf -v /etc/nsd/nsd.conf
