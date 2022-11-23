# Variables in Terraform
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-variables
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}
