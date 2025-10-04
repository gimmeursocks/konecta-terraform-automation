output "network_id" {
  description = "Network id"
  value       = google_compute_network.main.id
}

output "network_name" {
  description = "Network name"
  value       = google_compute_network.main.name
}

output "network_self_link" {
  description = "Network self link"
  value       = google_compute_network.main.self_link
}

output "subnets" {
  description = "Map of subnet details"
  value = {
    for k, v in google_compute_subnetwork.subnets : k => {
      id        = v.id
      self_link = v.self_link
      ip_cidr   = v.ip_cidr_range
      region    = v.region
    }
  }
}