#!/bin/bash
##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################
# https://deb.nodesource.com/
# Install node js
sudo apt -y update && sudo apt -y upgrade
curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -

sudo apt-get update && sudo apt-get install nodejs mongodb-clients nginx build-essential gcc g++ make -y

mkdir -p ~/code/app-dist
mv /tmp/server.js ~/code/app-dist/server.js
cd  ~/code/app-dist/

# Install pm2
sudo npm init -y
sudo npm install npm@10.2.4
sudo npm install express mongodb
sudo npm fund

# Configure Nginx
sudo systemctl enable nginx
sudo rm /etc/nginx/sites-enabled/default
sudo mv /tmp/default.conf /etc/nginx/sites-available/default
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
sudo service nginx restart

# Setup firewall
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw enable

# Configure pm2 to run hello on startup

sudo npm install pm2 -g
sudo systemctl enable pm2-root
sudo --preserve-env pm2 start server.js
sudo pm2 save
sudo pm2 list
sudo pm2 startup