#!/bin/bash
# Packages, installs (on peer0.org1, peer1.org1, peer0.org2), approves (Org1+Org2), and commits asset-transfer-basic
set -e

NETWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../test-network" && pwd)"
CC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../chaincode/asset-transfer-basic" && pwd)"
cd "$NETWORK_DIR"

export PATH=${NETWORK_DIR}/../bin:$PATH
export FABRIC_CFG_PATH=${NETWORK_DIR}/../config
export ORDERER_CA=${NETWORK_DIR}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
CC_NAME=basic
CC_VERSION=1.0
CC_SEQUENCE=1

echo "[1/6] Packaging chaincode..."
peer lifecycle chaincode package basic.tar.gz --path "$CC_DIR" --lang golang --label ${CC_NAME}_${CC_VERSION}

install_on() {
  local mspid=$1 msp_path=$2 tls_root=$3 addr=$4
  export CORE_PEER_TLS_ENABLED=true
  export CORE_PEER_LOCALMSPID=$mspid
  export CORE_PEER_MSPCONFIGPATH=$msp_path
  export CORE_PEER_TLS_ROOTCERT_FILE=$tls_root
  export CORE_PEER_ADDRESS=$addr
  peer lifecycle chaincode install basic.tar.gz
}

ORG1_MSP=${NETWORK_DIR}/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
ORG1_TLS=${NETWORK_DIR}/organizations/peerOrganizations/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem
ORG2_MSP=${NETWORK_DIR}/organizations/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
ORG2_TLS=${NETWORK_DIR}/organizations/peerOrganizations/org2.example.com/tlsca/tlsca.org2.example.com-cert.pem

echo "[2/6] Installing on peer0.org1..."
install_on Org1MSP "$ORG1_MSP" "$ORG1_TLS" localhost:7051

echo "[3/6] Installing on peer1.org1..."
install_on Org1MSP "$ORG1_MSP" "$ORG1_TLS" localhost:8051

echo "[4/6] Installing on peer0.org2..."
install_on Org2MSP "$ORG2_MSP" "$ORG2_TLS" localhost:9051

echo "Fetching package ID..."
CC_PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep "Package ID" | sed -n 's/^Package ID: \(.*\), Label:.*/\1/p')
echo "Package ID: $CC_PACKAGE_ID"

echo "[5/6] Approving for Org2, then Org1..."
install_on Org2MSP "$ORG2_MSP" "$ORG2_TLS" localhost:9051
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  --channelID mychannel --name $CC_NAME --version $CC_VERSION --package-id $CC_PACKAGE_ID --sequence $CC_SEQUENCE

install_on Org1MSP "$ORG1_MSP" "$ORG1_TLS" localhost:7051
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  --channelID mychannel --name $CC_NAME --version $CC_VERSION --package-id $CC_PACKAGE_ID --sequence $CC_SEQUENCE

echo "Checking commit readiness..."
peer lifecycle chaincode checkcommitreadiness --channelID mychannel --name $CC_NAME --version $CC_VERSION --sequence $CC_SEQUENCE --tls --cafile "$ORDERER_CA" --output json

echo "[6/6] Committing chaincode..."
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "$ORDERER_CA" \
  --channelID mychannel --name $CC_NAME --version $CC_VERSION --sequence $CC_SEQUENCE \
  --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_TLS" \
  --peerAddresses localhost:9051 --tlsRootCertFiles "$ORG2_TLS"

peer lifecycle chaincode querycommitted --channelID mychannel --name $CC_NAME --cafile "$ORDERER_CA"
echo "Chaincode deployment complete."
