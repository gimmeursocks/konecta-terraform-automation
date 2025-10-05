# OUTPUT FROM ROOT MODULE

output "project_id" {
  description = "The GCP project ID"
  value       = local.project_id
}

output "project_number" {
  description = "The GCP project number"
  value       = var.create_project ? module.project[0].project_number : data.google_project.existing[0].number
}

output "project_name" {
  description = "The GCP project name"
  value       = var.create_project ? module.project[0].project_name : data.google_project.existing[0].name
}

# VPC OUTPUTS

output "network_id" {
  description = "The VPC network ID"
  value       = var.enable_vpc ? module.vpc[0].network_id : null
}

output "network_name" {
  description = "The VPC network name"
  value       = var.enable_vpc ? module.vpc[0].network_name : null
}

output "network_self_link" {
  description = "The VPC network self link"
  value       = var.enable_vpc ? module.vpc[0].network_self_link : null
}

output "subnets" {
  description = "Map of subnet details"
  value       = var.enable_vpc ? module.vpc[0].subnets : {}
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value       = var.enable_vpc ? { for k, v in module.vpc[0].subnets : k => v.id } : {}
}

output "subnet_self_links" {
  description = "Map of subnet self links"
  value       = var.enable_vpc ? { for k, v in module.vpc[0].subnets : k => v.self_link } : {}
}

# GCS OUTPUTS

output "bucket_names" {
  description = "Map of GCS bucket names"
  value       = var.enable_gcs ? module.gcs[0].bucket_names : {}
}

output "bucket_urls" {
  description = "Map of GCS bucket URLs"
  value       = var.enable_gcs ? module.gcs[0].bucket_urls : {}
}

output "bucket_self_links" {
  description = "Map of GCS bucket self links"
  value       = var.enable_gcs ? module.gcs[0].bucket_self_links : {}
}

# COMPUTE OUTPUTS

output "instance_template_ids" {
  description = "Map of instance template IDs"
  value       = local.enable_compute ? module.compute[0].instance_template_ids : {}
}

output "mig_instance_groups" {
  description = "Map of managed instance group URLs"
  value       = local.enable_compute ? module.compute[0].mig_instance_groups : {}
}

# CLOUD SQL OUTPUTS

output "cloudsql_connection_name" {
  description = "Cloud SQL instance connection name"
  value       = local.enable_cloudsql ? module.cloudsql[0].instance_connection_name : null
  sensitive   = true
}

output "cloudsql_instance_ip" {
  description = "Cloud SQL instance IP address"
  value       = local.enable_cloudsql ? module.cloudsql[0].instance_ip_address : null
  sensitive   = true
}

output "cloudsql_database_names" {
  description = "List of created database names"
  value       = local.enable_cloudsql ? module.cloudsql[0].database_names : []
}

# CLOUD RUN OUTPUTS

output "cloudrun_service_urls" {
  description = "Map of Cloud Run service URLs"
  value       = local.enable_cloudrun ? module.cloudrun[0].service_urls : {}
}

output "cloudrun_service_names" {
  description = "Map of Cloud Run service names"
  value       = local.enable_cloudrun ? module.cloudrun[0].service_names : {}
}

# GKE OUTPUTS

output "gke_cluster_id" {
  description = "GKE cluster ID"
  value       = local.enable_gke ? module.gke[0].cluster_id : null
}

output "gke_cluster_name" {
  description = "GKE cluster name"
  value       = local.enable_gke ? module.gke[0].cluster_name : null
}

output "gke_cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = local.enable_gke ? module.gke[0].cluster_endpoint : null
  sensitive   = true
}

output "gke_cluster_ca_certificate" {
  description = "GKE cluster CA certificate"
  value       = local.enable_gke ? module.gke[0].cluster_ca_certificate : null
  sensitive   = true
}

output "gke_node_pool_names" {
  description = "List of GKE node pool names"
  value       = local.enable_gke ? module.gke[0].node_pool_names : []
}

output "gke_kubeconfig_command" {
  description = "Command to configure kubectl"
  value       = local.enable_gke ? "gcloud container clusters get-credentials ${module.gke[0].cluster_name} --region ${var.gke_region != "" ? var.gke_region : var.default_region} --project ${local.project_id}" : null
}

# LOAD BALANCER OUTPUTS

output "load_balancer_ip" {
  description = "Load balancer public IP address"
  value       = local.enable_loadbalancer ? module.loadbalancer[0].load_balancer_ip : null
}

output "load_balancer_backend_service_id" {
  description = "Load balancer backend service ID"
  value       = local.enable_loadbalancer ? module.loadbalancer[0].backend_service_id : null
}

output "load_balancer_url_map_id" {
  description = "Load balancer URL map ID"
  value       = local.enable_loadbalancer ? module.loadbalancer[0].url_map_id : null
}

# PUB/SUB OUTPUTS

output "pubsub_topic_ids" {
  description = "Map of Pub/Sub topic IDs"
  value       = local.enable_pubsub ? module.pubsub[0].topic_ids : {}
}

output "pubsub_topic_names" {
  description = "Map of Pub/Sub topic names"
  value       = local.enable_pubsub ? module.pubsub[0].topic_names : {}
}

output "pubsub_subscription_ids" {
  description = "Map of Pub/Sub subscription IDs"
  value       = local.enable_pubsub ? module.pubsub[0].subscription_ids : {}
}

output "pubsub_subscription_names" {
  description = "Map of Pub/Sub subscription names"
  value       = local.enable_pubsub ? module.pubsub[0].subscription_names : {}
}

# MONITORING OUTPUTS

output "monitoring_notification_channel_ids" {
  description = "Map of notification channel IDs"
  value       = local.enable_monitoring ? module.monitoring[0].notification_channel_ids : {}
}

output "monitoring_alert_policy_ids" {
  description = "Map of alert policy IDs"
  value       = local.enable_monitoring ? module.monitoring[0].alert_policy_ids : {}
}

output "monitoring_dashboard_ids" {
  description = "Map of dashboard IDs"
  value       = local.enable_monitoring ? module.monitoring[0].dashboard_ids : {}
}

# SUMMARY OUTPUTS

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    project_id         = local.project_id
    region             = var.default_region
    vpc_enabled        = var.enable_vpc
    compute_enabled    = local.enable_compute
    cloudsql_enabled   = local.enable_cloudsql
    cloudrun_enabled   = local.enable_cloudrun
    gke_enabled        = local.enable_gke
    lb_enabled         = local.enable_loadbalancer
    pubsub_enabled     = local.enable_pubsub
    monitoring_enabled = local.enable_monitoring
  }
}
