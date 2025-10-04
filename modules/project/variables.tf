variable "project_name" {
  description = "The project name"
  type        = string
}

variable "project_id" {
  description = "The unique project ID (used as name)."
  type        = string
}

variable "organization_id" {
  description = "GCP Organization ID to associate with this project."
  type        = string
}

variable "billing_account" {
  description = "Billing account ID in format XXXXXX-XXXXXX-XXXXXX."
  type        = string
}

variable "labels" {
  description = "Labels to apply to the project."
  type        = map(string)
  default     = {}
}

variable "apis" {
  description = "List of APIs to enable."
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

variable "create_service_account" {
  description = "Whether to create a default service account."
  type        = bool
  default     = false
}

variable "service_account_roles" {
  description = "Roles to assign to the default service account."
  type        = list(string)
  default     = []
}
