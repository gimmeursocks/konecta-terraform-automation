resource "google_container_cluster" "primary" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.regional ? var.region : var.zone

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {}

  resource_labels = var.labels
}

resource "google_container_node_pool" "pools" {
  for_each = var.node_pools

  project    = var.project_id
  name       = each.key
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.main.location
  node_count = lookup(each.value, "initial_node_count", 1)

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = lookup(each.value, "disk_size_gb", 100)
    spot         = lookup(each.value, "spot", false)
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = merge(
      var.labels,
      lookup(each.value, "labels", {})
    )

    tags = lookup(each.value, "tags", [])
  }
}
