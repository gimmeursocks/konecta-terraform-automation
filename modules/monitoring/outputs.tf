output "alert_policy_id" {
  description = "ID of the created Cloud Monitoring alert policy."
  value       = google_monitoring_alert_policy.high_cpu.id
}

output "log_sink_name" {
  description = "Name of the logging sink exporting logs to GCS."
  value       = google_logging_project_sink.logs_to_bucket.name
}
