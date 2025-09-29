resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  project       = var.project_id
  name          = var.subnet_name
  ip_cidr_range = var.cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}
