#!/bin/sh

# setting up the peer1 env variables inside cli environment

my_dir="$(dirname "$0")"
. "$my_dir/parse_yaml.sh"

eval $(parse_yaml fabric-artifacts/values.yaml "config_")

# setting up the peer1 env variables inside cli environment
export GENESIS_BLOCK=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/fabricK8s/HLF/channel-artifacts/orderer-channel.tx
export CLI_POD_ID=`kubectl get pod | grep cli | cut -f1 -d' '`
export ORDERER_ADDR="dev-orderer-g746q:7050"
export ORG_DOMAIN="org1.example.com"
export CHAINCODE_PATH=github.com/hyperledger/fabric/peer/crypto/crypto-config/fabricK8s/HLF/chaincode/chaincode_example02/go
export CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/fabricK8s/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_ADDRESS="dev-peer0-xyz:7051"
export CHANNEL_NAME="mychannel"
# invoke 

set -x
kubectl exec $CLI_POD_ID -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && peer chaincode invoke -o $ORDERER_ADDR -C $CHANNEL_NAME -n chaincode_example02 -v 1.0 -c '{\"Args\":[\"invoke\",\"a\",\"b\",\"10\"]}'"  >&log.txt
set +x
