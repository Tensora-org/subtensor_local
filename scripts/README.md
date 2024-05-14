This is the folder that has most of my local tweaks and scripts in it. 

**Binary**

Steps to set up the environment from the binary:
1. install_rust.sh
2. init.sh
4. localnet_wallet_setup.sh
5. CHAIN=customSpecRaw.json scripts/localnet_bob_start.sh
6. CHAIN=customSpecRaw.json scripts/localnet_add_alice.sh    (Updating the bootnode address if it is not on the same machine)
7. pip install bittensor
8. Run Python3 set_up_players.py

If you want to make any further changes to the spec file for running the chain:
1. Make the changes to the non-raw version of the spec file in the specs directory. 
2. Convert the chain spec to raw format:
    './target/release/node-subtensor build-spec --chain=customSpec.json --raw --disable-default-bootnode > customSpecRaw.json'

**Docker**

This is all made simpler using docker. Simply from the subtensor_local directory you should be able to run:
1. ./install_docker.sh
2. On the main instance that will hold the root of your blockchain: /scripts/localnet_docker.sh
3. On other machines you want to add to the network: /scripts/localnet_docker.sh local [root_node_ip] [bob_node_id]
4. sudo apt install python3-pip
5. pip3 install bittensor
6. localnet_wallet_setup.sh
7. Run Python3 set_up_players.py

With this docker implementation, the data on the blockchain will persist as long as you run the blockchain. If you need to change this, you can add volumes back in the docker-compose.yml 

**Troubleshooting**

1. If you are trying to connect to a blockchain endpoint in a docker container, make sure you have the --ws-external in the node-subtensor call. For a service running in a dcoker container to communicate with the outside world, it need to listen on 0.0.0.0 not 127.0.0.1. 