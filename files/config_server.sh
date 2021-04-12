#!/bin/bash

# Install Docker
sudo apt update -y
sudo apt install -y software-properties-common docker.io docker-compose python3-pip
sudo systemctl enable docker
sudo systemctl start docker
echo -e "Docker Installed"

# Run containers
sudo docker run --name hackazon --restart unless-stopped -d -p 8080:80 -p 8443:443 ianwijaya/hackazon
sudo docker run --name dvwa --restart unless-stopped -d -p 8081:80 vulnerables/web-dvwa
sudo docker run --name f5demoapp --restart unless-stopped -d -p 8082:80 -e F5DEMO_APP=website f5devcentral/f5-demo-httpd:nginx
sudo docker run --name juice-shop --restart=unless-stopped -d -p 8083:3000 bkimminich/juice-shop
sudo docker run --name nginx01 --restart=unless-stopped -d -p 8084:80 nginx:latest
sudo docker run --name bwapp --restart=unless-stopped -d -p 8085:80 raesene/bwapp

# Kafka Container - for Telemetry Streaming
cd /home/azureuser/
git clone https://github.com/wurstmeister/kafka-docker
rm -f /home/azureuser/kafka-docker/docker-compose.yml
curl https://raw.githubusercontent.com/cavalen/vlab-azure-tf/master/files/docker-compose.yml -o /home/azureuser/kafka-docker/docker-compose.yml
cd /home/azureuser/kafka-docker/
sudo docker-compose up -d

# Book Catalog API - Lab API Protection - Port TCP:3000
cd /home/azureuser/
git clone https://github.com/cavalen/bookscatalog
cd ./bookscatalog
sudo docker-compose up -d
