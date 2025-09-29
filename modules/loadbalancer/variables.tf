variable "project_id" {
  description = "GCP project ID where the load balancer will be created."
  type        = string
}

variable "name" {
  description = "Base name prefix for all load balancer resources."
  type        = string
}

variable "backend_instances" {
  description = "List of backend instance group self-links or backend bucket IDs."
  type        = list(string)
  default     = []
}
