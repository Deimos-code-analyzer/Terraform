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

# Get latest release tag
LATEST=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name')

# Download and extract runner (escaped for Terraform)
curl -o actions-runner-linux-x64.tar.gz -L \
  "https://github.com/actions/runner/releases/download/$${LATEST}/actions-runner-linux-x64-$${LATEST:1}.tar.gz"

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
