resource "google_cloud_run_service" "service" {
  project  = var.project_id
  name     = var.cloudrun_name
  location = var.location

  template {
    spec {
      containers {
        image = var.image

        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }

      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Allows unauthenticated access if requested
resource "google_cloud_run_service_iam_member" "invoker" {
  count    = var.allow_unauthenticated ? 1 : 0
  project  = var.project_id
  location = var.location
  service  = google_cloud_run_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}