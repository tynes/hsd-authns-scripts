#!/bin/bash

docker run --rm \
    -v $PWD/nsd/zones/:/zones \
    -ti hardware/nsd-dnssec nsd-checkzone tynes. /zones/db.tynes
