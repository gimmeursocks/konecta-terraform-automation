resource "google_storage_bucket" "bucket" {
  name     = var.my-bucket-name
  location = var.location
}