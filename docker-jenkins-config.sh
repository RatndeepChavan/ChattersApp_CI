#!bin/bash

cd /
# ?can be use /var/jenkins_home/ to keep the downloaded files.

# Install necessary ubuntu packages
apk add wget dpkg unzip libc6-compat

# Add foreign architecture
dpkg --add-architecture amd64

# OWASP dependancy check installation
wget https://github.com/jeremylong/DependencyCheck/releases/download/v11.1.1/dependency-check-11.1.1-release.zip
unzip dependency-check-11.1.1-release.zip
chmod 777 dependency-check/

# Snyk installation
wget https://github.com/snyk/cli/releases/download/v1.1294.3/snyk-alpine
chmod +x snyk-alpine

# Trivy installation
wget https://github.com/aquasecurity/trivy/releases/download/v0.58.1/trivy_0.58.1_Linux-64bit.deb
dpkg -i trivy_0.58.1_Linux-64bit.deb

# Docker-compose plugin installation
wget https://github.com/docker/compose/releases/download/v2.32.2/docker-compose-linux-x86_64
chmod +x docker-compose-linux-x86_64

rm dependency-check-11.1.1-release.zip trivy_0.58.1_Linux-64bit.deb
