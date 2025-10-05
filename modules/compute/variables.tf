variable "project_id" {
  description = "GCP project ID to deploy the VM."
  type        = string
}

variable "instance_templates" {
  description = "Map of instance templates"
  type = map(object({
    machine_type = string
    source_image = string
    network      = string
    subnetwork   = string
    region       = optional(string)
    disk_size_gb = optional(number)
    tags         = optional(list(string))
    labels       = optional(map(string))
  }))
  default = {}
}

variable "managed_instance_groups" {
  description = "Map of managed instance groups"
  type = map(object({
    template    = string
    zone        = string
    target_size = optional(number)
  }))
  default = {}
}

variable "autoscalers" {
  description = "Map of autoscalers"
  type = map(object({
    mig             = string
    max_replicas    = number
    min_replicas    = number
    cooldown_period = optional(number)
    cpu_target      = optional(number)
  }))
  default = {}
}

variable "labels" {
  description = "Default labels"
  type        = map(string)
  default     = {}
}