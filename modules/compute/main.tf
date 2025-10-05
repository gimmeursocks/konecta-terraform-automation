resource "google_compute_instance_template" "templates" {
  for_each = var.instance_templates

  project      = var.project_id
  name_prefix  = "${each.key}-"
  machine_type = each.value.machine_type
  region       = lookup(each.value, "region", null)

  disk {
    source_image = each.value.source_image
    auto_delete  = true
    boot         = true
    disk_size_gb = lookup(each.value, "disk_size_gb", 20)
  }

  network_interface {
    network    = each.value.network
    subnetwork = each.value.subnetwork
  }

  tags   = lookup(each.value, "tags", [])
  labels = merge(var.labels, lookup(each.value, "labels", {}))
}

resource "google_compute_instance_group_manager" "migs" {
  for_each = var.managed_instance_groups

  project = var.project_id
  name    = each.key
  zone    = each.value.zone

  base_instance_name = each.key

  version {
    instance_template = google_compute_instance_template.templates[each.value.template].id
  }

  target_size = lookup(each.value, "target_size", 1)
}

resource "google_compute_autoscaler" "autoscalers" {
  for_each = var.autoscalers

  project = var.project_id
  name    = each.key
  zone    = google_compute_instance_group_manager.migs[each.value.mig].zone
  target  = google_compute_instance_group_manager.migs[each.value.mig].id

  autoscaling_policy {
    max_replicas    = each.value.max_replicas
    min_replicas    = each.value.min_replicas
    cooldown_period = lookup(each.value, "cooldown_period", 60)

    cpu_utilization {
      target = lookup(each.value, "cpu_target", 0.6)
    }
  }
}