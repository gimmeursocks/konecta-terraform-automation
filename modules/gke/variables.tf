variable "project_id" {
  description = "GCP project ID to deploy gke"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "region" {
  description = "Region or zone (e.g., us-central1)."
  type        = string
}

variable "network" {
  description = "VPC network name or self_link."
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork name or self_link."
  type        = string
}

# Node pool variables
variable "node_count" {
  description = "Number of nodes in the node pool."
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for nodes (e.g., e2-medium)."
  type        = string
  default     = "e2-medium"
}