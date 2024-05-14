#!/bin/bash

sudo apt-get update
sudo apt install build-essential
sudo apt-get install clang
sudo apt-get install curl
sudo apt-get install git
sudo apt-get install make
sudo apt install --assume-yes git clang curl libssl-dev protobuf-compiler
sudo apt install --assume-yes git clang curl libssl-dev llvm libudev-dev make protobuf-compiler

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

rustup default stable
rustup update
rustup target add wasm32-unknown-unknown
rustup toolchain install nightly
rustup target add --toolchain nightly wasm32-unknown-unknown

