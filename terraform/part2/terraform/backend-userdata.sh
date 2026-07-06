#!/bin/bash

apt-get update -y

apt-get install -y \
python3 \
python3-pip \
python3-full \
python3.14-venv \
curl \
git

curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

apt-get install -y nodejs

npm install -g pm2