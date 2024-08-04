#!/bin/bash
set -e

# Update the package index and install Docker
dnf update -y
dnf install -y docker

# Start Docker service and enable it to start on boot
systemctl start docker
systemctl enable docker

# Add the ec2-user to the docker group
usermod -a -G docker ec2-user

# Create a self-signed SSL certificate
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/CN=localhost"

# Create necessary directories
mkdir -p /usr/share/nginx/html

# Create the NGINX configuration for HTTPS
cat <<EOL > /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    server {
        listen 443 ssl;
        server_name localhost;

        ssl_certificate /etc/nginx/ssl/nginx.crt;
        ssl_certificate_key /etc/nginx/ssl/nginx.key;

        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_prefer_server_ciphers on;
        ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256";
        ssl_ecdh_curve secp384r1;
        ssl_session_timeout  10m;
        ssl_session_cache shared:SSL:10m;
        ssl_session_tickets off;

        ssl_stapling on;
        ssl_stapling_verify on;
        resolver 8.8.8.8 8.8.4.4 valid=300s;
        resolver_timeout 5s;

        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;

        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files \$uri \$uri/ =404;
        }
    }
}
EOL

# Create the HTML file
echo 'yo this is nginx' > /usr/share/nginx/html/index.html

# Run NGINX using Docker
docker run -d -p 443:443 -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf -v /usr/share/nginx/html:/usr/share/nginx/html -v /etc/nginx/ssl:/etc/nginx/ssl nginx:alpine
