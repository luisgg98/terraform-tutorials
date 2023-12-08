#!/bin/bash
##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################
echo "Server IP: $MONGODB_IP"
sudo /usr/bin/pm2  delete all
sudo /usr/bin/pm2 save

sudo MONGODB_IP=$MONGODB_IP /usr/bin/pm2 start  /home/ubuntu/code/app-dist/server.js
sudo MONGODB_IP=$MONGODB_IP /usr/bin/pm2 restart  /home/ubuntu/code/app-dist/server.js --update-env 
sudo /usr/bin/pm2 startup
sudo /usr/bin/pm2 save
sudo /usr/bin/pm2 list