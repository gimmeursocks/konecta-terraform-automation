# Create a Cloud Monitoring alert policy on high CPU usage
resource "google_monitoring_alert_policy" "high_cpu" {
  project      = var.project_id
  display_name = "${var.name_prefix}-high-cpu"
  combiner = "OR"

  conditions {
    display_name = "VM CPU > ${var.cpu_threshold}%"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.cpu_threshold / 100
      duration        = "60s"
      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels
}

# Create a basic logging sink to export logs to GCS
resource "google_logging_project_sink" "logs_to_bucket" {
  name        = "${var.name_prefix}-logs-sink"
  project     = var.project_id
  destination = "storage.googleapis.com/${var.logs_bucket}"
  filter      = var.log_filter

  unique_writer_identity = true
}
