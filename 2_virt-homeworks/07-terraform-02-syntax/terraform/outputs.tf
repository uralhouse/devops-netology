
# Outputs for the YC ID

output "cloud_id" {
  value = data.yandex_client_config.me.cloud_id
}
output "folder_id" {
  value = data.yandex_client_config.me.folder_id
}
output "zone" {
  value = data.yandex_client_config.me.zone
}


# Outputs for subnet

output "public-subnet-id-default" {
  value = [for instance in yandex_compute_instance.default: instance.network_interface[0].subnet_id]
}

# Outputs for compute instance

output "private-ip-for-compute-instance-default" {
  value = [for instance in yandex_compute_instance.default: instance.network_interface[0].ip_address]
}
output "public-ip-for-compute-instance-default" {
  value = [for instance in yandex_compute_instance.default: instance.network_interface[0].nat_ip_address]
}
