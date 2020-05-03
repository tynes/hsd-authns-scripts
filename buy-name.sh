#!/bin/bash

NAME=${1:-tynes}
GIT_ROOT=${2:-$PWD}

HSD="$GIT_ROOT/bin/hsd"
HSW_CLI="$GIT_ROOT/bin/hsw-cli"
HSD_CLI="$GIT_ROOT/bin/hsd-cli"

export HSD_NETWORK=regtest

OPEN_HEIGHT=$($HSD_CLI rpc getnameinfo "$NAME" \
    | jq -r .start.start)

CURRENT_HEIGHT=$($HSD_CLI info | jq -r .chain.height)

TO_MINE="$(($OPEN_HEIGHT-$CURRENT_HEIGHT))"

if [ "$TO_MINE" -lt 0 ]; then
    TO_MINE=1
fi

ADDRESS=$($HSW_CLI account get default | jq -r .receiveAddress)

$HSD_CLI rpc generatetoaddress "$OPEN_HEIGHT" "$ADDRESS" > /dev/null

$HSW_CLI rpc sendopen "$NAME" > /dev/null

$HSD_CLI rpc generatetoaddress 1 "$ADDRESS" > /dev/null

BLOCKS_TO_BID=$($HSD_CLI rpc getnameinfo "$NAME" | jq -r .info.stats.blocksUntilBidding)

$HSD_CLI rpc generatetoaddress "$BLOCKS_TO_BID" "$ADDRESS" > /dev/null

$HSW_CLI rpc sendbid "$NAME" 1 1 > /dev/null

BLOCKS_TO_REVEAL=$($HSD_CLI rpc getnameinfo "$NAME" | jq -r .info.stats.blocksUntilReveal)

$HSD_CLI rpc generatetoaddress "$BLOCKS_TO_REVEAL" "$ADDRESS" > /dev/null

$HSW_CLI rpc sendreveal "$NAME" > /dev/null

BLOCKS_TO_CLOSE=$($HSD_CLI rpc getnameinfo "$NAME" | jq -r .info.stats.blocksUntilClose)

$HSD_CLI rpc generatetoaddress "$BLOCKS_TO_CLOSE" "$ADDRESS" > /dev/null

RESOURCE=$(cat resource.json)

$HSW_CLI rpc sendupdate "$NAME" "$RESOURCE" > /dev/null

$HSD_CLI rpc generatetoaddress 25 "$ADDRESS" > /dev/null

echo "Name: $NAME"
$HSD_CLI rpc getnameresource "$NAME"
