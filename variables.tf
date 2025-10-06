# Root variables consumed by main.tf and passed to modules
variable "project_id" {
  description = "Unique ID for the new GCP project (also used as its name)."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Project ID must be 6-30 characters, start with a letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "project_name" {
  description = "Name of the new GCP project"
  type        = string
  default     = ""
}

variable "organization_id" {
  description = "GCP Organization ID to associate with the project."
  type        = string
  default     = ""
}

variable "billing_account" {
  description = "Billing account ID (format: XXXXXX-XXXXXX-XXXXXX)."
  type        = string

  validation {
    condition     = can(regex("^[A-Z0-9]{6}-[A-Z0-9]{6}-[A-Z0-9]{6}$", var.billing_account))
    error_message = "Billing account must be in format: XXXXXX-XXXXXX-XXXXXX."
  }
}

variable "default_region" {
  description = "Region for the resources in this project"
  type        = string
  default     = "europe-west12"
}

variable "labels" {
  description = "Key/value labels to apply to the project."
  type        = map(string)
  default     = {}
}

variable "create_project" {
  description = "Whether to create a new GCP project"
  type        = bool
  default     = true
}

# MODULE: PROJECT
variable "apis" {
  description = "List of APIs to enable for the project."
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "storage-api.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com"
  ]
}

variable "project_iam_members" {
  description = "IAM role to member mappings for the project"
  type        = map(string)
  default     = {}
}

# MODULE: VPC
variable "enable_vpc" {
  description = "Enable VPC network creation"
  type        = bool
  default     = true
}
variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "main-vpc"
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    ip_cidr_range = string
    region        = string
  }))
  default = {}
}

# MODULE: GCS
variable "enable_gcs" {
  description = "Enable bucket creation"
  type        = bool
  default     = true
}

variable "gcs_default_location" {
  description = "Default location for GCS buckets"
  type        = string
  default     = "US"
}

variable "buckets" {
  description = "Map of GCS buckets to create"
  type = map(object({
    location                    = optional(string)
    storage_class               = optional(string)
    uniform_bucket_level_access = optional(bool)
    versioning                  = optional(bool)
    force_destroy               = optional(bool)
    labels                      = optional(map(string))
  }))
  default = {}
}

variable "bucket_iam_members" {
  description = "IAM members for buckets"
  type = map(object({
    bucket = string
    role   = string
    member = string
  }))
  default = {}
}

# MODULE: COMPUTE
variable "enable_compute" {
  description = "Enable Compute Engine resources"
  type        = bool
  default     = false
}

variable "instance_templates" {
  description = "Map of instance templates"
  type        = any
  default     = {}
}

variable "managed_instance_groups" {
  description = "Map of managed instance groups"
  type        = any
  default     = {}
}

variable "autoscalers" {
  description = "Map of autoscaler configurations"
  type        = any
  default     = {}
}

# MODULE: CLOUDSQL
variable "enable_cloudsql" {
  description = "Enable Cloud SQL database"
  type        = bool
  default     = false
}

variable "cloudsql_instance_name" {
  description = "Cloud SQL instance name"
  type        = string
  default     = ""
}

variable "cloudsql_database_version" {
  description = "Database version (POSTGRES_15, MYSQL_8_0, etc.)"
  type        = string
  default     = "POSTGRES_15"
}

variable "cloudsql_region" {
  description = "Cloud SQL region (defaults to default_region if empty)"
  type        = string
  default     = ""
}

variable "cloudsql_tier" {
  description = "Machine tier for Cloud SQL"
  type        = string
  default     = "db-f1-micro"
}

variable "cloudsql_disk_size_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 10
}

variable "cloudsql_disk_type" {
  description = "Disk type (PD_SSD or PD_HDD)"
  type        = string
  default     = "PD_SSD"
}

variable "cloudsql_disk_autoresize" {
  description = "Enable automatic disk size increase"
  type        = bool
  default     = true
}

variable "cloudsql_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "cloudsql_databases" {
  description = "List of databases to create"
  type        = list(string)
  default     = []
}

variable "cloudsql_users" {
  description = "Map of database users"
  type = map(object({
    password = string
  }))
  default   = {}
  sensitive = true
}

# MODULE: CLOUDRUN
variable "enable_cloudrun" {
  description = "Enable Cloud Run services"
  type        = bool
  default     = false
}

variable "cloudrun_services" {
  description = "Map of Cloud Run services"
  type        = any
  default     = {}
}

variable "cloudrun_iam_members" {
  description = "IAM members for Cloud Run services"
  type        = any
  default     = {}
}

# MODULE: GKE
variable "enable_gke" {
  description = "Enable Google Kubernetes Engine cluster"
  type        = bool
  default     = false
}

variable "gke_cluster_name" {
  description = "GKE cluster name"
  type        = string
  default     = ""
}

variable "gke_region" {
  description = "GKE region (defaults to default_region if empty)"
  type        = string
  default     = ""
}

variable "gke_zone" {
  description = "GKE zone for zonal clusters"
  type        = string
  default     = null
}

variable "gke_regional" {
  description = "Create regional cluster (recommended)"
  type        = bool
  default     = true
}

variable "gke_network" {
  description = "VPC network name (used if enable_vpc is false)"
  type        = string
  default     = ""
}

variable "gke_subnetwork" {
  description = "VPC subnetwork name (used if enable_vpc is false)"
  type        = string
  default     = ""
}

variable "gke_node_pools" {
  description = "Map of node pools"
  type        = any
  default     = {}
}

# MODULE: LB
variable "enable_loadbalancer" {
  description = "Enable HTTP(S) load balancer"
  type        = bool
  default     = false
}

variable "loadbalancer_name" {
  description = "Load balancer name"
  type        = string
  default     = ""
}

variable "lb_create_static_ip" {
  description = "Create static IP for load balancer"
  type        = bool
  default     = true
}

variable "lb_protocol" {
  description = "Backend protocol (HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "lb_backend_port_name" {
  description = "Named port for backends"
  type        = string
  default     = "http"
}

variable "lb_backend_timeout" {
  description = "Backend timeout in seconds"
  type        = number
  default     = 30
}

variable "lb_health_check_port" {
  description = "Health check port"
  type        = number
  default     = 80
}

variable "lb_health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "lb_enable_ssl" {
  description = "Enable SSL/HTTPS"
  type        = bool
  default     = false
}

variable "lb_ssl_certificates" {
  description = "List of SSL certificate self links"
  type        = list(string)
  default     = []
}

# MODULE: PUB/SUB
variable "enable_pubsub" {
  description = "Enable Pub/Sub resources"
  type        = bool
  default     = false
}

variable "pubsub_topics" {
  description = "Map of Pub/Sub topics"
  type        = any
  default     = {}
}

variable "pubsub_subscriptions" {
  description = "Map of Pub/Sub subscriptions"
  type        = any
  default     = {}
}

variable "pubsub_topic_iam_members" {
  description = "IAM members for topics"
  type        = any
  default     = {}
}

variable "pubsub_subscription_iam_members" {
  description = "IAM members for subscriptions"
  type        = any
  default     = {}
}

# MODULE: MONITORING
variable "enable_monitoring" {
  description = "Enable monitoring and logging resources"
  type        = bool
  default     = true
}

variable "monitoring_notification_channels" {
  description = "Map of notification channels"
  type        = any
  default     = {}
}

variable "monitoring_alert_policies" {
  description = "Map of alert policies"
  type        = any
  default     = {}
}

variable "monitoring_dashboards" {
  description = "Map of monitoring dashboards"
  type        = any
  default     = {}
}

variable "monitoring_log_sinks" {
  description = "Map of log sinks"
  type        = any
  default     = {}
}

variable "monitoring_log_metrics" {
  description = "Map of log-based metrics"
  type        = any
  default     = {}
}
