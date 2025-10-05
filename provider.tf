provider "google" {
  project = var.project_id
  region  = var.default_region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}