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