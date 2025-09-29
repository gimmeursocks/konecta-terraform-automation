output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnet_names" {
  value = [for s in google_compute_subnetwork.subnet : s.name]
}

output "network_self_link" {
  value = google_compute_network.vpc.self_link
}