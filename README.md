1.	Prerequisites and steps:
2.	Setup Kubernetes Cluster either on (Azure/GCP/On premises).
3.	This project deployed on Azure kubernetes service.
4.	Install Helm & tiller and bind the service account (https://docs.microsoft.com/en-us/azure/aks/kubernetes-helm)
5.	git clone https://github.com/anzalbeg/fabricK8s.git
6.	Go inside the fabricK8s/HLF directory 
7.	Once you setup kubernetes. Get clusterIP range from the cluster, run the below .

8.	kubectl get services -o wide --all-namespaces  
9.	You will get cluster-ip address range, in my case it is “10.0.0.0/16”. Copy first three number from cluster-ip address in kube-dns service and replace the clusterIpRange attribute value in values.yaml file. 
10.	Run the command “kubectl get pods -o wide --all-namespaces” to get pods ip range. 

11.	Copy 10.240 (for your case it will be different) in IP column and replace kubeSystemIpRange attribute value in values.yaml file.

12.	After configuration change Run the below command to deploy fabric on k8s
a.	Helm install –name dev ./fabric-artifacts -f dev.com.yaml


13.	Wait for 1 min to get all pods comes in a running state. You can check the status of pods by running the below command
Kubectl get pods

14.	Once all pods are in running state, you are good to go to run first script which is “channel.sh”. run channel.sh inside HLF directory. But below running channel.sh , cross check orderer logs. 

15.	Next step is to create channel on orderer, we are keeping default channel name “mychannel”. After running channel.sh.

16.	We have successfully created channel “mychannel”. Next join peers to that channel. We have “joinchannel.sh” script, just run this script inside HLF directory

17.	Install chaincode on both peers using Installchaincode.sh script. Run this script inside HLF directory
18.	Next step is to update anchor peers, we have updateAnchorpeers.sh script. After updating anchor peers.
19.	Once we have all setup mentioned as above, we are good to go to instantiate (deploy) chaincode on channel “mychannel”. Run instantiateChaincode.sh script. 
20.	If you setup all thing in good shape till now without any error message, you are good to go to perform invoke and query transactions on mychannel ledger. We have scripts invoke.sh and query.sh to perform the transactions. Go ahead and run invoke.sh script to create first smartcontract transaction on the ledger. You will get something like this.
$ ./invoke.sh
+ kubectl exec dev-cli-59987bfb76-r26m8 -it -- bash -c 'CORE_PEER_LOCALMSPID=Org1MSP && CORE_PEER_ADDRESS=dev-peer0-xyz:7051 && peer chaincode invoke -o dev-orderer-g746q:7050 -C mychannel -n chaincode_example02 -v 1.0 -c '\''{"Args":["invoke","a","b","10"]}'\'''
21.	+ set +

1.	About the project
•	This project using fabric 1.1 version. 
•	All binaries inside bin folder (peer, orderer, configtxgen, configtxlator and cyptogen) should be present.
•	There is a file “network-artifacts-gen.sh” that used to generate the artifacts inside channel-artifacts directory. If you want to generate artifacts again run this file.
•	crypto-config directory contains msp of peer and orderer organizations.
•	All the transaction is happening from inside cli container. Here we are not registering any users. 
•	Helm is used for installing and managing kubernetes deployments.  

Kubernetes details
Total 5 deployments.
•	Ca1
•	Ca2
•	Cli
•	Peer0org1
•	Peer0org2
Six pods  
•	Ca1
•	Ca2
•	Peer0org1
•	Peer0org2
•	Cli
•	orderer
Five replica set
•	Ca1
•	Ca2
•	Cli
•	Peer0org1
•	Peer0org2
One StateFul Sets
•	orderer
Six services
•	Ca1-org1
•	Ca2-org2
•	Orderer-g764q
•	Peer0-abc
•	Peer0-xyz
•	kubernetes
All services are NodePort type to get external traffic directly to your service.
