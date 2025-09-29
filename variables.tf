# Root variables consumed by main.tf and passed to modules
variable "project_id" {
  description = "Unique ID for the new GCP project (also used as its name)."
  type        = string
}

variable "organization_id" {
  description = "GCP Organization ID to associate with the project."
  type        = string
}

variable "billing_account" {
  description = "Billing account ID (format: XXXXXX-XXXXXX-XXXXXX)."
  type        = string
}

variable "region" {
  description = "Region for the resources in this project"
  type        = string
}

variable "labels" {
  description = "Key/value labels to apply to the project."
  type        = map(string)
  default     = {}
}

variable "apis" {
  description = "List of APIs to enable for the project."
  type        = list(string)
  default     = []
}

variable "create_service_account" {
  description = "Whether to create a default service account in the project."
  type        = bool
  default     = false
}

variable "service_account_roles" {
  description = <<EOT
List of IAM roles to attach to the default service account if created.
Example: ["roles/editor", "roles/iam.serviceAccountUser"]
EOT
  type        = list(string)
  default     = []
}

# VPC Module
variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "cidr" {
  description = "CIDR range for the subnet"
  type        = string
}

# GCS Module
variable "bucket_name" {
  description = "Name of the storage bucket"
  type        = string
}

variable "location" {
  description = "Location for the storage bucket"
  type        = string
}

variable "storage_class" {
  description = "Storage class (STANDARD, NEARLINE, COLDLINE, ARCHIVE)."
  type        = string
  default     = "STANDARD"
}

variable "force_destroy" {
  description = "Set to true to delete bucket even if it contains objects."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Map of labels to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "versioning" {
  description = "Enable object versioning."
  type        = bool
  default     = false
}

variable "uniform_access" {
  description = "Enable uniform bucket-level access."
  type        = bool
  default     = true
}

# Compute Module
variable "instance_name" {
  description = "The name of the VM instance"
  type        = string
}

variable "machine_type" {
  description = "The machine type of the VM instance"
  type        = string
}

variable "zone" {
  description = "Zone to deploy the VM (e.g., us-central1-a)."
  type        = string
}

variable "image" {
  description = "The boot disk image for the VM instance"
  type        = string
}

variable "disk_size_gb" {
  description = "Boot disk size in GB."
  type        = number
  default     = 20
}

variable "network" {
  description = "The network for the VM instance"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name or self_link."
  type        = string
}

variable "tags" {
  description = "Optional network tags for firewall rules."
  type        = list(string)
  default     = []
}

# Cloud SQL Module
variable "sql_instance_name" {
  description = "the name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "the database version for the Cloud SQL instance"
  type        = string
}

variable "sql_machine_type" {
  description = "the machine type for the Cloud SQL instance"
  type        = string
}

variable "db_name" {
  description = "Default database name."
  type        = string
}

variable "db_user" {
  description = "Database username."
  type        = string
}

variable "db_password" {
  description = "Database user password."
  type        = string
  sensitive   = true
}

variable "deletion_protection" {
  description = "Prevent accidental deletion."
  type        = bool
  default     = true
}

# Cloudrun module
variable "cloudrun_name" {
  description = "The name of the Cloud Run service"
  type        = string
}
variable "cloudrun_image" {
  description = "the container image to deploy to Cloud Run"
  type        = string
}

variable "cloudrun_env_vars" {
  description = "Environment variables for the container."
  type        = map(string)
  default     = {}
}

variable "cloudrun_allow_unauthenticated" {
  description = "Allow public (unauthenticated) access to Cloud Run."
  type        = bool
  default     = false
}

# GKE Module
variable "gke_cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "gke_node_count" {
  description = "Number of nodes in the node pool."
  type        = number
  default     = 1
}

variable "gke_machine_type" {
  description = "Machine type for nodes (e.g., e2-medium)."
  type        = string
  default     = "e2-medium"
}

# Loadbalancer Module
variable "lb_name" {
  description = "Base name prefix for all load balancer resources."
  type        = string
}

# Pub/Sub Module
variable "topic_name" {
  description = "Name of the Pub/Sub topic."
  type        = string
}

variable "subscription_name" {
  description = "Name of the Pub/Sub subscription."
  type        = string
}

variable "pubsub_labels" {
  description = "Optional labels to apply to the Pub/Sub topic."
  type        = map(string)
  default     = {}
}

# Monitoring Module
variable "alert_name_prefix" {
  description = "Prefix to use for alert policy and sink names."
  type        = string
}

variable "alert_cpu_threshold" {
  description = "CPU utilization percentage that triggers the alert."
  type        = number
  default     = 80
}

variable "monitoring_logs_bucket" {
  description = "Name of the GCS bucket to receive exported logs."
  type        = string
}

variable "alert_notification_channels" {
  description = "List of Cloud Monitoring notification channel IDs."
  type        = list(string)
  default     = []
}