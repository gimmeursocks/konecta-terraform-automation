variable "project_id" {
  description = "GCP project ID where monitoring resources will be created."
  type        = string
}

variable "name_prefix" {
  description = "Prefix to use for alert policy and sink names."
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization percentage that triggers the alert."
  type        = number
  default     = 80
}

variable "notification_channels" {
  description = "List of Cloud Monitoring notification channel IDs."
  type        = list(string)
  default     = []
}

variable "logs_bucket" {
  description = "Name of the GCS bucket to receive exported logs."
  type        = string
}

variable "log_filter" {
  description = "Advanced logs filter (e.g., severity>=ERROR)."
  type        = string
  default     = "severity>=ERROR"
}
