#!/bin/bash
# Joins peer1.org1 to mychannel (network.sh only auto-joins peer0 of each org)
set -e

NETWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../test-network" && pwd)"
cd "$NETWORK_DIR"

export PATH=${NETWORK_DIR}/../bin:$PATH
export FABRIC_CFG_PATH=${NETWORK_DIR}/../config
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_MSPCONFIGPATH=${NETWORK_DIR}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=${NETWORK_DIR}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
export CORE_PEER_ADDRESS=localhost:8051
export ORDERER_CA=${NETWORK_DIR}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem

echo "Joining peer1.org1.example.com to mychannel..."
peer channel join -b ./channel-artifacts/mychannel.block

echo "Verifying..."
peer channel list
