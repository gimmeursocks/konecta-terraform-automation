resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnets

  project       = var.project_id
  name          = each.key
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.main.id
}

# Optional firewall rules
resource "google_compute_firewall" "default" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.main.name
  allow {
    protocol = "all"
  }
  source_ranges = [for subnet in var.subnets : subnet.ip_cidr_range]
}