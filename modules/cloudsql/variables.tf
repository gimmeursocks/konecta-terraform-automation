variable "project_id" {
  description = "Project ID for this DB instance"
  type        = string
}

variable "instance_name" {
  description = "the name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "the database version for the Cloud SQL instance"
  type        = string
}

variable "region" {
  description = "the region for the Cloud SQL instance"
  type        = string
}

variable "machine_type" {
  description = "the machine type for the Cloud SQL instance"
  type        = string
}

variable "db_name" {
  description = "Default database name."
  type        = string
}

variable "db_user" {
  description = "Database username."
  type        = string
}

variable "db_password" {
  description = "Database user password."
  type        = string
  sensitive   = true
}

variable "deletion_protection" {
  description = "Prevent accidental deletion."
  type        = bool
  default     = true
}