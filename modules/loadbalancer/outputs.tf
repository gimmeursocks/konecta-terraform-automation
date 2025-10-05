output "load_balancer_ip" {
  description = "The external IP address of the global HTTP(S) Load Balancer."
  value       = var.create_static_ip ? google_compute_global_address.lb_ip[0].address : null
}

output "backend_service_id" {
  description = "Backend service ID"
  value       = google_compute_backend_service.main.id
}

output "url_map_id" {
  description = "URL map ID"
  value       = google_compute_url_map.main.id
}