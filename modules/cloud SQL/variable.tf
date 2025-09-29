variable "instance_name" {
    description = "the name of the Cloud SQL instance"
    type = string 
}
variable "database_version" {
    description = "the database version for the Cloud SQL instance"
    type = string 
}
variable "region" {
    description = "the region for the Cloud SQL instance"
    type = string 
}
variable "machine_type" {
    description = "the machine type for the Cloud SQL instance"
    type = string 
}