resource "google_project" "main" {
  name                = var.project_name
  project_id          = var.project_id
  org_id              = var.organization_id
  billing_account     = var.billing_account
  auto_create_network = false
  labels              = var.labels
}

# Enable required APIs
resource "google_project_service" "enabled_apis" {
  for_each = toset(var.apis)

  project                    = google_project.main.project_id
  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_project_iam_member" "project_roles" {
  for_each = var.iam_members

  project = google_project.main.project_id
  role    = each.key
  member  = each.value
}