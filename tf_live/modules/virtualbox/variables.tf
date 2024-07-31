variable "vm_name" {
  description = "The name of the VM."
  type        = string
}

variable "vm_memory" {
  description = "The amount of memory for the VM."
  type        = string
}

variable "vm_cpu" {
  description = "The number of CPUs for the VM."
  type        = number
}

variable "vm_count" {
  description = "The number of VMs to create."
  type        = number
}

variable "host_interface" {
  description = "The host interface for the VM network."
  type        = string
}

variable "vm_user_data" {
  description = "User data for cloud-init."
  type        = string
}

variable "vm_image" {
  description = "The image to use for the VM."
  type        = string
}

variable "private_key_path" {
  description = "Path to the SSH private key."
  type        = string
}
