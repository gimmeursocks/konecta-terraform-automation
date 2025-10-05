output "notification_channel_ids" {
  description = "Map of notification channel IDs"
  value       = { for k, v in google_monitoring_notification_channel.channels : k => v.id }
}

output "alert_policy_ids" {
  description = "Map of alert policy IDs"
  value       = { for k, v in google_monitoring_alert_policy.policies : k => v.id }
}

output "dashboard_ids" {
  description = "Map of dashboard IDs"
  value       = { for k, v in google_monitoring_dashboard.dashboards : k => v.id }
}

output "log_metric_ids" {
  description = "Map of log metric IDs"
  value       = { for k, v in google_logging_metric.metrics : k => v.id }
}