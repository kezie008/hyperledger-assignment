#!/bin/bash
# Initializes ledger, queries from both Org1 peers, invokes a transfer, verifies propagation to peer1
set -e

NETWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../test-network" && pwd)"
cd "$NETWORK_DIR"

export PATH=${NETWORK_DIR}/../bin:$PATH
export FABRIC_CFG_PATH=${NETWORK_DIR}/../config
export ORDERER_CA=${NETWORK_DIR}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
ORG1_TLS=${NETWORK_DIR}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
ORG2_TLS=${NETWORK_DIR}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=${NETWORK_DIR}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=$ORG1_TLS
export CORE_PEER_ADDRESS=localhost:7051

echo "=== InitLedger ==="
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  -C mychannel -n basic \
  --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_TLS" \
  --peerAddresses localhost:9051 --tlsRootCertFiles "$ORG2_TLS" \
  -c '{"function":"InitLedger","Args":[]}'
sleep 2

echo "=== Query from peer0.org1 ==="
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

echo "=== Query from peer1.org1 (verifying replica sync) ==="
export CORE_PEER_ADDRESS=localhost:8051
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

echo "=== Invoke TransferAsset (asset1 -> Christopher) ==="
export CORE_PEER_ADDRESS=localhost:7051
peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  -C mychannel -n basic \
  --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_TLS" \
  --peerAddresses localhost:9051 --tlsRootCertFiles "$ORG2_TLS" \
  -c '{"function":"TransferAsset","Args":["asset1","Christopher"]}'
sleep 2

echo "=== Verify on peer1.org1 ==="
export CORE_PEER_ADDRESS=localhost:8051
peer chaincode query -C mychannel -n basic -c '{"Args":["ReadAsset","asset1"]}'
