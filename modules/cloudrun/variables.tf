variable "project_id" {
  description = "GCP project ID to deploy cloudrun"
  type        = string
}

variable "cloudrun_name" {
  description = "The name of the Cloud Run service"
  type        = string
}

variable "location" {
  description = "The location (region) for the Cloud Run service"
  type        = string
}

variable "image" {
  description = "the container image to deploy to Cloud Run"
  type        = string
}

variable "env_vars" {
  description = "Environment variables for the container."
  type        = map(string)
  default     = {}
}

variable "allow_unauthenticated" {
  description = "Allow public (unauthenticated) access to Cloud Run."
  type        = bool
  default     = false
}