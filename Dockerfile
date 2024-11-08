
ARG BASE_IMAGE=ubuntu:20.04

FROM $BASE_IMAGE as builder
SHELL ["/bin/bash", "-c"]

# This is being set so that no interactive components are allowed when updating.
ARG DEBIAN_FRONTEND=noninteractive

# show backtraces
ENV RUST_BACKTRACE 1

# Necessary libraries for Rust execution
RUN apt-get update && \
    apt-get install -y curl build-essential protobuf-compiler clang git && \
    rm -rf /var/lib/apt/lists/*

# Install cargo and Rust
RUN set -o pipefail && curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN mkdir -p /subtensor && \
    mkdir /subtensor/scripts

# Scripts
COPY ./scripts/init.sh /subtensor/scripts/

# Capture dependencies
COPY Cargo.lock Cargo.toml /subtensor/

# Copy our sources
COPY ./node /subtensor/node
COPY ./pallets /subtensor/pallets
COPY ./runtime /subtensor/runtime
COPY ./support /subtensor/support

# Copy our toolchain
COPY rust-toolchain.toml /subtensor/
RUN /subtensor/scripts/init.sh

# Cargo build
WORKDIR /subtensor
RUN cargo build --release --features "pow-faucet runtime-benchmarks fast-blocks"
EXPOSE 30333 9933 9944

# Specs (This spec has our wallet balances added)
COPY ./scripts/specs/customSpec.json /subtensor/stagingSpec.json

FROM $BASE_IMAGE AS subtensor
COPY --from=builder /subtensor/stagingSpec.json /
COPY --from=builder /subtensor/target/release/node-subtensor /usr/local/bin
