variable "project_id" {
  description = "GCP project ID to deploy gke"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "regional" {
  description = "Create a regional cluster"
  type        = bool
  default     = true
}

variable "region" {
  description = "Region or zone (e.g., us-central1)."
  type        = string
}

variable "zone" {
  description = "GCP zone (for zonal clusters)"
  type        = string
  default     = null
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
variable "node_pools" {
  description = "Map of node pools"
  type = map(object({
    machine_type       = string
    initial_node_count = optional(number)
    disk_size_gb       = optional(number)
    spot               = optional(bool)
    labels             = optional(map(string))
    tags               = optional(list(string))
  }))
}

variable "labels" {
  description = "Cluster labels"
  type        = map(string)
  default     = {}
}