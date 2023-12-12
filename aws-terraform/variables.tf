##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################

variable "resources_region" {
  default = "eu-west-1"
}
variable "resources_net_additional_reg" {
  default = "eu-west-1b"

}
# Error: creating EC2 Subnet: InvalidParameterValue: Value (eu-west-1) for parameter availabilityZone is invalid. Subnets can currently only be created in the following availability zones: eu-west-1a, eu-west-1b, eu-west-1c.
#default = "eu-west-1"
variable "resource_net_regin" {
  default = "eu-west-1a"

}
variable "machine_type" {
  default = "t2.micro"
}

variable "sg_ec2_instance" {
  default = "security_group_ec2"
}

variable "sg_loadbalancer" {
  default = "security_group_loadbalancer"
}

variable "sg_database" {
  default = "security_group_database"
}

variable "load_balancer_tg" {
  default = "loadbalancertg"

}

variable "load_balancer_rc" {
  default = "loadbalancerresource"

}

variable "ec2_aws_ami_mongodb" {
  default = "ami-01a2c6e8216c66a57"
}

variable "ec2_aws_ami_nodejs" {
  default = "ami-0b4c167beafc093df"
}
