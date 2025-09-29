resource "google_cloud_run_service" "default" {
  name     = var.cloudrun_name
  location = var.location

  template {
    spec {
      containers {
        image = var.image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}