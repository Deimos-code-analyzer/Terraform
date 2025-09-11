#!/bin/bash
set -e

# Update system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install dependencies
sudo apt-get install -y curl jq tar

# Create runner directory
mkdir -p /home/ubuntu/actions-runner
cd /home/ubuntu/actions-runner

# Download latest runner package
curl -o actions-runner-linux-x64.tar.gz -L \
  https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64-2.322.0.tar.gz

# Extract it
tar xzf ./actions-runner-linux-x64.tar.gz

# Configure the runner
./config.sh --unattended \
  --url https://github.com/Deimos-code-analyzer \
  --token ${RUNNER_TOKEN} \
  --name "ec2-runner-$(hostname)" \
  --labels "ec2,self-hosted" \
  --work _work

# Install as a service
sudo ./svc.sh install
sudo ./svc.sh start
