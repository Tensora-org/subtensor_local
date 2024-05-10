This is the folder that has most of my local tweaks in it. 

Firstly, we currently have two nodes that can be run to make a local subnet, we will be increasing this number. 

Steps to set up the environment:
1. install_rust.sh
2. init.sh
3. localnet_setup.sh (I am not sure this works?)
4. localnet_wallet_setup.sh
5. CHAIN=customSpecRaw.json scripts/localnet_bob_start.sh
6. CHAIN=customSpecRaw.json scripts/localnet_add_alice.sh    (Updating the bootnode address if it is not on the same machine)
7. pip install bittensor
8. Run Python3 set_up_subnet.py    (needs to be run on the node with alice or tweak the script to point at Bob's ws socket)
9. Run Python3 set_up_miners_valis.py    

If you want to make any further changes to the spec file for running the chain:
1. Make the changes to the non-raw version of the spec file in the specs directory. 
2. Convert the chain spec to raw format:
    './target/release/node-subtensor build-spec --chain=customSpec.json --raw --disable-default-bootnode > customSpecRaw.json'

