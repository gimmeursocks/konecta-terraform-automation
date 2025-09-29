variable "project_id" {
  description = "The GCP project ID where Pub/Sub resources will be created."
  type        = string
}

variable "topic_name" {
  description = "Name of the Pub/Sub topic."
  type        = string
}

variable "subscription_name" {
  description = "Name of the Pub/Sub subscription."
  type        = string
}

variable "ack_deadline_seconds" {
  description = "Number of seconds the subscriber has to acknowledge a message."
  type        = number
  default     = 10
}

variable "labels" {
  description = "Optional labels to apply to the Pub/Sub topic."
  type        = map(string)
  default     = {}
}
