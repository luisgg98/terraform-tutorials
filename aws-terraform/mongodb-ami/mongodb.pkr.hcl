
##################
##
##  Universidad Internacional de la Rioja
##  Luis Garcia Garces
##
##################
packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.7"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


source "amazon-ebs" "ubuntu" {

  ami_name                    = "unir-luis-aws-packer-mongodb-2"
  instance_type               = "t2.micro"
  region                      = "eu-west-1"
  vpc_id ="vpc-0a60677de1be17332"
  subnet_id                   = "subnet-0a7a6afa71909ba39"
  associate_public_ip_address = true
  ssh_timeout = "45m"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"

}

build {
  name    = "learn-packer"
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "shell" {
    script       = "install.sh"
  }

}

