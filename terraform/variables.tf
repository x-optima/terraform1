#variables.tf

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
}

variable "flow" {
  type    = string
}

variable "ssh_public_key" {
  type = string
}

variable "service_account_key_file" {
  type = string 
}  

variable "ssh_private_key_file" {
  type = string 
}

# Пользователь на ВМ (из cloud-init)
variable "ssh_user" {
  type    = string
}