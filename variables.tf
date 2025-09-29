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

# Optional service-account creation flags
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


# Omar's code

variable "project_id" {}
variable "vpc_name" {}
variable "subnet_name" {}
variable "cidr" {}
variable "region" {}
variable "my_bucket_name" {}
variable "location" {}
variable "instance_name" {}
variable "machine_type" {}
variable "image" {} 
variable "network" {}
variable "sql_instance_name" {}
variable "database_version" {}
variable "sql_machine_type" {}
variable "cloudrun_name" {}
variable "cloudrun_location" {}
variable "cloudrun_image" {}
