output "project_id" {
  value = google_project.this.project_id
}

output "project_number" {
  value = google_project.this.number
}

output "service_account_email" {
  value       = var.create_service_account ? google_service_account.default[0].email : null
  description = "Email of the created service account (if any)."
}
