#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Welcome to AWS CloudStart Youth 2025!" > /var/www/html/index.html
echo "Welcome to AWS CloudStart Youth 2025!" | sudo tee /var/www/html/index.html
