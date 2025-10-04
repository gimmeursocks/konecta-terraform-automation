output "project_id" {
  value = google_project.main.project_id
  description = "The project id"
}

output "project_number" {
  value = google_project.main.number
  description = "The project number"
}

output "project_name" {
  value       = google_project.main.name
  description = "The project name"
}

output "service_account_email" {
  value       = var.create_service_account ? google_service_account.default[0].email : null
  description = "Email of the created service account (if any)."
}
