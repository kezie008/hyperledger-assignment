# Hyperledger Fabric Network — DevOps Assignment

A customized Hyperledger Fabric v2.5.16 network built from the official
`fabric-samples/test-network` reference, extended to meet assignment
requirements: **1 organization (Org1) running 2 peers**, plus a second
org (Org2) used only for endorsement/orderer participation as per the
standard test-network topology, 1 orderer, CouchDB state database, and
TLS enabled across all components.

## What's customized vs. vanilla test-network

Vanilla `test-network` only runs **one peer per org**. To satisfy the
"2 peer nodes" requirement, the following files were modified:

- `test-network/organizations-cryptogen/crypto-config-org1.yaml` —
  `Template.Count` changed from 1 to 2, so `cryptogen` generates
  certificates for both `peer0.org1` and `peer1.org1`.
- `test-network/compose/compose-test-net.yaml` — added a
  `peer1.org1.example.com` service and volume definition.
- `test-network/compose/compose-couch.yaml` — added a dedicated
  `couchdb2` instance for peer1's state database.
- `test-network/compose/docker/docker-compose-test-net.yaml` — added
  peer1's Docker socket mount (required for chaincode container
  invocation).

**Known limitation:** `network.sh down` does not clean up peer1,
because Fabric's `networkDown()` function hardcodes the BFT compose
file set during teardown, and peer1 only exists in the customized
non-BFT compose files. `scripts/cleanup.sh` handles this correctly by
targeting the same compose file combination used to bring the network
up.

## Prerequisites

- Docker Engine + Docker Compose plugin
- Go 1.21+
- Fabric binaries + Docker images (installed via `bootstrap.sh`,
  see [Hyperledger Fabric docs](https://hyperledger-fabric.readthedocs.io/))

## Usage

```bash
# 1. Bring up the network, create the channel, join peer0 of each org
cd test-network
./network.sh up createChannel -c mychannel -s couchdb

# 2. Join peer1.org1 (not handled by network.sh)
cd ..
./scripts/join-peer1.sh

# 3. Deploy chaincode (asset-transfer-basic) to all 3 peers
./scripts/deploy-chaincode.sh

# 4. Run transaction tests (init, query from both Org1 peers, invoke, verify)
./scripts/test-transactions.sh

# 5. Tear everything down
./scripts/cleanup.sh
```

## Architecture

- **Org1**: peer0 (host port 7051), peer1 (host port 8051), each with
  its own CouchDB instance (couchdb0, couchdb2)
- **Org2**: peer0 (host port 9051), with couchdb1
- **Orderer**: single Raft orderer node (port 7050)
- **Channel**: `mychannel`
- **Chaincode**: `asset-transfer-basic` (Go), installed on all 3 peers,
  approved by both orgs, committed at sequence 1

## Verified functionality

- Channel creation and multi-peer join (including manual peer1 join)
- Chaincode lifecycle: package → install (x3) → approve (x2) → commit
- `InitLedger`, `GetAllAssets`, `TransferAsset`, `ReadAsset` all tested
  and confirmed to replicate correctly to peer1's independent ledger
  and CouchDB instance
- TLS enabled on all peer/orderer communication
