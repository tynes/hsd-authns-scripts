# Handshake Authoritative NS Demo

This repo is a demo app showing how to set up an authoritative
nameserver. It is necessary to set up an authoritative name
server when using Handshake because if all records must be
placed on chain, it would not be scalable.

## Requirements

- [hsd](https://github.com/handshake-org/hsd)
- Unix like operating system
- Docker
- `dig`

If you are running on macOS, you will need to enable
binding to the loopback address `127.0.1.1`. The DNS
server listens on that address so that the user doesn't
need to reconfigure their current DNS settings.

```bash
$ sudo ifconfig lo0 alias 127.0.1.1 up
```


## Demo

Make sure to be running `hsd` in `regtest`

```bash
$ hsd --network regtest --memory true
```

Now navigate through an auction and set the resource on chain.
The resource is in `resource.json`.

```bash
# Usage ./buy-name.sh <name> <path to hsd gitrepo>
$ ./buy-name.sh tynes
```

Now start the authoritative name server. It is configured
with a few DNS RRs, they can be found in `nsd/zones/db.tynes`.
The `run.sh` script will run a docker image `hardware/nsd-dnssec`.

```bash
$ docker pull hardware/nsd-dnssec
$ ./run.sh
```

Now query for DNS records by sending a request to the `hsd`
recursive resolver.

```bash
$ ./dig.sh lol.tynes TXT
```

## hsd Ports

|                          | Main  | Testnet | Regtest | Simnet |
|--------------------------|-------|---------|---------|--------|
| Recursive Nameserver     | 5350  | 15350   | 25350   | 35350  |
| Authoritative Nameserver | 5349  | 15349   | 25349   | 35349  |
| Plaintext P2P            | 12038 | 13038   | 14038   | 15038  |
| Encrypted P2P            | 44806 | 45806   | 46806   | 47806  |
| Node HTTP                | 12037 | 13037   | 14037   | 15037  |
| Wallet HTTP              | 12039 | 13039   | 14039   | 15039  |


## Next Steps

Setting up a `DS` record to start a DNSSEC based chain of trust.
See the [Handout](https://github.com/pinheadmz/handout) project
for a guide on how to do this.
