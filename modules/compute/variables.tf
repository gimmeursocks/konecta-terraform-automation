variable "project_id" {
  description = "GCP project ID to deploy the VM."
  type        = string
}

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