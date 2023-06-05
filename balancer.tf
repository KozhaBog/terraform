resource "yandex_alb_load_balancer" "test-balancer" {
  name       = "my-load-balancer"
  network_id = yandex_vpc_network.network_balancer.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet_balancer.id
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }

  log_options {
    discard_rule {
      http_code_intervals = ["HTTP_2XX"]
      discard_percent     = 75
    }
  }
}

resource "yandex_alb_target_group" "foo" {
  name = "my-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.subnet_balancer.id
    ip_address = yandex_compute_instance.nginx.network_interface.0.ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.subnet_balancer.id
    ip_address = yandex_compute_instance.apache.network_interface.0.ip_address
  }
}

resource "yandex_alb_backend_group" "test-backend-group" {
  name = "test-backend-group"
  session_affinity {
    connection {
      source_ip = "true"
    }
  }

  http_backend {
    name             = "backend-balancer"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.foo.id]
    load_balancing_config {
      panic_threshold = 90
      mode            = "ROUND_ROBIN"
    }
    healthcheck {
      timeout             = "10s"
      interval            = "2s"
      healthy_threshold   = 10
      unhealthy_threshold = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}
