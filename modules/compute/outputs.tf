output "instance_name" {
  description = "Name of the VM instance."
  value       = google_compute_instance.vm.name
}

output "instance_self_link" {
  description = "Self link (API URL) of the VM instance."
  value       = google_compute_instance.vm.self_link
}

output "instance_ip" {
  description = "External IP of the VM instance."
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}
