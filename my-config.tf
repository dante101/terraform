terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
 
provider "yandex" {
  token  =  "AQAAAAuzoALUa4lBmRvPScfso"
  cloud_id  = "b1g4b7nijg7"
  folder_id = "b1g2f1bhg"
  zone      = "ru-central1-a"
}


variable "image-id" {
    type = string
}

resource "yandex_compute_instance" "vm-1" {
    name = "our-ubuntu-vm"
    platform_id = "standard-v1"
    zone = "ru-central1-a"

    resources {
        cores = 2
        memory = 4
    }

    boot_disk {
        initialize_params {
            image_id = var.image-id
        }
    }
    network_interface {
        subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
        nat = true
    }
    metadata = {
        ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
}

resource "yandex_vpc_network" "network-1" {
    name = "network-1"
} 
resource "yandex_vpc_subnet" "subnet-1" {
  name = "network-1"
  zone       = "ru-central1-a"
  network_id = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.0.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
 
output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
} 
