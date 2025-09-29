resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.region

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1
  ip_allocation_policy {}
}

resource "google_container_node_pool" "default" {
  name     = "${var.cluster_name}-pool"
  project  = var.project_id
  cluster  = google_container_cluster.primary.name
  location = var.region

  node_count = var.node_count

  node_config {
    machine_type = var.machine_type
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
