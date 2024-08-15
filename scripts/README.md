### Building from Binary 

1. bash ./install_rust.sh
2. restart terminal
3. bash ./init.sh
4. ./install_aws.sh    (This is if you want to build and push the images to the aws repo)
5. ./install_docker.sh

If you already have a chainspec created you can skip the next two steps:

The next step involves building the custom chainspecs, to do this, you need to first build the node. The aim of this step is to provide prefunded wallets for the blockchain.

We first need to create the plain chain spec and then convert it from plain to raw format, as this is what is needed by the blockchain. 

6. ./build.sh
7. run './target/release/node-subtensor build-spec --disable-default-bootnode --chain local > "./scripts/specs/customSpec.json"'

    Stop at this point and change the addresses of wallets in the balance section. 

8. run './target/release/node-subtensor build-spec --disable-default-bootnode --raw --chain "./scripts/specs/customSpec.json" > "./scripts/specs/customSpecRaw.json"

You can then go in the customSpec.json and scroll to the bottom. Use the wallets in the wallets directory to assign coldkeys for prefunding.

If you just want to build and run the blockchain on your own machine you can run: 

9. CHAIN=customSpecRaw ./localnet.sh


### Building from docker (recommended)

This approach is very easy. It comes with two wallets "miners" and "validators" that are prefunded in the wallets directory. 

1. ./install_aws.sh    (This is if you want to build and push the images to the aws repo)
3. run 'aws configure sso' and log in from the command line, make sure you call your aws profile tensora_dev
4. run 'export AWS_PROFILE=tensora_dev
5. ./install_docker.sh
6. ./localnet_docker.sh
7. ./localnet_ecosystem_setup.sh

Then you should be good to connect to the blockchain. 