variable "zone" {                                # Используем переменную для передачи в конфиг инфраструктуры
  description = "Use specific availability zone" # Опционально описание переменной
  type        = string                           # Опционально тип переменной
  default     = "ru-central1-a"                  # Опционально значение по умолчанию для переменной
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.91.0" # Фиксируем версию провайдера
    }
  }
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "vedroplease"
    region     = "ru-central1-a"
    key        = "issue1/lemp.tfstate"
    access_key = "YCAJEvbPJgskkLXDaQXL4NzD_"
    secret_key = "YCNqUrtYHBb4G9JMgD1MAwKwWZLH8sKMyUlzTcn7"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "network"
}

resource "yandex_vpc_subnet" "subnet1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

module "ya_instance_1" {
  source                = "./modules"
  instance_family_image = "lamp"
  vpc_subnet_id         = yandex_vpc_subnet.subnet1.id
}
