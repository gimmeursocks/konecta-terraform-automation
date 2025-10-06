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
  default     = 0
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

variable "iam_members" {
  description = "IAM role to member mappings"
  type        = map(string)
  default     = {}
}
