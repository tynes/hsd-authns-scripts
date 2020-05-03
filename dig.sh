#!/bin/bash

RS_PORT=5350
NS_PORT=5349

if [ "$HSD_NETWORK" == 'main' ]; then
    RS_PORT=5350
    NS_PORT=5349
elif [ "$HSD_NETWORK" == 'testnet' ]; then
    RS_PORT=15350
    NS_PORT=15349
elif [ "$HSD_NETWORK" == 'regtest' ]; then
    RS_PORT=25350
    NS_PORT=25349
elif [ "$HSD_NETWORK" == 'simnet' ]; then
    RS_PORT=35350
    NS_PORT=35349
fi

dig @127.0.0.1 -p "$RS_PORT" $@
