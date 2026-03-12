#!/bin/bash

yum update -y

# Install Apache
yum install httpd -y
systemctl start httpd
systemctl enable httpd

# Install PHP
amazon-linux-extras install php8.0 -y

# Install MySQL
yum install mariadb-server -y
systemctl start mariadb
systemctl enable mariadb

# Download WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz

tar -xzf latest.tar.gz
cp -r wordpress/* .

# Permissions
chown -R apache:apache /var/www/html

systemctl restart httpd
