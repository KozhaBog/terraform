resource "yandex_compute_instance" "nginx" {
  name        = "nginx-host"
  platform_id = "standard-v3" # тип процессора (Intel Ice Lake)

  resources {
    core_fraction = 20 # Гарантированная доля vCPU
    cores         = 2  # vCPU
    memory        = 1  # RAM

  }
  labels = {
    "weight" = "100"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8s56jeuvv3pe3niji7" # ОС (debian-11)
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_balancer.id # подсеть central1-a 
    nat       = true                                 # автоматически установить динамический ip
  }

  metadata = {
    ssh-keys  = "ssh-rsa "
  }
}

resource "yandex_compute_instance" "apache" {
  name        = "apache-host"
  platform_id = "standard-v3" # тип процессора (Intel Ice Lake)

  resources {
    core_fraction = 20 # Гарантированная доля vCPU
    cores         = 2  # vCPU
    memory        = 1  # RAM
  }

  labels = {
    "weight" = "100"
  }

  boot_disk {
    initialize_params {
      image_id = "fd8s56jeuvv3pe3niji7" # ОС (debian-11)
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet_balancer.id # подсеть central1-a 
    nat       = true                                 # автоматически установить динамический ip
  }

  metadata = {
    ssh-keys  = "ssh-rsa "
    user-data = "#!/bin/bash \n sudo apt-get update \n sudo apt-get install apache2 -y \n sudo service apache2 start"
  }
}

