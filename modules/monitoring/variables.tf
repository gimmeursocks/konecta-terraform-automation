variable "project_id" {
  description = "GCP project ID where monitoring resources will be created."
  type        = string
}

variable "notification_channels" {
  description = "Map of Cloud Monitoring notification channel IDs"
  type = map(object({
    type        = string
    labels      = optional(map(string))
    user_labels = optional(map(string))
    enabled     = optional(bool)
  }))
  default = {}
}

variable "alert_policies" {
  description = "Map of alert policies"
  type = map(object({
    combiner = optional(string)
    enabled  = optional(bool)
    condition = object({
      display_name    = string
      filter          = string
      duration        = optional(string)
      comparison      = optional(string)
      threshold_value = optional(number)
      aggregations = optional(object({
        alignment_period   = optional(string)
        per_series_aligner = optional(string)
      }))
    })
    notification_channels = optional(list(string))
    documentation         = optional(string)
    user_labels           = optional(map(string))
  }))
  default = {}
}

variable "dashboards" {
  description = "Map of monitoring dashboards"
  type = map(object({
    columns = optional(number)
    tiles   = optional(list(any))
  }))
  default = {}
}

variable "log_sinks" {
  description = "Map of log sinks"
  type = map(object({
    destination            = string
    filter                 = optional(string)
    unique_writer_identity = optional(bool)
  }))
  default = {}
}

variable "log_metrics" {
  description = "Map of log-based metrics"
  type = map(object({
    filter          = string
    metric_kind     = optional(string)
    value_type      = optional(string)
    unit            = optional(string)
    value_extractor = optional(string)
    labels = optional(list(object({
      key         = string
      value_type  = string
      description = optional(string)
    })))
    label_extractors = optional(map(string))
  }))
  default = {}
}

variable "labels" {
  description = "Default labels"
  type        = map(string)
  default     = {}
}
