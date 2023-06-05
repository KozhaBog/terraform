output "internal_ip_address_vm_1" {
  value = module.ya_instance_1.internal_ip_address_vm
}

output "external_ip_address_vm_1" {
  value = module.ya_instance_1.external_ip_address_vm
}

output "access_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  sensitive = true
}
output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive = true
}
output "nginx_instance_ip" {
  value = yandex_compute_instance.nginx.network_interface.0.nat_ip_address
}

output "apache_instance_ip" {
  value = yandex_compute_instance.apache.network_interface.0.nat_ip_address
}
