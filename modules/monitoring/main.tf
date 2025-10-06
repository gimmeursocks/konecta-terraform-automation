resource "google_monitoring_notification_channel" "channels" {
  for_each = var.notification_channels

  project      = var.project_id
  display_name = each.key
  type         = each.value.type
  labels       = lookup(each.value, "labels", {})

  user_labels = merge(var.labels, lookup(each.value, "user_labels", {}))

  enabled = lookup(each.value, "enabled", true)
}

resource "google_monitoring_alert_policy" "policies" {
  for_each = var.alert_policies

  project      = var.project_id
  display_name = each.key
  combiner     = coalesce(each.value.combiner, "OR")
  enabled      = lookup(each.value, "enabled", true)

  conditions {
    display_name = each.value.condition.display_name

    condition_threshold {
      filter          = each.value.condition.filter
      duration        = coalesce(each.value.condition.duration, "60s")
      comparison      = lookup(each.value.condition, "comparison", "COMPARISON_GT")
      threshold_value = lookup(each.value.condition, "threshold_value", 0)
    }
  }

  notification_channels = [
    for channel in lookup(each.value, "notification_channels", []) :
    google_monitoring_notification_channel.channels[channel].id
  ]

  dynamic "documentation" {
    for_each = lookup(each.value, "documentation", null) != null ? [1] : []
    content {
      content   = lookup(each.value, "documentation", "Alert triggered for ${each.key}")
      mime_type = "text/markdown"
    }
  }

  user_labels = merge(var.labels, lookup(each.value, "user_labels", {}))
}

resource "google_monitoring_dashboard" "dashboards" {
  for_each = var.dashboards

  project = var.project_id
  dashboard_json = jsonencode({
    displayName = each.key
    mosaicLayout = {
      columns = lookup(each.value, "columns", 12)
      tiles   = lookup(each.value, "tiles", [])
    }
  })
}

resource "google_logging_project_sink" "sinks" {
  for_each = var.log_sinks

  project     = var.project_id
  name        = each.key
  destination = each.value.destination
  filter      = lookup(each.value, "filter", "")

  unique_writer_identity = lookup(each.value, "unique_writer_identity", true)
}

resource "google_logging_metric" "metrics" {
  for_each = var.log_metrics

  project = var.project_id
  name    = each.key
  filter  = each.value.filter

  metric_descriptor {
    metric_kind = lookup(each.value, "metric_kind", "DELTA")
    value_type  = lookup(each.value, "value_type", "INT64")
    unit        = lookup(each.value, "unit", "1")

    dynamic "labels" {
      for_each = lookup(each.value, "labels", [])
      content {
        key         = labels.value.key
        value_type  = labels.value.value_type
        description = lookup(labels.value, "description", "")
      }
    }
  }

  label_extractors = lookup(each.value, "label_extractors", {})

  value_extractor = lookup(each.value, "value_extractor", null)
}
