output "instance_template_ids" {
  description = "Map of instance template IDs"
  value       = { for k, v in google_compute_instance_template.templates : k => v.id }
}

output "mig_instance_groups" {
  description = "Map of MIG instance group URLs"
  value       = { for k, v in google_compute_instance_group_manager.migs : k => v.instance_group }
}
