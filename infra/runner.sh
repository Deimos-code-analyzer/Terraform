#!/bin/bash
set -e

# Update system
apt-get update -y
apt-get upgrade -y

# Install dependencies
apt-get install -y curl jq tar

# Create runner directory (owned by ubuntu)
mkdir -p /home/ubuntu/actions-runner
chown ubuntu:ubuntu /home/ubuntu/actions-runner
cd /home/ubuntu/actions-runner

# Get latest release tag
LATEST=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name')

# Download and extract runner
curl -o actions-runner-linux-x64.tar.gz -L \
  "https://github.com/actions/runner/releases/download/$${LATEST}/actions-runner-linux-x64-$${LATEST:1}.tar.gz"

tar xzf ./actions-runner-linux-x64.tar.gz
chown -R ubuntu:ubuntu /home/ubuntu/actions-runner

# Configure the runner as ubuntu user
sudo -u ubuntu /home/ubuntu/actions-runner/config.sh --unattended \
  --url https://github.com/Deimos-code-analyzer \
  --token ${RUNNER_TOKEN} \
  --name "ec2-runner-$(hostname)" \
  --labels "ec2,self-hosted" \
  --work _work

# Install and start service as ubuntu user
sudo /home/ubuntu/actions-runner/svc.sh install
sudo /home/ubuntu/actions-runner/svc.sh start
