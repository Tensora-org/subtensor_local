#!/bin/bash

: "${CHAIN:=local}"
: "${BUILD_BINARY:=1}"
: "${SPEC_PATH:=specs/}"
: "${FEATURES:=pow-faucet}"

FULL_PATH="$SPEC_PATH$CHAIN"

echo "Chain spec path: ${FULL_PATH}"

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

echo "*** Purging previous state..."
./target/release/node-subtensor purge-chain -y --base-path /tmp/bob --chain="specs/local.json" >/dev/null 2>&1
echo "*** Previous chainstate purged"

echo "*** Starting localnet nodes..."

bob_start=(
	./target/release/node-subtensor
	--base-path /tmp/bob
	--chain="specs/local.json"
	--bob
	--port 30333
	--rpc-port 9935
	--validator
	--rpc-cors=all
	--rpc-methods=unsafe
)

(trap 'kill 0' SIGINT; ("${bob_start[@]}" 2>&1))
