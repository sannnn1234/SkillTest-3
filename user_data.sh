#!/bin/bash
apt update -y
apt install nginx -y
systemctl start nginx
systemctl enable nginx

echo "<h1>Welcome to the Terraform-managed Nginx Server on Ubuntu</h1>" > /var/www/html/index.html
