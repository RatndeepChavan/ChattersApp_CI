#!bin/bash

# Updated system
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker
echo "\n######################################################"
echo "Installing docker..."
echo "######################################################\n"

sudo apt-get install -y docker.io
sudo usermod -aG docker $USER
sudo apt-get update

# Install docker compose plugin
echo "\n######################################################"
echo "Installing docker-compose..."
echo "######################################################\n"

sudo apt install -y docker-compose
sudo apt-get update

# Create folder to save jenkins data
echo "\n######################################################"
echo "Creating folder..."
echo "######################################################\n"

mkdir data/
chmod 777 data

# Copy jenkins container configuration
echo "\n######################################################"
echo "Copying configs..."
echo "######################################################\n"

cp docker-jenkins-config.sh data/

# Initiat alpine jenkins in docker container
echo "\n######################################################"
echo "Building jenkins container..."
echo "######################################################\n"

newgrp docker
