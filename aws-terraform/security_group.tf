##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################
# Terraform and Security Groups
# https://stackoverflow.com/questions/55023605/aws-and-terraform-default-egress-rule-in-security-group
# AWS Traffic
# https://www.whizlabs.com/blog/aws-ingress-egress/
# https://docs.aws.amazon.com/es_es/vpc/latest/userguide/egress-only-internet-gateway.html
# https://antonputra.com/amazon/create-alb-terraform/#create-aws-alb-with-ec2-backend

resource "aws_security_group" "sg_ec2_instance" {
  name   = var.sg_ec2_instance
  vpc_id = aws_vpc.vpc_main.id
}

resource "aws_security_group" "sg_loadbalancer" {
  name   = var.sg_loadbalancer
  vpc_id = aws_vpc.vpc_main.id
}

# DATABASE SECURITY GROUP
resource "aws_security_group" "sg_database" {
  name   = var.sg_database
  vpc_id = aws_vpc.vpc_main.id

}
# First, we want to open port 80 for all incoming requests from the internet.
# Then we need to open the egress rule to redirect requests to the EC2 instances

resource "aws_security_group_rule" "ingress_ec2_traffic" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_ec2_instance.id
  source_security_group_id = aws_security_group.sg_loadbalancer.id
}

## DATABASE MONGODB SECURITY GROUP RULE
resource "aws_security_group_rule" "ingress_database_traffic" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_database.id
  source_security_group_id = aws_security_group.sg_ec2_instance.id
}

resource "aws_security_group_rule" "ingress_ec2_allow_database" {
  type                     = "egress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_ec2_instance.id
  cidr_blocks       = ["0.0.0.0/0"]
  #
}


# Allow Egress traffic from the subnets where the EC2 instances are located
# to the subnet whete the database is located
resource "aws_security_group_rule" "egress_database_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_database.id
  cidr_blocks       = ["0.0.0.0/0"]

}


resource "aws_security_group_rule" "ingress_loadbalancer_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_loadbalancer_traffic" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_loadbalancer.id
  source_security_group_id = aws_security_group.sg_ec2_instance.id
}



##############################
## SSH 22
##############################
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress" // Ingress indicates inbound rules
  from_port         = 22        // SSH standard port
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_ec2_instance.id
  cidr_blocks       = ["0.0.0.0/0"] // WARNING: This allows SSH from any IP address. For production, restrict to specific IPs.
}

# aws_security_group.sg_database.id
resource "aws_security_group_rule" "allow_ssh_22" {
  type              = "ingress" // Ingress indicates inbound rules
  from_port         = 22        // SSH standard port
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_database.id
  cidr_blocks       = ["0.0.0.0/0"] // WARNING: This allows SSH from any IP address. For production, restrict to specific IPs.
}

