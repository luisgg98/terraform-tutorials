##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################
resource "aws_instance" "mongodb" {

  ami                    = var.ec2_aws_ami_mongodb
  instance_type          = var.machine_type
  subnet_id              = aws_subnet.private_database_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_database.id]

}


#echo "export MONGODB_IP=${aws_instance.mongodb.private_ip}" >> /etc/profile
data "template_file" "client" {
  template = file("./run_on_client.sh")
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    echo "export MONGODB_IP=${aws_instance.mongodb.private_ip}" >> /etc/profile
    echo "MONGODB_IP=${aws_instance.mongodb.private_ip}" >> /etc/environment 
    EOF
  } #second part
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }
}


output "mongodb_private_ip" {
  value = aws_instance.mongodb.private_ip
}


# DATABASE NEEDS A DIFFERENT AMI
resource "aws_instance" "nodejs_instances" {
  count         = 2
  ami           = var.ec2_aws_ami_nodejs
  instance_type = var.machine_type
  subnet_id     = aws_subnet.private_ec2_subnet.id

  vpc_security_group_ids = [aws_security_group.sg_ec2_instance.id]
  user_data              = data.template_cloudinit_config.config.rendered
}



