variable "project_id" {
  description = "GCP project ID to deploy cloudrun"
  type        = string
}

variable "default_region" {
  description = "Default region for Cloud Run services"
  type        = string
  default     = "europe-west12"
}

variable "services" {
  description = "Map of Cloud Run services"
  type = map(object({
    image                 = string
    region                = optional(string)
    cpu                   = optional(string)
    memory                = optional(string)
    allow_unauthenticated = optional(bool)
    vpc_connector         = optional(string)
    vpc_egress            = optional(string)
    env_vars              = optional(map(string))
    labels                = optional(map(string))
  }))
}

variable "iam_members" {
  description = "IAM members for Cloud Run services"
  type = map(object({
    service = string
    role    = string
    member  = string
  }))
  default = {}
}

variable "labels" {
  description = "Default labels"
  type        = map(string)
  default     = {}
}