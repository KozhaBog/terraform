terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.91.0" # Фиксируем версию провайдера
    }
  }
}
data "yandex_compute_image" "my_image" {
  family = var.instance_family_image
}
resource "yandex_compute_instance" "vm" {
  name = "terraform-1"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.my_image.id
    }
  }

  network_interface {
    subnet_id = var.vpc_subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "~/.ssh/id_rsa.pub"
  }
}
