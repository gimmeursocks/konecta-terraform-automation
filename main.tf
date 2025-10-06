# DATA SOURCES
data "google_project" "existing" {
  count      = var.create_project ? 0 : 1
  project_id = var.project_id
}

# LOCAL VALUES
locals {
  # Common labels applied to all resources
  common_labels = merge(
    var.labels,
    {
      managed_by = "terraform"
      project    = var.project_id
      created_at = formatdate("YYYY-MM-DD", timestamp())
    }
  )

  # Project reference
  project_id = var.create_project ? module.project[0].project_id : var.project_id

  # Network references
  network_name   = var.enable_vpc ? module.vpc[0].network_name : ""
  network_id     = var.enable_vpc ? module.vpc[0].network_id : ""
  primary_subnet = var.enable_vpc && length(module.vpc[0].subnets) > 0 ? values(module.vpc[0].subnets)[0] : null

  # Feature flags
  enable_compute      = var.enable_compute && length(var.instance_templates) > 0
  enable_cloudsql     = var.enable_cloudsql && var.cloudsql_instance_name != ""
  enable_cloudrun     = var.enable_cloudrun && length(var.cloudrun_services) > 0
  enable_gke          = var.enable_gke && var.gke_cluster_name != ""
  enable_loadbalancer = var.enable_loadbalancer && var.loadbalancer_name != ""
  enable_pubsub       = var.enable_pubsub && length(var.pubsub_topics) > 0
  enable_monitoring   = var.enable_monitoring
}

# MODULE: PROJECT
module "project" {
  source = "./modules/project"
  count  = var.create_project ? 1 : 0

  project_id      = var.project_id
  project_name    = (var.project_name != "") ? var.project_name : var.project_id
  organization_id = (var.organization_id != "") ? var.organization_id : null
  billing_account = var.billing_account
  labels          = local.common_labels
  apis            = var.apis
  iam_members     = var.project_iam_members
}

# MODULE: VPC NETWORK
module "vpc" {
  source = "./modules/vpc"
  count  = var.enable_vpc ? 1 : 0

  project_id   = local.project_id
  network_name = var.network_name
  subnets      = var.subnets

  depends_on = [module.project]
}

# MODULE: CLOUD STORAGE
module "gcs" {
  source = "./modules/gcs"
  count  = var.enable_gcs ? 1 : 0

  project_id         = local.project_id
  default_location   = var.gcs_default_location
  buckets            = var.buckets
  bucket_iam_members = var.bucket_iam_members
  labels             = local.common_labels

  depends_on = [module.project]
}

# MODULE: COMPUTE ENGINE
module "compute" {
  source = "./modules/compute"
  count  = local.enable_compute ? 1 : 0

  project_id              = local.project_id
  instance_templates      = var.instance_templates
  managed_instance_groups = var.managed_instance_groups
  autoscalers             = var.autoscalers
  labels                  = local.common_labels

  depends_on = [module.vpc]
}

# MODULE: CLOUD SQL
module "cloudsql" {
  source = "./modules/cloudsql"
  count  = local.enable_cloudsql ? 1 : 0

  project_id          = local.project_id
  instance_name       = var.cloudsql_instance_name
  database_version    = var.cloudsql_database_version
  region              = var.cloudsql_region != "" ? var.cloudsql_region : var.default_region
  tier                = var.cloudsql_tier
  disk_size_gb        = var.cloudsql_disk_size_gb
  disk_type           = var.cloudsql_disk_type
  disk_autoresize     = var.cloudsql_disk_autoresize
  deletion_protection = var.cloudsql_deletion_protection
  databases           = var.cloudsql_databases
  users               = var.cloudsql_users

  depends_on = [module.vpc]
}

#MODULE: CLOUDRUN
module "cloudrun" {
  source = "./modules/cloudrun"
  count  = local.enable_cloudrun ? 1 : 0

  project_id     = local.project_id
  default_region = var.default_region
  services       = var.cloudrun_services
  iam_members    = var.cloudrun_iam_members
  labels         = local.common_labels

  depends_on = [module.project]
}

# MODULE: GKE
module "gke" {
  source = "./modules/gke"
  count  = local.enable_gke ? 1 : 0

  project_id   = local.project_id
  cluster_name = var.gke_cluster_name
  region       = var.gke_region != "" ? var.gke_region : var.default_region
  zone         = var.gke_zone
  regional     = var.gke_regional
  network      = var.enable_vpc ? module.vpc[0].network_name : var.gke_network
  subnetwork   = var.enable_vpc ? keys(module.vpc[0].subnets)[0] : var.gke_subnetwork
  node_pools   = var.gke_node_pools
  labels       = local.common_labels

  depends_on = [module.vpc]
}

# MODULE: LB
module "loadbalancer" {
  source = "./modules/loadbalancer"
  count  = local.enable_loadbalancer ? 1 : 0

  project_id        = local.project_id
  name              = var.loadbalancer_name
  create_static_ip  = var.lb_create_static_ip
  protocol          = var.lb_protocol
  backend_port_name = var.lb_backend_port_name
  backend_timeout   = var.lb_backend_timeout
  health_check_port = var.lb_health_check_port
  health_check_path = var.lb_health_check_path
  enable_ssl        = var.lb_enable_ssl
  ssl_certificates  = var.lb_ssl_certificates

  depends_on = [module.compute, module.gke]
}

# MODULE: PUB/SUB
module "pubsub" {
  source = "./modules/pubsub"
  count  = local.enable_pubsub ? 1 : 0

  project_id               = local.project_id
  topics                   = var.pubsub_topics
  subscriptions            = var.pubsub_subscriptions
  topic_iam_members        = var.pubsub_topic_iam_members
  subscription_iam_members = var.pubsub_subscription_iam_members
  labels                   = local.common_labels

  depends_on = [module.project]
}

# MODULE: MONITORING & LOGGING
module "monitoring" {
  source = "./modules/monitoring"
  count  = local.enable_monitoring ? 1 : 0

  project_id            = local.project_id
  notification_channels = var.monitoring_notification_channels
  alert_policies        = var.monitoring_alert_policies
  dashboards            = var.monitoring_dashboards
  log_sinks             = var.monitoring_log_sinks
  log_metrics           = var.monitoring_log_metrics
  labels                = local.common_labels

  depends_on = [module.project]
}
