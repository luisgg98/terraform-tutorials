##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################
##############################################
##
##
## NETWORK CONFIGURATION
##
##
##############################################
# Comunication between subnets https://docs.aws.amazon.com/vpc/latest/userguide/intra-vpc-route.html
# VPC
resource "aws_vpc" "vpc_main" {
  cidr_block = "10.0.0.0/16"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_main.id
}

# Route table for Internet Gateway
resource "aws_route" "igw_route" {
  route_table_id         = aws_vpc.vpc_main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}



# In Amazon Web Services (AWS), communication between instances in different subnets within the same Virtual Private Cloud (VPC) is allowed by default.
# This is because all subnets within a VPC are part of the same network and share the same route tables.

resource "aws_subnet" "public_loadbalancer_subnet" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = var.resource_net_regin
  map_public_ip_on_launch = true
}

# New Subnet in a Different Availability Zone
resource "aws_subnet" "additional_loadbalancer_subnet" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.3.0/24"                    # Make sure the CIDR block doesn't overlap with existing subnets
  availability_zone       = var.resources_net_additional_reg # Specify a different Availability Zone
  map_public_ip_on_launch = true
}


# Subnets
resource "aws_subnet" "private_database_subnet" {
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.resource_net_regin
  map_public_ip_on_launch = true
}
# Private subnet for the database

resource "aws_subnet" "private_ec2_subnet" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.resource_net_regin
  map_public_ip_on_launch = true
}