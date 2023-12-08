#!/bin/bash
##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################
# Import the public key used by the package management system
sudo apt-get install gnupg curl -y
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
# Create a list file for MongoDB
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Reload local package database
sudo apt-get update
# Install the MongoDB packages
sudo apt-get install -y mongodb-org
sudo sudo apt-get update
sudo dpkg --get-selections | grep hold
sudo apt-get --fix-broken install -y
sudo apt-get upgrade -y

# Modify only specific lines using sed
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf
# Add any other configurations using echo or sed as needed
sudo cat /etc/mongod.conf
#Start MongoDB
sudo systemctl daemon-reload
sudo systemctl start mongod
# Verify that MongoDB has started successfully
sudo systemctl status mongod

sudo systemctl enable mongod

# Restart MongoDB
sudo systemctl restart mongod
