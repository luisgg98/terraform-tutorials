#!/bin/bash
##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################
export AWS_ACCESS_KEY_ID="${1}"
export AWS_SECRET_ACCESS_KEY="${2}"
cd node-ami/ && packer build packer.pkr.hcl 
cd ..
cd mongodb-ami/ && packer build  mongodb.pkr.hcl