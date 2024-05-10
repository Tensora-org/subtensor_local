#!/bin/bash

# Define source and destination directories
SRC_DIR="/home/ubuntu/localdevnet/wallets"
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
