#!bin/bash

# Update the System
sudo apt update -y && sudo apt upgrade -y

# change to root directory
cd /

# Install necessary ubuntu packages
sudo apt-get install unzip

# OWASP dependancy check installation
sudo wget https://github.com/jeremylong/DependencyCheck/releases/download/v11.1.1/dependency-check-11.1.1-release.zip
sudo unzip dependency-check-11.1.1-release.zip
sudo chmod 777 dependency-check

# Snyk installation
sudo wget https://github.com/snyk/cli/releases/download/v1.1295.0/snyk-linux
sudo chmod +x snyk-linux

# Trivy installation
sudo wget https://github.com/aquasecurity/trivy/releases/download/v0.58.1/trivy_0.58.1_Linux-64bit.deb
sudo dpkg -i trivy_0.58.1_Linux-64bit.deb

# Removing uneccessary files
sudo rm -rf dependency-check-11.1.1-release.zip trivy_0.58.1_Linux-64bit.deb

# Install docker and docker-compose
sudo apt-get install -y docker.io
sudo apt install -y docker-compose

# Install Java
sudo apt install openjdk-21-jdk -y
echo "java -version"

# Install jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y

# Start jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Add sudo privilleged to jenkins user
sudo chmod +x /etc/sudoers.d
echo "jenkins ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/jenkins-sudo > /dev/null

# Jenkins initial password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Add user to docker group
# !this command shoult be at end else it'll break script execution
sudo usermod -aG docker $USER && newgrp docker

# To check jenkins status
# sudo systemctl status jenkins
