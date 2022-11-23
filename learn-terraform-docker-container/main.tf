# Install Terraform
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}
#https://www.fpgmaas.com/blog/deploying-a-flask-api-to-cloudrun
provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  # Terraform loads all files in the current directory ending in .tf, so you can name your configuration files however you choose.
  name  = var.instance_name
  ports {
    internal = 80
    external = 8000
  }
}
