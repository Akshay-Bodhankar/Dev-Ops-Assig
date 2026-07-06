#!/bin/bash

# Update packages
apt-get update -y

# Install required packages
apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    python3-full \
    python3.14-venv

# Install Node.js 22
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

apt-get install -y nodejs

# Install PM2 globally
npm install -g pm2

# Verify installation
node -v
npm -v
python3 --version

echo "Frontend EC2 setup completed." > /home/ubuntu/frontend-setup.log