output "cloud_run_url" {
  description = "Public URL of the Cloud Run service."
  value       = google_cloud_run_service.service.status[0].url
}

output "service_name" {
  description = "Name of the Cloud Run service."
  value       = google_cloud_run_service.service.name
}
