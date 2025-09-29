output "lb_ip" {
  description = "The external IP address of the global HTTP(S) Load Balancer."
  value       = google_compute_global_address.lb_ip.address
}

output "forwarding_rule" {
  description = "Name of the global forwarding rule for the load balancer."
  value       = google_compute_global_forwarding_rule.default.name
}
