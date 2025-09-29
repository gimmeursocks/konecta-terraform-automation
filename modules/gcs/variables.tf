variable "project_id" {
  description = "GCP project ID where the bucket will be created."
  type        = string
}
variable "bucket_name" {
  description = "Name of the storage bucket"
  type        = string
}

variable "location" {
  description = "Location for the storage bucket"
  type        = string
}

variable "storage_class" {
  description = "Storage class (STANDARD, NEARLINE, COLDLINE, ARCHIVE)."
  type        = string
  default     = "STANDARD"
}

variable "force_destroy" {
  description = "Set to true to delete bucket even if it contains objects."
  type        = bool
  default     = false
}

variable "labels" {
  description = "Map of labels to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "versioning" {
  description = "Enable object versioning."
  type        = bool
  default     = false
}

variable "uniform_access" {
  description = "Enable uniform bucket-level access."
  type        = bool
  default     = true
}