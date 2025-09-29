variable "instance_name" {
  description = "The name of the VM instance"
  type        = string
}
variable "machine_type" {
  description = "The machine type of the VM instance"
  type        = string
}
variable "image" {
  description = "The boot disk image for the VM instance"
  type        = string
}
variable "network" {
  description = "The network for the VM instance"
  type        = string
}