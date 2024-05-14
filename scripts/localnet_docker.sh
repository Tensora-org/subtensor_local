#!/bin/bash

# Usage: ./run_services.sh [mode] [node_ip] [node_id]
# Example: ./run_services.sh local 192.168.1.1 12D3KooWGWghCVE5eqZ9YHKbegDaJjJQU9oZD45BYqAWowBtm8CB 

# node_ip is the ip address of the machines running the alice and bob nodes. 
# node_id is the id of the bob node

MODE=${1:-default}  # Mode, default to 'default' if not specified
NODE_IP=${2:-unset}
NODE_ID=${3:-unset}

# Check if mode is 'local' and if required parameters are provided
if [ "$MODE" == "local" ]; then
  if [ "NODE_IP" == "unset" ]; then  # Check if NODE_IP is provided
    echo "Error: NODE_IP is required for local mode."
    echo "Usage: ./run_services.sh local [node_ip] [node_id]"
    exit 1
  fi
  if [ "NODE_ID" == "unset" ]; then  # Check if NODE_ID is provided
    echo "Error: NODE_ID is required for local mode."
    echo "Usage: ./run_services.sh local [node_ip] [node_id]"
    exit 1
  fi

  echo "Starting local staging node..."
  echo "Using NODE_IP: $NODE_IP"
  echo "Using NODE_ID: $NODE_ID"
  
  # Exporting the NODE_IP and NODE_ID for docker-compose to pick up
  export NODE_IP
  export NODE_ID

  docker compose down --remove-orphans
  docker compose up -d local_staging_node
else

  docker compose down --remove-orphans
  echo "Starting Alice and Bob nodes..."
  docker compose up -d alice_node bob_node
fi
