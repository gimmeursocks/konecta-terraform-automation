variable "project_id" {
  description = "GCP Project ID where resources will be created"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    ip_cidr_range = string
    region        = string
  }))
}

variable "cidr" {
  description = "CIDR range for the subnet"
  type        = string
}

variable "region" {
  description = "Region for the subnet"
  type        = string
}