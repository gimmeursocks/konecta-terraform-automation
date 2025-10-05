output "project_id" {
  description = "The project id"
  value       = google_project.main.project_id
}

output "project_number" {
  description = "The project number"
  value       = google_project.main.number
}

output "project_name" {
  description = "The project name"
  value       = google_project.main.name
}

output "service_account_email" {
  description = "Email of the created service account (if any)."
  value       = var.create_service_account ? google_service_account.default[0].email : null
}
