resource "google_cloud_run_v2_service" "services" {
  for_each = var.services

  project  = var.project_id
  name     = each.key
  location = lookup(each.value, "region", var.default_region)

  template {
    containers {
      image = each.value.image

      dynamic "env" {
        for_each = lookup(each.value, "env_vars", {})
        content {
          name  = env.key
          value = env.value
        }
      }
      resources {
        limits = {
          cpu    = lookup(each.value, "cpu", "1000m")
          memory = lookup(each.value, "memory", "512Mi")
        }
      }
    }

    dynamic "vpc_access" {
      for_each = lookup(each.value, "vpc_connector", null) != null ? [1] : []
      content {
        connector = each.value.vpc_connector
        egress    = lookup(each.value, "vpc_egress", "PRIVATE_RANGES_ONLY")
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  labels = merge(var.labels, lookup(each.value, "labels", {}))
}

# Allows unauthenticated access if requested
resource "google_cloud_run_service_iam_member" "invoker" {
  for_each = { for k, v in var.services : k => v if lookup(v, "allow_unauthenticated", false) }

  project  = var.project_id
  location = google_cloud_run_v2_service.services[each.key].location
  service  = google_cloud_run_v2_service.services[each.key].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service_iam_member" "members" {
  for_each = var.iam_members

  project  = var.project_id
  location = google_cloud_run_v2_service.services[each.value.service].location
  service  = google_cloud_run_v2_service.services[each.value.service].name
  role     = each.value.role
  member   = each.value.member
}