output "cluster_id" {
  description = "Cluster ID"
  value       = google_container_cluster.primary.id
}

output "cluster_name" {
  description = "Cluster name"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "node_pool_names" {
  description = "Node pool names"
  value       = [for pool in google_container_node_pool.pools : pool.name]
}