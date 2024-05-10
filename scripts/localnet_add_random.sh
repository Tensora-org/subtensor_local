#!/bin/bash

: "${CHAIN:=local}"
: "${BUILD_BINARY:=1}"
: "${SPEC_PATH:=specs/}"
: "${FEATURES:=pow-faucet}"

FULL_PATH="$SPEC_PATH$CHAIN"

if [ ! -d "$SPEC_PATH" ]; then
	echo "*** Creating directory ${SPEC_PATH}..."
	mkdir $SPEC_PATH
fi

# if [[ $BUILD_BINARY == "1" ]]; then
# 	echo "*** Building substrate binary..."
# 	cargo build --release --features "$FEATURES"
# 	echo "*** Binary compiled"
# fi

echo "*** Building chainspec..."
./target/release/node-subtensor build-spec --disable-default-bootnode --raw --chain $FULL_PATH > "specs/local.json"
echo "*** Chainspec built and output to file"

echo "*** Starting localnet nodes..."

alice_start=(
	./target/release/node-subtensor
	--base-path /tmp/node01
	--chain="specs/local.json"
	--name node01
	--port 30335
	--rpc-port 9954
	--rpc-methods=unsafe
	--rpc-cors=all
	--allow-private-ipv4
	--bootnodes /ip4/127.0.0.1/tcp/30333/p2p/12D3KooWGWghCVE5eqZ9YHKbegDaJjJQU9oZD45BYqAWowBtm8CB 
)

(trap 'kill 0' SIGINT; ("${alice_start[@]}" 2>&1))
