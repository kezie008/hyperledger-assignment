#!/bin/bash
# Full teardown, including peer1 (network.sh down misses it since peer1 only
# exists in our custom compose files, and networkDown() hardcodes the bft compose set)
set -e

NETWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../test-network" && pwd)"
cd "$NETWORK_DIR"

export DOCKER_SOCK=${DOCKER_HOST:-/var/run/docker.sock}
DOCKER_SOCK="${DOCKER_SOCK##unix://}"
export DOCKER_SOCK

echo "Stopping and removing all containers/volumes/network..."
docker compose \
  -f compose/compose-test-net.yaml \
  -f compose/docker/docker-compose-test-net.yaml \
  -f compose/compose-couch.yaml \
  down --volumes --remove-orphans

echo "Removing generated crypto material and channel artifacts..."
rm -rf organizations/peerOrganizations organizations/ordererOrganizations organizations/fabric-ca
rm -rf channel-artifacts system-genesis-block
rm -f basic.tar.gz

echo "Cleanup complete."
