#!/bin/bash
# Update package list and install Docker
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

# Create a custom HTML file for NGINX
echo "<html><body><h1>Yo, this is NGINX</h1></body></html>" > index.html

# Create a Dockerfile for the custom NGINX container
echo "FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html" > Dockerfile

# Build and run the custom NGINX container
sudo docker build -t custom-nginx .
sudo docker run -d -p 80:80 custom-nginx

# Ensure Docker and the NGINX container start on boot
sudo systemctl enable docker
