#!/bin/sh

# This is set up to work on ubuntu

echo "*** Checking if Rust is already installed"

if which rustup >/dev/null 2>&1; then
    echo "Rust is already installed. Exiting."
    exit 0
fi

echo "*** Installing Rust"

sudo apt update

sudo apt install -y git clang curl libssl-dev llvm libudev-dev

curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME/.cargo/env"
rustup default stable

rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

echo "*** Rust installation complete"
