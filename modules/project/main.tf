resource "google_project" "main" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.organization_id
  billing_account = var.billing_account
  auto_create_network = false
  labels          = var.labels
}

# Enable required APIs
resource "google_project_service" "enabled_apis" {
  for_each           = toset(var.apis)

  project            = google_project.main.project_id
  service            = each.value
  disable_on_destroy = false
  disable_dependent_services = false
}

# Optional: create a default service account (if enabled)
resource "google_service_account" "default" {
  count        = var.create_service_account ? 1 : 0
  account_id   = "${var.project_id}-sa"
  display_name = "${var.project_id} Service Account"
  project      = google_project.main.project_id
}

# Optional: attach roles to the service account
resource "google_project_iam_member" "sa_roles" {
  for_each = var.create_service_account ? toset(var.service_account_roles) : toset([])
  project  = google_project.main.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.default[0].email}"
}