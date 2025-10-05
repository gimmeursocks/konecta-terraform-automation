variable "project_id" {
  description = "The GCP project ID where Pub/Sub resources will be created."
  type        = string
}

variable "topics" {
  description = "Map of Pub/Sub topics"
  type = map(object({
    message_retention_duration = optional(string)
    labels                     = optional(map(string))
  }))
}

variable "subscriptions" {
  description = "Map of Pub/Sub subscriptions"
  type = map(object({
    topic                      = string
    ack_deadline_seconds       = optional(number)
    message_retention_duration = optional(string)
    labels                     = optional(map(string))
  }))
  default = {}
}

variable "topic_iam_members" {
  description = "IAM members for topics"
  type = map(object({
    topic  = string
    role   = string
    member = string
  }))
  default = {}
}

variable "subscription_iam_members" {
  description = "IAM members for subscriptions"
  type = map(object({
    subscription = string
    role         = string
    member       = string
  }))
  default = {}
}

variable "labels" {
  description = "Optional labels to apply to the Pub/Sub topic."
  type        = map(string)
  default     = {}
}
