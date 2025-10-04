variable "project_id" {
  description = "GCP project ID where the buckets will be created."
  type        = string
}

variable "default_location" {
  description = "Location for the storage bucket"
  type        = string
  default     = "US"
}

variable "buckets" {
  description = "Map of buckets to create"
  type = map(object({
    location                    = optional(string)
    storage_class               = optional(string)
    uniform_bucket_level_access = optional(bool)
    versioning                  = optional(bool)
    force_destroy               = optional(bool)
    labels                      = optional(map(string))
  }))
}

variable "labels" {
  description = "Map of labels to assign to the bucket."
  type        = map(string)
  default     = {}
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