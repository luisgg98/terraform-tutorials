# Variables in Terraform
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-variables
variable "virtual_machine_name" {
  type        = string
  default     = "AzureVirtualNameMachine"
}

variable "vm_nic_name" {
    type        = string
  default     = "AzureNicNameMachine"
}

variable "vm_vnet" {
  type = string
  default = "AzureVirtualNetName"
}
variable "vm_az_av_set" {
  type = string
  default = "AzureAvailabilitySet"
}

variable "vm_admin_user" {
    type = string
  default = "adminuser"
}
variable "vm_admin_pass" {
    type = string
  default = "P@$$w0rd1234!"
}

