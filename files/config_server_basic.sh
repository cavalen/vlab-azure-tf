#!/bin/bash

# Install Docker
sudo apt update -y
sudo apt install -y software-properties-common docker.io docker-compose python3-pip
sudo systemctl enable docker
sudo systemctl start docker
echo -e "Docker Installed"

# Run containers
sudo docker run --name crApi -d -p 8080:8080 cavalen/njsapi
suso docker run --name nginxhello -d -p 8081:80 cavalen/nginx_echo
cd /home/azureuser/
git clone https://github.com/lcrilly/ergast-f1-api
cd ergast-f1-api 
sudo docker-compose up -d --remove-orphans
