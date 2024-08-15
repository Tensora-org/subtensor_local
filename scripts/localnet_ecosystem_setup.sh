#!/bin/bash

# This script moves the wallets to the local directory and sets up:
# Subnets, validator, adds stake adn root network weights and 2 miners.

# Define source and destination directories
SRC_DIR="/home/ubuntu/subtensor_local/wallets"
DEST_DIR="/home/ubuntu/.bittensor/wallets"

# Check if source directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Source directory $SRC_DIR does not exist."
    exit 1
fi

# Create the destination directory if it doesn't exist
if [ ! -d "$DEST_DIR" ]; then
    echo "Destination directory $DEST_DIR does not exist. Creating it now."
    mkdir -p "$DEST_DIR"
fi

# Copy contents from source to destination
cp -r "$SRC_DIR"/* "$DEST_DIR"/

# Verify the copy was successful
if [ $? -eq 0 ]; then
    echo "Contents from $SRC_DIR successfully copied to $DEST_DIR."
else
    echo "An error occurred while copying the contents."
    exit 1
fi

echo "Registering subnet"

btcli subnet create --subtensor.network ws://127.0.0.1:9944 --wallet.name "validators" --no_prompt

btcli s register --subtensor.network ws://127.0.0.1:9944 --netuid 1 --wallet.name "validators" --wallet.hotkey "validator_1" --no_prompt

btcli stake add --wallet.name "validators" --wallet.hotkey "validator_1" --subtensor.network ws://127.0.0.1:9944 --no_prompt

# This didn't work
# btcli root weights --netuids 1 --weights 0.04 --wallet.name "validators" --wallet.hotkey "validator_1" --no_prompt

btcli s register --subtensor.network ws://127.0.0.1:9944 --netuid 1 --wallet.name "miners" --wallet.hotkey "miner_1" --no_prompt

btcli s register --subtensor.network ws://127.0.0.1:9944 --netuid 1 --wallet.name "miners" --wallet.hotkey "miner_2" --no_prompt