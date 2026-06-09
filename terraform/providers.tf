#providers.tf

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.140"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
  zone                     = var.zone
}

# Подключение к удалённому Docker на ВМ по SSH
provider "docker" {
  # Terraform Docker provider умеет работать с удалённым Docker-хостом по ssh://user@ip:22 [web:31][web:24]
  host = "ssh://${var.ssh_user}@${yandex_compute_instance.server1.network_interface.0.nat_ip_address}:22"
}
