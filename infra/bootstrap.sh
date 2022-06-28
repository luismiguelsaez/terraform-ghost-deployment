#!/usr/bin/env bash

# Disable firewall

ufw disable

# Install docker

apt-get -y update
apt-get -y upgrade
apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Create content directories

mkdir -p /data/ghost/content

# Add user to docker group

usermod -aG docker ubuntu

# Enable and start docker service

systemctl enable docker
systemctl start docker

