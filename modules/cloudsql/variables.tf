variable "project_id" {
  description = "Project ID for this DB instance"
  type        = string
}

variable "instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "The database version for the Cloud SQL instance"
  type        = string
}

variable "region" {
  description = "The region for the Cloud SQL instance"
  type        = string
}

variable "tier" {
  description = "The machine tier for the Cloud SQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size_gb" {
  description = "Disk size in GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Disk type (PD_SSD or PD_HDD)"
  type        = string
  default     = "PD_SSD"
}

variable "disk_autoresize" {
  description = "Enable disk autoresize"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Prevent accidental deletion."
  type        = bool
  default     = true
}

variable "databases" {
  description = "List of databases to create"
  type        = list(string)
  default     = []
}

variable "users" {
  description = "Map of database users"
  type = map(object({
    password = string
  }))
  default = {}
}
