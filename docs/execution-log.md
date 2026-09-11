========================================================================================================================================
========================================================================================================================================
Logs or screenshots showing:
▪ Network running
▪ Successful transactions
========================================================================================================================================
========================================================================================================================================

[root@lasc-lxawx-01 test-network]# docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -v awx
NAMES                                                                                                   STATUS        PORTS
dev-peer1.org1.example.com-basic_1.0-1b4e2104317d15998204af0288ee2f8f4c374ab854ced610763928e0c3966445   Up 11 hours
dev-peer0.org2.example.com-basic_1.0-1b4e2104317d15998204af0288ee2f8f4c374ab854ced610763928e0c3966445   Up 11 hours
dev-peer0.org1.example.com-basic_1.0-1b4e2104317d15998204af0288ee2f8f4c374ab854ced610763928e0c3966445   Up 11 hours
peer0.org2.example.com                                                                                  Up 12 hours   0.0.0.0:9051->9051/tcp, [::]:9051->9051/tcp, 7051/tcp, 0.0.0.0:9445->9445/tcp, [::]:9445->9445/tcp
peer1.org1.example.com                                                                                  Up 12 hours   0.0.0.0:8051->7051/tcp, [::]:8051->7051/tcp, 0.0.0.0:9446->9444/tcp, [::]:9446->9444/tcp
peer0.org1.example.com                                                                                  Up 12 hours   0.0.0.0:7051->7051/tcp, [::]:7051->7051/tcp, 0.0.0.0:9444->9444/tcp, [::]:9444->9444/tcp
couchdb0                                                                                                Up 12 hours   4369/tcp, 9100/tcp, 0.0.0.0:5984->5984/tcp, [::]:5984->5984/tcp
couchdb2                                                                                                Up 12 hours   4369/tcp, 9100/tcp, 0.0.0.0:8984->5984/tcp, [::]:8984->5984/tcp
couchdb1                                                                                                Up 12 hours   4369/tcp, 9100/tcp, 0.0.0.0:7984->5984/tcp, [::]:7984->5984/tcp
orderer.example.com                                                                                     Up 12 hours   0.0.0.0:7050->7050/tcp, [::]:7050->7050/tcp, 0.0.0.0:7053->7053/tcp, [::]:7053->7053/tcp, 0.0.0.0:9443->9443/tcp, [::]:9443->9443/tcp


[root@lasc-lxawx-01 test-network]# cd /home/hyperledger/my-fabric-assignment
[root@lasc-lxawx-01 my-fabric-assignment]# ./scripts/test-transactions.sh
=== InitLedger ===
2026-09-11 00:11:14.279 EDT 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200
=== Query from peer0.org1 ===
[{"AppraisedValue":300,"Color":"blue","ID":"asset1","Owner":"Tomoko","Size":5},{"AppraisedValue":400,"Color":"red","ID":"asset2","Owner":"Brad","Size":5},{"AppraisedValue":500,"Color":"green","ID":"asset3","Owner":"Jin Soo","Size":10},{"AppraisedValue":600,"Color":"yellow","ID":"asset4","Owner":"Max","Size":10},{"AppraisedValue":700,"Color":"black","ID":"asset5","Owner":"Adriana","Size":15},{"AppraisedValue":800,"Color":"white","ID":"asset6","Owner":"Michel","Size":15}]
=== Query from peer1.org1 (verifying replica sync) ===
[{"AppraisedValue":300,"Color":"blue","ID":"asset1","Owner":"Tomoko","Size":5},{"AppraisedValue":400,"Color":"red","ID":"asset2","Owner":"Brad","Size":5},{"AppraisedValue":500,"Color":"green","ID":"asset3","Owner":"Jin Soo","Size":10},{"AppraisedValue":600,"Color":"yellow","ID":"asset4","Owner":"Max","Size":10},{"AppraisedValue":700,"Color":"black","ID":"asset5","Owner":"Adriana","Size":15},{"AppraisedValue":800,"Color":"white","ID":"asset6","Owner":"Michel","Size":15}]
=== Invoke TransferAsset (asset1 -> Christopher) ===
2026-09-11 00:11:17.029 EDT 0001 INFO [chaincodeCmd] chaincodeInvokeOrQuery -> Chaincode invoke successful. result: status:200 payload:"Tomoko"
=== Verify on peer1.org1 ===
{"AppraisedValue":300,"Color":"blue","ID":"asset1","Owner":"Christopher","Size":5}
[root@lasc-lxawx-01 my-fabric-assignment]#


========================================================================================================================================
========================================================================================================================================
7. Expected Outcome
At the end of this assignment, the candidate should have:
• A fully functional Hyperledger Fabric network
• Automated scripts for setup and teardown
• Demonstrated understanding of blockchain infrastructure
• Clear and maintainable DevOps workflow
========================================================================================================================================
========================================================================================================================================

[root@lasc-lxawx-01 my-fabric-assignment]# cd /home/hyperledger/fabric-samples/test-network
[root@lasc-lxawx-01 test-network]# docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -v awx
NAMES                                                                                                   STATUS        PORTS
dev-peer1.org1.example.com-basic_1.0-1b4e2104317d15998204af0288ee2f8f4c374ab854ced610763928e0c3966445   Up 11 hours
dev-peer0.org2.example.com-basic_1.0-1b4e2104317d15998204af0288ee2f8f4c374ab854ced610763928e0c3966445   Up 11 hours
dev-peer0.org1.example.com-basic_1.0-1b4e2104317d15998204af0288ee2f8f4c374ab854ced610763928e0c3966445   Up 11 hours
peer0.org2.example.com                                                                                  Up 12 hours   0.0.0.0:9051->9051/tcp, [::]:9051->9051/tcp, 7051/tcp, 0.0.0.0:9445->9445/tcp, [::]:9445->9445/tcp
peer1.org1.example.com                                                                                  Up 12 hours   0.0.0.0:8051->7051/tcp, [::]:8051->7051/tcp, 0.0.0.0:9446->9444/tcp, [::]:9446->9444/tcp
peer0.org1.example.com                                                                                  Up 12 hours   0.0.0.0:7051->7051/tcp, [::]:7051->7051/tcp, 0.0.0.0:9444->9444/tcp, [::]:9444->9444/tcp
couchdb0                                                                                                Up 12 hours   4369/tcp, 9100/tcp, 0.0.0.0:5984->5984/tcp, [::]:5984->5984/tcp
couchdb2                                                                                                Up 12 hours   4369/tcp, 9100/tcp, 0.0.0.0:8984->5984/tcp, [::]:8984->5984/tcp
couchdb1                                                                                                Up 12 hours   4369/tcp, 9100/tcp, 0.0.0.0:7984->5984/tcp, [::]:7984->5984/tcp
orderer.example.com                                                                                     Up 12 hours   0.0.0.0:7050->7050/tcp, [::]:7050->7050/tcp, 0.0.0.0:7053->7053/tcp, [::]:7053->7053/tcp, 0.0.0.0:9443->9443/tcp, [::]:9443->9443/tcp



[root@lasc-lxawx-01 test-network]# cd /home/hyperledger/my-fabric-assignment/scripts
[root@lasc-lxawx-01 scripts]# ls -la
total 16
drwxr-xr-x 2 root root  100 Sep 10 13:34 .
drwxr-xr-x 7 root root  117 Sep 10 13:17 ..
-rwxr-xr-x 1 root root  870 Sep 10 13:34 cleanup.sh
-rwxr-xr-x 1 root root 3343 Sep 10 13:34 deploy-chaincode.sh
-rwxr-xr-x 1 root root  920 Sep 10 13:34 join-peer1.sh
-rwxr-xr-x 1 root root 2180 Sep 10 13:34 test-transactions.sh



[root@lasc-lxawx-01 scripts]# cat /home/hyperledger/my-fabric-assignment/README.md
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



[root@lasc-lxawx-01 scripts]# cd /home/hyperledger/my-fabric-assignment
[root@lasc-lxawx-01 my-fabric-assignment]# git log --oneline
24e3bdf (HEAD -> main, origin/main) Add execution proof documentation
38b2457 Add automation scripts, README, and peer1 customization docs
a9784fe Initial Hyperledger Fabric network config: 1 org, 2 peers, orderer, CouchDB, TLS
53066aa Initial commit
