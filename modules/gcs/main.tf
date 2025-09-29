resource "google_storage_bucket" "bucket" {
  project       = var.project_id
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  labels = var.labels
  versioning {
    enabled = var.versioning
  }

  uniform_bucket_level_access = var.uniform_access
}