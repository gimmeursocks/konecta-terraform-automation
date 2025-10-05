variable "project_id" {
  description = "GCP project ID where the load balancer will be created."
  type        = string
}

variable "name" {
  description = "Base name prefix for all load balancer resources."
  type        = string
}

variable "create_static_ip" {
  description = "Create static IP address"
  type        = bool
  default     = true
}

variable "protocol" {
  description = "Backend protocol (HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "backend_port_name" {
  description = "Named port for backends"
  type        = string
  default     = "http"
}

variable "backend_timeout" {
  description = "Backend timeout in seconds"
  type        = number
  default     = 30
}

variable "health_check_port" {
  description = "Health check port"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "enable_ssl" {
  description = "Enable SSL/HTTPS"
  type        = bool
  default     = false
}

variable "ssl_certificates" {
  description = "List of SSL certificate self links"
  type        = list(string)
  default     = []
}