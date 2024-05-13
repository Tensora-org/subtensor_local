#!/usr/bin/env bash
# This script is meant to be run on Unix/Linux based systems
set -e

echo "*** Initializing WASM build environment"

if ! (( ${#CI_PROJECT_NAME} )) ; then
   rustup update nightly
   rustup update stable
fi

rustup target add wasm32-unknown-unknown --toolchain nightly

# The below seemed to be missing from my env
sudo apt-get update
sudo apt-get install protobuf-compiler
sudo apt-get install make
sudo apt-get update