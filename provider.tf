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

  backend "gcs" {
    # bucket and prefix will be provided dynamically
  }
}