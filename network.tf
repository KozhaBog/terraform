resource "yandex_vpc_network" "network_balancer" {
  name = "lb-network"
}

resource "yandex_vpc_subnet" "subnet_balancer" {
  name           = "lb-subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_balancer.id
  v4_cidr_blocks = ["10.60.1.0/24"]
}

resource "yandex_alb_http_router" "tf-router" {
  name = "router-balancer"
  labels = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-balancer" {
  name           = "balancer"
  http_router_id = yandex_alb_http_router.tf-router.id
  route {
    name = "balancer"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.test-backend-group.id
        timeout          = "3s"
      }
    }
  }
}
